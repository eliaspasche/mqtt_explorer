# MQTT Explorer

# Technology
- dart
- flutter

# Local setup
Download the flutter sdk from https://docs.flutter.dev/get-started/install and follow the installation guide. 
You can check your flutter installtion using `flutter doctor`.

To run this application you will need to switch to the latest version of flutter using `flutter channel master`
and update the versions using `flutter upgrade`.

To get or update your local dependencies use `flutter pub get`.

If you are developing with Visual Studio Code you can hit `F5` to start the application in debug mode or type `flutter run` in your terminal.


# Pages of the Application
The app is devided into three pages. A bottom navigation is used to navigate between these pages.

## Connection Page
On this page the connection to a MQTT broker can be configured. The app can connect via an ip address or a hostname.  
Currently the port `1883` is used always due to the connection without SSL and authentication.

The current connection state is displayed for the users with icons and text. In addition to that, colors are used to indicate the status.

## Subscribe Page
The user can subscribe to multiple topics on this page. Messages from the configured broker with one of the subscribed topics are displayed below. 

The list of messages can be cleared completly. Single messages can be removed as well.

## Publish Page
On this page, the use can publish own messages to the configured broker using a custom topic.  
The buttons to publish a message is only enabled, if a topic is configured. The user is informed via tooltip about this behavior.

# Error Handling
In case of errors, especially connection erros, the user is informed with notifications and tooltips. Highlight colors for errors and success are used here aswell.

# UML Class Diagram
![UML class diagram](https://github.com/eliaspasche/mqtt_explorer/blob/bdd0899cac752742388a8f83b3345f3f57464670/docs/UML_class_diagram.png)

# Visualisation UI Elements
To get a better understanding of the ui components we provide a visualisation of the main ui widgets.
