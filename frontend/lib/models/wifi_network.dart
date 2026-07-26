// this class is just a shape for one wifi network
// it does not do anything, it only holds data

class WifiNetworkModel {
  final String ssid;
  final String bssid;
  final int rssi;
  final String frequency;
  final int channel;
  final String encryptionType;

  WifiNetworkModel({
    required this.ssid,
    required this.bssid,
    required this.rssi,
    required this.frequency,
    required this.channel,
    required this.encryptionType,
  });
}
