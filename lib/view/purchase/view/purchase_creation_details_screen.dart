import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:projecthub/view/profile/provider/user_provider.dart';
import 'package:projecthub/view/purchase/model/purched_creation_model.dart';
import 'package:provider/provider.dart';
import 'package:share_plus/share_plus.dart';
import '../../../config/api_config.dart';
import '../../../services/file_service.dart';
import '../provider/purchased_creation_provider.dart';

class PurchaseDetailsScreen extends StatefulWidget {
  final PurchedCreationModel creation;
  const PurchaseDetailsScreen({super.key, required this.creation});

  @override
  State<PurchaseDetailsScreen> createState() => _PurchaseDetailsScreenState();
}

class _PurchaseDetailsScreenState extends State<PurchaseDetailsScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      // Fetch the purchase details when the widget is built

      final userProvider =
          Provider.of<UserInfoProvider>(Get.context!, listen: false);
      final purchaseCreationProvider =
          Provider.of<PurchedCreationProvider>(Get.context!, listen: false);
      await purchaseCreationProvider.fetchPurchedCreationDetails(
          userProvider.user!.userId, widget.creation.creationId);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: const Text('Purchase Details'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Get.back(),
        ),
        actions: [
          Tooltip(
            message: 'Share',
            child: IconButton(
              icon: const Icon(Icons.share),
              onPressed: () {
                // Implement share functionality
                Share.share(
                    'Check out this creation: ${widget.creation.creationTitle}');
              },
            ),
          ),
          Tooltip(
            message: 'Report issue',
            child: IconButton(
              icon: const Icon(Icons.report_gmailerrorred),
              onPressed: () {
                // Implement download functionality
                // FilesDownloadController().downloadZipFile(creation);
              },
            ),
          ),
        ],
      ),
      body: Consumer<PurchedCreationProvider>(
          builder: (context, provider, child) {
        if (provider.isDetailsLoading) {
          return const Center(child: CircularProgressIndicator());
        }
        if (provider.detailScreenErrorMessage.isNotEmpty) {
          return Center(child: Text(provider.detailScreenErrorMessage));
        }
        if (provider.purchedCreationDetails == null) {
          return const Center(child: Text('No purchase details available'));
        }
        final creation = provider.purchedCreationDetails!.creation;
        return SingleChildScrollView(
          padding: EdgeInsets.all(16.r),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Product Image Gallery
              Container(
                alignment: Alignment.center,
                height: 250.h,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12.r),
                  color: Colors.white,
                  boxShadow: const [
                    BoxShadow(
                      color: Colors.black12,
                      blurRadius: 8,
                      offset: Offset(0, 4),
                    )
                  ],
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(12.r),
                  child: Image.network(
                    ApiConfig.getFileUrl(creation.creationThumbnail! ?? ''),
                    fit: BoxFit.cover,
                    errorBuilder: (_, __, ___) => Center(
                      child: Icon(Icons.broken_image, size: 60.r),
                    ),
                  ),
                ),
              ),
              SizedBox(height: 20.h),

              // Product Title and Price
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      creation.creationTitle ?? 'Untitled Creation',
                      style: TextStyle(
                        fontSize: 22.sp,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: 12.w,
                      vertical: 6.h,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.green[50],
                      borderRadius: BorderRadius.circular(20.r),
                      border: Border.all(color: Colors.green[100]!),
                    ),
                    child: Text(
                      (provider.purchedCreationDetails!.purchasedPrice),
                      style: TextStyle(
                        fontSize: 18.sp,
                        fontWeight: FontWeight.bold,
                        color: Colors.green[800],
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 8.h),

              // Rating and Reviews
              if (creation.avgRating != null)
                Row(
                  children: [
                    RatingWidget(
                      rating: creation.avgRating.toString() ?? "0",
                      size: 20.r,
                    ),
                    SizedBox(width: 8.w),
                    Text(
                      '${creation.avgRating} (${creation.totalReviews ?? 0} reviews)',
                      style: TextStyle(
                        fontSize: 14.sp,
                        color: Colors.grey[600],
                      ),
                    ),
                  ],
                ),
              SizedBox(height: 20.h),

              // Purchase Information Card
              Card(
                elevation: 2,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12.r),
                ),
                child: Padding(
                  padding: EdgeInsets.all(16.r),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Purchase Information',
                        style: TextStyle(
                          fontSize: 18.sp,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 12.h),
                      _buildDetailRow(
                        icon: Icons.receipt,
                        label: 'Order ID',
                        value: '#${provider.purchedCreationDetails!.orderId}',
                      ),
                      _buildDetailRow(
                        icon: Icons.calendar_today,
                        label: 'Purchase Date',
                        value:
                            provider.purchedCreationDetails!.orderDate != null
                                ? provider.purchedCreationDetails!.orderDate!
                                : 'Not specified',
                      ),
                      _buildDetailRow(
                        icon: Icons.payment,
                        label: 'Payment Method',
                        value:
                            'Credit Card', // Replace with actual payment method
                      ),
                      _buildDetailRow(
                        icon: Icons.confirmation_number,
                        label: 'License Type',
                        value:
                            'Standard License', // Replace with actual license
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 20.h),

              // Product Description
              Card(
                elevation: 2,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12.r),
                ),
                child: Padding(
                  padding: EdgeInsets.all(16.r),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Description',
                        style: TextStyle(
                          fontSize: 18.sp,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(
                        height: 12.h,
                        width: double.infinity,
                      ),
                      Text(
                        (creation.creationDescription != null &&
                                creation.creationDescription != "")
                            ? creation.creationDescription!
                            : 'No description available',
                        style: TextStyle(
                          fontSize: 15.sp,
                          height: 1.5,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 20.h),

              // Product Details
              Card(
                elevation: 2,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12.r),
                ),
                child: Padding(
                  padding: EdgeInsets.all(16.r),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Product Details',
                        style: TextStyle(
                          fontSize: 18.sp,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 12.h),
                      _buildDetailItem('Category', "1 static"
                          // creation.categoryId?.toString() ?? 'Not specified',
                          ),
                      _buildDetailItem(
                        'File Format',
                        creation.fileFormat ??
                            "Not define", // Replace with actual file format
                      ),
                      _buildDetailItem(
                        'File Size',
                        creation.fileSize ??
                            "Not define", // Replace with actual file size
                      ),
                      // _buildDetailItem(
                      //   'Last Updated',
                      //   dateFormat.format(DateTime.parse(creation.createtime!)),
                      // ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 20.h),

              // Seller Information
              Card(
                elevation: 2,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12.r),
                ),
                child: Padding(
                  padding: EdgeInsets.all(16.r),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Seller Information',
                        style: TextStyle(
                          fontSize: 18.sp,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 12.h),
                      ListTile(
                        contentPadding: EdgeInsets.zero,
                        leading: CircleAvatar(
                          radius: 25.r,
                          backgroundImage:
                              creation.seller!.sellerProfilePhoto != null
                                  ? NetworkImage(ApiConfig.baseURL +
                                      creation.seller!.sellerProfilePhoto!)
                                  : null,
                          child: creation.seller!.sellerProfilePhoto == null
                              ? Icon(Icons.person, size: 14.r)
                              : null,
                        ),
                        title: Text(
                          creation.seller.sellerName ?? 'Unknown Seller',
                          style: TextStyle(
                            fontSize: 16.sp,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        // subtitle: Text(
                        //   'Joined ${dateFormat.format(DateTime.parse(creation.seller? ?? DateTime.now().toString()))}',
                        //   style: TextStyle(fontSize: 13.sp),
                        // ),
                      ),
                      // SizedBox(height: 8.h),
                      // Row(
                      //   children: [
                      //     _buildSellerStat(
                      //         'Products', '42'), // Replace with actual
                      //     SizedBox(width: 16.w),
                      //     _buildSellerStat(
                      //         'Rating', '4.8'), // Replace with actual
                      //     SizedBox(width: 16.w),
                      //     _buildSellerStat(
                      //         'Sales', '128'), // Replace with actual
                      //   ],
                      // ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 30.h),

              // Download Button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    padding: EdgeInsets.symmetric(vertical: 16.h),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12.r),
                    ),
                  ),
                  onPressed: () {
                    FileServices.downloadZipFile(creation);
                  },
                  child: Text(
                    'Download Files',
                    style: TextStyle(fontSize: 16.sp),
                  ),
                ),
              ),
            ],
          ),
        );
      }),
    );
  }

  Widget _buildDetailRow({
    required IconData icon,
    required String label,
    required String value,
  }) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 8.h),
      child: Row(
        children: [
          Icon(icon, size: 20.r, color: Colors.grey[600]),
          SizedBox(width: 12.w),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: TextStyle(
                  fontSize: 13.sp,
                  color: Colors.grey[600],
                ),
              ),
              SizedBox(height: 2.h),
              Text(
                value,
                style: TextStyle(
                  fontSize: 15.sp,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildDetailItem(String label, String value) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 8.h),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 100.w,
            child: Text(
              label,
              style: TextStyle(
                fontSize: 14.sp,
                color: Colors.grey[600],
              ),
            ),
          ),
          SizedBox(width: 12.w),
          Expanded(
            child: Text(
              value,
              style: TextStyle(
                fontSize: 14.sp,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSellerStat(String label, String value) {
    return Column(
      children: [
        Text(
          value,
          style: TextStyle(
            fontSize: 16.sp,
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(height: 2.h),
        Text(
          label,
          style: TextStyle(
            fontSize: 12.sp,
            color: Colors.grey[600],
          ),
        ),
      ],
    );
  }
}

class RatingWidget extends StatelessWidget {
  final String rating;
  final double size;

  const RatingWidget({
    super.key,
    required this.rating,
    this.size = 16,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(5, (index) {
        return Icon(
          Icons.star,
          color: Colors.amber,
          size: size.r,
        );
      }),
    );
  }
}
