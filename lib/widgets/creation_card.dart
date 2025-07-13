import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:projecthub/config/api_config.dart';
import 'package:projecthub/constant/app_text.dart';
import 'package:projecthub/services/file_service.dart';
import 'package:projecthub/view/user_listed_creation/model/listed_creation_model.dart';
import 'package:projecthub/model/creation_model.dart';
import 'package:share_plus/share_plus.dart';

import '../view/purchase/model/purched_creation_model.dart';
import '../view/purchase/view/purchase_creation_details_screen.dart';

class CreatationCard extends StatelessWidget {
  final Creation creation;
  final VoidCallback? onTap;

  const CreatationCard({
    super.key,
    required this.creation,
    this.onTap,
  });

  Future<void> share() async {
    await Share.share('Check out this template: ${creation.creationTitle}');
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Card(
        elevation: 2,
        // margin: EdgeInsets.symmetric(vertical: 8.h, horizontal: 8.w),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Thumbnail Image
            ClipRRect(
              borderRadius:
                  const BorderRadius.vertical(top: Radius.circular(12)),
              child: Image.network(
                "${ApiConfig.baseURL}/${creation.creationThumbnail!}",
                height: 180.h,
                width: double.infinity,
                fit: BoxFit.cover,
                loadingBuilder: (context, child, loadingProgress) {
                  if (loadingProgress == null) return child;
                  return SizedBox(
                    height: 180.h,
                    child: Center(
                      child: CircularProgressIndicator(
                        value: loadingProgress.expectedTotalBytes != null
                            ? loadingProgress.cumulativeBytesLoaded /
                                loadingProgress.expectedTotalBytes!
                            : null,
                      ),
                    ),
                  );
                },
                errorBuilder: (context, error, stackTrace) {
                  return Container(
                    alignment: Alignment.center,
                    height: 180.h,
                    color: Colors.grey[200],
                    child: const Icon(
                      Icons.broken_image,
                      size: 50,
                      color: Color.fromARGB(255, 171, 171, 171),
                    ),
                  );
                },
              ),
            ),

            // Content
            Padding(
              padding: EdgeInsets.all(12.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Title and Rating
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          creation.creationTitle ?? 'Untitled Template',
                          style: TextStyle(
                            fontSize: 19.sp,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      if (creation.avgRating != null)
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
                                creation.avgRating!.toString().length > 3
                                    ? creation.avgRating!
                                        .toString()
                                        .substring(0, 3)
                                    : creation.avgRating!.toString(),
                                style: TextStyle(
                                  fontSize: 14.sp,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                    ],
                  ),

                  SizedBox(height: 8.h),

                  // Description
                  if (creation.creationDescription != null &&
                      creation.creationDescription!.isNotEmpty)
                    Column(
                      children: [
                        Text(
                          creation.creationDescription!,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontSize: 14.sp,
                            color: Colors.grey[600],
                          ),
                        ),
                        SizedBox(height: 8.h),
                      ],
                    ),

                  // Seller Info and Price
                  Row(
                    children: [
                      // Seller Avatar
                      CircleAvatar(
                        radius: 20.r,
                        backgroundImage: creation.seller?.sellerProfilePhoto !=
                                null
                            ? NetworkImage(
                                "${ApiConfig.baseURL}/${creation.seller!.sellerProfilePhoto!}")
                            : null,
                        child: creation.seller.sellerProfilePhoto == null
                            ? const Icon(Icons.person, size: 20)
                            : null,
                      ),

                      SizedBox(width: 8.w),

                      // Seller Name
                      Expanded(
                        child: Text(
                          creation.seller.sellerName ?? 'Unknown Seller',
                          style: TextStyle(
                            fontSize: 14.5.sp,
                            fontWeight: FontWeight.w500,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),

                      // Price
                      Container(
                        padding: EdgeInsets.symmetric(
                            horizontal: 12.w, vertical: 6.h),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                          color: const Color(0XFFE5ECFF),
                        ),
                        child: Text(
                          '₹${creation.creationPrice ?? '0'}',
                          style: TextStyle(
                            fontSize: 16.sp,
                            fontWeight: FontWeight.bold,
                            color: const Color(0XFF23408F),
                          ),
                        ),
                      ),
                    ],
                  ),

                  SizedBox(height: 8.h),

                  // Footer (Date and Actions)
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Added: ${creation.createtime?.split(' ')[1]} ${creation.createtime?.split(' ')[2]} ${creation.createtime?.split(' ')[3]}",
                        style: TextStyle(
                          fontSize: 12.sp,
                          color: Colors.grey[500],
                        ),
                      ),
                      Row(
                        children: [
                          IconButton(
                            icon: (creation.isLikedByUser!)
                                ? const Icon(Icons.favorite,
                                    color: Colors.red, size: 20)
                                : const Icon(Icons.favorite_border, size: 20),
                            onPressed: () {},
                            padding: EdgeInsets.zero,
                            constraints: const BoxConstraints(),
                          ),
                          Text(creation.totalLikes!.toString()),
                          SizedBox(width: 8.w),
                          IconButton(
                            icon: const Icon(Icons.share, size: 20),
                            onPressed: share,
                            padding: EdgeInsets.zero,
                            constraints: const BoxConstraints(),
                          ),
                        ],
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

class ListedCreationCard extends StatefulWidget {
  final ListedCreation creation;
  const ListedCreationCard({super.key, required this.creation});

  @override
  State createState() => _ListedCreationCardState();
}

class _ListedCreationCardState extends State<ListedCreationCard> {
  Future<void> share() async {
    await Share.share('check out my website https://example.com');
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12.h),
          boxShadow: [
            BoxShadow(
              color: const Color(0XFF23408F).withOpacity(0.24),
              offset: const Offset(-4, 5),
              blurRadius: 16.h,
            ),
          ],
          color: Colors.white),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12.h),
              boxShadow: [
                BoxShadow(
                    color: const Color(0XFF23408F).withOpacity(0.14),
                    offset: const Offset(-4, 5),
                    blurRadius: 16.h),
              ],
              color: Colors.white,
            ),
            child: Stack(
              children: [
                Container(
                  height: 210.h,
                  width: double.infinity.w,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20.h),
                      color: Colors.white),
                  child: ClipRRect(
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(12.h),
                        topRight: Radius.circular(12.h)),
                    child: Image(
                      image: NetworkImage(widget.creation.creationThumbnail),
                      fit: BoxFit.fill,
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(left: 10.w, top: 10.h),
                  child: Container(
                    alignment: Alignment.center,
                    height: 33.h,
                    width: 32.w,
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.white,
                    ),
                    child: IconButton(
                      splashRadius: 10.h,
                      onPressed: () {},
                      icon: const Center(
                        child: Icon(
                          Icons.save_as,
                          size: 14,
                        ),
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(left: 55.w, top: 10.h),
                  child: Container(
                    alignment: Alignment.center,
                    height: 33.h,
                    width: 32.w,
                    decoration: const BoxDecoration(
                        shape: BoxShape.circle, color: Colors.white),
                    child: Center(
                      child: IconButton(
                        onPressed: () {
                          share();
                        },
                        icon: const Icon(
                          Icons.share,
                          size: 14,
                        ),
                      ),
                    ),
                  ),
                )
              ],
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 10.h),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 11.h),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: EdgeInsets.only(right: 0.w),
                      child: Text(
                        widget.creation.creationTitle,
                        style: TextStyle(
                            fontWeight: FontWeight.w700,
                            fontSize: 15.sp,
                            fontFamily: 'Gilroy',
                            color: const Color.fromARGB(255, 0, 0, 0)),
                      ),
                    ),
                    SizedBox(height: 11.h),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        const Text("Listed Price : "),
                        Container(
                          padding: EdgeInsets.symmetric(horizontal: 10.w),
                          height: 30.h,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(12.h),
                              color: const Color(0XFFE5ECFF)),
                          child: Center(
                            child: Text(
                              "₹ ${widget.creation.creationPrice.toString()}",
                              style: TextStyle(
                                  color: const Color(0XFF23408F),
                                  fontFamily: 'Gilroy',
                                  fontSize: 17.sp,
                                  fontWeight: FontWeight.w700),
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 10.h,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        const Text("Status : "),
                        Container(
                          padding: EdgeInsets.symmetric(horizontal: 10.w),
                          height: 30.h,
                          //width: 74.w,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(12.h),
                              color: const Color(0XFFE5ECFF)),
                          child: Center(
                            child: Text(
                              "UnderReview",
                              style: AppText.subHeddingStyle,
                            ),
                          ),
                        ),
                      ],
                    )
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
