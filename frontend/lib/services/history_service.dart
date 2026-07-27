import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../models/history_model.dart';
import '../models/wifi_network.dart';

class HistoryService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<List<HistoryModel>> getHistory() async {
    User? user = _auth.currentUser;

    if (user == null) {
      return [];
    }

    QuerySnapshot snapshot = await _firestore
        .collection('users')
        .doc(user.uid)
        .collection('history')
        .orderBy('viewedAt', descending: true)
        .get();

    List<HistoryModel> history = [];

    for (var doc in snapshot.docs) {
      history.add(HistoryModel.fromMap(doc.data() as Map<String, dynamic>));
    }

    return history;
  }

  Future<void> addToHistory(WifiNetworkModel network) async {
    User? user = _auth.currentUser;

    if (user == null) {
      return;
    }

    HistoryModel entry = HistoryModel(
      network: network,
      viewedAt: DateTime.now(),
    );

    await _firestore
        .collection('users')
        .doc(user.uid)
        .collection('history')
        .add(entry.toMap());
  }
}
