import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:projecthub/view/profile/provider/user_provider.dart';
import 'package:projecthub/constant/app_color.dart';
import 'package:projecthub/services/app_local_permission_service.dart';
import 'package:projecthub/view/home/view/home_screen.dart';
import 'package:projecthub/view/profile/view/profile_screen.dart';
import 'package:projecthub/view/purchase/view/purchase_screen.dart';
import 'package:projecthub/view/search_screen/search_screen.dart';
import 'package:geocoding/geocoding.dart';
import 'package:provider/provider.dart';

import '../shorts/view/shorts_screen.dart';

// import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class AppNavigationScreen extends StatefulWidget {
  const AppNavigationScreen({super.key});

  @override
  State<AppNavigationScreen> createState() => _AppNavigationScreenState();
}

class _AppNavigationScreenState extends State<AppNavigationScreen> {
  int _selectedIndex = 0; // Current index of the selected button
  final PageController _pageController =
      PageController(); // Page controller to manage PageView
  AppLocalPermissionService appPermissionController =
      AppLocalPermissionService();

  @override
  void initState() {
    super.initState();
    requestpermissions(); // Request location permissions on startup
  }

  void requestpermissions() async {
    // Check if location services are enabled
    appPermissionController.requestNotificationPermission();
    appPermissionController.requestStoragePermission();
    bool isLocationEnabled = await appPermissionController.isLocationOn();
    if (!isLocationEnabled) {
      // If not, show a dialog to inform the user
      showLocationErrorDialog("Location services are disabled.");
    } else {
      // If location services are enabled, check for permissions
      bool isPermissionGranted =
          await appPermissionController.requestLocationPermission();
      if (!isPermissionGranted) {
        // If permission is not granted, show a dialog to inform the user
        showLocationErrorDialog("Location permissions are denied.");
      } else {
        // If permission is granted, proceed with your logic
        // For example, you can fetch the user's location here
        Position position = await Geolocator.getCurrentPosition(
            desiredAccuracy: LocationAccuracy.high);

        Provider.of<UserInfoProvider>(Get.context!, listen: false)
            .setLocation(position);
        List<Placemark> placemarks = await placemarkFromCoordinates(
            position.latitude, position.longitude);

        if (placemarks.isNotEmpty) {
          log(placemarks[0].locality!); // this is the city name
        }
      }
    }
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index; // Update the selected index
    });
    _pageController.jumpToPage(index); // Jump to the selected page
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView(
        physics: const NeverScrollableScrollPhysics(),
        pageSnapping: false,
        controller: _pageController, // Connect the PageController
        onPageChanged: (index) {
          setState(() {
            _selectedIndex = index; // Update the selected index
          });
        },
        children: const [
          HomeScreen(),
          TemplateListScreen(),
          ReelsScreen(),
          PurchaseScreen(), // First Screen
          ProfileScreen(), // First Screen
        ],
      ),
      bottomNavigationBar: NavigationBarTheme(
        data: NavigationBarThemeData(
          indicatorColor: Colors.transparent,
          // labelTextStyle: WidgetStatePropertyAll(TextStyle(fontSize: 12.5)),
          labelTextStyle: WidgetStateProperty.resolveWith<TextStyle>(
            (Set<WidgetState> states) {
              if (states.contains(WidgetState.selected)) {
                return TextStyle(
                  color: AppColor.primaryColor,
                  fontSize: 13.5,
                  fontWeight: FontWeight.w500,
                ); // Selected label style
              }
              return const TextStyle(
                // fontWeight: FontWeight.w500,
                color: Color.fromARGB(255, 113, 113, 113),
                fontSize: 13,
              ); // Unselected label style
            },
          ),
          // Set different icon styles based on their state
          iconTheme: WidgetStateProperty.resolveWith<IconThemeData>(
            (Set<WidgetState> states) {
              if (states.contains(WidgetState.selected)) {
                return IconThemeData(
                  color: AppColor.primaryColor,
                ); // Selected icon color
              }
              return const IconThemeData(
                  color:
                      Color.fromARGB(255, 81, 81, 81)); // Unselected icon color
            },
          ),
        ),
        child: NavigationBar(
          backgroundColor: const Color.fromARGB(255, 255, 255, 255),
          onDestinationSelected: _onItemTapped,
          selectedIndex: _selectedIndex,

          //labelBehavior: NavigationDestinationLabelBehavior.onlyShowSelected,
          //animationDuration: Duration(seconds: 1),
          destinations: const [
            NavigationDestination(
              selectedIcon: Icon(Icons.home),
              icon: Icon(Icons.home_outlined),
              label: "Home",
            ),
            NavigationDestination(
              selectedIcon: Icon(Icons.search),
              icon: Icon(Icons.search_outlined),
              label: "Seach",
            ),
            NavigationDestination(
              selectedIcon: Icon(Icons.play_circle_fill),
              icon: Icon(Icons.play_circle_outlined),
              label: "Clips",
            ),
            NavigationDestination(
              selectedIcon: Icon(Icons.shopping_bag),
              icon: Icon(Icons.shopping_bag_outlined),
              label: "Purchased",
            ),
            NavigationDestination(
              selectedIcon: Icon(Icons.person),
              icon: Icon(Icons.person_outlined),
              label: "Profile",
            ),
          ],
        ),
      ),
    );
  }

  void showLocationErrorDialog(String errorMessage) {
    showDialog(
      context: context,
      builder: (context) {
        String message = "An error occurred while fetching location.";
        if (errorMessage.contains('Location services are disabled')) {
          message = "Please enable location services.";
        } else if (errorMessage.contains('Location permissions are denied')) {
          message = "Location permissions are denied. Please enable them.";
        } else if (errorMessage
            .contains('Location permissions are permanently denied')) {
          message =
              "Location permissions are permanently denied. Please enable them in the app settings.";
        }

        return AlertDialog(
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                message,
                textAlign: TextAlign.center,
              ),
              const SizedBox(
                height: 10,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: const Text(
                      "Cancel",
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 17,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                  TextButton(
                    onPressed: () async {
                      await Geolocator.openAppSettings();
                    },
                    child: const Text(
                      "Open settings",
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 17,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}
