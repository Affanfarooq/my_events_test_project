import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:get/get.dart';

class NetworkController extends GetxController {
  final Connectivity _connectivity = Connectivity();
  
  var isConnected = true.obs;

  @override
  void onInit() {
    super.onInit();
    _checkInitialConnection();
    
    _connectivity.onConnectivityChanged.listen((List<ConnectivityResult> results) {
      _updateConnectionStatus(results);
    });
  }

  Future<void> _checkInitialConnection() async {
    final results = await _connectivity.checkConnectivity();
    _updateConnectionStatus(results);
  }

  void _updateConnectionStatus(List<ConnectivityResult> results) {
    final bool hasConnection = !results.contains(ConnectivityResult.none);
    
    if (isConnected.value != hasConnection) {
      isConnected.value = hasConnection;
    }
  }
}