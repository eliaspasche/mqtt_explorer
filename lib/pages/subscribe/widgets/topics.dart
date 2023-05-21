import 'package:flutter/material.dart';
import 'package:mqtt_explorer/models/client.dart';

import 'package:provider/provider.dart';

class TopicWidget extends StatefulWidget {
  const TopicWidget({super.key});

  @override
  State<TopicWidget> createState() => _TopicWidgetState();
}

class _TopicWidgetState extends State<TopicWidget> {
  TextEditingController topicController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    List<Widget> buildTopicList() {
      // Sort topics
      final List<String> sortedTopics = context.watch<Client>().topics.toList()
        ..sort();
      return sortedTopics
          .map((String topic) => Chip(
                label: Text(topic),
                onDeleted: () {
                  context.read<Client>().unsubscribeFromTopic(topic);
                },
              ))
          .toList();
    }

    void onClick() {
      context.read<Client>().subscribeToTopic(topicController.value.text);
      topicController.clear();
    }

    return Row(
      mainAxisSize: MainAxisSize.max,
      children: [
        Expanded(
          child: Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  const ListTile(
                    leading: Icon(Icons.topic_rounded),
                    title: Text('Topics'),
                    subtitle: Text('Manage the subscribed topics'),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      Expanded(
                        child: TextField(
                          controller: topicController,
                          onSubmitted: (value) => onClick(),
                          decoration: InputDecoration(
                            hintText: 'New Topic',
                            border: const OutlineInputBorder(),
                            suffixIcon: IconButton(
                              onPressed: () => onClick(),
                              icon: const Icon(Icons.add_rounded),
                              color: Theme.of(context).primaryColor,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  const Divider(
                    indent: 120,
                    endIndent: 120,
                  ),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisSize: MainAxisSize.max,
                    children: <Widget>[
                      Expanded(
                        child: Wrap(
                          spacing: 8.0,
                          runSpacing: 4.0,
                          alignment: WrapAlignment.center,
                          children: buildTopicList(),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
