import 'dart:developer';

import 'package:fluttertoast/fluttertoast.dart';
import 'package:projecthub/constant/app_data.dart';
import 'package:projecthub/model/order_details_model.dart';
import 'package:projecthub/model/payment_info_model.dart';
import 'package:projecthub/model/user_info_model.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';

class PaymetController {
  final Razorpay _razorpay = Razorpay();

  void makePayment(
    UserModel user,
    OrderDetails order,
    onPaymentSuccessful,
    onPaymentFailed,
  ) {
    var options = {
      'key': AppData.razorpayKey,
      'amount': order.total * 100,
      'name': AppData.name,
      'description': 'Paymet for creations',
      'prefill': <String, dynamic>{},
      'notes': {
        'gstAmount': order.totalGst,
        'platformFee': order.totalPlatformFees
      },
    };
    // Conditionally add contact if it's not null
    if (user.userContact != null) {
      (options['prefill'] as Map<String, dynamic>)['contact'] =
          user.userContact!;
    }

    // Conditionally add email if it's not null
    if (user.userEmail != null) {
      (options['prefill'] as Map<String, dynamic>)['email'] = user.userEmail!;
    }
    _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS,
        (PaymentSuccessResponse response) {
      _handlePaymentSuccess(response, onPaymentSuccessful, order);
    });
    _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR,
        (PaymentFailureResponse response) {
      _handlePaymentError(response, onPaymentFailed);
    });
    _razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, _handleExternalWallet);

    try {
      _razorpay.open(options);
    } catch (e) {
      rethrow;
    }
  }

  void _handlePaymentSuccess(
    PaymentSuccessResponse response,
    onPaymentSuccessful,
    OrderDetails order,
  ) {
    Fluttertoast.showToast(msg: "Paymet successful");
    log("paymet successful");
    PaymentData paymentData = PaymentData(
        razorpayPaymentId: response.paymentId!,
        paymentAmount: order.total,
        gstAmount: order.totalGst,
        platformFee: order.totalPlatformFees,
        paymentMethod: "upi",
        currency: "inr",
        status: "completed",
        paymentGatewayFee: 20);
    onPaymentSuccessful(order, paymentData);
    _razorpay.clear(); // Removes all listeners
  }

  void _handlePaymentError(PaymentFailureResponse response, onPaymentFailed) {
    Fluttertoast.showToast(msg: "Paymet failed");

    log("paymet failed");
    onPaymentFailed();
    _razorpay.clear(); // Removes all listeners
  }

  void _handleExternalWallet(ExternalWalletResponse response) {
    // Do something when an external wallet was selected
  }
}
