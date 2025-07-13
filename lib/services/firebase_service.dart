import 'dart:developer';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AppAuthentication {
  sendOTP(
      {required String number,
      required void Function(FirebaseAuthException) onVerificationFailed,
      required void Function(String verificationId, int? resendToken)
          onCodeSent,
      required void Function(String verificationId)
          onCodeAutoRetrievalTimeout}) async {
    try {
      log("Attempting to send OTP to $number");
      await FirebaseAuth.instance.verifyPhoneNumber(
        phoneNumber: number,
        verificationCompleted: (PhoneAuthCredential credential) async {
          log("Phone number auto-verified");
          await FirebaseAuth.instance.signInWithCredential(credential);
          Get.snackbar(
            "Verification Complete",
            "Phone number verified successfully!",
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: const Color.fromARGB(255, 233, 243, 252),
          );
        },
        verificationFailed: onVerificationFailed,
        codeSent: onCodeSent,
        codeAutoRetrievalTimeout: onCodeAutoRetrievalTimeout,
      );
    } catch (e) {
      log("Error in sending OTP: $e");
    }
  }

  verifyOTP(
      {required String verificationId,
      required String userEnteredOtp,
      required Function(UserCredential) onsignInWithCredential,
      required Function(dynamic) catchError,
      required Function() onErrorInOtpVerification}) async {
    PhoneAuthCredential credential = PhoneAuthProvider.credential(
      verificationId: verificationId,
      smsCode: userEnteredOtp,
    );
    try {
      await FirebaseAuth.instance
          .signInWithCredential(credential)
          .then(onsignInWithCredential)
          .catchError(catchError);
    } catch (e) {
      onErrorInOtpVerification();
    }
  }
}
