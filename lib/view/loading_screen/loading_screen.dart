import 'dart:developer';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:projecthub/view/app_navigation_bar/app_navigation_bar.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';

import '../advertisement/provider/advertisement_provider.dart';
import '../home/provider/categories_provider.dart';
import '../../app_providers/creation_provider.dart';
import '../profile/provider/user_provider.dart';
import '../../constant/app_padding.dart';
import '../error_screen/error_screen.dart';

class LoadingScreen extends StatefulWidget {
  final int userId;
  const LoadingScreen({super.key, required this.userId});

  @override
  State<LoadingScreen> createState() => _LoadingScreentState();
}

class _LoadingScreentState extends State<LoadingScreen> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      // Fetch data after the first frame is rendered
      fetchData(widget.userId);
    });
    // Fetch data when the widget is built
  }

  fetchData(int uid) async {
    try {
      await Future.wait([
        Provider.of<UserInfoProvider>(Get.context!, listen: false)
            .fetchUserDetails(uid),
        Provider.of<GeneralCreationProvider>(Get.context!, listen: false)
            .fetchGeneralCreations(uid, 1, 10),
        Provider.of<RecentCreationProvider>(Get.context!, listen: false)
            .fetchRecentCreations(uid, 1, 10),
        Provider.of<TreandingCreationProvider>(Get.context!, listen: false)
            .fetchTrendingCreations(uid, 1, 10),
        Provider.of<CategoriesProvider>(Get.context!, listen: false)
            .fetchCategories(uid),
        fetchAdvertisements(uid),
      ]);

      Get.offAll(() => const AppNavigationScreen());
    } catch (e) {
      log("Error fetching user data: $e");
      Get.snackbar("Error", "Unable to fetch user data. Please try again.");
      Get.to(ErrorScreen(
          errorMessage: "Unable to load app data. Please try again.",
          onRetry: () {
            _navigateToDefaultScreen(uid);
          }));
      // Continue even if some API calls fail
    }
  }

  void _navigateToDefaultScreen(int userId) {
    Get.offAll(() => LoadingScreen(
          userId: userId,
        ));
  }

  Future<void> fetchAdvertisements(uid) async {
    try {
      Position position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high);
      List<Placemark> placemarks =
          await placemarkFromCoordinates(position.latitude, position.longitude);
      await Provider.of<AdvertisementProvider>(Get.context!, listen: false)
          .getAdvertisements(uid!, placemarks[0].locality!);
      Provider.of<UserInfoProvider>(context, listen: false)
          .setLocation(position);
    } catch (e) {
      log("Error fetching advertisements: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
          child: SizedBox(
        height: Get.height,
        width: Get.width,
        child: ListView(
          //controller: _scrollController,
          children: [
            SizedBox(height: Get.height * 0.012),
            getTopBarShimmer(),
            SizedBox(height: Get.height * 0.006),
            const AdverticmentSlider(),
            SizedBox(height: Get.height * 0.018),
            getSectionHeddingShimmer(100.w),
            getCategoriesSliderShimmer(),
            SizedBox(height: Get.height * 0.018),
            getSectionHeddingShimmer(150.w),
            SizedBox(height: Get.height * 0.008),
            trendingCreationViewShimmer(),
            SizedBox(height: Get.height * 0.012),
            getSectionHeddingShimmer(150.w),
            SizedBox(height: Get.height * 0.008),
            getRecentlyAddedCreationViewShimmer(),
            SizedBox(height: Get.height * 0.012),

            SizedBox(height: Get.height * 0.012),
            // getOtherCreationView(),
            SizedBox(height: Get.height * 0.012),
          ],
        ),
      )),
    );
  }

  Widget getTopBarShimmer() {
    return Shimmer.fromColors(
      baseColor: Colors.grey[300]!,
      highlightColor: Colors.grey[100]!,
      child: Row(
        children: [
          const SizedBox(width: 16),
          ClipRRect(
            borderRadius: const BorderRadius.all(Radius.circular(50)),
            child: Container(
              color: Colors.white,
              height: 50.h,
              width: 50.h,
            ),
          ),
          SizedBox(width: 10.w),
          Container(
            width: Get.width * 0.6,
            height: 21.h,
            color: Colors.white,
          ),
        ],
      ),
    );
  }

  Widget getSectionHeddingShimmer(double width) {
    return Shimmer.fromColors(
      baseColor: Colors.grey[300]!,
      highlightColor: Colors.grey[100]!,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Row(
          children: [
            Container(
              width: width,
              height: 18.h,
              color: Colors.white,
            ),
          ],
        ),
      ),
    );
  }

  Widget getCategoriesSliderShimmer() {
    return Shimmer.fromColors(
      baseColor: Colors.grey[300]!,
      highlightColor: Colors.grey[100]!,
      child: SizedBox(
        height: Get.height * 0.135,
        child: ListView.separated(
          physics: const BouncingScrollPhysics(),
          scrollDirection: Axis.horizontal,
          padding: EdgeInsets.all(AppPadding.edgePadding),
          itemBuilder: (context, index) => Container(
            width: Get.height * 0.135 - 2 * AppPadding.edgePadding,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(15),
            ),
          ),
          separatorBuilder: (context, index) => const SizedBox(width: 20),
          itemCount: 5,
        ),
      ),
    );
  }

  Widget trendingCreationViewShimmer() {
    return Shimmer.fromColors(
      baseColor: Colors.grey[300]!,
      highlightColor: Colors.grey[100]!,
      child: SizedBox(
        height: 220.h,
        width: double.infinity.w,
        child: ListView.separated(
          padding: EdgeInsets.symmetric(
              horizontal: AppPadding.edgePadding, vertical: 4),
          physics: const BouncingScrollPhysics(),
          scrollDirection: Axis.horizontal,
          itemBuilder: (context, index) => Container(
            width: 200.h,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(9.h),
              color: Colors.white,
            ),
          ),
          separatorBuilder: (context, index) => SizedBox(width: 10.w),
          itemCount: 3,
        ),
      ),
    );
  }

  Widget getRecentlyAddedCreationViewShimmer() {
    return Shimmer.fromColors(
      baseColor: Colors.grey[300]!,
      highlightColor: Colors.grey[100]!,
      child: SizedBox(
        height: 320.h,
        width: double.infinity.w,
        child: ListView.separated(
          padding: EdgeInsets.symmetric(
              horizontal: AppPadding.edgePadding, vertical: 4),
          physics: const BouncingScrollPhysics(),
          scrollDirection: Axis.horizontal,
          itemBuilder: (context, index) => Container(
            width: 266.h,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(9.h),
              color: Colors.white,
            ),
          ),
          separatorBuilder: (context, index) => SizedBox(width: 12.w),
          itemCount: 3,
        ),
      ),
    );
  }
}

class AdverticmentSlider extends StatefulWidget {
  const AdverticmentSlider({super.key});

  @override
  State<AdverticmentSlider> createState() => _AdverticmentSliderState();
}

class _AdverticmentSliderState extends State<AdverticmentSlider> {
  List item = [
    1,
    2,
    3,
  ];
  @override
  Widget build(BuildContext context) {
    return CarouselSlider(
        options: CarouselOptions(
          height: Get.height * 0.21,
          //autoPlay: true,
          autoPlayAnimationDuration: const Duration(seconds: 1),
          autoPlayInterval: const Duration(seconds: 4),
          aspectRatio: 1.0,
          enlargeCenterPage: true,
          onPageChanged: (index, reason) {
            setState(() {});
          },
          enlargeStrategy: CenterPageEnlargeStrategy.height,
          pageSnapping: true, // Snapping effect enabled
        ),
        items: item.map((item) {
          return Shimmer.fromColors(
            baseColor: Colors.grey[300]!,
            highlightColor: Colors.grey[100]!,
            child: Container(
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.all(Radius.circular(10)),
              ),
              margin: const EdgeInsets.all(7),
              height: Get.height * 0.21,
            ),
          );
        }).toList());
  }
}
