// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:get/get.dart';
import 'package:projecthub/app_providers/user_provider.dart';
import 'package:projecthub/constant/app_color.dart';
import 'package:projecthub/constant/app_icons.dart';
import 'package:projecthub/constant/app_padding.dart';
import 'package:projecthub/model/creation_info_model.dart';
import 'package:projecthub/view/product_details_screen/product_details_screen.dart';
import 'package:projecthub/widgets/app_primary_button.dart';
import 'package:provider/provider.dart';

class AddToCartPage extends StatefulWidget {
  const AddToCartPage({super.key});

  @override
  State createState() {
    return _AddToCartPage();
  }
}

class _AddToCartPage extends State<AddToCartPage> {
  List<Creation> cartCreations = [];
  double subTotal = 0;
  double platFromFees = 0;
  double gstTax = 0;
  double platFromFeesPercentage = 10;
  double gstTaxPercentage = 3;

  Future<bool> _requestPop() {
    Navigator.of(context).pop();
    return Future.value(true);
  }

  getCost(List<Creation> creationList) {
    double cost = 0;
    for (int i = 0; i < creationList.length; i++) {
      cost = cost + creationList[i].price;
    }
    subTotal = cost;
    platFromFees = subTotal * platFromFeesPercentage / 100;
    gstTax = subTotal * gstTaxPercentage / 100;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    cartCreations = Provider.of<UserInfoProvider>(context).userInCartCreation;
    getCost(cartCreations);

    return WillPopScope(
      onWillPop: _requestPop,
      child: Scaffold(
        backgroundColor: AppColor.bgColor,
        appBar: AppBar(
          backgroundColor: AppColor.bgColor,
          elevation: 0,
          centerTitle: true,
          title: const Text("Cart"),
          leading: Builder(
            builder: (BuildContext context) {
              return IconButton(
                icon: AppIcon.backIcon,
                onPressed: _requestPop,
              );
            },
          ),
        ),
        body: Column(
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
                  itemCount: cartCreations.length,
                  itemBuilder: (context, index) {
                    return getCreationCard(cartCreations[index]);
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
                        _getPriceInfo("platFromFees", "$platFromFees"),
                        _getPriceInfo("GST Tax", "$gstTax"),
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
                              "₹ ${subTotal + platFromFees + gstTax}",
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
                            onPressed: () {},
                            title: "CheckOut",
                          ),
                        )
                      ],
                    ),
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  void removeItem(Creation index) {
    cartCreations.remove(index);
    setState(() {});
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

  getCreationCard(Creation creation) {
    return Slidable(
      // actionPane: SlidableDrawerActionPane(),
      endActionPane: ActionPane(
        motion: const DrawerMotion(),
        children: [
          SlidableAction(
            onPressed: (context) {
              removeItem(creation);
              setState(() {});
            },
            icon: Icons.close,
            padding: EdgeInsets.zero,
            flex: 1,
            label: "Remove",
          )
        ],
      ),
      child: InkWell(
        onTap: () {
          Get.to(ProductDetailsScreen(creation: creation));
        },
        child: Container(
          margin: const EdgeInsets.only(top: 10, bottom: 10),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.shade200,
                blurRadius: 10,
              )
            ],
          ),
          child: Padding(
            padding: EdgeInsets.all(AppPadding.edgePadding),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  height: Get.height * 0.1,
                  width: Get.width * 0.3,
                  decoration: const BoxDecoration(
                    shape: BoxShape.rectangle,
                    borderRadius: BorderRadius.all(
                      Radius.circular(15),
                    ),
                  ),
                  child: Image.asset(
                    creation.imagePath,
                    fit: BoxFit.cover,
                  ),
                ),
                Padding(
                  padding: EdgeInsets.all(AppPadding.itermInsidePadding),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(creation.title),
                      Text(creation.price.toString()),
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
