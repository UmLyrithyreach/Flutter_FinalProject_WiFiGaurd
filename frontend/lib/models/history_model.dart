import '../models/wifi_network.dart';

class HistoryModel {
  final WifiNetworkModel network;
  final DateTime viewedAt;

  HistoryModel({required this.network, required this.viewedAt});
}
