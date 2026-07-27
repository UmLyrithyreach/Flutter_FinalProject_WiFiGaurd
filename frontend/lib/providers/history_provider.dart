import 'package:flutter/material.dart';
import '../models/history_model.dart';
import '../models/wifi_network.dart';
import '../services/history_service.dart';

class HistoryProvider extends ChangeNotifier {
  final HistoryService historyService = HistoryService();

  List<HistoryModel> historyList = [];
  bool isLoading = false;

  Future<void> loadHistory() async {
    isLoading = true;
    notifyListeners();

    List<HistoryModel> result = await historyService.getHistory();
    historyList = result;

    isLoading = false;
    notifyListeners();
  }

  // called from wifi_detail_screen.dart every time a network is opened
  Future<void> addToHistory(WifiNetworkModel network) async {
    await historyService.addToHistory(network);
    await loadHistory();
  }
}
