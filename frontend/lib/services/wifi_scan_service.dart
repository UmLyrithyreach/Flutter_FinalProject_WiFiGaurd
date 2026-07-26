import 'package:wifi_iot/wifi_iot.dart';
import '../models/wifi_network.dart';

// this file only talks to the wifi_iot package
// it takes the raw scan data and turns it into WifiNetworkModel

class WifiScanService {
  Future<List<WifiNetworkModel>> scanNetworks() async {
    List<WifiNetwork> rawList = await WiFiForIoTPlugin.loadWifiList();

    List<WifiNetworkModel> networkList = [];

    for (int i = 0; i < rawList.length; i++) {
      WifiNetwork raw = rawList[i];

      String ssidValue;
      if (raw.ssid == null) {
        ssidValue = "Unknown";
      } else {
        ssidValue = raw.ssid!;
      }

      String bssidValue;
      if (raw.bssid == null) {
        bssidValue = "Unknown";
      } else {
        bssidValue = raw.bssid!;
      }

      int rssiValue;
      if (raw.level == null) {
        rssiValue = 0;
      } else {
        rssiValue = raw.level!;
      }

      String frequencyValue;
      int channelValue;

      if (raw.frequency == null) {
        frequencyValue = "Unknown";
        channelValue = 0;
      } else {
        if (raw.frequency! > 5000) {
          frequencyValue = "5 GHz";
          channelValue = (raw.frequency! - 5000) ~/ 5;
        } else {
          frequencyValue = "2.4 GHz";
          channelValue = (raw.frequency! - 2407) ~/ 5;
        }
      }

      String encryptionValue;
      if (raw.capabilities == null) {
        encryptionValue = "Unknown";
      } else {
        if (raw.capabilities!.contains("WPA3")) {
          encryptionValue = "WPA3";
        } else if (raw.capabilities!.contains("WPA2")) {
          encryptionValue = "WPA2";
        } else if (raw.capabilities!.contains("WPA")) {
          encryptionValue = "WPA";
        } else {
          encryptionValue = "Open";
        }
      }

      WifiNetworkModel network = WifiNetworkModel(
        ssid: ssidValue,
        bssid: bssidValue,
        rssi: rssiValue,
        frequency: frequencyValue,
        channel: channelValue,
        encryptionType: encryptionValue,
      );

      networkList.add(network);
    }

    return networkList;
  }
}
