import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/wifi_provider.dart';
import '../../models/wifi_network.dart';
import '../wifi/wifi_detail_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int selectedTabIndex = 0;

  // this runs after the button is tapped and the provider is done
  // it decides which popup to show based on what the provider found
  void handleScanTap(WifiProvider wifiProvider) async {
    await wifiProvider.scanNetworks();

    if (wifiProvider.needPermission == true) {
      showLocationDialog(
        title: "Enable Location Access",
        message:
            "WiFiGuard needs location permission to scan nearby wifi networks.",
        buttonText: "Enable Location",
        onPressed: () {
          Navigator.pop(context);
          wifiProvider.locationService.requestPermission();
        },
      );
      return;
    }

    if (wifiProvider.needLocationService == true) {
      showLocationDialog(
        title: "Turn On Location Services",
        message:
            "Your location permission is on, but the phone's location service is off. Please turn it on to scan.",
        buttonText: "Open Settings",
        onPressed: () {
          Navigator.pop(context);
          wifiProvider.locationService.openLocationSettings();
        },
      );
      return;
    }
  }

  void showLocationDialog({
    required String title,
    required String message,
    required String buttonText,
    required VoidCallback onPressed,
  }) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: const Color(0xFF1A1420),
          title: Text(title, style: const TextStyle(color: Colors.white)),
          content: Text(message, style: const TextStyle(color: Colors.grey)),
          actions: [
            TextButton(
              onPressed: onPressed,
              child: Text(
                buttonText,
                style: const TextStyle(color: Color(0xFFEC4899)),
              ),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    WifiProvider wifiProvider = Provider.of<WifiProvider>(context);

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
                    "WifiGuard",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
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

              const SizedBox(height: 20),

              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(18),
                decoration: BoxDecoration(
                  color: const Color(0xFF1A1420),
                  borderRadius: BorderRadius.circular(18),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "GOOD AFTERNOON",
                      style: TextStyle(
                        color: Colors.grey,
                        fontSize: 11,
                        letterSpacing: 1,
                      ),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      "Scan now to protect your system, we are worrying!",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 16),

                    SizedBox(
                      width: double.infinity,
                      height: 48,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          padding: EdgeInsets.zero,
                          backgroundColor: Colors.transparent,
                          shadowColor: Colors.transparent,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30),
                          ),
                        ),
                        onPressed: () {
                          handleScanTap(wifiProvider);
                        },
                        child: Ink(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(30),
                            gradient: const LinearGradient(
                              colors: [Color(0xFFEC4899), Color(0xFF7B2FF7)],
                            ),
                          ),
                          child: Container(
                            alignment: Alignment.center,
                            child: buildScanButtonChild(
                              wifiProvider.isScanning,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 24),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    "NEARBY NETWORKS",
                    style: TextStyle(
                      color: Colors.grey,
                      fontSize: 11,
                      letterSpacing: 1,
                    ),
                  ),
                  Text(
                    "${wifiProvider.networkList.length} found",
                    style: const TextStyle(color: Colors.grey, fontSize: 11),
                  ),
                ],
              ),

              const SizedBox(height: 10),

              Expanded(child: buildNetworkArea(wifiProvider)),
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
            buildNavItem(icon: Icons.wifi, label: "Scan", index: 0),
            buildNavItem(icon: Icons.history, label: "History", index: 1),
            buildNavItem(
              icon: Icons.person_outline,
              label: "Profile",
              index: 2,
            ),
          ],
        ),
      ),
    );
  }

  // shows either the empty state or the list of scanned networks
  Widget buildNetworkArea(WifiProvider wifiProvider) {
    if (wifiProvider.networkList.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              width: 70,
              height: 60,
              child: Stack(
                children: [
                  const Positioned(
                    left: 5,
                    top: 0,
                    child: Icon(Icons.wifi, color: Color(0xFF4A9EFF), size: 60),
                  ),
                  Positioned(
                    bottom: 2,
                    right: 2,
                    child: Container(
                      width: 22,
                      height: 22,
                      decoration: BoxDecoration(
                        color: Colors.redAccent,
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: const Color(0xFF0D0710),
                          width: 2,
                        ),
                      ),
                      child: const Icon(
                        Icons.close,
                        color: Colors.white,
                        size: 14,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            const Text(
              "No networks detected nearby. Tap scan to search again.",
              style: TextStyle(color: Colors.grey, fontSize: 13),
            ),
          ],
        ),
      );
    } else {
      return ListView.builder(
        itemCount: wifiProvider.networkList.length,
        itemBuilder: (context, index) {
          WifiNetworkModel network = wifiProvider.networkList[index];
          return buildNetworkCard(network);
        },
      );
    }
  }

  Widget buildNetworkCard(WifiNetworkModel network) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => WifiDetailScreen(network: network),
          ),
        );
      },
      child: buildNetworkCardContent(network),
    );
  }

  Widget buildNetworkCardContent(WifiNetworkModel network) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: const Color(0xFF1A1420),
        borderRadius: BorderRadius.circular(14),
      ),
      child: Row(
        children: [
          const Icon(Icons.wifi, color: Color(0xFF4A9EFF)),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  network.ssid,
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  "${network.encryptionType} · ${network.frequency} · ${network.rssi} dBm",
                  style: const TextStyle(color: Colors.grey, fontSize: 11),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget buildScanButtonChild(bool isScanning) {
    if (isScanning == true) {
      return const SizedBox(
        width: 20,
        height: 20,
        child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2),
      );
    } else {
      return const Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.refresh, color: Colors.white, size: 18),
          SizedBox(width: 8),
          Text(
            "Scan Nearby WiFi",
            style: TextStyle(
              color: Colors.white,
              fontSize: 15,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      );
    }
  }

  Widget buildNavItem({
    required IconData icon,
    required String label,
    required int index,
  }) {
    bool isSelected = selectedTabIndex == index;

    if (isSelected == true) {
      return GestureDetector(
        onTap: () {
          setState(() {
            selectedTabIndex = index;
          });
        },
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
        onTap: () {
          setState(() {
            selectedTabIndex = index;
          });
        },
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
