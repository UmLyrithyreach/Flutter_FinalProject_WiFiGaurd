import 'package:device_preview/device_preview.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'firebase_options.dart';
import 'providers/auth_provider.dart';
import 'providers/wifi_provider.dart';
import 'providers/review_provider.dart';
import 'models/wifi_network.dart';
import 'screens/home/home_screen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        ChangeNotifierProvider(
          create: (_) => WifiProvider()
            ..networkList = [
              WifiNetworkModel(
                ssid: "Office_WiFi",
                bssid: "00:AA:BB:CC:11:22",
                rssi: -43,
                frequency: "5 GHz",
                channel: 149,
                encryptionType: "WPA3",
              ),
              WifiNetworkModel(
                ssid: "CADT_Student",
                bssid: "11:22:33:44:55:66",
                rssi: -61,
                frequency: "2.4 GHz",
                channel: 6,
                encryptionType: "WPA2",
              ),
              WifiNetworkModel(
                ssid: "Coffee_Shop",
                bssid: "77:88:99:AA:BB:CC",
                rssi: -72,
                frequency: "2.4 GHz",
                channel: 11,
                encryptionType: "Open",
              ),
            ],
        ),
        ChangeNotifierProvider(create: (_) => ReviewProvider()),
      ],
      child: DevicePreview(enabled: true, builder: (context) => const MyApp()),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      locale: DevicePreview.locale(context),
      builder: DevicePreview.appBuilder,
      home: const HomeScreen(),
    );
  }
}
