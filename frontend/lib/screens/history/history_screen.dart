import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/history_provider.dart';
import '../../models/history_model.dart';
import '../wifi/wifi_detail_screen.dart';
import '../home/home_screen.dart';
import '../profile/profile_screen.dart';

class HistoryScreen extends StatefulWidget {
  const HistoryScreen({Key? key}) : super(key: key);

  @override
  State<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      Provider.of<HistoryProvider>(context, listen: false).loadHistory();
    });
  }
  String getGroupLabel(DateTime viewedAt) {
    DateTime now = DateTime.now();
    DateTime today = DateTime(now.year, now.month, now.day);
    DateTime yesterday = today.subtract(const Duration(days: 1));
    DateTime entryDate = DateTime(viewedAt.year, viewedAt.month, viewedAt.day);

    if (entryDate == today) {
      return "TODAY";
    } else if (entryDate == yesterday) {
      return "YESTERDAY";
    } else {
      return "${viewedAt.day}/${viewedAt.month}/${viewedAt.year}";
    }
  }

  String formatTime(DateTime time) {
    int hour = time.hour;
    String period;

    if (hour >= 12) {
      period = "PM";
    } else {
      period = "AM";
    }

    int displayHour = hour % 12;
    if (displayHour == 0) {
      displayHour = 12;
    }

    String minuteText = time.minute.toString().padLeft(2, '0');

    return "$displayHour:$minuteText $period";
  }


  Map<String, List<HistoryModel>> buildGroupedHistory(
    List<HistoryModel> historyList,
  ) {
    Map<String, List<HistoryModel>> grouped = {};

    for (int i = 0; i < historyList.length; i++) {
      HistoryModel entry = historyList[i];
      String label = getGroupLabel(entry.viewedAt);

      if (grouped.containsKey(label) == false) {
        grouped[label] = [];
      }

      grouped[label]!.add(entry);
    }

    return grouped;
  }

  @override
  Widget build(BuildContext context) {
    HistoryProvider historyProvider = Provider.of<HistoryProvider>(context);
    Map<String, List<HistoryModel>> grouped = buildGroupedHistory(
      historyProvider.historyList,
    );

    return Scaffold(
      backgroundColor: const Color(0xFF0D0710),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 10),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    "History",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Container(
                    width: 44,
                    height: 44,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(14),
                      gradient: const LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [Color(0xFF7B2FF7), Color(0xFFB721FF)],
                      ),
                    ),
                    child: const Icon(
                      Icons.wifi,
                      color: Colors.white,
                      size: 20,
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 24),

              Expanded(child: buildHistoryArea(historyProvider, grouped)),
            ],
          ),
        ),
      ),

      bottomNavigationBar: Container(
        decoration: const BoxDecoration(color: Color(0xFF1A1420)),
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            buildNavItem(
              icon: Icons.wifi,
              label: "Scan",
              isSelected: false,
              onTap: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => const HomeScreen()),
                );
              },
            ),
            buildNavItem(
              icon: Icons.history,
              label: "History",
              isSelected: true,
              onTap: () {
                // already here, do nothing
              },
            ),
            buildNavItem(
              icon: Icons.person_outline,
              label: "Profile",
              isSelected: false,
              onTap: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const ProfileScreen(),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget buildHistoryArea(
    HistoryProvider historyProvider,
    Map<String, List<HistoryModel>> grouped,
  ) {
    if (historyProvider.isLoading == true) {
      return const Center(
        child: CircularProgressIndicator(color: Colors.white),
      );
    }

    if (historyProvider.historyList.isEmpty) {
      return const Center(
        child: Text(
          "No networks viewed yet.",
          style: TextStyle(color: Colors.grey, fontSize: 13),
        ),
      );
    }

    List<Widget> sections = [];
    List<String> groupKeys = grouped.keys.toList();

    for (int i = 0; i < groupKeys.length; i++) {
      String label = groupKeys[i];
      List<HistoryModel> entries = grouped[label]!;

      sections.add(
        Padding(
          padding: const EdgeInsets.only(bottom: 10),
          child: Text(
            label,
            style: const TextStyle(
              color: Colors.grey,
              fontSize: 11,
              letterSpacing: 1,
            ),
          ),
        ),
      );

      for (int j = 0; j < entries.length; j++) {
        sections.add(buildHistoryCard(entries[j]));
      }

      sections.add(const SizedBox(height: 14));
    }

    return ListView(children: sections);
  }

  Widget buildHistoryCard(HistoryModel entry) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => WifiDetailScreen(network: entry.network),
          ),
        );
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 10),
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: const Color(0xFF1A1420),
          borderRadius: BorderRadius.circular(14),
        ),
        child: Row(
          children: [
            Container(
              width: 38,
              height: 38,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: const Color(0xFF7B2FF7).withOpacity(0.2),
              ),
              child: const Icon(
                Icons.access_time,
                color: Color(0xFFB721FF),
                size: 18,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    entry.network.ssid,
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                    ),
                  ),
                  const SizedBox(height: 2),
                  const Text(
                    "Viewed",
                    style: TextStyle(color: Colors.grey, fontSize: 12),
                  ),
                ],
              ),
            ),
            Text(
              formatTime(entry.viewedAt),
              style: const TextStyle(color: Colors.grey, fontSize: 12),
            ),
            const SizedBox(width: 6),
            const Icon(Icons.chevron_right, color: Colors.grey, size: 18),
          ],
        ),
      ),
    );
  }

  Widget buildNavItem({
    required IconData icon,
    required String label,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    if (isSelected == true) {
      return GestureDetector(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 8),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            gradient: const LinearGradient(
              colors: [Color(0xFFEC4899), Color(0xFF7B2FF7)],
            ),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(icon, color: Colors.white, size: 20),
              const SizedBox(height: 2),
              Text(
                label,
                style: const TextStyle(color: Colors.white, fontSize: 11),
              ),
            ],
          ),
        ),
      );
    } else {
      return GestureDetector(
        onTap: onTap,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, color: Colors.grey, size: 20),
            const SizedBox(height: 2),
            Text(
              label,
              style: const TextStyle(color: Colors.grey, fontSize: 11),
            ),
          ],
        ),
      );
    }
  }
}
