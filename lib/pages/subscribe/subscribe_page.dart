import 'package:flutter/material.dart';
import 'package:mqtt_explorer/pages/subscribe/widgets/topics.dart';
import 'package:mqtt_explorer/pages/subscribe/widgets/messages.dart';

/// Page to handle subsriptions to different topics and receive messages
class SubscribePage extends StatefulWidget {
  const SubscribePage({super.key});

  @override
  State<SubscribePage> createState() => _SubscribePageState();
}

class _SubscribePageState extends State<SubscribePage> {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(20),
      alignment: Alignment.center,
      child: const Column(
        mainAxisAlignment: MainAxisAlignment.start,
        mainAxisSize: MainAxisSize.max,
        children: <Widget>[
          TopicWidget(),
          SizedBox(height: 16),
          MessageWidget(),
        ],
      ),
    );
  }
}
