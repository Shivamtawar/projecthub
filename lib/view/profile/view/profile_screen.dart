import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:get/get.dart';
import 'package:projecthub/view/profile/provider/user_provider.dart';
import 'package:projecthub/config/api_config.dart';
import 'package:projecthub/constant/app_color.dart';
import 'package:projecthub/constant/app_padding.dart';
import 'package:projecthub/controller/logout_data_controller.dart';
import 'package:projecthub/view/cart/view/cart_page.dart';
import 'package:projecthub/view/user_listed_creation/view/listed_creation_screen.dart';
import 'package:projecthub/view/bank_accounts/view/bank_account_page.dart';
import 'package:projecthub/view/profile/view/edit_profile.dart';
import 'package:projecthub/view/splash/splash_screen.dart';
import 'package:projecthub/widgets/app_primary_button.dart';
import 'package:provider/provider.dart';

import '../../../utils/app_shared_preferences.dart';
import '../../advertisement/view/add_submission_form.dart';
import '../../app_navigation_bar/app_navigation_bar.dart';
import '../reffer_screen.dart';
import '../../transactions_history/view/all_transactions_screen.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  @override
  void initState() {
    super.initState();

    SchedulerBinding.instance.addPostFrameCallback((_) {
      Provider.of<UserInfoProvider>(context, listen: false).fetchUserDetails(
          Provider.of<UserInfoProvider>(context, listen: false).user!.userId);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: WillPopScope(
        onWillPop: () async {
          Get.offAll(() => const AppNavigationScreen(),
              transition: Transition
                  .leftToRightWithFade); // Replace with your actual home screen
          return false;
        },
        child: SafeArea(
          child:
              Consumer<UserInfoProvider>(builder: (context, provider, child) {
            // if (provider.isLoading) {
            //   return const Center(child: CircularProgressIndicator());
            // }

            // if (provider.errorMessage.isNotEmpty) {
            //   return Center(child: Text(provider.errorMessage));
            // }

            // if (provider.user == null) {
            //   return const Center(
            //       child:
            //           Text("error occur\nplease clear all cache and try again"));
            // }

            return SingleChildScrollView(
              child: Column(
                children: [
                  const SizedBox(height: 20),
                  ProfileHeader(user: provider.user),
                  WalletRow(user: provider.user),
                  OptionList(user: provider.user),
                ],
              ),
            );
          }),
        ),
      ),
    );
  }
}

// Profile Header Section
class ProfileHeader extends StatelessWidget {
  // ignore: prefer_typing_uninitialized_variables
  final user;
  const ProfileHeader({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(AppPadding.edgePadding),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CircleAvatar(
                radius: Get.height * 0.05,
                backgroundImage: (user.profilePhoto != null)
                    ? NetworkImage(
                        ApiConfig.baseURL + user.profilePhoto!,
                      )
                    : null,
                child: (user.profilePhoto == null)
                    ? const Icon(
                        Icons.person,
                        size: 40,
                        color: Colors.black45,
                      )
                    : null,
              ),
              SizedBox(width: Get.width * 0.042),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      user.userName,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    (user.userDescription != null)
                        ? Text(user.userDescription!)
                        : const Text("No description added"),
                    const SizedBox(height: 8),
                    //Text('Mobile: +91 9876543210\nEmail: johndoe@gmail.com'),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 15),
          if (user.userContact != null)
            getContactSection(
              const Icon(
                Icons.phone,
                size: 18,
              ),
              user.userContact!,
            ),
          const SizedBox(height: 4),
          if (user.userEmail != null)
            getContactSection(
              const Icon(
                Icons.mail,
                size: 18,
              ),
              user.userEmail!,
            ),
          SizedBox(height: Get.height * 0.02),
          Row(
            children: [
              AppPrimaryButton(
                title: "Edit profile",
                onPressed: () {
                  Get.to(() => EditProfileScreen(
                        user: user,
                      ));
                },
                height: Get.height * 0.05,
              ),
              SizedBox(width: Get.width * 0.03),
              // AppPrimaryButton(
              //   title: "Share profile",
              //   onPressed: () {},
              //   height: Get.height * 0.05,
              // ),
            ],
          )
        ],
      ),
    );
  }
}

getContactSection(Widget icon, String value) {
  return Row(
    children: [
      icon,
      SizedBox(width: Get.width * 0.02),
      Text(
        value,
        style: const TextStyle(fontSize: 13, color: Colors.black87),
      ),
    ],
  );
}

// Wallet and Stats Section
class WalletRow extends StatelessWidget {
  // ignore: prefer_typing_uninitialized_variables
  final user;
  const WalletRow({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.all(AppPadding.edgePadding),
      elevation: 0,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SizedBox(
          //height: Get.height * 0.07,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildWalletColumn('₹ ${user.walletMoney}', 'Wallet'),
              Container(
                height: Get.height * 0.04,
                width: 1.5, // Space taken by the divider horizontally
                color: AppColor.primaryColor,
              ),
              _buildWalletColumn('${user.boughthCreationNumber}', 'Bought'),
              Container(
                height: Get.height * 0.04,
                width: 1.5, // Space taken by the divider horizontally
                color: AppColor.primaryColor,
              ),
              _buildWalletColumn('${user.listedCreationNumber}', 'Listed'),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildWalletColumn(String value, String title) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          alignment: Alignment.center,
          width: Get.width * 0.2,
          child: Text(
            maxLines: 1,
            value,
            style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
            overflow: TextOverflow.ellipsis,
          ),
        ),
        const SizedBox(height: 6),
        Container(
          alignment: Alignment.center,
          width: Get.width * 0.2,
          child: Text(
            title,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }
}

// Options List
class OptionList extends StatelessWidget {
  // ignore: prefer_typing_uninitialized_variables
  final user;
  OptionList({super.key, required this.user});
  final options = [
    {
      'icon': Icons.shopping_cart_outlined,
      'text': 'Cart',
      "navigateTo": const AddToCartPage(),
    },
    {
      'icon': Icons.list_alt_outlined,
      'text': 'Listed creations',
      "navigateTo": const ListedProjectScreen(),
    },
    {
      'icon': Icons.account_balance_outlined,
      'text': 'Bank Accounts',
      "navigateTo": const BankAccountPage()
    },
    {'icon': Icons.money_outlined, 'text': 'Withdraw Money'},
    {'icon': Icons.analytics_outlined, 'text': 'Sell Analysis'},
    {'icon': Icons.history_outlined, 'text': 'Purchase History'},
    {
      'icon': Icons.swap_horiz_outlined,
      'text': 'Transaction Histoty',
      "navigateTo": const TransactionListScreen()
    },
    {
      'icon': Icons.campaign_outlined,
      'text': 'Advertisement',
      "navigateTo": AdSubmissionScreen()
    },
    {
      'icon': Icons.card_giftcard,
      'text': 'Refer and Earn',
      'navigateTo': const ReferScreen()
    },
    {'icon': Icons.info_outline, 'text': 'About Us'},
    {'icon': Icons.feedback_outlined, 'text': 'Feedback'},
    {'icon': Icons.logout_outlined, 'text': 'Logout'},
  ];

  logOut(context) {
    PrefData.clearAppSharedPref();
    ClearDataController().clearAllProviders(context);
    Get.offAll(const Splashscreen());
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: options.length,
      itemBuilder: (context, index) {
        final option = options[index];
        return ListTile(
          leading: Icon(
            option['icon'] as IconData,
            color: AppColor.primaryColor,
          ),
          title: Text(option['text'] as String),
          onTap: () {
            if (option['text'] == 'Logout') {
              _showLogoutDialog(context);
            } else {
              Get.to(option["navigateTo"]);
            }
          },
        );
      },
    );
  }

  void _showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Logout'),
          content: const Text('Are you sure you want to logout?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                // Perform Logout Logic
                logOut(context);
                ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Logged out successfully')));
              },
              child: const Text('Logout'),
            ),
          ],
        );
      },
    );
  }
}
