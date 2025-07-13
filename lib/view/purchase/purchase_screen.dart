import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:projecthub/app_providers/data_file_provider.dart';
import 'package:projecthub/app_providers/user_provider.dart';
import 'package:projecthub/constant/app_padding.dart';
import 'package:projecthub/constant/app_text.dart';
import 'package:projecthub/constant/app_textfield_border.dart';
import 'package:projecthub/model/creation_info_model.dart';
import 'package:projecthub/widgets/creation_card.dart';
import 'package:provider/provider.dart';

class PurchaseScreen extends StatefulWidget {
  const PurchaseScreen({super.key});

  @override
  State<PurchaseScreen> createState() => _PurchaseScreenState();
}

class _PurchaseScreenState extends State<PurchaseScreen> {
  List<Creation> _userPurchasedCreations = [];
  final ScrollController _scrollController = ScrollController();
  bool _isSearchVisible = true;
  double _lastScrollOffset = 0.0;

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

  getDate() {
    _userPurchasedCreations =
        Provider.of<UserInfoProvider>(context).userPerchedCreations;
  }

  @override
  Widget build(BuildContext context) {
    getDate();
    return Scaffold(
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            getSearchField(),
            Padding(
              padding: EdgeInsets.only(
                  left: AppPadding.edgePadding,
                  right: AppPadding.edgePadding,
                  top: AppPadding.edgePadding,
                  bottom: AppPadding.edgePadding * 0.6),
              child: Text(
                "My puchesed creations",
                style: AppText.heddingStyle2bBlack,
              ),
            ),
            Expanded(
              child: ListView.separated(
                  controller: _scrollController,
                  padding: EdgeInsets.all(AppPadding.edgePadding),
                  itemCount: _userPurchasedCreations.length,
                  separatorBuilder: (context, index) =>
                      const SizedBox(height: 15),
                  itemBuilder: (context, index) {
                    return CreatationCard(
                        creation: _userPurchasedCreations[index]);
                  }),
            ),
          ],
        ),
      ),
    );
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
        ));
  }
}
