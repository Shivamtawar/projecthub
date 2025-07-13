// ignore_for_file: use_build_context_synchronously

import 'dart:async';
import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:projecthub/view/advertisement/provider/advertisement_provider.dart';
import 'package:projecthub/view/home/provider/categories_provider.dart';
import 'package:projecthub/view/app_navigation_bar/app_navigation_bar.dart';
import 'package:provider/provider.dart';
import 'package:projecthub/app_providers/creation_provider.dart';
import 'package:projecthub/view/profile/provider/user_provider.dart';
import 'package:projecthub/utils/screen_size.dart';
import 'package:projecthub/utils/app_shared_preferences.dart';
import 'package:projecthub/view/intro_slider_screen/view/slider_screen.dart';
import 'package:projecthub/view/loading_screen/loading_screen.dart';
import '../error_screen/error_screen.dart';
import '../login/view/login_screen.dart';
import '../permission_screen/permission_screen.dart';

class Splashscreen extends StatefulWidget {
  const Splashscreen({super.key});

  @override
  State<Splashscreen> createState() => _SplashscreenState();
}

class _SplashscreenState extends State<Splashscreen> {
  bool? isIntro;
  int? isLoginId;
  bool _splashTimeout = false;
  bool _dataLoaded = false;

  @override
  void initState() {
    super.initState();
    // Start 3-second timer for splash screen
    Timer(const Duration(seconds: 3), () {
      if (!_dataLoaded) {
        setState(() => _splashTimeout = true);
      }
    });
    _loadInitialData();
  }

  Future<void> _loadInitialData() async {
    try {
      // 1. First load the basic preferences
      isIntro = await PrefData.getIntro();
      isLoginId = await PrefData.getLogin();

      // For testing: Uncomment if you need to clear preferences
      //PrefData.clearAppSharedPref();

      // 2. If user is logged in, fetch all required data
      if (isLoginId != null && isLoginId! > 0 && isIntro == true) {
        final locationStatus = await Permission.location.status;
        if (locationStatus.isGranted) {
          try {
            await _fetchUserData();
          } catch (e) {
            log("Error fetching user data: $e");

            Get.to(ErrorScreen(
                errorMessage: "Unable to load app data. Please try again.",
                onRetry: () {
                  _navigateToDefaultScreen(isLoginId ?? -1);
                }));
            return;
          }
        }
      }

      // Mark data as loaded
      _dataLoaded = true;

      // Navigate immediately if data is loaded
      _navigateAfterSplash();
    } catch (e) {
      log("Error in splash screen: $e");
      _dataLoaded = true; // Consider data loaded even if error occurs
      // Get.snackbar("Error", "Unable to load app data. Please try again.");
      // Get.to(ErrorScreen(
      //     errorMessage: e.toString(),
      //     onRetry: () {
      //       _navigateToDefaultScreen(isLoginId ?? -1);
      //     }));
    } finally {
      //setState(() => _isLoading = false);
    }
  }

  Future<void> _fetchUserData() async {
    try {
      await Future.wait([
        Provider.of<UserInfoProvider>(Get.context!, listen: false)
            .fetchUserDetails(isLoginId!),
        Provider.of<GeneralCreationProvider>(Get.context!, listen: false)
            .fetchGeneralCreations(isLoginId!, 1, 10),
        Provider.of<RecentCreationProvider>(Get.context!, listen: false)
            .fetchRecentCreations(isLoginId!, 1, 10),
        Provider.of<TreandingCreationProvider>(Get.context!, listen: false)
            .fetchTrendingCreations(isLoginId!, 1, 10),
        Provider.of<CategoriesProvider>(Get.context!, listen: false)
            .fetchCategories(isLoginId!),
        fetchAdvertisements(),
      ]);
    } catch (e) {
      log("Error fetching user data: $e");
      // Continue even if some API calls fail
      rethrow;
    }
  }

  Future<void> fetchAdvertisements() async {
    try {
      Position position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high);
      List<Placemark> placemarks =
          await placemarkFromCoordinates(position.latitude, position.longitude);
      await Provider.of<AdvertisementProvider>(Get.context!, listen: false)
          .getAdvertisements(isLoginId!, placemarks[0].locality!);
      Provider.of<UserInfoProvider>(context, listen: false)
          .setLocation(position);
    } catch (e) {
      log("Error fetching advertisements: $e");
    }
  }

  Future<void> _navigateAfterSplash() async {
    if (!_dataLoaded && !_splashTimeout) return;

    // Check location permission if user is logged in
    if (isLoginId != null && isLoginId! > 0) {
      final locationStatus = await Permission.location.status;
      if (!locationStatus.isGranted) {
        Get.offAll(() => PermissionRequestScreen(userId: isLoginId!));
        return;
      }
    }

    if (isIntro == false) {
      Get.offAll(() => const SlidePage());
    } else if (isLoginId == null || isLoginId == -1) {
      Get.offAll(() => const LoginScreen());
    } else if (_dataLoaded) {
      Get.offAll(() => const AppNavigationScreen());
    } else {
      Get.offAll(() => LoadingScreen(userId: isLoginId!));
    }
  }

  void _navigateToDefaultScreen(int userId) {
    Get.offAll(() => LoadingScreen(
          userId: userId,
        ));
  }

  @override
  Widget build(BuildContext context) {
    // If splash timeout occurred but data isn't loaded, show loading screen
    if (_splashTimeout && !_dataLoaded) {
      return LoadingScreen(userId: isLoginId ?? -1);
    }

    initializeScreenSize(context);
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Center(
            child: SizedBox(
              height: 95.h,
              width: 95.h,
              child: Image.asset(
                "assets/images/education_image.png",
                fit: BoxFit.cover,
              ),
            ),
          ),
          Text(
            "PROJECT HUB",
            style: TextStyle(
              fontSize: 28.sp,
              color: const Color(0XFF23408F),
              fontFamily: 'AvenirLTPro',
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }
}
