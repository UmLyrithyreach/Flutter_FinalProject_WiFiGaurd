import '../models/history_model.dart';
import '../models/wifi_network.dart';

// this is just a temporary version so history screen works for now
// friend will change the inside of these functions to use real firestore

class HistoryService {
  static List<HistoryModel> fakeHistory = [];

  Future<List<HistoryModel>> getHistory() async {
    await Future.delayed(const Duration(milliseconds: 300));
    return fakeHistory;
  }

  Future<void> addToHistory(WifiNetworkModel network) async {
    HistoryModel entry = HistoryModel(
      network: network,
      viewedAt: DateTime.now(),
    );

    // add newest first so the list shows most recent on top
    fakeHistory.insert(0, entry);
  }
}
