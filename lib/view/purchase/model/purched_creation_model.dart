class PurchedCreationModel {
  final String creationDescription;
  final String creationFile;
  final int creationId;
  final String creationThumbnail;
  final String creationTitle;
  final String orderDate;
  final int orderId;
  final String purchasedPrice;

  PurchedCreationModel({
    required this.creationDescription,
    required this.creationFile,
    required this.creationId,
    required this.creationThumbnail,
    required this.creationTitle,
    required this.orderDate,
    required this.orderId,
    required this.purchasedPrice,
  });

  factory PurchedCreationModel.fromJson(Map<String, dynamic> json) {
    return PurchedCreationModel(
      creationDescription: json['creation_description'],
      creationFile: json['creation_file'],
      creationId: json['creation_id'],
      creationThumbnail: json['creation_thumbnail'],
      creationTitle: json['creation_title'],
      orderDate: json['order_date'],
      orderId: json['order_id'],
      purchasedPrice: json['purchased_price'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'creation_description': creationDescription,
      'creation_file': creationFile,
      'creation_id': creationId,
      'creation_thumbnail': creationThumbnail,
      'creation_title': creationTitle,
      'order_date': orderDate,
      'order_id': orderId,
      'purchased_price': purchasedPrice,
    };
  }
}
