import 'package:flutter/material.dart';
import 'package:mqtt_client/mqtt_client.dart';
import 'package:mqtt_explorer/models/client.dart';
import 'package:mqtt_explorer/models/status.dart';
import 'package:mqtt_explorer/shared/snacks.dart';
import 'package:provider/provider.dart';

/// Page to configure the connection to a mqtt broker
class ConnectionPage extends StatefulWidget {
  const ConnectionPage({super.key});

  @override
  State<ConnectionPage> createState() => _ConnectionPageState();
}

class _ConnectionPageState extends State<ConnectionPage> {
  late TextEditingController _brokerController;
  late ScaffoldMessengerState _messenger;

  @override
  void initState() {
    super.initState();

    _brokerController = TextEditingController();

    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      _brokerController.text =
          Provider.of<Client>(context, listen: false).client.server;
    });
  }

  @override
  void didChangeDependencies() {
    _messenger = ScaffoldMessenger.of(context);
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    _brokerController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Status status = context.watch<Client>().status;
    bool isReadyToConnect = context.watch<Client>().broker.isNotEmpty;

    /// Handles changes of the broker text field.
    void onBrokerChange(String value) {
      // Update broker
      context.read<Client>().broker = value;

      // Disconnect on changes if the current state is connected.
      if (status == Status.connected) {
        context.read<Client>().disconnect();
      }
    }

    /// Connects to a broker. The current value of the broker text field is used.
    /// Shows a snack in case of any error for user feedback.
    void connectToBroker() async {
      if (context.read<Client>().client.connectionStatus?.state ==
          MqttConnectionState.connected) {
        context.read<Client>().disconnect();
      } else {
        try {
          await context.read<Client>().connect();
        } catch (e) {
          _messenger.showSnackBar(
              errorSnack("Error while connecting.", e.toString()));
        }
      }
    }

    return Container(
      margin: const EdgeInsets.all(20),
      alignment: Alignment.topCenter,
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              const ListTile(
                leading: Icon(Icons.hub_outlined),
                title: Text("Connection"),
                subtitle: Text("Configure the connection to a MQTT broker."),
              ),
              const SizedBox(height: 8),
              const ConnectionStatus(),
              const SizedBox(height: 8),
              TextField(
                controller: _brokerController,
                onSubmitted: (value) =>
                    isReadyToConnect ? connectToBroker() : null,
                onChanged: onBrokerChange,
                decoration: InputDecoration(
                  border: const OutlineInputBorder(),
                  hintText: 'MQTT Broker',
                  icon: Icon(
                    status.icon,
                    color: status.color,
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  FilledButton.icon(
                    icon: Icon(status == Status.connected
                        ? Icons.stop_rounded
                        : Icons.play_arrow_rounded),
                    label: Text(
                        status == Status.connected ? 'Disconnect' : 'Connect'),
                    onPressed: () =>
                        isReadyToConnect ? connectToBroker() : null,
                    style: ButtonStyle(
                        backgroundColor: status == Status.connected
                            ? MaterialStateProperty.all<Color>(Colors.red)
                            : MaterialStateProperty.all<Color>(Colors.green),
                        foregroundColor:
                            MaterialStateProperty.all<Color>(Colors.white)),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Helper widget to display the current connection status.
class ConnectionStatus extends StatelessWidget {
  const ConnectionStatus({super.key});

  @override
  Widget build(BuildContext context) {
    // Get required variables from context
    Status status = context.watch<Client>().status;
    String? error = context.watch<Client>().errorMessage;

    return Tooltip(
      message: status == Status.faulted ? error : "",
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            status.icon,
            color: status.color,
          ),
          const SizedBox(width: 8),
          Text(
            status.message,
            style: TextStyle(color: status.color),
          ),
        ],
      ),
    );
  }
}
