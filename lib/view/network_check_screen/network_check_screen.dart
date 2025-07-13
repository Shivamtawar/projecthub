import 'dart:async';
import 'dart:developer';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:projecthub/constant/app_color.dart';

class InternetChecker extends StatefulWidget {
  final Widget child;

  const InternetChecker({Key? key, required this.child}) : super(key: key);

  @override
  _InternetCheckerState createState() => _InternetCheckerState();
}

class _InternetCheckerState extends State<InternetChecker> {
  bool? _isConnected;
  late StreamSubscription<List<ConnectivityResult>> _connectivitySubscription;

  @override
  void initState() {
    super.initState();
    _initConnectivity();
  }

  Future<void> _initConnectivity() async {
    // Initial check
    await _checkInternetConnection();

    // Listen for changes
    _connectivitySubscription = Connectivity()
        .onConnectivityChanged
        .listen((List<ConnectivityResult> results) {
      _checkInternetConnection();
    });
  }

  Future<void> _checkInternetConnection() async {
    try {
      var connectivityResult = await Connectivity().checkConnectivity();
      final newState = connectivityResult.isNotEmpty &&
          connectivityResult.contains(ConnectivityResult.none) == false;

      if (_isConnected != newState) {
        setState(() {
          _isConnected = newState;
        });
      }
    } catch (e) {
      log('Error checking connectivity: $e');
      setState(() {
        _isConnected = false;
      });
    }
  }

  @override
  void dispose() {
    _connectivitySubscription.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Show loading while checking initial connection
    if (_isConnected == null) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return _isConnected! ? widget.child : _buildNoInternetScreen();
  }

  Widget _buildNoInternetScreen() {
    return PopScope(
      canPop: false, // Prevent back button from working
      child: Scaffold(
        backgroundColor: Colors.white,
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                "assets/images/nointernet.jpg",
                height: 120,
              ),
              const SizedBox(height: 20),
              const Text(
                "No Internet Connection",
                style: TextStyle(
                  fontSize: 18,
                  color: Colors.red,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 20),
              const Text(
                "Please check your connection and try again",
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 14),
              ),
              const SizedBox(height: 30),
              ElevatedButton(
                onPressed: _checkInternetConnection,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColor.primaryColor,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
                ),
                child: const Text(
                  "Retry",
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
