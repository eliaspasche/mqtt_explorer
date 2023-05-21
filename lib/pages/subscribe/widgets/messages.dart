import 'package:flutter/material.dart';
import 'package:mqtt_explorer/models/client.dart';
import 'package:mqtt_explorer/models/message.dart';
import 'package:provider/provider.dart';

class MessageWidget extends StatefulWidget {
  const MessageWidget({super.key});

  @override
  State<MessageWidget> createState() => _MessageWidgetState();
}

class _MessageWidgetState extends State<MessageWidget> {
  ScrollController scrollController = ScrollController();

  @override
  Widget build(BuildContext context) {
    /// Build messages to card widgets
    List<Widget> buildMessageList() {
      // Scroll to top on new messages
      if (scrollController.hasClients) {
        scrollController.animateTo(
          0.0,
          duration: const Duration(milliseconds: 600),
          curve: Curves.easeOut,
        );
      }

      return context
          .watch<Client>()
          .messages
          .map((Message message) => Card(
                child: ListTile(
                  trailing: IconButton(
                    icon: const Icon(Icons.cancel_rounded),
                    onPressed: () =>
                        context.read<Client>().removeMessage(message),
                  ),
                  title: Text(message.topic),
                  subtitle: Text(message.message),
                  dense: true,
                ),
              ))
          .toList()
          .reversed
          .toList();
    }

    void clearList() {
      context.read<Client>().clearMessages();
    }

    return Expanded(
      child: Card(
        elevation: 0,
        surfaceTintColor: Theme.of(context).scaffoldBackgroundColor,
        child: Padding(
          padding: const EdgeInsets.all(0),
          child: Column(
            children: [
              ListTile(
                leading: const Icon(Icons.message_rounded),
                title: const Text("Messages"),
                subtitle:
                    const Text("Received messages for all subscribed topics"),
                trailing: ElevatedButton.icon(
                  icon: const Icon(Icons.clear_all_rounded),
                  onPressed: () => clearList(),
                  label: const Text("Clear Messages"),
                ),
              ),
              Expanded(
                child: ListView(
                  controller: scrollController,
                  scrollDirection: Axis.vertical,
                  shrinkWrap: true,
                  children: buildMessageList(),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
