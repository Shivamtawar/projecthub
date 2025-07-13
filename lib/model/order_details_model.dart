import 'package:projecthub/view/cart/model/incard_creation_model.dart';

class OrderDetails {
  List<InCardCreationInfo> creations; // List to hold Creation2 objects
  double subTotal; // Subtotal for the order
  double totalGst; // Total GST for the order
  double totalPlatformFees; // Total platform fees for the order
  double
      total; // Total amount for the order (after applying GST and platform fees)

  // Constructor to initialize the properties
  OrderDetails({
    required this.creations,
    required this.subTotal,
    required this.totalGst,
    required this.totalPlatformFees,
    required this.total,
  });
  // Convert OrderDetails to JSON
  Map<String, dynamic> toJson() {
    return {
      'creations': creations.map((creation) => creation.toJson()).toList(),
      'subTotal': subTotal,
      'totalGst': totalGst,
      'totalPlatformFees': totalPlatformFees,
      'total': total,
    };
  }

  // Create an OrderDetails instance from JSON
  factory OrderDetails.fromJson(Map<String, dynamic> json) {
    return OrderDetails(
      creations: json['creations'],
      subTotal: json['subTotal'],
      totalGst: json['totalGst'],
      totalPlatformFees: json['totalPlatformFees'],
      total: json['total'],
    );
  }
}
