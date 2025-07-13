import 'dart:io';

import '../../../config/api_config.dart';

class ListedCreation {
  final int? creationId;
  final String creationTitle;
  final String creationDescription;
  final double creationPrice;
  final String creationThumbnail;
  final String creationFile;
  final int categoryId;
  final String? keyword;
  final double? rating;
  final String? creationOtherImages;
  final int totalCopySell;
  final int? userId;
  final String status;

  ListedCreation({
    this.creationId,
    required this.creationTitle,
    required this.creationDescription,
    required this.creationPrice,
    required this.creationThumbnail,
    required this.creationFile,
    required this.categoryId,
    this.rating,
    this.keyword,
    this.creationOtherImages,
    this.totalCopySell = 0,
    this.userId,
    this.status = 'underreview',
  });

  factory ListedCreation.fromJson(Map<String, dynamic> json) {
    return ListedCreation(
      creationId: json['creation_id'],
      creationTitle: json['creation_title'],
      creationDescription: json['creation_description'],
      creationPrice: double.parse(json['creation_price']),
      creationThumbnail: "${ApiConfig.baseURL}/${json['creation_thumbnail']}",
      creationFile: json['creation_file'],
      categoryId: json['category_id'],
      keyword: json['keyword'],
      creationOtherImages: json['creation_other_images'],
      totalCopySell: json['total_copy_sell'] ?? 0,
      userId: json['user_id'],
      status: json['status'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'creation_id': creationId,
      'creation_title': creationTitle,
      'creation_description': creationDescription,
      'creation_price': creationPrice,
      'creation_thumbnail': creationThumbnail,
      'creation_file': creationFile,
      'category_id': categoryId,
      'keyword': keyword,
      'creation_other_images': creationOtherImages,
      'total_copy_sell': totalCopySell,
      'user_id': userId,
      'status': status,
    };
  }
}

class NewCreationModel {
  final String creationTitle;
  final String? creationDescription;
  final double creationPrice;
  final File creationThumbnail; // Changed to File
  final File creationFile; // Changed to File
  final int categoryId;
  final List<String>? keyword;
  final List<String>? otherImages;
  final int userId;
  double uploadProgress = 0;
  final String? youtubelink;

  NewCreationModel(
      {required this.creationTitle,
      this.creationDescription,
      required this.creationPrice,
      required this.creationThumbnail,
      required this.creationFile,
      required this.categoryId,
      this.keyword,
      this.otherImages,
      required this.userId,
      required this.youtubelink});

  // Factory constructor to create an instance from a JSON object
  factory NewCreationModel.fromJson(Map<String, dynamic> json) {
    return NewCreationModel(
        creationTitle: json['creation_title'],
        creationDescription: json['creation_description'],
        creationPrice: json['creation_price'],
        creationThumbnail:
            json['creation_thumbnail'], // Assuming the path is in JSON
        creationFile: json['creation_file'], // Assuming the path is in JSON
        categoryId: json['category_id'],
        keyword: List<String>.from(json['keyword'] ?? []),
        otherImages: List<String>.from(json['other_images'] ?? []),
        userId: json['user_id'],
        youtubelink: json["youtube_link"]);
  }

  // Method to convert the instance to a JSON object
  Map<String, dynamic> toJson() {
    return {
      'creation_title': creationTitle,
      'creation_description': creationDescription,
      'creation_price': creationPrice,
      'creation_thumbnail':
          creationThumbnail.path, // Assuming you store the file path
      'creation_file': creationFile.path, // Assuming you store the file path
      'category_id': categoryId,
      'keyword': keyword,
      'other_images': otherImages,
      'user_id': userId,
      'youtube_link': youtubelink
    };
  }
}
