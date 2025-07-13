// ignore_for_file: deprecated_member_use

import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:get/get.dart';
import 'package:projecthub/app_providers/order_provider.dart';
import 'package:projecthub/view/profile/provider/user_provider.dart';
import 'package:projecthub/constant/app_color.dart';
import 'package:projecthub/constant/app_icons.dart';
import 'package:projecthub/constant/app_padding.dart';
import 'package:projecthub/controller/paymet_controller.dart';
import 'package:projecthub/view/cart/model/incard_creation_model.dart';
import 'package:projecthub/model/order_details_model.dart';
import 'package:projecthub/view/app_navigation_bar/app_navigation_bar.dart';
import 'package:projecthub/view/product_details_screen/product_details_screen.dart';
import 'package:projecthub/widgets/app_primary_button.dart';
import 'package:provider/provider.dart';
import '../../../config/api_config.dart';
import '../../../model/payment_info_model.dart';
import '../provider/card_creation_provider.dart';

class AddToCartPage extends StatefulWidget {
  const AddToCartPage({super.key});

  @override
  State createState() {
    return _AddToCartPage();
  }
}

class _AddToCartPage extends State<AddToCartPage> {
  double subTotal = 0.00;
  double totalPlatFromFees = 0.00;
  double totalGst = 0.00;
  double totalCost = 0.00;

  @override
  void initState() {
    super.initState();
    Provider.of<InCardCreationProvider>(context, listen: false)
        .fetchInCardCreations(
            Provider.of<UserInfoProvider>(context, listen: false).user!.userId);
  }

  onPaymentSuccessful(OrderDetails order, PaymentData paymentData) async {
    final userProvider = Provider.of<UserInfoProvider>(context, listen: false);

    List productDetail = [];

    for (int i = 0; i < order.creations.length; i++) {
      double price = double.parse(
          (double.parse(order.creations[i].creation.creationPrice!.toString()))
              .toStringAsFixed(2));

      log((order.creations[i].creation).toString());
      productDetail.add({
        'seller_id': order.creations[i].creation.seller.sellerId,
        'creation_id': order.creations[i].creation.creationId,
        'price': price,
        'gst_amount': double.parse(
            (price * (order.creations[i].creation.gstTaxPercentage!) / 100)
                .toStringAsFixed(2)),
        'platform_fee': double.parse(
            (price * (order.creations[i].creation.platformFee!) / 100)
                .toStringAsFixed(2)),
      });
    }
    Get.defaultDialog(
        title: "please wait",
        content: const Center(
          child: CircularProgressIndicator(),
        ));

    final provider = Provider.of<OrderProvider>(context, listen: false);
    try {
      await provider.placeOrder(
        userProvider.user!.userId,
        paymentData.toJson(),
        productDetail,
        DateTime.now().toString(),
      );
    } catch (e) {
      Get.snackbar("Order failed", "Paymet confirm but order failed");
    } finally {
      Navigator.of(context).pop();
    }

    Get.defaultDialog(
        title: '',
        barrierDismissible: false,
        content: Column(
          children: [
            Image(
              image: const AssetImage(
                'assets/images/successpayment.png',
              ),
              height: 120.h,
              width: 120.w,
            ),
            SizedBox(height: 10.h),
            Text(
              "Payment Successfull",
              style: TextStyle(
                  fontSize: 28.sp,
                  fontFamily: 'Gilroy',
                  fontWeight: FontWeight.w700),
            ),
            SizedBox(height: 10.h),
            Text(
              'The purchased items have been moved to the "Purchased" section.',
              style: TextStyle(
                  color: const Color(0XFF292929),
                  fontFamily: 'Gilroy',
                  fontSize: 15.sp,
                  fontStyle: FontStyle.normal),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 10.h),
            Padding(
              padding: EdgeInsets.only(
                  top: 20.h, bottom: 20.h, right: 10.w, left: 10.w),
              child: GestureDetector(
                onTap: () {
                  Get.offAll(() => const AppNavigationScreen());
                },
                child: Container(
                  height: 56.h,
                  width: 374.w,
                  //color: Color(0XFF23408F),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20.h),
                    color: const Color(0XFF23408F),
                  ),
                  child: Center(
                    child: Text("Ok",
                        style: TextStyle(
                          color: const Color(0XFFFFFFFF),
                          fontSize: 18.sp,
                          fontWeight: FontWeight.w700,
                          fontFamily: 'Gilroy',
                        )),
                  ),
                ),
              ),
            ),
          ],
        ));
  }

  onPaymentFailed() {
    Get.snackbar("Payment failed", "please try agian");
  }

  onCheckOut(OrderDetails order) {
    final userProvider = Provider.of<UserInfoProvider>(context, listen: false);
    PaymetController().makePayment(
        userProvider.user!, order, onPaymentSuccessful, onPaymentFailed);
  }

  Future<bool> _requestPop() {
    Navigator.of(context).pop();
    return Future.value(true);
  }

  getCost(List<InCardCreationInfo> creationList) {
    double subCost = 0.00;
    double gst = 0.00;
    double platFromFees = 0.00;

    for (int i = 0; i < creationList.length; i++) {
      double creationPrice =
          double.parse("${creationList[i].creation.creationPrice}");

      subCost = subCost + creationPrice;
      gst = gst +
          (creationPrice * creationList[i].creation.gstTaxPercentage!) / 100;
      platFromFees = platFromFees +
          (creationPrice * creationList[i].creation.platformFee!) / 100;
    }

    // Round values to 2 decimal places
    subTotal = double.parse(subCost.toStringAsFixed(2));
    totalPlatFromFees = double.parse(platFromFees.toStringAsFixed(2));
    totalGst = double.parse(gst.toStringAsFixed(2));

    totalCost = double.parse((subCost + gst + platFromFees).toStringAsFixed(2));
  }

  removeItemFromCard(InCardCreationInfo inCardCreationInfo) async {
    final provider =
        Provider.of<InCardCreationProvider>(context, listen: false);
    await provider.removeItemFromCard(
      Provider.of<UserInfoProvider>(context, listen: false).user!.userId,
      inCardCreationInfo.carditemId,
    );
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _requestPop,
      child: Scaffold(
        backgroundColor: AppColor.bgColor,
        appBar: AppBar(
          backgroundColor: AppColor.bgColor,
          elevation: 0,
          title: const Text("Your Cart"),
          leading: Builder(
            builder: (BuildContext context) {
              return IconButton(
                icon: AppIcon.backIcon,
                onPressed: _requestPop,
              );
            },
          ),
        ),
        body:
            Consumer<InCardCreationProvider>(builder: (context, value, child) {
          if (value.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }
          if (value.errorMessage.isNotEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.error),
                  const SizedBox(height: 10),
                  Text(
                    value.errorMessage,
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            );
          }
          if (value.creations!.isEmpty) {
            return Center(
                child: Column(
              children: [
                SizedBox(
                  height: 120.h,
                  width: 120.w,
                  child: Image.asset("assets/images/cart.png"),
                ),
                const SizedBox(height: 4),
                const Text("Your cart is empty"),
                Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: AppPrimaryElevetedButton(
                      onPressed: () {}, title: "Browse Creations"),
                )
              ],
            ));
          }
          getCost(value.creations!);

          return Column(
            children: [
              Expanded(
                flex: 1,
                child: Padding(
                  padding: EdgeInsets.only(
                    left: AppPadding.edgePadding,
                    right: AppPadding.edgePadding,
                  ),
                  child: ListView.builder(
                    shrinkWrap: true,
                    itemCount: value.creations!.length,
                    itemBuilder: (context, index) {
                      return getCreationCard(value.creations![index]);
                    },
                  ),
                ),
              ),
              Container(
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: const BorderRadius.only(
                      topRight: Radius.circular(30),
                      topLeft: Radius.circular(30),
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.shade200,
                        blurRadius: 10,
                      )
                    ]),
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Container(
                        width: Get.width * 0.2,
                        height: 3,
                        color: const Color.fromARGB(197, 194, 194, 194),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(
                          horizontal: AppPadding.edgePadding * 2),
                      child: Column(
                        children: [
                          _getPriceInfo("SubTotal", "$subTotal"),
                          _getPriceInfo("platFromFees", "$totalPlatFromFees"),
                          _getPriceInfo("GST Tax", "$totalGst"),
                          const SizedBox(height: 10),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text(
                                "Total",
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Color.fromARGB(255, 44, 44, 44),
                                  fontWeight: FontWeight.w800,
                                ),
                              ),
                              Text(
                                "₹ $totalCost",
                                style: const TextStyle(
                                  fontSize: 14,
                                  color: Color.fromARGB(255, 44, 44, 44),
                                  fontWeight: FontWeight.w800,
                                ),
                              ),
                            ],
                          ),
                          Padding(
                            padding: EdgeInsets.symmetric(
                              vertical: AppPadding.edgePadding * 1.5,
                            ),
                            child: AppPrimaryElevetedButton(
                              onPressed: () {
                                Map<String, dynamic> data = {
                                  'creations': value.creations,
                                  'subTotal': subTotal,
                                  'totalGst': totalGst,
                                  'totalPlatformFees': totalPlatFromFees,
                                  'total': totalCost,
                                };

                                onCheckOut(OrderDetails.fromJson(data));
                              },
                              title: "Check Out",
                            ),
                          )
                        ],
                      ),
                    )
                  ],
                ),
              )
            ],
          );
        }),
      ),
    );
  }

  _getPriceInfo(String key, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            key,
            style: const TextStyle(
              fontSize: 13,
              color: Color.fromARGB(255, 105, 104, 104),
              fontWeight: FontWeight.w800,
            ),
          ),
          Text(
            "₹ $value",
            style: const TextStyle(
              fontSize: 13,
              color: Color.fromARGB(255, 105, 104, 104),
              fontWeight: FontWeight.w800,
            ),
          ),
        ],
      ),
    );
  }

  getCreationCard(InCardCreationInfo inCardCreationInfo) {
    return Slidable(
      // actionPane: SlidableDrawerActionPane(),
      endActionPane: ActionPane(
        motion: const DrawerMotion(),
        children: [
          SlidableAction(
            onPressed: (context) {
              removeItemFromCard(inCardCreationInfo);
            },
            icon: Icons.close,
            padding: EdgeInsets.zero,
            flex: 1,
            label: "Remove",
          )
        ],
      ),
      child: Container(
        margin: const EdgeInsets.only(top: 10, bottom: 10),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: const [
            BoxShadow(
              color: Color.fromARGB(255, 225, 225, 225),
              blurRadius: 10,
            )
          ],
        ),
        child: Material(
          color: Colors
              .transparent, // Set transparent background for ripple effect
          child: Ink(
            decoration: BoxDecoration(
              color: Colors.white, // Card background color
              borderRadius:
                  BorderRadius.circular(12), // Border radius for Ink effect
            ),
            child: InkWell(
              borderRadius:
                  BorderRadius.circular(12), // Match the border radius
              hoverColor: const Color.fromARGB(
                  255, 145, 145, 145), // Slight black hover effect
              highlightColor: const Color.fromARGB(95, 119, 117, 117)
                  .withOpacity(0.2), // Slight black highlight effect
              splashColor: Colors.black.withOpacity(0.1), // Black splash color
              onTap: () {
                Get.to(ProductDetailsScreen(
                    creation: inCardCreationInfo.creation));
              },
              child: Padding(
                padding: EdgeInsets.all(AppPadding.edgePadding),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          height: Get.height * 0.096,
                          width: Get.width * 0.35,
                          decoration: BoxDecoration(
                            shape: BoxShape.rectangle,
                            borderRadius: const BorderRadius.all(
                              Radius.circular(9),
                            ),
                            color: Colors
                                .grey.shade200, // Placeholder background color
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(9),
                            child: Image.network(
                              ApiConfig.getFileUrl(inCardCreationInfo
                                  .creation.creationThumbnail!),
                              fit: BoxFit.fill,
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                        width: AppPadding
                            .itermInsidePadding), // Space between elements
                    Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(
                          width: Get.width * 0.4,
                          child: Text(
                            inCardCreationInfo.creation.creationTitle!,
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 15,
                            ),
                          ),
                        ),
                        const SizedBox(height: 1),
                        SizedBox(
                          width: Get.width * 0.4,
                          child: Text(
                            '₹${inCardCreationInfo.creation.creationPrice}',
                            style: const TextStyle(
                              color: Colors.green,
                              fontWeight: FontWeight.bold,
                              fontSize: 14,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
