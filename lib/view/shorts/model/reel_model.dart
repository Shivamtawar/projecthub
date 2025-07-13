import 'dart:convert';

class ReelModel {
  final int categoryId;
  final String createtime;
  final String creationDescription;
  final String creationFile;
  final int creationId;
  final String? creationOtherImages;
  final String creationPrice;
  final String creationThumbnail;
  final String creationTitle;
  bool isLikedByUser;
  final List<String> keyword;
  final String lastUpdated;
  int likeCount;
  int shareCount;
  final String status;
  int totalCopySell;
  final int userId;
  final String? youtubeLink;

  ReelModel({
    required this.categoryId,
    required this.createtime,
    required this.creationDescription,
    required this.creationFile,
    required this.creationId,
    required this.creationOtherImages,
    required this.creationPrice,
    required this.creationThumbnail,
    required this.creationTitle,
    required this.isLikedByUser,
    required this.keyword,
    required this.lastUpdated,
    required this.likeCount,
    required this.shareCount,
    required this.status,
    required this.totalCopySell,
    required this.userId,
    required this.youtubeLink,
  });

  factory ReelModel.fromJson(Map<String, dynamic> json) {
    return ReelModel(
      categoryId: json['category_id'],
      createtime: json['createtime'],
      creationDescription: json['creation_description'],
      creationFile: json['creation_file'],
      creationId: json['creation_id'],
      creationOtherImages: json['creation_other_images'],
      creationPrice: json['creation_price'],
      creationThumbnail: json['creation_thumbnail'],
      creationTitle: json['creation_title'],
      isLikedByUser: json['is_liked_by_user'] == 1,
      keyword: List<String>.from(jsonDecode(json['keyword'] ?? '[]')),
      lastUpdated: json['last_updated'],
      likeCount: json['like_count'],
      shareCount: json['share_count'],
      status: json['status'],
      totalCopySell: json['total_copy_sell'],
      userId: json['user_id'],
      youtubeLink: json['youtube_link'],
    );
  }
}
