import 'package:flutter/material.dart';
import 'package:mqtt_client/mqtt_client.dart';

enum Status {
  connected(
    icon: Icons.cloud_done,
    message: "Connected",
    color: Colors.green,
    state: MqttConnectionState.connected,
  ),
  disconnected(
    icon: Icons.cloud_off,
    message: "Disconnected",
    color: Colors.grey,
    state: MqttConnectionState.disconnected,
  ),
  connecting(
    icon: Icons.cloud_upload,
    message: "Connecting",
    color: Colors.blue,
    state: MqttConnectionState.connecting,
  ),
  disconnecting(
    icon: Icons.cloud_download,
    message: "Disconecting",
    color: Colors.grey,
    state: MqttConnectionState.disconnecting,
  ),
  faulted(
    icon: Icons.error,
    message: "Faulted",
    color: Colors.red,
    state: MqttConnectionState.faulted,
  );

  const Status({
    required this.icon,
    required this.message,
    required this.color,
    required this.state,
  });

  final IconData icon;
  final String message;
  final Color color;
  final MqttConnectionState state;
}
