import 'dart:async';
import 'dart:io';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:weather_app/app/app.logger.dart';

class ConnectivityService {
  final log = getLogger('ConnectivityService');
  final Connectivity _connectivity = Connectivity();
  bool hasConnection = false;
  StreamController<bool> connectionChangeController =
      StreamController.broadcast();
  Stream<bool> get connectionChange => connectionChangeController.stream;
  ConnectivityService() {
    log.i('ConnectivityService initialised');
    checkInternetConnection();
  }
  Future<bool> checkInternetConnection() async {
    bool previousConnection = hasConnection;
    try {
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        hasConnection = true;
      } else {
        hasConnection = false;
      }
    } on SocketException catch (_) {
      hasConnection = false;
    }
    if (previousConnection != hasConnection) {
      connectionChangeController.add(hasConnection);
      onChange();
    }
    return hasConnection;
  }

  void _connectionChange(ConnectivityResult result) {
    checkInternetConnection();
  }

  void onChange() {
    _connectivity.onConnectivityChanged.listen(_connectionChange);
  }

  void dispose() {
    connectionChangeController.close();
  }
}
