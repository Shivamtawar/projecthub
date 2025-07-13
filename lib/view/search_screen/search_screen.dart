import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:projecthub/view/profile/provider/user_provider.dart';
import 'package:projecthub/config/api_config.dart';
import 'package:projecthub/model/creation_model.dart';
import 'package:projecthub/view/app_navigation_bar/app_navigation_bar.dart';
import 'package:projecthub/view/product_details_screen/product_details_screen.dart';
import 'package:provider/provider.dart';
import '../../constant/app_padding.dart';
import '../../constant/app_textfield_border.dart';
import 'provider/search_creation_controller.dart';

class TemplateListScreen extends StatefulWidget {
  const TemplateListScreen({super.key});

  @override
  State createState() => _TemplateListScreenState();
}

class _TemplateListScreenState extends State<TemplateListScreen> {
  final TextEditingController _searchController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  bool _isSearchVisible = true;
  bool _isScrollingDown = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      fetchSearchedCreations("", true);
    });
    _scrollController.addListener(_scrollListener);
  }

  void _scrollListener() {
    // Detect scroll direction
    if (_scrollController.position.userScrollDirection ==
        ScrollDirection.reverse) {
      if (!_isScrollingDown) {
        _isScrollingDown = true;
        _hideSearchField();
      }
    } else if (_scrollController.position.userScrollDirection ==
        ScrollDirection.forward) {
      if (_isScrollingDown) {
        _isScrollingDown = false;
        _showSearchField();
      }
    }

    // Check if we've reached the bottom for pagination
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent) {
      fetchSearchedCreations(_searchController.text.trim(), false);
    }
  }

  void _hideSearchField() {
    if (_isSearchVisible) {
      setState(() {
        _isSearchVisible = false;
      });
    }
  }

  void _showSearchField() {
    if (!_isSearchVisible) {
      setState(() {
        _isSearchVisible = true;
      });
    }
  }

  Future<void> fetchSearchedCreations(String query, bool reset) async {
    final provider =
        Provider.of<SearchedCreationProvider>(context, listen: false);
    final userProvider = Provider.of<UserInfoProvider>(context, listen: false);
    await provider.fetchSearchedCreation(
        query, userProvider.user!.userId, reset);
  }

  void showFilters() {
    Get.defaultDialog(
      title: "Filters",
      content: const Column(
        children: [
          ListTile(title: Text("Latest first")),
          ListTile(title: Text("Oldest first")),
          ListTile(title: Text("Most popular first")),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _searchController.dispose();
    _scrollController.removeListener(_scrollListener);
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        Get.offAll(() =>
            const AppNavigationScreen()); // Replace with your actual home screen
        return false;
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Template Marketplace'),
          centerTitle: true,
        ),
        body: Column(
          children: [
            AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              height: _isSearchVisible ? Get.height * 0.10 : 0,
              curve: Curves.easeInOut,
              child: AnimatedOpacity(
                duration: const Duration(milliseconds: 300),
                opacity: _isSearchVisible ? 1 : 0,
                child: Padding(
                  padding: EdgeInsets.all(AppPadding.edgePadding),
                  child: TextFormField(
                    controller: _searchController,
                    onChanged: (value) async {
                      await fetchSearchedCreations(
                          _searchController.text.trim(), true);
                    },
                    decoration: InputDecoration(
                      focusedBorder: AppTextfieldBorder.focusedBorder,
                      contentPadding: const EdgeInsets.all(8),
                      hintText: 'Search...',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      prefixIcon: const Icon(Icons.search),
                      suffixIcon: IconButton(
                        onPressed: showFilters,
                        icon: const Icon(Icons.filter_list),
                      ),
                    ),
                  ),
                ),
              ),
            ),
            Consumer<SearchedCreationProvider>(
              builder: (context, provider, child) {
                if (provider.isLoading && provider.searchedCreations == null) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (provider.errormassage.isNotEmpty) {
                  return Center(
                    child: Text(
                      provider.errormassage,
                      style: const TextStyle(fontSize: 18),
                    ),
                  );
                }

                if (provider.searchedCreations == null ||
                    provider.searchedCreations!.isEmpty) {
                  return const Center(
                    child: Text(
                      'No templates found',
                      style: TextStyle(fontSize: 18),
                    ),
                  );
                }

                return Expanded(
                  child: NotificationListener<ScrollNotification>(
                    onNotification: (notification) {
                      // Let the scroll controller handle the notifications
                      return false;
                    },
                    child: ListView.builder(
                      controller: _scrollController,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 4),
                      itemCount: provider.searchedCreations!.length +
                          (provider.isLoading ? 1 : 0),
                      itemBuilder: (context, index) {
                        if (index >= provider.searchedCreations!.length) {
                          return const Center(
                            child: Padding(
                              padding: EdgeInsets.all(16.0),
                              child: CircularProgressIndicator(),
                            ),
                          );
                        }
                        return ComfortableTemplateCard(
                          template: provider.searchedCreations![index],
                          onTap: () {
                            FocusScope.of(context).unfocus();

                            Get.to(
                              () => ProductDetailsScreen(
                                creation: provider.searchedCreations![index],
                              ),
                              transition: Transition.rightToLeftWithFade,
                            );
                          },
                        );
                      },
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

// Keep your ComfortableTemplateCard widget as is

class ComfortableTemplateCard extends StatelessWidget {
  final Creation template;
  final VoidCallback? onTap;

  const ComfortableTemplateCard({
    super.key,
    required this.template,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Card(
        elevation: 3,
        margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Thumbnail - larger but still compact
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Container(
                  alignment: Alignment.center,
                  width: 100,
                  height: 100,
                  color: Colors.grey[200],
                  child: Image.network(
                    ApiConfig.getFileUrl(template.creationThumbnail!),
                    height: 100,
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
                    errorBuilder: (context, error, stackTrace) {
                      return const Icon(Icons.broken_image,
                          size: 40, color: Colors.grey);
                    },
                  ),
                ),
              ),

              const SizedBox(width: 16),

              // Content area - more spacious
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // Title
                    Text(
                      template.creationTitle!,
                      style: const TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.bold,
                        height: 1.2,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),

                    const SizedBox(height: 6),

                    // Seller
                    Text(
                      'By ${template.seller.sellerName!}',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey[600],
                        height: 1.2,
                      ),
                    ),

                    const SizedBox(height: 8),

                    // Description (shortened)
                    Text(
                      template.creationDescription!.length > 60
                          ? '${template.creationDescription!.substring(0, 60)}...'
                          : template.creationDescription!,
                      style: TextStyle(
                        fontSize: 13,
                        color: Colors.grey[700],
                        height: 1.3,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),

                    const SizedBox(height: 12),

                    // Footer with price and category
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        // Category
                        if (template.avgRating != null)
                          Container(
                            padding: EdgeInsets.symmetric(
                                horizontal: 8.w, vertical: 4.h),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20),
                              color: const Color(0XFFFAF4E1),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                const Icon(
                                  Icons.star,
                                  color: Color(0xFFFFA000),
                                  size: 16,
                                ),
                                SizedBox(width: 4.w),
                                Text(
                                  template.avgRating!.toString().length > 3
                                      ? template.avgRating!
                                          .toString()
                                          .substring(0, 3)
                                      : template.avgRating!.toString(),
                                  style: TextStyle(
                                    fontSize: 14.sp,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ),

                        // Price
                        Text(
                          '\$${template.creationPrice!.toStringAsFixed(2)}',
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.blue,
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
      ),
    );
  }
}
