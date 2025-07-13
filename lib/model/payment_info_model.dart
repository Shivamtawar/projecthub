class PaymentData {
  final String razorpayPaymentId;
  final double paymentAmount;
  final double gstAmount;
  final double platformFee;
  final String paymentMethod;
  final String currency;
  final String status;
  final double paymentGatewayFee;

  PaymentData({
    required this.razorpayPaymentId,
    required this.paymentAmount,
    required this.gstAmount,
    required this.platformFee,
    required this.paymentMethod,
    required this.currency,
    required this.status,
    required this.paymentGatewayFee,
  });

  // Factory method to create a PaymentData instance from JSON
  factory PaymentData.fromJson(Map<String, dynamic> json) {
    return PaymentData(
      razorpayPaymentId: json['razorpay_payment_id'],
      paymentAmount: json['payment_amount'],
      gstAmount: json['gst_amount'],
      platformFee: json['platform_fee'],
      paymentMethod: json['payment_method'],
      currency: json['currency'],
      status: json['status'],
      paymentGatewayFee: json['payment_gateway_fee'],
    );
  }

  // Method to convert PaymentData instance to JSON
  Map<String, dynamic> toJson() {
    return {
      'razorpay_payment_id': razorpayPaymentId,
      'payment_amount': paymentAmount,
      'gst_amount': gstAmount,
      'platform_fee': platformFee,
      'payment_method': paymentMethod,
      'currency': currency,
      'status': status,
      'payment_gateway_fee': paymentGatewayFee,
    };
  }
}
