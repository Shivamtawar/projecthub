import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:projecthub/view/profile/provider/user_provider.dart';
import 'package:projecthub/constant/app_padding.dart';
import 'package:projecthub/constant/app_text.dart';
import 'package:projecthub/constant/app_textfield_border.dart';
import 'package:provider/provider.dart';
import '../../../widgets/creation_card.dart';
import '../../app_navigation_bar/app_navigation_bar.dart';
import '../model/purched_creation_model.dart';
import '../provider/purchased_creation_provider.dart';
import '../widgets/purched_creation_card.dart';

enum PurchaseSortOption {
  latestFirst,
  oldestFirst,
  priceHighToLow,
  priceLowToHigh,
}

class PurchaseScreen extends StatefulWidget {
  const PurchaseScreen({super.key});

  @override
  State<PurchaseScreen> createState() => _PurchaseScreenState();
}

class _PurchaseScreenState extends State<PurchaseScreen> {
  final ScrollController _scrollController = ScrollController();
  bool _isSearchVisible = true;
  double _lastScrollOffset = 0.0;
  bool _isLoadingMore = false;
  int page = 1;
  PurchaseSortOption _currentSortOption = PurchaseSortOption.latestFirst;
  String _searchQuery = '';
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
    _loadInitialData();
  }

  void _loadInitialData() {
    Provider.of<PurchedCreationProvider>(context, listen: false)
        .fetchUserPurchedCreation(
      Provider.of<UserInfoProvider>(context, listen: false).user!.userId,
    );
    setState(() => page++);
  }

  void _onScroll() {
    if (_scrollController.position.pixels ==
            _scrollController.position.maxScrollExtent &&
        !_isLoadingMore) {
      _loadMoreData();
    }

    double currentOffset = _scrollController.position.pixels;
    if (currentOffset > _lastScrollOffset + 5 && _isSearchVisible) {
      setState(() => _isSearchVisible = false);
    } else if (currentOffset < _lastScrollOffset - 5 && !_isSearchVisible) {
      setState(() => _isSearchVisible = true);
    }
    _lastScrollOffset = currentOffset;
  }

  Future<void> _loadMoreData() async {
    setState(() => _isLoadingMore = true);
    await Provider.of<PurchedCreationProvider>(context, listen: false)
        .fetchMoreUserPurchedCreation(
      Provider.of<UserInfoProvider>(context, listen: false).user!.userId,
    );
    setState(() {
      page++;
      _isLoadingMore = false;
    });
    _applyFilters();
  }

  void _applyFilters() {
    final provider =
        Provider.of<PurchedCreationProvider>(context, listen: false);
    List<PurchedCreationModel> filtered = provider.purchedCreations ?? [];

    if (_searchQuery.isNotEmpty) {
      filtered = filtered.where((purchase) {
        return purchase.creationTitle
            .toLowerCase()
            .contains(_searchQuery.toLowerCase());
      }).toList();
    }

    switch (_currentSortOption) {
      case PurchaseSortOption.latestFirst:
        filtered.sort((a, b) => b.orderDate.compareTo(a.orderDate));
        break;
      case PurchaseSortOption.oldestFirst:
        filtered.sort((a, b) => a.orderDate.compareTo(b.orderDate));
        break;

      case PurchaseSortOption.priceHighToLow:
        filtered.sort((a, b) => b.purchasedPrice.compareTo(a.purchasedPrice));
        break;
      case PurchaseSortOption.priceLowToHigh:
        filtered.sort((a, b) => a.purchasedPrice.compareTo(b.purchasedPrice));
        break;
    }

    provider.setFilteredCreations(filtered);
  }

  void _showFilters() {
    Get.bottomSheet(
      Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(16.r)),
        ),
        padding: EdgeInsets.all(AppPadding.edgePadding),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 40.w,
              height: 4.h,
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(2.r),
              ),
            ),
            SizedBox(height: 16.h),
            Text(
              "Sort Purchases",
              style: AppText.heddingStyle2bBlack.copyWith(fontSize: 18.sp),
            ),
            SizedBox(height: 16.h),
            const Divider(),
            ...PurchaseSortOption.values.map((option) {
              return RadioListTile<PurchaseSortOption>(
                title: Text(
                  option.toString().split('.').last.replaceAllMapped(
                      RegExp(r'([A-Z])'), (m) => ' ${m.group(1)}'),
                  style: TextStyle(fontSize: 15.sp),
                ),
                value: option,
                groupValue: _currentSortOption,
                onChanged: (PurchaseSortOption? value) {
                  if (value != null) {
                    setState(() => _currentSortOption = value);
                    _applyFilters();
                    Get.back();
                  }
                },
              );
            }),
            SizedBox(height: 8.h),
          ],
        ),
      ),
    );
  }

  Widget _buildSearchField() {
    return AnimatedOpacity(
      duration: const Duration(milliseconds: 300),
      opacity: _isSearchVisible ? 1 : 0,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        height: _isSearchVisible ? Get.height * 0.10 : 0,
        color: Colors.white,
        child: _isSearchVisible
            ? Padding(
                padding: EdgeInsets.all(AppPadding.edgePadding),
                child: TextFormField(
                  controller: _searchController,
                  onChanged: (value) {
                    setState(() => _searchQuery = value);
                    _applyFilters();
                  },
                  decoration: InputDecoration(
                    focusedBorder: AppTextfieldBorder.focusedBorder,
                    contentPadding: const EdgeInsets.all(8),
                    hintText: 'Search...',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    prefixIcon: const Icon(Icons.search),
                    suffixIcon: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        if (_searchQuery.isNotEmpty)
                          IconButton(
                            icon: const Icon(Icons.clear, color: Colors.grey),
                            onPressed: () {
                              _searchController.clear();
                              setState(() => _searchQuery = '');
                              _applyFilters();
                            },
                          ),
                        IconButton(
                          onPressed: _showFilters,
                          icon: const Icon(Icons.tune, color: Colors.grey),
                        ),
                      ],
                    ),
                  ),
                ),
              )
            : null,
      ),
    );
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        Get.offAll(
          () => const AppNavigationScreen(),
          transition: Transition.leftToRightWithFade,
        );
        return false;
      },
      child: Scaffold(
        backgroundColor: Colors.grey[50],
        body: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildSearchField(),
              Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: AppPadding.edgePadding,
                ),
                child: Text(
                  "My Purchases",
                  style: AppText.heddingStyle2bBlack.copyWith(
                    fontSize: 18.5.sp,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              SizedBox(height: 8.h),
              Expanded(
                child: Consumer<PurchedCreationProvider>(
                  builder: (context, provider, child) {
                    final items = _searchQuery.isEmpty &&
                            _currentSortOption == PurchaseSortOption.latestFirst
                        ? provider.purchedCreations
                        : provider.filteredCreations;

                    if (provider.isLoading && items == null) {
                      return const Center(
                          child: CircularProgressIndicator.adaptive());
                    }

                    if (provider.errorMessage.isNotEmpty) {
                      return Center(
                        child: Padding(
                          padding: EdgeInsets.all(AppPadding.edgePadding),
                          child: Text(
                            provider.errorMessage,
                            textAlign: TextAlign.center,
                            style: AppText.heddingStyle2bBlack.copyWith(
                              color: Colors.red,
                            ),
                          ),
                        ),
                      );
                    }

                    if (items == null || items.isEmpty) {
                      return Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            SizedBox(
                              height: 180.h,
                              width: 180.w,
                              child: SvgPicture.asset(
                                "assets/images/no_creation_found.svg",
                                color: Colors.grey[400],
                              ),
                            ),
                            SizedBox(height: 24.h),
                            Text(
                              _searchQuery.isEmpty
                                  ? "No purchases yet"
                                  : "No matching purchases",
                              style: AppText.heddingStyle2bBlack.copyWith(
                                fontSize: 18.sp,
                                color: Colors.grey[600],
                              ),
                            ),
                            SizedBox(height: 8.h),
                            Text(
                              _searchQuery.isEmpty
                                  ? "Your purchased items will appear here"
                                  : "Try a different search term",
                              style: TextStyle(
                                fontSize: 14.sp,
                                color: Colors.grey,
                              ),
                            ),
                          ],
                        ),
                      );
                    }

                    return RefreshIndicator(
                      onRefresh: () async {
                        await Provider.of<PurchedCreationProvider>(context,
                                listen: false)
                            .fetchUserPurchedCreation(
                          Provider.of<UserInfoProvider>(context, listen: false)
                              .user!
                              .userId,
                        );
                        _applyFilters();
                      },
                      child: ListView.separated(
                        controller: _scrollController,
                        padding: EdgeInsets.all(AppPadding.edgePadding),
                        physics: const AlwaysScrollableScrollPhysics(),
                        itemCount: items.length + (_isLoadingMore ? 1 : 0),
                        separatorBuilder: (context, index) =>
                            SizedBox(height: 16.h),
                        itemBuilder: (context, index) {
                          if (index >= items.length) {
                            return Center(
                              child: Padding(
                                padding: EdgeInsets.all(16.h),
                                child:
                                    const CircularProgressIndicator.adaptive(),
                              ),
                            );
                          }
                          return PurchedCreationCard(
                            purchedCreationModel: items[index],
                          );
                        },
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
