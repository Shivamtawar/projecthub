// ignore_for_file: use_build_context_synchronously

import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:projecthub/app_providers/creation_provider.dart';
import 'package:projecthub/view/profile/provider/user_provider.dart';
import 'package:projecthub/config/api_config.dart';
import 'package:projecthub/constant/app_color.dart';
import 'package:projecthub/constant/app_padding.dart';
import 'package:projecthub/constant/app_text.dart';
import 'package:projecthub/controller/creation_controller.dart';
import 'package:projecthub/model/creation_model.dart';
import 'package:projecthub/widgets/app_primary_button.dart';
import 'package:provider/provider.dart';

import '../app_shimmer.dart';
import '../cart/view/cart_page.dart';

// ignore: must_be_immutable
class ProductDetailsScreen extends StatefulWidget {
  Creation creation;
  ProductDetailsScreen({super.key, required this.creation});

  @override
  State<ProductDetailsScreen> createState() => _ProductDetailsScreenState();
}

class _ProductDetailsScreenState extends State<ProductDetailsScreen> {
  bool showReview = false;

  @override
  void initState() {
    super.initState();
    Provider.of<RecomandedCreationProvider>(context, listen: false)
        .feachRecommandedCreation(
            Provider.of<UserInfoProvider>(context, listen: false).user!.userId,
            widget.creation);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          SizedBox(
            height: Get.height * 0.83,
            child: ListView(
              children: [
                Stack(
                  children: [
                    SizedBox(
                      height: Get.height * 0.27,
                      width: Get.width,
                      child: Image.network(
                        ApiConfig.getFileUrl(
                            widget.creation.creationThumbnail!),
                        fit: BoxFit.cover,
                      ),
                    ),
                    Positioned(
                        top: 0,
                        left: 0,
                        child: IconButton(
                            onPressed: () {
                              Get.back();
                            },
                            icon: const Icon(
                              Icons.arrow_back_ios,
                              size: 20,
                            ))),
                    Positioned(
                      top: 0,
                      right: 0,
                      child: Column(
                        children: [
                          IconButton(
                            onPressed: () {},
                            icon: const Icon(
                              Icons.favorite_outline,
                              color: Colors.black,
                              size: 22,
                            ),
                          ),
                          IconButton(
                            onPressed: () {},
                            icon: const Icon(
                              Icons.share_outlined,
                              color: Colors.black,
                              size: 22,
                            ),
                          )
                        ],
                      ),
                    )
                  ],
                ),
                Padding(
                  padding: EdgeInsets.all(AppPadding.edgePadding * 1.2),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.creation.creationTitle!,
                        style: AppText.bigHeddingStyle1a,
                      ),
                      SizedBox(height: 14.h),
                      const Text(
                        "About This Creation",
                        style: TextStyle(
                            color: Colors.black87,
                            fontSize: 15,
                            fontWeight: FontWeight.w500),
                      ),
                      SizedBox(height: 10.h),
                      Text(
                        widget.creation.creationDescription!,
                        style: AppText.subHeddingStyle,
                      ),
                      SizedBox(height: 30.h),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          const Icon(Icons.lock_clock),
                          const SizedBox(width: 10),
                          Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                "Lifetime Access",
                                style: TextStyle(
                                    color: Colors.black87,
                                    fontSize: 15,
                                    fontWeight: FontWeight.w500),
                              ),
                              SizedBox(
                                width: Get.width * 0.8,
                                child: const Text(
                                  overflow: TextOverflow.ellipsis,
                                  "Buy once and access till whenever you want.",
                                  style: TextStyle(
                                      color: Colors.black87,
                                      fontSize: 14,
                                      fontWeight: FontWeight.w400),
                                ),
                              ),
                            ],
                          )
                        ],
                      ),
                      SizedBox(
                        height: 50.h,
                      ),
                      Row(
                        children: [
                          Container(
                            height: Get.height * 0.045,
                            width: Get.height * 0.045,
                            decoration: const BoxDecoration(
                              color: Color.fromARGB(207, 225, 225, 241),
                              shape: BoxShape.circle,
                            ),
                            child:
                                (widget.creation.seller!.sellerProfilePhoto !=
                                        null)
                                    ? ClipRRect(
                                        borderRadius: BorderRadius.circular(25),
                                        child: Image.network(
                                            ApiConfig.getFileUrl(widget.creation
                                                .seller!.sellerProfilePhoto!)),
                                      )
                                    : const Icon(Icons.person),
                          ),
                          const SizedBox(width: 15),
                          Text(
                            widget.creation.seller!.sellerName!,
                            style: TextStyle(
                                fontWeight: FontWeight.w400,
                                color: AppColor.primaryColor,
                                fontSize: 16),
                          )
                        ],
                      ),
                      SizedBox(height: 30.h),
                      GestureDetector(
                        onTap: () {
                          setState(() {
                            showReview = !showReview;
                          });
                        },
                        child: Row(
                          children: [
                            Icon(
                              Icons.star,
                              color: AppColor.secYello,
                              size: 20,
                            ),
                            SizedBox(width: Get.height * 0.01),
                            Text(
                              widget.creation.avgRating!
                                  .toString()
                                  .substring(0, 3),
                              style: const TextStyle(fontSize: 12),
                            ),
                            SizedBox(width: Get.height * 0.01),
                            Text(
                              "(${widget.creation.totalReviews} Reviews)",
                              style: const TextStyle(fontSize: 12),
                            ),
                            (showReview)
                                ? const Icon(Icons.arrow_drop_up)
                                : const Icon(Icons.arrow_drop_down_sharp)
                          ],
                        ),
                      ),
                      if (showReview) getReviews()
                    ],
                  ),
                ),
                Padding(
                  padding:
                      EdgeInsets.symmetric(horizontal: AppPadding.edgePadding),
                  child: const Text(
                    "You may also like",
                    style: TextStyle(fontSize: 15, fontWeight: FontWeight.w500),
                  ),
                ),
                SizedBox(height: 20.h),
                Consumer<RecomandedCreationProvider>(
                    builder: (context, value, child) {
                  if (value.isLoading) {
                    return SizedBox(
                      height: 210.h,
                      child: ListView.builder(
                          padding: const EdgeInsets.symmetric(horizontal: 8),
                          scrollDirection: Axis.horizontal,
                          itemCount: 6,
                          itemBuilder: (context, index) {
                            return const Padding(
                              padding: EdgeInsets.all(8.0),
                              child: RecommandationCreationCardPlacHolder(),
                            );
                          }),
                    );
                  } else {
                    return suggestCreationView(value);
                  }
                }),
                // suggestCreationView()
              ],
            ),
          ),
          getBottomContainer(),
        ],
      ),
    );
  }

  Widget getReviews() {
    return Column(
      children: List.generate(
        6,
        (index) => Container(
          padding: EdgeInsets.all(AppPadding.itermInsidePadding),
          margin: const EdgeInsets.symmetric(vertical: 8),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: Colors.white,
          ),
          //height: 100,
          width: double.infinity,
          child: Column(
            children: [
              Row(
                children: [
                  Container(
                    height: Get.height * 0.04,
                    width: Get.height * 0.04,
                    decoration: const BoxDecoration(
                      color: Color.fromARGB(201, 190, 190, 190),
                      shape: BoxShape.circle,
                    ),
                    child: (widget.creation.seller!.sellerProfilePhoto != null)
                        ? ClipRRect(
                            borderRadius: BorderRadius.circular(25),
                            child: Image.asset(
                                widget.creation.seller!.sellerProfilePhoto!),
                          )
                        : const Icon(Icons.person),
                  ),
                  const SizedBox(width: 15),
                  Text(
                    widget.creation.seller!.sellerName!,
                    style: const TextStyle(
                      fontWeight: FontWeight.w500,
                      color: Color.fromARGB(255, 72, 72, 72),
                    ),
                  )
                ],
              ),
              Row(
                children: [
                  SizedBox(width: Get.height * 0.04 + 15),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          for (int i = 1; i <= 5; i++)
                            Icon(
                              Icons.star,
                              color: AppColor.secYello,
                              size: 18,
                            ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      SizedBox(
                        width: Get.width * 0.7,
                        child: const Text(
                          "The Indian rupee (symbol: ₹; code: INR) is the official currency in the Republic of India.",
                          style: TextStyle(fontSize: 12, color: Colors.black87),
                        ),
                      )
                    ],
                  )
                ],
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget getBottomContainer() {
    return Expanded(
      child: Container(
        width: Get.width,
        color: const Color.fromARGB(255, 239, 239, 239),
        padding: EdgeInsets.all(AppPadding.edgePadding),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text("Price"),
                Text(
                  "₹ ${widget.creation.creationPrice!}",
                  style: AppText.bigHeddingStyle1b,
                ),
              ],
            ),
            Material(
              color: Colors.transparent,
              child: Row(
                children: [
                  Expanded(
                    flex: 0,
                    child: InkWell(
                      borderRadius: const BorderRadius.all(Radius.circular(10)),
                      child: Container(
                        // margin: const EdgeInsets.only(right: 5),
                        height: Get.height * 0.06,
                        padding:
                            EdgeInsets.symmetric(horizontal: Get.width * 0.06),
                        decoration: BoxDecoration(
                            color: Colors.transparent,
                            shape: BoxShape.rectangle,
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(
                                width: 0.5, color: Colors.grey.shade500)),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text(
                              "My Cart",
                              style: AppText.heddingStyle2bBlack,
                            )
                          ],
                        ),
                      ),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const AddToCartPage(),
                          ),
                        );
                      },
                    ),
                  ),
                  const SizedBox(width: 10),
                  AppPrimaryButton(
                    title: "Add To Cart",
                    icon: const Icon(
                      Icons.shopping_cart,
                      color: Colors.white,
                      size: 20,
                    ),
                    onPressed: () async {
                      try {
                        await CreationController().addCreationInCard(
                            Provider.of<UserInfoProvider>(context,
                                    listen: false)
                                .user!
                                .userId,
                            widget.creation.creationId);
                        SnackBar snackBar = const SnackBar(
                          content: Text("Product added"),
                          duration: Duration(milliseconds: 500),
                        );
                        ScaffoldMessenger.of(context).showSnackBar(snackBar);
                      } catch (e) {
                        SnackBar snackBar = const SnackBar(
                          content: Text("Failed to add creation in card"),
                          duration: Duration(milliseconds: 500),
                        );
                        ScaffoldMessenger.of(context).showSnackBar(snackBar);

                        log("$e");
                      }
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget suggestCreationView(value) {
    return SizedBox(
      //color: Colors.red,
      height: 230.h,
      width: double.infinity.w,
      child: ListView.separated(
        padding: EdgeInsets.symmetric(horizontal: AppPadding.edgePadding),
        physics: const BouncingScrollPhysics(),
        primary: false,
        shrinkWrap: true,
        scrollDirection: Axis.horizontal,
        itemCount: value.recomandedCreationProvider.length,
        separatorBuilder: (context, index) => const SizedBox(width: 10),
        itemBuilder: (BuildContext context, index) {
          Creation creation = value.recomandedCreationProvider[index];
          return Padding(
            padding: EdgeInsets.symmetric(vertical: 10.h),
            child: GestureDetector(
              onTap: () {
                Get.to(ProductDetailsScreen(
                  creation: creation,
                ));
              },
              child: Container(
                width: 200.w,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15),
                    color: Colors.white,
                    boxShadow: const [
                      BoxShadow(
                        color: Color.fromARGB(61, 157, 157, 163),
                        blurRadius: 5,
                        spreadRadius: 1,
                        // offset: Offset(1, -1),
                      )
                    ]),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      height: 120.h,
                      width: 200.w,
                      decoration: BoxDecoration(
                        //color: Colors.red,
                        borderRadius: BorderRadius.circular(50),
                      ),
                      child: ClipRRect(
                        borderRadius: const BorderRadius.only(
                            topRight: Radius.circular(15),
                            topLeft: Radius.circular(15)),
                        child: Image.network(
                          ApiConfig.getFileUrl(creation.creationThumbnail!),
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    SizedBox(height: 8.h),
                    Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: AppPadding.itermInsidePadding,
                      ),
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
                          SizedBox(height: 4.h),
                          Text(
                            overflow: TextOverflow.ellipsis,
                            maxLines: 2,
                            "by ${creation.seller!.sellerName!}",
                            style: TextStyle(
                              fontFamily: 'Gilroy',
                              fontWeight: FontWeight.w400,
                              fontSize: 13.sp,
                              color: const Color.fromARGB(255, 74, 74, 74),
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
        },
      ),
    );
  }
}
