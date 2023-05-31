import 'package:flutter/material.dart';
import 'package:mqtt_explorer/models/client.dart';
import 'package:mqtt_explorer/shared/snacks.dart';
import 'package:provider/provider.dart';

/// Page to publish messages to a specific topic
class PublishPage extends StatefulWidget {
  const PublishPage({super.key});

  @override
  State<PublishPage> createState() => _PublishPageState();
}

class _PublishPageState extends State<PublishPage> {
  late TextEditingController _topicController;
  late TextEditingController _messageController;
  late ScaffoldMessengerState _messenger;
  late FocusNode _focusMessage;

  @override
  void initState() {
    super.initState();

    _focusMessage = FocusNode();
    _topicController = TextEditingController();
    _messageController = TextEditingController();
  }

  @override
  void didChangeDependencies() {
    _messenger = ScaffoldMessenger.of(context);
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    _focusMessage.dispose();
    _topicController.dispose();
    _messageController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    _topicController.text = context.watch<Client>().publishTopic;
    bool readyToSend = context.watch<Client>().publishTopic.isNotEmpty;

    /// Handles the changes of the topic text field.
    void changeTopic(String value) {
      context.read<Client>().publishTopic = value;
    }

    /// Publishs the entered message to the active broker. The current value of the
    /// topic text field is used for the publishing topic.
    /// Shows a snack in case of any error for user feedback.
    void sendMessage() async {
      // Send message
      try {
        await context.read<Client>().publishMessage(_messageController.text);
      } catch (e) {
        _messenger
            .showSnackBar(errorSnack("Error while publishing.", e.toString()));

        return;
      }

      // Reset text field and set focus
      _messageController.clear();
      _focusMessage.requestFocus();

      _messenger.showSnackBar(successSnack("Message successfuly published."));
    }

    return Container(
      margin: const EdgeInsets.all(16),
      alignment: Alignment.topCenter,
      child: Column(
        children: [
          // Select a specific topic
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  const ListTile(
                    leading: Icon(Icons.topic_rounded),
                    title: Text("Topic"),
                    subtitle: Text(
                        "Specify the topic with which messages should be sent."),
                  ),
                  const SizedBox(height: 8),
                  TextField(
                    controller: _topicController,
                    onChanged: changeTopic,
                    onSubmitted: (value) => _focusMessage.requestFocus(),
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      hintText: 'Publish Topic',
                    ),
                  ),
                  const SizedBox(height: 8),
                ],
              ),
            ),
          ),
          // Send messages to configured topic
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  const ListTile(
                    leading: Icon(Icons.send_rounded),
                    title: Text("Messages"),
                    subtitle: Text("Sent messages with the configured topic."),
                  ),
                  const SizedBox(height: 8),
                  TextField(
                    controller: _messageController,
                    onSubmitted: readyToSend ? (value) => sendMessage() : null,
                    focusNode: _focusMessage,
                    maxLength: 65000,
                    keyboardType: TextInputType.multiline,
                    decoration: InputDecoration(
                      border: const OutlineInputBorder(),
                      hintText: 'Message',
                      suffixIcon: IconButton(
                        icon: const Icon(Icons.send_rounded),
                        onPressed: readyToSend ? () => sendMessage() : null,
                        tooltip:
                            !readyToSend ? "Topic or Message missing" : null,
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Tooltip(
                        message: !readyToSend ? "Topic or Message missing" : "",
                        child: FilledButton.icon(
                          icon: const Icon(Icons.send_rounded),
                          label: const Text("Publish"),
                          onPressed: readyToSend ? () => sendMessage() : null,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
