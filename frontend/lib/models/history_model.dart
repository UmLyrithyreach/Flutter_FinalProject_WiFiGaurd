import '../models/wifi_network.dart';

class HistoryModel {
  final WifiNetworkModel network;
  final DateTime viewedAt;

  HistoryModel({required this.network, required this.viewedAt});

  Map<String, dynamic> toMap() {
    return {
      'ssid': network.ssid,
      'bssid': network.bssid,
      'rssi': network.rssi,
      'frequency': network.frequency,
      'channel': network.channel,
      'encryptionType': network.encryptionType,
      'viewedAt': viewedAt.toIso8601String(),
    };
  }

  factory HistoryModel.fromMap(Map<String, dynamic> map) {
    return HistoryModel(
      network: WifiNetworkModel(
        ssid: map['ssid'],
        bssid: map['bssid'],
        rssi: map['rssi'],
        frequency: map['frequency'],
        channel: map['channel'],
        encryptionType: map['encryptionType'],
      ),
      viewedAt: DateTime.parse(map['viewedAt']),
    );
  }
}
