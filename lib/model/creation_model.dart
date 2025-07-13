import 'package:projecthub/model/seller_model.dart';

class Creation {
  final int creationId;
  final String? creationTitle;
  final String? creationDescription;
  final double? creationPrice;
  final double? gstTaxPercentage;
  final double? platformFee;
  final String? creationThumbnail;
  final String? creationFile;
  final String? fileFormat;
  final String? fileSize;
  //final int categoryId;
  final String? creationOtherImages;
  final String? createtime;
  final String? youtubeLink;
  final String? lastUpdated;
  final double? avgRating;
  final int totalReviews;
  final int totalLikes;
  final int totalCopySold;
  final bool isLikedByUser;
  final Seller seller;

  Creation({
    required this.creationId,
    this.creationTitle,
    this.creationDescription,
    this.creationPrice,
    this.gstTaxPercentage,
    this.platformFee,
    this.creationThumbnail,
    this.creationFile,
    this.fileFormat,
    this.fileSize,
    //required this.categoryId,
    this.creationOtherImages,
    this.createtime,
    this.youtubeLink,
    this.lastUpdated,
    this.avgRating,
    required this.totalReviews,
    required this.totalLikes,
    required this.totalCopySold,
    required this.isLikedByUser,
    required this.seller,
  });

  factory Creation.fromJson(Map<String, dynamic> json) {
    return Creation(
      creationId: json['creation_id'],
      creationTitle: json['creation_title'],
      creationDescription: json['creation_description'],
      creationPrice: double.parse(json['creation_price'].toString()),
      gstTaxPercentage: json['gst_percentage'] != null
          ? double.parse(json['gst_percentage'].toString())
          : null,
      platformFee: json['platform_fee_percentage'] != null
          ? double.parse(json['platform_fee_percentage'].toString())
          : null,
      creationThumbnail: json['creation_thumbnail'],
      creationFile: json['creation_file'],
      fileFormat: json['file_format'],
      fileSize: json['file_size'],
      //categoryId: json['category_id'],
      creationOtherImages: json['creation_other_images'],
      createtime: json['createtime'],
      youtubeLink: json['youtube_link'],
      lastUpdated: json['last_updated'],
      avgRating: json['avg_rating'] != null
          ? double.parse(json['avg_rating'].toString())
          : null,
      totalReviews: json['total_reviews'] ?? 0,
      totalLikes: json['total_likes'] ?? 0,
      totalCopySold: json['total_copy_sold'] ?? 0,
      isLikedByUser: json['is_liked_by_user'] ?? false,
      seller: Seller.fromJson(json['seller']),
    );
  }
  Map<String, dynamic> toJson() {
    return {
      'creation_id': creationId,
      'creation_title': creationTitle,
      'creation_description': creationDescription,
      'creation_price': creationPrice,
      'gst_percentage': gstTaxPercentage,
      'platform_fee_percentage': platformFee,
      'creation_thumbnail': creationThumbnail,
      'creation_file': creationFile,
      'file_format': fileFormat,
      'file_size': fileSize,
      //'category_id': categoryId,
      'creation_other_images': creationOtherImages,
      'createtime': createtime,
      'youtube_link': youtubeLink,
      'last_updated': lastUpdated,
      'avg_rating': avgRating,
      'total_reviews': totalReviews,
      'total_likes': totalLikes,
      'total_copy_sold': totalCopySold,
      'is_liked_by_user': isLikedByUser,
      'seller': seller.toJson(),
    };
  }
}
