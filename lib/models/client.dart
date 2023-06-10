import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:mqtt_client/mqtt_client.dart';
import 'package:mqtt_client/mqtt_server_client.dart';
import 'package:mqtt_explorer/models/message.dart';
import 'package:mqtt_explorer/models/status.dart';

/// Singleton client to wrap mqtt library
class Client with ChangeNotifier {
  final MqttServerClient _client =
      MqttServerClient("", "flutterMqttClient${Random().nextInt(90) + 10}");
  MqttServerClient get client => _client;

  String get broker => _client.server;
  set broker(String broker) {
    client.server = broker;
    notifyListeners();
  }

  Status status = Status.disconnected;
  String? errorMessage;
  Set<String> topics = <String>{};
  List<Message> messages = <Message>[];

  String _publishTopic = "";
  String get publishTopic => _publishTopic;
  set publishTopic(String publishTopic) {
    _publishTopic = publishTopic;
    notifyListeners();
  }

  StreamSubscription? subscription;

  /// Connects the client to the given [broker] and sets the required properties.
  /// [broker] can be an ip or host name of a broker.
  Future<void> connect() async {
    // Set client properties
    client.port = 1883;
    client.keepAlivePeriod = 60;
    client.onDisconnected = _onDisconnected;

    // Connect to broker
    try {
      status = Status.connecting;
      notifyListeners();
      await client.connect();
      status = Status.connected;
      notifyListeners();
    }
    // In case of errors
    catch (e) {
      disconnect();

      // Set status to faulted
      status = Status.faulted;
      errorMessage = e.toString();
      notifyListeners();

      // Rethrow to catch in caller
      rethrow;
    }

    // Add a listener on updates
    subscription = client.updates?.listen(_onMessage);
  }

  /// Method on new messages of the mqtt client.
  /// Processes the given [event].
  void _onMessage(List<MqttReceivedMessage> event) {
    final MqttPublishMessage recMess = event[0].payload as MqttPublishMessage;
    final String message =
        MqttPublishPayload.bytesToStringAsString(recMess.payload.message);

    messages.add(Message(
      topic: event[0].topic,
      message: message,
    ));

    notifyListeners();
  }

  /// Disconnects the client.
  void disconnect() {
    status = Status.disconnecting;
    notifyListeners();
    client.disconnect();
    _onDisconnected();
  }

  /// Subscribes the client to a given [topic].
  /// Tries to connect to the current [broker] if no connection is established.
  Future<void> subscribeToTopic(String topic) async {
    // try to connect if status is not connected
    if (status != Status.connected) {
      await connect();
    }

    if (topics.add(topic.trim())) {
      client.subscribe(topic, MqttQos.exactlyOnce);
    }
    notifyListeners();
  }

  /// Unsubscribes the client of the given [topic].
  /// Tries to connect to the current [broker] if no connection is established.
  Future<void> unsubscribeFromTopic(String topic) async {
    // try to connect if status is not connected
    if (status != Status.connected) {
      await connect();
    }

    if (topics.remove(topic.trim())) {
      client.unsubscribe(topic, expectAcknowledge: true);
    }
    notifyListeners();
  }

  /// Clears the list of received messages.
  void clearMessages() {
    messages.clear();
    notifyListeners();
  }

  /// Removes a single message from the received messages list.
  void removeMessage(Message message) {
    messages.remove(message);
    notifyListeners();
  }

  /// Publish a given [content] to the current [publishTopic].
  /// Tries to connect to the current [broker] if no connection is established.
  Future<void> publishMessage(String content) async {
    // try to connect if status is not connected
    if (status != Status.connected) {
      await connect();
    }

    final builder = MqttClientPayloadBuilder();
    builder.addString(content);

    client.publishMessage(publishTopic, MqttQos.exactlyOnce, builder.payload!);
  }

  /// Resets all properties after successful disconnect.
  void _onDisconnected() {
    topics.clear();
    messages.clear();

    // Set custom status dedending on client connection status
    status = Status.values.firstWhere(
        (element) => element.state == client.connectionStatus?.state,
        orElse: () => Status.disconnected);
    subscription?.cancel();
    subscription = null;
    notifyListeners();
  }
}
