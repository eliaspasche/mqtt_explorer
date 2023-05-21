import 'dart:async';

import 'package:flutter/material.dart';
import 'package:mqtt_client/mqtt_client.dart';
import 'package:mqtt_client/mqtt_server_client.dart';
import 'package:mqtt_explorer/models/message.dart';
import 'package:mqtt_explorer/models/status.dart';

class Client with ChangeNotifier {
  final MqttServerClient _client = MqttServerClient("", "myClient");
  MqttServerClient get client => _client;

  Status status = Status.disconnected;
  Set<String> topics = <String>{};
  List<Message> messages = <Message>[];

  StreamSubscription? subscription;

  /// Connects the client to the given [broker] and sets the required properties.
  /// [broker] can be an ip or host name of a broker.
  void connect(String broker) async {
    // Set client properties
    _client.server = broker;
    _client.port = 1883;
    _client.logging(on: true);
    _client.keepAlivePeriod = 30;
    _client.onDisconnected = _onDisconnected;

    // Connect
    try {
      status = Status.connecting;
      notifyListeners();
      await _client.connect();
      status = Status.connected;
      notifyListeners();
    } catch (e) {
      print(e);
      disconnect();
    }

    /// Check connection
    if (_client.connectionStatus?.state == MqttConnectionState.connected) {
      print('MQTT connected');
    } else {
      print('ERROR: MQTT connection failed - isconnecting ...');
      status = Status.faulted;
    }

    // Add a listener on updates
    subscription = _client.updates?.listen(_onMessage);
  }

  /// Method on new messages of the mqtt client.
  /// Processes the given [event].
  void _onMessage(List<MqttReceivedMessage> event) {
    final MqttPublishMessage recMess = event[0].payload as MqttPublishMessage;
    final String message =
        MqttPublishPayload.bytesToStringAsString(recMess.payload.message);

    print('New MQTT message: <-- ${event[0].topic} -->: $message');

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
    _client.disconnect();
    _onDisconnected();
  }

  /// Subscribes the client to a given [topic].
  void subscribeToTopic(String topic) {
    // Only connect if the client is connected
    if (status == Status.connected) {
      if (topics.add(topic.trim())) {
        print('Subscribing to ${topic.trim()}');
        client.subscribe(topic, MqttQos.exactlyOnce);
      }
      notifyListeners();
    }
  }

  /// Unsubscribes the client of the given [topic].
  void unsubscribeFromTopic(String topic) {
    // Only unsubscribe if the client is connected
    if (status == Status.connected) {
      if (topics.remove(topic.trim())) {
        client.unsubscribe(topic, expectAcknowledge: true);
        print('Unsubscribed from ${topic.trim()}');
      }
      notifyListeners();
    }
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

  /// Resets all properties after successful disconnect.
  void _onDisconnected() {
    topics.clear();
    messages.clear();
    status = Status.values.firstWhere(
        (element) => element.state == client.connectionStatus?.state,
        orElse: () => Status.disconnected);
    subscription?.cancel();
    subscription = null;
    notifyListeners();
    print('MQTT connection disconnected');
  }
}
