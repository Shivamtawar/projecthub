import 'dart:developer';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:palette_generator/palette_generator.dart';
import 'package:projecthub/view/advertisement/provider/advertisement_provider.dart';
import 'package:projecthub/view/home/provider/categories_provider.dart';
import 'package:projecthub/app_providers/creation_provider.dart';
import 'package:projecthub/config/api_config.dart';
import 'package:projecthub/constant/app_color.dart';
import 'package:projecthub/constant/app_padding.dart';
import 'package:projecthub/view/advertisement/model/advertisement_model.dart';
import 'package:projecthub/view/home/model/categories_info_model.dart';
import 'package:projecthub/model/creation_model.dart';
import 'package:projecthub/view/app_shimmer.dart';
import 'package:projecthub/view/profile/view/profile_screen.dart';
import 'package:projecthub/widgets/creation_card.dart';
import 'package:projecthub/view/home/view/categories_screen.dart';
import 'package:projecthub/view/product_details_screen/product_details_screen.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';

import '../../profile/provider/user_provider.dart';
import '../../../utils/uri_launch_service.dart';
import '../../all_creation_screen/all_creation_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final ScrollController _scrollController = ScrollController();
  bool _isLoadingMore = false;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_scrollController.position.pixels ==
            _scrollController.position.maxScrollExtent &&
        !_isLoadingMore) {
      _loadMoreCreations();
    }
  }

  Future<void> _loadMoreCreations() async {
    setState(() => _isLoadingMore = true);
    final userId =
        Provider.of<UserInfoProvider>(context, listen: false).user!.userId;
    await Provider.of<GeneralCreationProvider>(context, listen: false)
        .fetchMoreGeneralCreations(userId);
    setState(() => _isLoadingMore = false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: _buildContent(),
      ),
    );
  }

  Widget _buildContent() {
    return SizedBox(
      height: Get.height,
      width: Get.width,
      child: ListView(
        controller: _scrollController,
        children: const [
          SizedBox(height: 12),
          _TopBar(),
          SizedBox(height: 6),
          _AdvertisementSlider(),
          SizedBox(height: 18),
          _SectionHeader(
            leftTitle: "Categories",
            rightTitle: "See All",
            navigateTo: CategoriesPage(),
          ),
          _CategoriesSlider(),
          SizedBox(height: 18),
          _SectionHeader(
            leftTitle: "Trending Creations",
            rightTitle: "See All",
            navigateTo: AllCreationScreen(type: "trending"),
          ),
          SizedBox(height: 8),
          _TrendingCreationsView(),
          SizedBox(height: 35),
          _SectionHeader(
            leftTitle: "Recently Added Creations",
            rightTitle: "See All",
            navigateTo: AllCreationScreen(type: "recent"),
          ),
          _RecentlyAddedCreationsView(),
          SizedBox(height: 12),
          _SectionHeader(
            leftTitle: "Other",
            rightTitle: "See All",
            navigateTo: AllCreationScreen(type: "other"),
          ),
          SizedBox(height: 12),
          _OtherCreationsView(),
          SizedBox(height: 12),
        ],
      ),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  final String leftTitle;
  final String rightTitle;
  final Widget navigateTo;

  const _SectionHeader({
    required this.leftTitle,
    required this.rightTitle,
    required this.navigateTo,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: AppPadding.edgePadding),
      child: Row(
        children: [
          Text(
            leftTitle,
            style: TextStyle(
              fontSize: 16.sp,
              fontWeight: FontWeight.w600,
              fontFamily: 'Gilroy',
            ),
          ),
          const Spacer(),
          InkWell(
            onTap: () => Get.to(navigateTo),
            child: Text(
              rightTitle,
              style: TextStyle(
                fontSize: 14.sp,
                fontFamily: 'Gilroy',
                color: AppColor.primaryColor,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _TopBar extends StatelessWidget {
  const _TopBar();

  @override
  Widget build(BuildContext context) {
    return Consumer<UserInfoProvider>(
      builder: (context, provider, _) {
        final user = provider.user!;
        return Padding(
          padding: const EdgeInsets.only(left: 16),
          child: Row(
            children: [
              GestureDetector(
                onTap: () => Get.to(() => const ProfileScreen(),
                    transition: Transition.rightToLeftWithFade),
                child: CircleAvatar(
                  radius: Get.height * 0.028,
                  backgroundImage: user.profilePhoto != null
                      ? NetworkImage(ApiConfig.baseURL + user.profilePhoto!)
                      : null,
                  child: user.profilePhoto == null
                      ? const Icon(Icons.person,
                          size: 40, color: Colors.black45)
                      : null,
                ),
              ),
              SizedBox(width: 10.w),
              SizedBox(
                width: Get.width * 0.6,
                child: Text(
                  "Welcome, ${user.userName}",
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontFamily: 'Gilroy',
                    color: const Color(0XFF000000),
                    fontSize: 21.sp,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              const Spacer(),
              IconButton(
                onPressed: () {},
                icon: const Icon(Icons.notifications_on,
                    color: Color(0XFF23408F)),
              ),
              const SizedBox(width: 2),
            ],
          ),
        );
      },
    );
  }
}

class _CategoriesSlider extends StatelessWidget {
  const _CategoriesSlider();

  @override
  Widget build(BuildContext context) {
    return Consumer<CategoriesProvider>(
      builder: (context, provider, _) {
        if (provider.isLoading) {
          return const Center(child: CircularProgressIndicator());
        }
        return SizedBox(
          height: Get.height * 0.135,
          child: ListView.separated(
            physics: const BouncingScrollPhysics(),
            scrollDirection: Axis.horizontal,
            padding: EdgeInsets.all(AppPadding.edgePadding),
            itemCount: provider.categories!.length,
            separatorBuilder: (_, __) => const SizedBox(width: 20),
            itemBuilder: (context, index) => _CategoryCard(
              category: provider.categories![index],
              height: (Get.height * 0.135) - 2 * AppPadding.edgePadding,
            ),
          ),
        );
      },
    );
  }
}

class _CategoryCard extends StatelessWidget {
  final CategoryModel category;
  final double height;

  const _CategoryCard({required this.category, required this.height});

  @override
  Widget build(BuildContext context) {
    const double radius = 15;
    return InkWell(
      child: Container(
        height: height,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(radius),
          boxShadow: [BoxShadow(color: Colors.grey.shade200, blurRadius: 10)],
        ),
        child: FutureBuilder<Color>(
          future: _getDominantColor(ApiConfig.getFileUrl(category.image!)),
          builder: (context, snapshot) {
            final color = snapshot.data ?? const Color(0XFFEBE2C9);
            return Container(
              height: height,
              width: height,
              padding: EdgeInsets.all(Get.height * 0.008),
              decoration: BoxDecoration(
                color: color,
                borderRadius: BorderRadius.circular(radius),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                    height: height * 0.5,
                    child: Image.network(ApiConfig.getFileUrl(category.image!)),
                  ),
                  SizedBox(height: Get.height * 0.004),
                  Text(
                    category.name!,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 12.sp,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  static Future<Color> _getDominantColor(String imageUrl) async {
    final palette = await PaletteGenerator.fromImageProvider(
      NetworkImage(imageUrl),
      maximumColorCount: 10,
    );
    return palette.dominantColor?.color ?? Colors.grey;
  }
}

class _AdvertisementSlider extends StatelessWidget {
  const _AdvertisementSlider();

  @override
  Widget build(BuildContext context) {
    return Consumer<AdvertisementProvider>(
      builder: (context, provider, _) {
        if (provider.isLoading) {
          return const Center(child: CircularProgressIndicator());
        } else if (provider.advertisements.isEmpty) {
          return const Center(child: Text("No advertisements available."));
        }
        return CarouselSlider(
          options: CarouselOptions(
            height: Get.height * 0.22,
            autoPlay: true,
            autoPlayAnimationDuration: const Duration(seconds: 1),
            autoPlayInterval: const Duration(seconds: 5),
            aspectRatio: 1,
            viewportFraction: 0.85,
            enlargeCenterPage: true,
            enlargeStrategy: CenterPageEnlargeStrategy.height,
          ),
          items: provider.advertisements.map((ad) => _AdItem(ad)).toList(),
        );
      },
    );
  }
}

class _AdItem extends StatelessWidget {
  final AdvertisementModel ad;

  const _AdItem(this.ad);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(6),
      child: InkWell(
        onTap: () async {
          launchWebSite(ad.adWebsite!);
        },
        child: ClipRRect(
            borderRadius: const BorderRadius.all(Radius.circular(12)),
            child: SizedBox(
                width: Get.width * 0.85,
                child: Image.network(
                  ApiConfig.getFileUrl(ad.adImage!),
                  loadingBuilder: (context, child, loadingProgress) {
                    if (loadingProgress == null) return child;
                    return Shimmer(
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [
                          Colors.grey.shade300,
                          Colors.grey.shade100,
                          Colors.grey.shade300,
                        ],
                      ),
                      child: Container(
                        width: Get.width * 0.85,
                      ),
                    );
                  },
                  fit: BoxFit.cover,
                ))),
      ),
    );
  }
}

class _TrendingCreationsView extends StatelessWidget {
  const _TrendingCreationsView();

  @override
  Widget build(BuildContext context) {
    return Consumer<TreandingCreationProvider>(
      builder: (context, provider, _) {
        return SizedBox(
          height: 240.h,
          child: (provider.threandingCreations!.isEmpty)
              ? const Center(child: Text("No trending creations available."))
              : ListView.separated(
                  padding:
                      EdgeInsets.symmetric(horizontal: AppPadding.edgePadding),
                  physics: const BouncingScrollPhysics(),
                  scrollDirection: Axis.horizontal,
                  itemCount: provider.threandingCreations!.length,
                  separatorBuilder: (_, __) => SizedBox(width: 10.w),
                  itemBuilder: (context, index) {
                    final creation = provider.threandingCreations![index];
                    return _TrendingCreationItem(creation: creation);
                  },
                ),
        );
      },
    );
  }
}

class _TrendingCreationItem extends StatelessWidget {
  final Creation creation;

  const _TrendingCreationItem({required this.creation});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 10.h),
      child: GestureDetector(
        onTap: () => Get.to(ProductDetailsScreen(creation: creation)),
        child: Container(
          width: 200.h,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(9.h),
            color: Colors.white,
            boxShadow: const [
              BoxShadow(
                color: Color.fromARGB(77, 157, 157, 163),
                blurRadius: 4,
                spreadRadius: 2,
              )
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(9.h),
                  topRight: Radius.circular(9.h),
                ),
                child: SizedBox(
                  height: 120.h,
                  width: 200.w,
                  child: Image.network(
                    ApiConfig.getFileUrl(creation.creationThumbnail!),
                    fit: BoxFit.fill,
                    loadingBuilder: (context, child, loadingProgress) {
                      if (loadingProgress == null) return child;
                      return Center(
                        child: CircularProgressIndicator(
                          value: loadingProgress.expectedTotalBytes != null
                              ? loadingProgress.cumulativeBytesLoaded /
                                  loadingProgress.expectedTotalBytes!
                              : null,
                        ),
                      );
                    },
                    errorBuilder: (_, __, ___) => Icon(
                      Icons.broken_image,
                      size: 50.r,
                      color: Colors.grey,
                    ),
                  ),
                ),
              ),
              SizedBox(height: 8.h),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      creation.creationTitle!,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontFamily: 'Gilroy',
                        fontWeight: FontWeight.w700,
                        fontSize: 15.sp,
                        color: const Color(0XFF000000),
                      ),
                    ),
                    Text(
                      "by ${creation.seller!.sellerName!}",
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontFamily: 'Gilroy',
                        fontWeight: FontWeight.w400,
                        fontSize: 12.sp,
                        color: const Color.fromARGB(255, 92, 91, 91),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _RecentlyAddedCreationsView extends StatelessWidget {
  const _RecentlyAddedCreationsView();

  @override
  Widget build(BuildContext context) {
    return Consumer<RecentCreationProvider>(
      builder: (context, provider, _) {
        return SizedBox(
          height: 323.h,
          child: (provider.recentlyAddedCreations!.isEmpty)
              ? const Center(
                  child: Text("No recently added creations available."))
              : ListView.separated(
                  padding: EdgeInsets.all(AppPadding.edgePadding),
                  physics: const BouncingScrollPhysics(),
                  scrollDirection: Axis.horizontal,
                  itemCount: provider.recentlyAddedCreations!.length,
                  separatorBuilder: (_, __) => SizedBox(width: 12.w),
                  itemBuilder: (context, index) {
                    final creation = provider.recentlyAddedCreations![index];
                    return _RecentlyAddedCreationItem(creation: creation);
                  },
                ),
        );
      },
    );
  }
}

class _RecentlyAddedCreationItem extends StatelessWidget {
  final Creation creation;

  const _RecentlyAddedCreationItem({required this.creation});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(16.r),
      onTap: () {
        Get.to(() => ProductDetailsScreen(creation: creation));
      },
      child: Container(
        width: 220.w,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16.r),
          boxShadow: [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 8.r,
              offset: const Offset(0, 4),
            )
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.vertical(top: Radius.circular(16.r)),
              child: Stack(
                children: [
                  SizedBox(
                    height: 140.h,
                    width: double.infinity,
                    child: Image.network(
                      ApiConfig.getFileUrl(creation.creationThumbnail!),
                      fit: BoxFit.cover,
                      loadingBuilder: (context, child, loadingProgress) {
                        if (loadingProgress == null) return child;
                        return Center(
                          child: CircularProgressIndicator(
                            value: loadingProgress.expectedTotalBytes != null
                                ? loadingProgress.cumulativeBytesLoaded /
                                    loadingProgress.expectedTotalBytes!
                                : null,
                          ),
                        );
                      },
                      errorBuilder: (_, __, ___) => Icon(
                        Icons.broken_image,
                        size: 50.r,
                        color: Colors.grey,
                      ),
                    ),
                  ),
                  Positioned(
                    top: 8.w,
                    right: 8.w,
                    child: Container(
                      padding:
                          EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
                      decoration: BoxDecoration(
                        color: Colors.black54,
                        borderRadius: BorderRadius.circular(12.r),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.star, color: Colors.amber, size: 14.r),
                          SizedBox(width: 4.w),
                          Text(
                            creation.avgRating!.toString(),
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 12.sp,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.all(12.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    creation.creationTitle!,
                    style: TextStyle(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.bold,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  SizedBox(height: 8.h),
                  Row(
                    children: [
                      CircleAvatar(
                        radius: 14.r,
                        backgroundImage:
                            creation.seller!.sellerProfilePhoto != null
                                ? NetworkImage(ApiConfig.baseURL +
                                    creation.seller!.sellerProfilePhoto!)
                                : null,
                        child: creation.seller!.sellerProfilePhoto == null
                            ? Icon(Icons.person, size: 14.r)
                            : null,
                      ),
                      SizedBox(width: 8.w),
                      Expanded(
                        child: Text(
                          creation.seller!.sellerName!,
                          style: TextStyle(
                            fontSize: 14.sp,
                            color: Colors.grey.shade700,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 12.h),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "₹${creation.creationPrice!}",
                        style: TextStyle(
                          fontSize: 16.sp,
                          fontWeight: FontWeight.bold,
                          color: AppColor.primaryColor,
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.symmetric(
                            horizontal: 12.w, vertical: 4.h),
                        decoration: BoxDecoration(
                          color: AppColor.primaryColor.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(8.r),
                        ),
                        child: Text(
                          "View",
                          style: TextStyle(
                            fontSize: 12.sp,
                            color: AppColor.primaryColor,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _OtherCreationsView extends StatelessWidget {
  const _OtherCreationsView();

  @override
  Widget build(BuildContext context) {
    return Consumer<GeneralCreationProvider>(
      builder: (context, provider, _) {
        final isLoadingMore = context
                .dependOnInheritedWidgetOfExactType<_LoadingMoreIndicator>()
                ?.isLoadingMore ??
            false;
        if (provider.generalCreations!.isEmpty) {
          return const Center(child: Text("No other creations available."));
        }
        return Padding(
          padding: EdgeInsets.symmetric(horizontal: AppPadding.edgePadding),
          child: Column(
            children: [
              ...provider.generalCreations!.map((creation) => Padding(
                    padding: const EdgeInsets.only(bottom: 16),
                    child: GestureDetector(
                      onTap: () => Get.to(
                          ProductDetailsScreen(creation: creation as Creation)),
                      child: CreatationCard(creation: creation as Creation),
                    ),
                  )),
              if (isLoadingMore) const CreationCardPlaceholder(),
            ],
          ),
        );
      },
    );
  }
}

class _LoadingMoreIndicator extends InheritedWidget {
  final bool isLoadingMore;

  const _LoadingMoreIndicator({
    required this.isLoadingMore,
    required super.child,
  });

  @override
  bool updateShouldNotify(_LoadingMoreIndicator oldWidget) {
    return isLoadingMore != oldWidget.isLoadingMore;
  }
}

launchWebSite(websiteUrl) async {
  final url =
      websiteUrl!.trim(); // Assuming `ad.adLink` contains the target URL
  if (url != null && await UriLaunchService.canLaunchUrlApp(url)) {
    await UriLaunchService.launchUrlApp(url);
  } else {
    ScaffoldMessenger.of(Get.context!).showSnackBar(
      SnackBar(content: Text('Could not launch the ad link')),
    );
  }
}
