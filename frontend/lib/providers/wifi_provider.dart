import 'package:flutter/material.dart';
import '../services/location_service.dart';
import '../services/wifi_scan_service.dart';
import '../models/wifi_network.dart';

class WifiProvider extends ChangeNotifier {
  final LocationService locationService = LocationService();
  final WifiScanService wifiScanService = WifiScanService();

  List<WifiNetworkModel> networkList = [];
  bool isScanning = false;

  // these two tell the home screen which "case" screen to show
  bool needPermission = false;
  bool needLocationService = false;

  Future<void> scanNetworks() async {
    isScanning = true;
    needPermission = false;
    needLocationService = false;
    notifyListeners();

    // Case A: check permission first
    bool hasPermission = await locationService.hasPermission();

    if (hasPermission == false) {
      hasPermission = await locationService.requestPermission();
    }

    if (hasPermission == false) {
      needPermission = true;
      isScanning = false;
      notifyListeners();
      return;
    }

    // Case B: check if gps service is on
    bool serviceOn = await locationService.isServiceEnabled();

    if (serviceOn == false) {
      needLocationService = true;
      isScanning = false;
      notifyListeners();
      return;
    }

    // both checks passed, now actually scan
    List<WifiNetworkModel> result = await wifiScanService.scanNetworks();
    networkList = result;

    isScanning = false;
    notifyListeners();
  }
}
