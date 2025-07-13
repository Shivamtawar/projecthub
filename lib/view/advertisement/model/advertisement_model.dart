import 'dart:convert';

class AdvertisementModel {
  final int adId;
  final int? isCreation;
  final String? adTitle;
  final String? adDescription;
  final String? adWebsite;
  final String? adImage;
  final String? adStartDate;
  final String? adEndDate;
  final int adDuration;
  final List<String> targetLocations;
  final List<String> targetCategories;
  final int? isActive;
  final String? paymentId;
  final String? createdDate;
  final String? updatedDate;
  final int? adOwnerId;
  final List<String> platformTarget;
  final int? priorityLevel;
  final String? adType;
  final int? targetImpressionCount;

  AdvertisementModel({
    required this.adId,
    this.isCreation,
    this.adTitle,
    this.adDescription,
    this.adWebsite,
    this.adImage,
    required this.adStartDate,
    required this.adEndDate,
    required this.adDuration,
    required this.targetLocations,
    required this.targetCategories,
    this.isActive,
    this.paymentId,
    this.createdDate,
    this.updatedDate,
    this.adOwnerId,
    required this.platformTarget,
    this.priorityLevel,
    this.adType,
    this.targetImpressionCount,
  });

  factory AdvertisementModel.fromJson(Map<String, dynamic> json) {
    return AdvertisementModel(
      adId: json['ad_id'],
      isCreation: json['is_creation'],
      adTitle: json['ad_title'],
      adDescription: json['ad_description'],
      adWebsite: json['ad_website'],
      adImage: json['ad_image'],
      adStartDate: json['ad_start_date'],
      adEndDate: json['ad_end_date'],
      adDuration: json['ad_duration'],
      targetLocations:
          List<String>.from(jsonDecode(json['target_locations'] ?? '[]')),
      targetCategories:
          List<String>.from(jsonDecode(json['target_categories'] ?? '[]')),
      isActive: json['is_active'],
      paymentId: json['payment_id'],
      createdDate: json['created_date'],
      updatedDate: json['updated_date'],
      adOwnerId: json['ad_owner_id'],
      platformTarget:
          List<String>.from(jsonDecode(json['platform_target'] ?? '[]')),
      priorityLevel: json['priority_level'],
      adType: json['ad_type'],
      targetImpressionCount: json['target_impression_count'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'ad_id': adId,
      'is_creation': isCreation,
      'ad_title': adTitle,
      'ad_description': adDescription,
      'ad_website': adWebsite,
      'ad_image': adImage,
      'ad_start_date': adStartDate,
      'ad_end_date': adEndDate,
      'ad_duration': adDuration,
      'target_locations': targetLocations,
      'target_categories': targetCategories,
      'is_active': isActive,
      'payment_id': paymentId,
      'created_date': createdDate,
      'updated_date': updatedDate,
      'ad_owner_id': adOwnerId,
      'platform_target': platformTarget,
      'priority_level': priorityLevel,
      'ad_type': adType,
      'target_impression_count': targetImpressionCount,
    };
  }
}
