import 'package:geolocator/geolocator.dart';

class UserModel {
  int userId;
  String? userName;
  String? userPassword;
  String? userDescription;
  String? userContact;
  String? userEmail;
  String? profilePhoto;
  String? role;
  String? loginType;
  double? walletMoney;
  int? boughthCreationNumber;
  int? listedCreationNumber;
  Position? userLocation; // Added userLocation field

  // Constructor
  UserModel({
    required this.userId,
    required this.userName,
    required this.userPassword,
    this.userDescription,
    this.userContact,
    this.userEmail,
    this.profilePhoto,
    required this.role,
    required this.loginType,
    required this.walletMoney,
    required this.boughthCreationNumber,
    required this.listedCreationNumber,
  });

  // toJson Method
  Map<String, dynamic> toJson() {
    return {
      'user_id': userId,
      'user_name': userName,
      'user_password': userPassword,
      'user_description': userDescription,
      'user_contact': userContact,
      'user_email': userEmail,
      'profile_photo': profilePhoto,
      'loginType': loginType,
      'role': role,
      'wallet_money': walletMoney,
      'boughth_creation_number': boughthCreationNumber,
      'listed_creation_number': listedCreationNumber,
    };
  }

  // fromJson Method
  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      userId: json['user_id'],
      userName: json['user_name'],
      userPassword: "json['user_password']",
      userDescription: json['user_description'],
      userContact: json['user_contact'],
      userEmail: json['user_email'],
      profilePhoto: json['profile_photo'],
      role: json['role'],
      loginType: json['loginType'],
      walletMoney: (json['wallet_money'] is String)
          ? double.parse(json['wallet_money'])
          : json['wallet_money'],
      boughthCreationNumber: json['bought_creation_number'],
      listedCreationNumber: json['listed_creation_number'],
    );
  }
}

class NewUserInfo {
  String userName;
  String userPassword;
  String userContact;
  //String userEmail;
  String? profilePhoto;
  String role;

  // Constructor
  NewUserInfo({
    required this.userName,
    required this.userPassword,
    required this.userContact,
    //required this.userEmail,
    required this.role,
  });

  // toJson Method
  Map<String, dynamic> toJson() {
    return {
      'user_name': userName,
      'user_password': userPassword,
      'user_contact': userContact,
      //'user_email': userEmail,
      'profile_photo': profilePhoto,
      'role': role,
    };
  }

  // fromJson Method
  factory NewUserInfo.fromJson(Map<String, dynamic> json) {
    return NewUserInfo(
      userName: json['user_name'],
      userPassword: json['user_password'],
      userContact: json['user_contact'],
      //userEmail: json['user_email'],
      role: json['role'],
    );
  }
}
