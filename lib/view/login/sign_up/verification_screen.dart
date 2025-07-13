// ignore_for_file: deprecated_member_use

import 'dart:async';
import 'dart:developer';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:pinput/pinput.dart';
import 'package:projecthub/controller/authentication.dart';
import 'package:projecthub/utils/screen_size.dart';
import 'package:projecthub/view/home/home_screen.dart';
import 'package:projecthub/view/login/sign_up/sign_up_add_user_screen.dart';

class Verification extends StatefulWidget {
  final String number;
  final String verificationId;
  const Verification({
    required this.number,
    super.key,
    required this.verificationId,
  });

  @override
  State<Verification> createState() => _VerificationState();
}

class _VerificationState extends State<Verification> {
  final otpkey = GlobalKey<FormState>();
  TextEditingController otpController = TextEditingController();
  String? otp;
  bool submitPressedOnce = false;
  bool _showCircularIndicater = false;
  final _otpLength = 6;
  var userEnteredOtp = "";

  void onsignInWithCredential(value) {
    setState(() {
      _showCircularIndicater = false;
    });
    Get.to(SignUpAddUserScreen(phoneNumber: widget.number));
  }

  void catchError(error) {
    setState(() {
      _showCircularIndicater = false;
    });
    Get.snackbar(
      "Error during sign up",
      "OTP not match",
      snackPosition: SnackPosition.TOP,
      backgroundColor: const Color.fromARGB(255, 233, 243, 252),
    );
  }

  onErrorInOtpVerification() {
    setState(() {
      _showCircularIndicater = false;
    });
    log("error in verifyOTP method");
  }

  onConfirmPressed() {
    if (userEnteredOtp.length == _otpLength) {
      setState(() {
        _showCircularIndicater = true;
      });
      submitPressedOnce = true;
      try {
        AppAuthentication().verifyOTP(
          verificationId: widget.verificationId,
          userEnteredOtp: userEnteredOtp,
          onsignInWithCredential: onsignInWithCredential,
          catchError: catchError,
          onErrorInOtpVerification: onErrorInOtpVerification,
        );
      } catch (e) {
        Get.snackbar("Error", "verification failed");
      }
    } else {
      Get.snackbar(
        "OTP not entered",
        "Plcease enter valid $_otpLength digit OTP",
        snackPosition: SnackPosition.TOP,
        backgroundColor: const Color.fromARGB(255, 233, 243, 252),
      );
    }

    //   print("otp length ${otp!.length}");
    //   otp != null
    //       ? Get.defaultDialog(
    //           title: '',
    //           //middleText: '',
    //           content: Padding(
    //             padding: EdgeInsets.symmetric(horizontal: 20.w),
    //             child: Column(
    //               children: [
    //                 Image(
    //                   image: AssetImage("assets/User_Approved.png"),
    //                   height: 90.h,
    //                   width: 78.w,
    //                 ),
    //                 SizedBox(height: 30.h),
    //                 Text(
    //                   "Sucessful !",
    //                   style: TextStyle(
    //                       fontSize: 22.sp,
    //                       fontFamily: 'Gilroy',
    //                       fontWeight: FontWeight.bold),
    //                 ),
    //                 SizedBox(height: 20.h),
    //                 Text(
    //                   "Your password has been changed sucessfully ! ",
    //                   style: TextStyle(
    //                       fontSize: 15.sp,
    //                       fontFamily: 'Gilroy',
    //                       fontWeight: FontWeight.w700),
    //                   textAlign: TextAlign.center,
    //                 ),
    //                 SizedBox(height: 32.h),
    //                 ok_button(),
    //               ],
    //             ),
    //           ),
    //         )
    //       : Fluttertoast.showToast(
    //           msg: "Please enter the OTP",
    //           toastLength: Toast.LENGTH_SHORT,
    //           gravity: ToastGravity.CENTER,
    //           timeInSecForIosWeb: 1,
    //           backgroundColor: Colors.red,
    //           textColor: Colors.white,
    //           fontSize: 16.0.sp);

    //   // Navigator.
  }

  @override
  Widget build(BuildContext context) {
    initializeScreenSize(context);
    return WillPopScope(
      onWillPop: () {
        return Future.value(false);
      },
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        body: SafeArea(
          child: Padding(
            padding: EdgeInsets.only(left: 20.w, right: 20.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 16.h),
                backbutton(),
                SizedBox(height: 20.h),
                Center(
                  child: Text(
                    "Verification",
                    style: TextStyle(
                        fontSize: 24.sp,
                        fontFamily: 'Gilroy',
                        color: const Color(0XFF000000),
                        fontWeight: FontWeight.bold),
                    textAlign: TextAlign.center,
                  ),
                ),
                SizedBox(height: 20.h),
                Expanded(
                  child: ListView(
                    children: [
                      Align(
                        alignment: Alignment.center,
                        child: Text(
                          "OTP sent to the ${widget.number}",
                          style: TextStyle(
                              color: const Color(0XFF000000),
                              fontSize: 15.sp,
                              fontFamily: 'Gilroy',
                              fontWeight: FontWeight.bold),
                          textAlign: TextAlign.center,
                        ),
                      ),
                      SizedBox(height: 20.h),
                      otpformat(),
                      SizedBox(height: 30.h),
                      confirmbutton(),
                      SizedBox(height: 50.h),
                      if (_showCircularIndicater)
                        const Center(child: CircularProgressIndicator()),
                    ],
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(bottom: 30.h),
                  child: resendOtpButton(),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget otpformat() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15),
      child: Form(
        key: otpkey, // Attach _formKey here
        child: Pinput(
          // errorText: "please enter valid otp",
          onChanged: (value) {
            setState(() {
              userEnteredOtp = value;
            });
            if (value.length == _otpLength) {
              setState(() {
                _showCircularIndicater = true;
              });
              try {
                AppAuthentication().verifyOTP(
                  verificationId: widget.verificationId,
                  userEnteredOtp: userEnteredOtp,
                  onsignInWithCredential: onsignInWithCredential,
                  catchError: catchError,
                  onErrorInOtpVerification: onErrorInOtpVerification,
                );
              } catch (e) {
                Get.snackbar("Error", "verification failed");
              }
            }
          },
          length: _otpLength,
          // ignore: avoid_print
          onCompleted: (pin) => print(pin),
        ),
      ),
    );
  }

  Widget backbutton() {
    return TextButton(
        onPressed: () {
          Get.back();
        },
        child: const Icon(Icons.arrow_back_ios, color: Color(0XFF000000)));
  }

  Widget confirmbutton() {
    return Center(
        child: GestureDetector(
      onTap: onConfirmPressed,
      child: Container(
        height: 56.h,
        width: 374.w,
        //color: Color(0XFF23408F),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          color: const Color(0XFF23408F),
        ),
        child: Center(
          child: Text(
            "Confirm",
            style: TextStyle(
              color: const Color(0XFFFFFFFF),
              fontSize: 18.sp,
              fontWeight: FontWeight.bold,
              fontFamily: 'Gilroy',
            ),
          ),
        ),
      ),
    ));
  }

  Widget resendOtpButton() {
    return Center(
      child: RichText(
        text: TextSpan(
          text: 'Don’t receive code?',
          style: TextStyle(
              color: Colors.black, fontSize: 15.sp, fontFamily: 'Gilroy'),
          children: [
            TextSpan(
              recognizer: TapGestureRecognizer()
                ..onTap = () {
                  // AppAuthentication.sendOTP(widget.number);
                },
              text: ' Resend',
              style: TextStyle(
                  fontFamily: 'Gilroy',
                  color: const Color(0XFF000000),
                  fontSize: 15.sp,
                  fontWeight: FontWeight.w700,
                  fontStyle: FontStyle.normal),
            )
          ],
        ),
      ),
    );
  }

  Widget okButton() {
    return Padding(
      padding: EdgeInsets.only(bottom: 20.h),
      child: Center(
        child: GestureDetector(
          onTap: () {
            //PrefData.setLogin(true);
            Get.to(const HomeScreen());
          },
          child: Container(
            height: 56.h,
            width: 334.w,
            //color: Color(0XFF23408F),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              color: const Color(0XFF23408F),
            ),
            child: Center(
              child: Text("Ok",
                  style: TextStyle(
                      color: const Color(0XFFFFFFFF),
                      fontSize: 18.sp,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'Gilroy')),
            ),
          ),
        ),
      ),
    );
  }
}
