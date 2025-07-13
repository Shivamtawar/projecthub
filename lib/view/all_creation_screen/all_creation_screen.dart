import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:projecthub/app_providers/creation_provider.dart';
import 'package:projecthub/view/profile/provider/user_provider.dart';
import 'package:projecthub/model/creation_model.dart';
import 'package:projecthub/view/product_details_screen/product_details_screen.dart';
import 'package:provider/provider.dart';

import '../../constant/app_padding.dart';
import '../../constant/app_textfield_border.dart';
import '../../widgets/creation_card.dart';
import '../app_shimmer.dart';

class AllCreationScreen extends StatefulWidget {
  final String type;
  const AllCreationScreen({super.key, required this.type});

  @override
  State<AllCreationScreen> createState() => _AllCreationScreenState();
}

class _AllCreationScreenState extends State<AllCreationScreen> {
  final ScrollController _scrollController = ScrollController();
  bool _isSearchVisible = true;
  double _lastScrollOffset = 0.0;
  bool _isLoadingMore = false;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  void _onScroll() {
    double currentOffset = _scrollController.position.pixels;

    if (currentOffset > _lastScrollOffset && _isSearchVisible) {
      // Scrolling down - hide search field
      setState(() {
        _isSearchVisible = false;
      });
    } else if (currentOffset < _lastScrollOffset && !_isSearchVisible) {
      // Scrolling up - show search field
      setState(() {
        _isSearchVisible = true;
      });
    }

    _lastScrollOffset = currentOffset;
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: Text(
        'All ${widget.type} Creations',
        style: const TextStyle(
            fontSize: 17,
            color: Color.fromARGB(255, 0, 0, 0),
            fontWeight: FontWeight.w600),
      )),
      body: Column(
        children: [
          // getSearchField(),
          Expanded(
            child: Consumer(
              builder: (
                context,
                value,
                child,
              ) {
                if (widget.type == 'trending') {
                  return Consumer<TreandingCreationProvider>(
                    builder: (context, provider, child) {
                      return _buildListView(provider.threandingCreations!,
                          provider.fetchMoreTrendingCreations, provider);
                    },
                  );
                } else if (widget.type == 'other') {
                  return Consumer<GeneralCreationProvider>(
                    builder: (context, provider, child) {
                      return _buildListView(provider.generalCreations!,
                          provider.fetchMoreGeneralCreations, provider);
                    },
                  );
                } else {
                  return Consumer<RecentCreationProvider>(
                    builder: (context, provider, child) {
                      return _buildListView(provider.recentlyAddedCreations!,
                          provider.fetchMoreRecentCreations, provider);
                    },
                  );
                }
              },
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _fetchNextCreations(fetchMoreCreations) async {
    await fetchMoreCreations(
        Provider.of<UserInfoProvider>(context, listen: false).user!.userId);

    await Future.delayed(const Duration(seconds: 2));
    setState(() {
      _isLoadingMore = false;
    });
  }

  Widget _buildListView(
      List<Creation> creations, Function fetchMoreCreations, provider) {
    _scrollController.addListener(() {
      if (_scrollController.position.pixels ==
              _scrollController.position.maxScrollExtent &&
          !_isLoadingMore) {
        setState(() {
          _isLoadingMore = true;
        });
        _fetchNextCreations(fetchMoreCreations);
      }
    });

    return ListView.separated(
        controller: _scrollController,
        padding: EdgeInsets.all(AppPadding.edgePadding),
        itemCount: creations.length + 3,
        separatorBuilder: (context, index) => const SizedBox(height: 15),
        itemBuilder: (context, index) {
          if (index >= creations.length) {
            return _isLoadingMore
                ? const Center(child: CreationCardPlaceholder())
                : const SizedBox.shrink();
          }
          return GestureDetector(
              onTap: () {
                Get.to(ProductDetailsScreen(creation: creations[index]));
              },
              child: CreatationCard(creation: creations[index]));
        });
  }

  Widget getSearchField() {
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
                  decoration: InputDecoration(
                    focusedBorder: AppTextfieldBorder.focusedBorder,
                    contentPadding: const EdgeInsets.all(8),
                    hintText: 'Search...',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    prefixIcon: const Icon(Icons.search),
                    suffixIcon: IconButton(
                      onPressed: () {
                        showFilters();
                      },
                      icon: const Icon(Icons.filter_list),
                    ),
                  ),
                ),
              )
            : null,
      ),
    );
  }

  showFilters() {
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
}
