class Seller {
  String? sellerEmail;
  int? sellerId;
  String? sellerName;
  String? sellerProfilePhoto;

  Seller(
      {this.sellerEmail,
      this.sellerId,
      this.sellerName,
      this.sellerProfilePhoto});

  Seller.fromJson(Map<String, dynamic> json) {
    sellerEmail = json['seller_email'];
    sellerId = json['seller_id'];
    sellerName = json['seller_name'];
    sellerProfilePhoto = json['seller_profile_photo'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['seller_email'] = sellerEmail;
    data['seller_id'] = sellerId;
    data['seller_name'] = sellerName;
    data['seller_profile_photo'] = sellerProfilePhoto;
    return data;
  }
}
