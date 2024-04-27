import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:mqtt_client/mqtt_client.dart';
import 'package:mqtt_client/mqtt_browser_client.dart';
import 'package:mqtt_client/mqtt_server_client.dart';

class MqttService {
  dynamic client;

  Future<bool> publish(String topic, String message) async {
    if (kIsWeb) {
      client = MqttBrowserClient.withPort(
          'wss://broker.emqx.io/mqtt', 'flutter_web_app', 8084);
    } else {
      client = MqttServerClient.withPort(
          'broker.emqx.io', 'flutter_android_app', 1883);
    }

    client.logging(on: true);
    client.setProtocolV311();
    client.keepAlivePeriod = 60;
    client.connectTimeoutPeriod = 10000;

    try {
      await client.connect();
    } on Exception catch (_) {
      client.disconnect();
      return false;
    }

    if (client.connectionStatus!.state != MqttConnectionState.connected) {
      return false;
    }

    final builder = MqttClientPayloadBuilder();
    builder.addString(message);
    client.publishMessage(topic, MqttQos.atMostOnce, builder.payload!);
    client.disconnect();

    return true;
  }
}
