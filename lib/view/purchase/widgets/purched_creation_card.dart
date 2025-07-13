import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../config/api_config.dart';
import '../model/purched_creation_model.dart';
import '../view/purchase_creation_details_screen.dart';

class PurchedCreationCard extends StatefulWidget {
  final PurchedCreationModel purchedCreationModel;
  const PurchedCreationCard({super.key, required this.purchedCreationModel});

  @override
  State<PurchedCreationCard> createState() => _PurchedCreationCardState();
}

class _PurchedCreationCardState extends State<PurchedCreationCard> {
  bool _isHovering = false;

  @override
  Widget build(BuildContext context) {
    final creation = widget.purchedCreationModel;
    final purchaseDate = creation.orderDate.toString();
    final price = creation.purchasedPrice;

    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      transform: Matrix4.identity()..scale(_isHovering ? 1.01 : 1.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12.r),
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(_isHovering ? 0.3 : 0.2),
            blurRadius: _isHovering ? 12 : 8,
            offset: Offset(0, _isHovering ? 4 : 2),
          ),
        ],
      ),
      child: GestureDetector(
        onTap: () {
          Get.to(() =>
              PurchaseDetailsScreen(creation: widget.purchedCreationModel));
        },
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Image with overlay
            Stack(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(12.r),
                    topRight: Radius.circular(12.r),
                  ),
                  child: Container(
                    height: 180.h,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: Colors.grey[200],
                    ),
                    child: creation.creationThumbnail != null
                        ? Image.network(
                            ApiConfig.getFileUrl(creation.creationThumbnail!),
                            fit: BoxFit.cover,
                            loadingBuilder: (context, child, loadingProgress) {
                              if (loadingProgress == null) return child;
                              return Center(
                                child: CircularProgressIndicator(
                                  value: loadingProgress.expectedTotalBytes !=
                                          null
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
                          )
                        : Icon(
                            Icons.image_not_supported,
                            size: 50.r,
                            color: Colors.grey,
                          ),
                  ),
                ),
                Positioned(
                  top: 10.r,
                  right: 10.r,
                  child: Container(
                    padding: EdgeInsets.all(6.r),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(8.r),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          blurRadius: 4,
                        ),
                      ],
                    ),
                    child: Text(
                      '₹${double.parse(price).toStringAsFixed(2)}',
                      style: TextStyle(
                        fontSize: 14.sp,
                        fontWeight: FontWeight.bold,
                        color: Colors.green[700],
                      ),
                    ),
                  ),
                ),
              ],
            ),

            // Content section
            Padding(
              padding: EdgeInsets.all(12.r),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          creation.creationTitle ?? 'Untitled Creation',
                          style: TextStyle(
                            fontSize: 16.sp,
                            fontWeight: FontWeight.w600,
                            color: Colors.black87,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      IconButton(
                        onPressed: () {
                          //  FilesDownloadController().downloadZipFile(creation);
                        },
                        icon: Icon(
                          Icons.download_rounded,
                          size: 22.r,
                          color: Theme.of(context).primaryColor,
                        ),
                        tooltip: 'Download',
                      ),
                    ],
                  ),

                  SizedBox(height: 8.h),

                  // Purchase info row
                  Row(
                    children: [
                      Icon(
                        Icons.calendar_today,
                        size: 16.r,
                        color: Colors.grey[600],
                      ),
                      SizedBox(width: 6.w),
                      Text(
                        'Purchased: $purchaseDate',
                        style: TextStyle(
                          fontSize: 13.sp,
                          color: Colors.grey[600],
                        ),
                      ),
                    ],
                  ),

                  SizedBox(height: 6.h),

                  Row(
                    children: [
                      Text(
                        'Order ID: ',
                        style: TextStyle(
                          fontSize: 13.sp,
                          color: Colors.grey[600],
                        ),
                      ),
                      SizedBox(width: 4.w),
                      Text(
                        '#${creation.orderId}',
                        style: TextStyle(
                          fontSize: 13.sp,
                          color: Colors.grey[600],
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
