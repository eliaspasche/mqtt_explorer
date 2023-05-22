# MQTT Explorer

## Technology Stack
- dart
- flutter

## Functionality

### Pages
The app is devided into three pages. A bottom navigation is used to navigate between these pages.

#### Connection
On this page the connection to a MQTT broker can be configured. The app can connect via an ip address or a hostname.
Currently the port `1883` is used always due to the connection without SSL and authentication.

The current connection state is displayed for the users with icons and text. In addition to that, colors are used to indicate the status.

#### Subscribe
The user can subscribe to multiple topics on this page. Messages from the configured broker with one of the subscribed topics are displayed below. 

The list of messages can be cleared completly. Single messages can be removed as well.

#### Publish
On this page, the use can publish own messages to the configured broker using a custom topic. The buttons to publish a message is only enabled, if a topic is configured. The user is informed via tooltip about this behavior.

### Error Handling
In case of errors, especially connection erros, the user is informed with notifications and tooltips. Highlight colors for errors and success are used here aswell.

