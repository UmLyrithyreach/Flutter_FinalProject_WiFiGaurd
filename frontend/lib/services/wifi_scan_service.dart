import 'package:wifi_scan/wifi_scan.dart';

class WifiScanService {
  Future<List<WiFiAccessPoint>> scanWifi() async {
    await WiFiScan.instance.startScan();

    return await WiFiScan.instance.getScannedResults();
  }
}