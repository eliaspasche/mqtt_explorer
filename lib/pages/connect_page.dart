import 'package:flutter/material.dart';
import 'package:mqtt_client/mqtt_client.dart';
import 'package:mqtt_explorer/models/client.dart';
import 'package:mqtt_explorer/models/status.dart';
import 'package:provider/provider.dart';

class ConnectionPage extends StatefulWidget {
  const ConnectionPage({super.key});

  @override
  State<ConnectionPage> createState() => _ConnectionPageState();
}

class _ConnectionPageState extends State<ConnectionPage> {
  TextEditingController brokerController = TextEditingController();

  void _onClick() {
    if (context.read<Client>().client.connectionStatus?.state ==
        MqttConnectionState.connected) {
      context.read<Client>().disconnect();
    } else {
      context.read<Client>().connect(brokerController.value.text);
    }
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      brokerController.text =
          Provider.of<Client>(context, listen: false).client.server;
    });
  }

  @override
  Widget build(BuildContext context) {
    Status status = context.watch<Client>().status;

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
                controller: brokerController,
                onSubmitted: (value) => _onClick(),
                onChanged: (value) {
                  if (status == Status.connected) {
                    context.read<Client>().disconnect();
                  }
                },
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
                    onPressed: () {
                      _onClick();
                    },
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

class ConnectionStatus extends StatelessWidget {
  const ConnectionStatus({super.key});

  @override
  Widget build(BuildContext context) {
    Status status = context.watch<Client>().status;

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
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
    );
  }
}
