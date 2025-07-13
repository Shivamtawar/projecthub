import 'package:flutter/material.dart';
import 'package:projecthub/constant/app_color.dart';
import 'package:projecthub/view/home/home_screen.dart';
import 'package:projecthub/view/listed_project/listed_creation_screen.dart';
import 'package:projecthub/view/profile/profile_screen.dart';
import 'package:projecthub/view/purchase/purchase_screen.dart';
import 'package:projecthub/view/search_screen/search_screen.dart';

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

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index; // Update the selected index
    });
    _pageController.jumpToPage(index); // Jump to the selected page
  }

  @override
  Widget build(BuildContext context) {
    // final appLocal = AppLocalizations.of(context)!;

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
          SearchScreen(),
          PurchaseScreen(), // First Screen
          ListedProjectScreen(), // First Screen
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
              selectedIcon: Icon(Icons.shopping_bag),
              icon: Icon(Icons.shopping_bag_outlined),
              label: "Purchased",
            ),
            NavigationDestination(
              selectedIcon: Icon(Icons.list_alt),
              icon: Icon(Icons.list_alt_outlined),
              label: "Listed",
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
}
