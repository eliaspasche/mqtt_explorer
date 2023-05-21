import 'package:flutter/material.dart';

class PublishPage extends StatefulWidget {
  const PublishPage({super.key});

  @override
  State<PublishPage> createState() => _PublishPageState();
}

class _PublishPageState extends State<PublishPage> {
  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      child: const Text("Publish"),
    );
  }
}
