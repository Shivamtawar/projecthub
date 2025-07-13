import 'package:intl/intl.dart';

class TransactionModel {
  final int paymentId;
  final String razorpayPaymentId;
  final double paymentAmount;
  final double? gstAmount;
  final double? platformFee;
  final String? paymentMethod;
  final String currency;
  final DateTime transactionDate;
  final String status;
  final double? paymentGatewayFee;
  final int? orderId;

  TransactionModel({
    required this.paymentId,
    required this.razorpayPaymentId,
    required this.paymentAmount,
    this.gstAmount,
    this.platformFee,
    this.paymentMethod,
    this.currency = 'INR',
    required this.transactionDate,
    this.status = 'pending',
    this.paymentGatewayFee,
    this.orderId,
  });

  factory TransactionModel.fromJson(Map<String, dynamic> json) {
    return TransactionModel(
      paymentId: json['payment_id'],
      razorpayPaymentId: json['razorpay_payment_id'],
      paymentAmount: double.parse(json['payment_amount'].toString()),
      gstAmount: json['gst_amount'] != null
          ? double.parse(json['gst_amount'].toString())
          : null,
      platformFee: json['platform_fee'] != null
          ? double.parse(json['platform_fee'].toString())
          : null,
      paymentMethod: json['payment_method'],
      currency: json['currency'] ?? 'INR',
      transactionDate: _parseDateString(json['transaction_date']),
      status: json['status'] ?? 'pending',
      paymentGatewayFee: json['payment_gateway_fee'] != null
          ? double.parse(json['payment_gateway_fee'].toString())
          : null,
      orderId: json['order_id'],
    );
  }

  static DateTime _parseDateString(String dateString) {
    // Parse the input GMT date
    return DateFormat("EEE, dd MMM yyyy HH:mm:ss 'GMT'", 'en_US')
        .parseUtc(dateString) // parse as UTC
        .toLocal();
  }
}
