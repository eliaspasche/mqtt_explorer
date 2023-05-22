import 'package:flutter/material.dart';
import 'package:mqtt_explorer/pages/connect_page.dart';
import 'package:mqtt_explorer/pages/publish_page.dart';
import 'package:mqtt_client/mqtt_server_client.dart';

import 'package:mqtt_explorer/pages/subscribe/subscribe_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late PageController _pageController;
  int _page = 0;

  @override
  void initState() {
    _pageController = PageController();
    super.initState();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    void navigationTapped(int page) {
      _pageController.animateToPage(page,
          duration: const Duration(milliseconds: 300), curve: Curves.ease);
    }

    /// Handles page changes
    void onPageChanged(int page) {
      setState(() {
        _page = page;
      });
    }

    return Scaffold(
      bottomNavigationBar: NavigationBar(
        onDestinationSelected: navigationTapped,
        selectedIndex: _page,
        destinations: const <Widget>[
          NavigationDestination(
            icon: Icon(Icons.hub_rounded),
            label: 'Connection',
          ),
          NavigationDestination(
            icon: Icon(Icons.download_rounded),
            label: 'Subscribe',
          ),
          NavigationDestination(
            icon: Icon(Icons.publish_rounded),
            label: 'Publish',
          ),
        ],
      ),
      body: PageView(
        controller: _pageController,
        onPageChanged: onPageChanged,
        children: const <Widget>[
          ConnectionPage(),
          SubscribePage(),
          PublishPage(),
        ],
      ),
    );
  }
}
