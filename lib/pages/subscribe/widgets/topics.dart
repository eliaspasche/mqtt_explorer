import 'package:flutter/material.dart';
import 'package:mqtt_explorer/models/client.dart';
import 'package:mqtt_explorer/shared/snacks.dart';

import 'package:provider/provider.dart';

class TopicWidget extends StatefulWidget {
  const TopicWidget({super.key});

  @override
  State<TopicWidget> createState() => _TopicWidgetState();
}

class _TopicWidgetState extends State<TopicWidget> {
  late TextEditingController _topicController;
  late ScaffoldMessengerState _messenger;
  late FocusNode _focusTopic;

  @override
  void initState() {
    super.initState();

    _topicController = TextEditingController();
    _focusTopic = FocusNode();
  }

  @override
  void didChangeDependencies() {
    _messenger = ScaffoldMessenger.of(context);
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    _topicController.dispose();

    _focusTopic.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    /// Usubscribes from a given [topic].
    /// Shows a snack in case of any error for user feedback.
    void unsubscribeFromTopic(String topic) async {
      try {
        await context.read<Client>().unsubscribeFromTopic(topic);
      } catch (e) {
        _messenger.showSnackBar(errorSnack("Please check your connection."));
      }
    }

    /// Build the list of topics. Returns a list of [Widget]
    /// containing a [Chip] for each topic.
    List<Widget> buildTopicList() {
      // Sort topics
      final List<String> sortedTopics = context.watch<Client>().topics.toList()
        ..sort();

      return sortedTopics
          .map(
            (String topic) => Chip(
              label: Text(topic),
              onDeleted: () => unsubscribeFromTopic(topic),
            ),
          )
          .toList();
    }

    /// Subscribes to a new topic. The topic is read from the [_topicController].
    void subscribeToTopic() async {
      try {
        await context
            .read<Client>()
            .subscribeToTopic(_topicController.value.text);
        _topicController.clear();
        _focusTopic.requestFocus();
      } catch (e) {
        _messenger.showSnackBar(
            errorSnack("Please check your connection.", e.toString()));
      }
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
                          controller: _topicController,
                          onSubmitted: (value) => subscribeToTopic(),
                          focusNode: _focusTopic,
                          decoration: InputDecoration(
                            hintText: 'New Topic',
                            border: const OutlineInputBorder(),
                            suffixIcon: IconButton(
                              onPressed: () => subscribeToTopic(),
                              icon: const Icon(Icons.add_rounded),
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
