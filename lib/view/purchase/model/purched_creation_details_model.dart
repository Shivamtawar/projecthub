import 'package:projecthub/model/creation_model.dart';

class PurchaseDetails {
  final String purchasedPrice;
  final int orderId;
  final String orderDate;
  final String gstAmount;
  final String platformFee;
  final Creation creation;

  PurchaseDetails({
    required this.purchasedPrice,
    required this.orderId,
    required this.orderDate,
    required this.gstAmount,
    required this.platformFee,
    required this.creation,
  });

  factory PurchaseDetails.fromJson(Map<String, dynamic> json) {
    return PurchaseDetails(
      purchasedPrice: json['purchased_price'],
      orderId: json['order_id'],
      orderDate: json['order_date'],
      gstAmount: json['gst_amount'],
      platformFee: json['platform_fee'],
      creation: Creation.fromJson(json['creation']),
    );
  }
}
