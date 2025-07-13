import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:projecthub/view/advertisement/provider/advertisement_provider.dart';
import 'package:projecthub/view/bank_accounts/provider/bank_account_provider.dart';
import 'package:projecthub/view/home/provider/categories_provider.dart';
import 'package:projecthub/app_providers/creation_provider.dart';
import 'package:projecthub/view/transactions_history/provider/histroy_provider.dart';
import 'package:projecthub/app_providers/order_provider.dart';
import 'package:projecthub/view/shorts/provider/reels_providel.dart';
import 'package:projecthub/view/profile/provider/user_provider.dart';
import 'package:projecthub/constant/app_color.dart';
import 'package:projecthub/controller/initialization_controller.dart';
import 'package:provider/provider.dart';

import 'view/cart/provider/card_creation_provider.dart';
import 'view/network_check_screen/network_check_screen.dart';
import 'view/purchase/provider/purchased_creation_provider.dart';
import 'view/search_screen/provider/search_creation_controller.dart';
import 'view/splash/splash_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await AppInilization().initializeFirebase();
  await AppInilization().initializeNotifications();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => UserInfoProvider()),
        ChangeNotifierProvider(create: (_) => ListedCreationProvider()),
        ChangeNotifierProvider(create: (_) => GeneralCreationProvider()),
        ChangeNotifierProvider(create: (_) => RecentCreationProvider()),
        ChangeNotifierProvider(create: (_) => TreandingCreationProvider()),
        ChangeNotifierProvider(create: (_) => PurchedCreationProvider()),
        ChangeNotifierProvider(create: (_) => RecomandedCreationProvider()),
        ChangeNotifierProvider(create: (_) => InCardCreationProvider()),
        ChangeNotifierProvider(create: (_) => BankAccountProvider()),
        ChangeNotifierProvider(create: (_) => OrderProvider()),
        ChangeNotifierProvider(create: (_) => CategoriesProvider()),
        ChangeNotifierProvider(create: (_) => ReelsProvider()),
        ChangeNotifierProvider(create: (_) => HistroyProvider()),
        ChangeNotifierProvider(create: (_) => SearchedCreationProvider()),
        ChangeNotifierProvider(create: (_) => AdvertisementProvider()),
      ],
      child: GetMaterialApp(
        // navigatorKey: navigatorKey,
        debugShowCheckedModeBanner: false,
        routes: {
          '/splash': (context) => const Splashscreen(),
        },
        theme: ThemeData(
          scaffoldBackgroundColor: AppColor.bgColor,
          iconTheme: IconThemeData(
            color:
                AppColor.primaryColor, // Sets the default color for all icons
            size: 21,
          ),
          appBarTheme: AppBarTheme(
            color: AppColor.bgColor,
            iconTheme: const IconThemeData(color: Colors.black),
            titleTextStyle: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Color.fromARGB(255, 51, 51, 51),
            ),
          ),
          textTheme: TextTheme(
            headlineLarge: const TextStyle(
              fontSize: 32,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
            bodyLarge: TextStyle(
              fontSize: 16,
              color: Colors.grey[800],
            ),
            headlineMedium: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        home: const InternetChecker(child: Splashscreen()),
      ),
    );
  }
}
