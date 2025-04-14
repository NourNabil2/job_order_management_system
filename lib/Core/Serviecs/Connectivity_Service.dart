import 'dart:async';
import 'dart:developer' as developer;

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/cupertino.dart';

class InternetConnectivityService {
  InternetConnectivityService._internal();

  static final InternetConnectivityService instance =
  InternetConnectivityService._internal();

  factory InternetConnectivityService() => instance;

  List<ConnectivityResult>? connectionStatus;
  final Connectivity connectivity = Connectivity();
  StreamSubscription<List<ConnectivityResult>>? connectivitySubscription;

  ValueNotifier<bool> isOffline = ValueNotifier(false);

  /// Starts listening to internet connection changes
  void startListening() {
    connectivitySubscription =
        connectivity.onConnectivityChanged.listen(_updateConnectionStatus);
  }

  Future<void> _updateConnectionStatus(List<ConnectivityResult> result) async {
    connectionStatus = result;
    isOffline.value = connectionStatus!.contains(ConnectivityResult.none);

    developer.log("${isOffline.value}");

    developer.log('Connectivity changed: $connectionStatus');
  }

  /// Stops listening to network changes and prevents memory leaks
  void dispose() {
    connectivitySubscription?.cancel();
    connectivitySubscription = null;
  }
}