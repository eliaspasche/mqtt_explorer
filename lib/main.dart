import 'package:flutter/material.dart';
import 'package:mqtt_explorer/app.dart';
import 'package:mqtt_explorer/models/client.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => Client()),
      ],
      child: const MqttExplorer(),
    ),
  );
}

/// Main App: Mqtt Explorer
class MqttExplorer extends StatelessWidget {
  const MqttExplorer({super.key});

  final Color seedColor = const Color.fromARGB(255, 29, 38, 125);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: "MQTT Explorer",
      // light theme
      theme: ThemeData(
          useMaterial3: true,
          colorScheme: ColorScheme.fromSeed(
            seedColor: seedColor,
          ),
          fontFamily: 'Roboto'),
      // darkt theme
      darkTheme: ThemeData(
          useMaterial3: true,
          colorScheme: ColorScheme.fromSeed(
            seedColor: seedColor,
            brightness: Brightness.dark,
          ),
          fontFamily: 'Roboto'),
      // starting point of application
      home: const HomePage(),
      themeMode: ThemeMode.system,
    );
  }
}
