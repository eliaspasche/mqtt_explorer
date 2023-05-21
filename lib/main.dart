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

class MqttExplorer extends StatelessWidget {
  const MqttExplorer({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: "MQTT Explorer",
      theme: ThemeData(
          useMaterial3: true,
          colorScheme: ColorScheme.fromSeed(
            seedColor: const Color.fromARGB(255, 6, 72, 134),
          ),
          fontFamily: 'Roboto'),
      home: const HomePage(),
      themeMode: ThemeMode.light,
    );
  }
}
