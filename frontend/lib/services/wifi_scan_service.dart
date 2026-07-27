import 'package:wifi_scan/wifi_scan.dart';

import '../models/wifi_network.dart';

class WifiScanService {
  Future<List<WifiNetworkModel>> scanNetworks() async {
    final canStartScan = await WiFiScan.instance.canStartScan(
      askPermissions: true,
    );
    if (canStartScan != CanStartScan.yes) {
      return [];
    }

    final started = await WiFiScan.instance.startScan();
    if (!started) {
      return [];
    }

    final canGetResults = await WiFiScan.instance.canGetScannedResults();
    if (canGetResults != CanGetScannedResults.yes) {
      return [];
    }

    final rawList = await WiFiScan.instance.getScannedResults();
    return rawList.map(_toNetworkModel).toList(growable: false);
  }

  WifiNetworkModel _toNetworkModel(WiFiAccessPoint raw) {
    final frequency = raw.frequency;
    final isFiveGhz = frequency > 5000;
    final capabilities = raw.capabilities;

    return WifiNetworkModel(
      ssid: raw.ssid.isEmpty ? 'Unknown' : raw.ssid,
      bssid: raw.bssid.isEmpty ? 'Unknown' : raw.bssid,
      rssi: raw.level,
      frequency: isFiveGhz ? '5 GHz' : '2.4 GHz',
      channel: isFiveGhz ? (frequency - 5000) ~/ 5 : (frequency - 2407) ~/ 5,
      encryptionType: capabilities.contains('WPA3')
          ? 'WPA3'
          : capabilities.contains('WPA2')
          ? 'WPA2'
          : capabilities.contains('WPA')
          ? 'WPA'
          : 'Open',
    );
  }
}
