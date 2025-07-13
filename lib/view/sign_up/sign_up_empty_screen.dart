// ignore_for_file: deprecated_member_use

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:projecthub/constant/app_text.dart';
import 'package:projecthub/constant/app_textfield_border.dart';
import 'package:projecthub/utils/screen_size.dart';
import '../login/view/login_screen.dart';
import 'sign_in_phonenumber.dart';
import 'term_and_condition.dart';

class SignInEmptyScreen extends StatefulWidget {
  const SignInEmptyScreen({super.key});

  @override
  State<SignInEmptyScreen> createState() => _SignInEmptyScreenState();
}

class _SignInEmptyScreenState extends State<SignInEmptyScreen> {
  bool ischeaked = false;
  bool ispassHiden = true;
  bool ispassHiden1 = true;
  bool isSubmitPressed = false;

  String passworderror = '';
  final formkey = GlobalKey<FormState>();
  TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController confirmpassController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    initializeScreenSize(context);
    return WillPopScope(
      onWillPop: () {
        return Future.value(false);
      },
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        body: Padding(
          padding: EdgeInsets.only(left: 20.w, right: 20.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 30.h),
              back_button(),
              SizedBox(height: 20.h),
              Center(
                child: Text(
                  "Create an account",
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 24.sp,
                      fontFamily: 'Gilroy',
                      color: const Color(0XFF000000)),
                  textAlign: TextAlign.center,
                ),
              ),
              //  SizedBox(height: 20.h),
              Expanded(
                child: ListView(
                  children: [
                    detailform(),
                    SizedBox(height: 25.h),
                    term_condition_cheakbox(),
                    SizedBox(height: 25.h),
                    sign_up_button(),
                  ],
                ),
              ),
              Padding(
                padding: EdgeInsets.only(bottom: 30.h),
                child: already_login_button(),
              ),
              //Checkbox
            ],
          ),
        ),
      ),
    );
  }

  toggle() {
    setState(() {
      ispassHiden = !ispassHiden;
    });
  }

  toggle1() {
    setState(() {
      ispassHiden1 = !ispassHiden1;
    });
  }

  Widget detailform() {
    return Form(
      key: formkey,
      child: Column(
        children: [
          TextFormField(
            onChanged: (value) {
              if (isSubmitPressed) {
                formkey.currentState!.validate();
              }
            },
            controller: nameController,
            decoration: InputDecoration(
              hintText: 'Name',
              hintStyle: AppText.textFieldHintTextStyle,
              focusedErrorBorder: AppTextfieldBorder.focusedErrorBorder,
              errorBorder: AppTextfieldBorder.errorBorder,
              focusedBorder: AppTextfieldBorder.focusedBorder,
              enabledBorder: AppTextfieldBorder.enabledBorder,
              filled: true,
              fillColor: const Color(0xFFF5F5F5),
              contentPadding:
                  EdgeInsets.only(left: 20.w, top: 20.h, bottom: 20.h),
            ),
            validator: (val) {
              if (val!.isEmpty) return 'Enter the  Name';
              return null;
            },
          ),
          SizedBox(height: 20.h),
          TextFormField(
            onChanged: (value) {
              if (isSubmitPressed) {
                formkey.currentState!.validate();
              }
            },
            controller: emailController,
            decoration: InputDecoration(
              hintText: 'Email',
              hintStyle: AppText.textFieldHintTextStyle,
              focusedErrorBorder: AppTextfieldBorder.focusedErrorBorder,
              errorBorder: AppTextfieldBorder.errorBorder,
              focusedBorder: AppTextfieldBorder.focusedBorder,
              enabledBorder: AppTextfieldBorder.enabledBorder,
              filled: true,
              fillColor: const Color(0xFFF5F5F5),
              contentPadding:
                  EdgeInsets.only(left: 20.w, top: 20.h, bottom: 20.h),
            ),
            validator: (val) {
              if (val!.isEmpty) {
                return 'Enter the  email';
              } else {
                if (!RegExp(
                        r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                    .hasMatch(val)) {
                  return "Please enter valid email address";
                }
              }
              return null;
            },
          ),
          SizedBox(height: 20.h),
          TextFormField(
            onChanged: (value) {
              if (isSubmitPressed) {
                formkey.currentState!.validate();
              }
            },
            controller: passwordController,
            obscureText: ispassHiden,
            decoration: InputDecoration(
              suffixIcon: ispassHiden
                  ? GestureDetector(
                      onTap: () => toggle(),
                      child: const Icon(
                        Icons.visibility,
                        color: Color.fromARGB(255, 171, 170, 170),
                      ))
                  : GestureDetector(
                      onTap: () => toggle(),
                      child: const Icon(
                        Icons.visibility_off,
                        color: Color.fromARGB(255, 171, 170, 170),
                      )),
              hintText: 'Password',
              hintStyle: AppText.textFieldHintTextStyle,
              focusedErrorBorder: AppTextfieldBorder.focusedErrorBorder,
              errorBorder: AppTextfieldBorder.errorBorder,
              focusedBorder: AppTextfieldBorder.focusedBorder,
              enabledBorder: AppTextfieldBorder.enabledBorder,
              filled: true,
              fillColor: const Color(0xFFF5F5F5),
              contentPadding:
                  EdgeInsets.only(left: 20.w, top: 20.h, bottom: 20.h),
            ),
            validator: (val) {
              if (val!.isEmpty) {
                return 'Enter the  password';
              } else if (passwordController.text.length < 4) {
                return "Password should contain minimum 4 letters";
              }
              return null;
            },
          ),
          SizedBox(height: 20.h),
          TextFormField(
            onChanged: (value) {
              if (isSubmitPressed) {
                formkey.currentState!.validate();
              }
            },
            controller: confirmpassController,
            obscureText: ispassHiden1,
            decoration: InputDecoration(
              suffixIcon: ispassHiden1
                  ? GestureDetector(
                      onTap: () => toggle1(),
                      child: const Icon(
                        Icons.visibility,
                        color: Color.fromARGB(255, 171, 170, 170),
                      ))
                  : GestureDetector(
                      onTap: () => toggle1(),
                      child: const Icon(
                        Icons.visibility_off,
                        color: Color.fromARGB(255, 171, 170, 170),
                      )),
              hintText: 'Confirm password',
              hintStyle: AppText.textFieldHintTextStyle,
              focusedErrorBorder: AppTextfieldBorder.focusedErrorBorder,
              errorBorder: AppTextfieldBorder.errorBorder,
              focusedBorder: AppTextfieldBorder.focusedBorder,
              enabledBorder: AppTextfieldBorder.enabledBorder,
              filled: true,
              fillColor: const Color(0xFFF5F5F5),
              contentPadding:
                  EdgeInsets.only(left: 20.w, top: 20.h, bottom: 20.h),
            ),
            validator: (val) {
              if (val!.isEmpty) {
                return 'Enter the  confirmpassword';
              } else if (confirmpassController.value !=
                  passwordController.value) {
                return 'Confirmpassword and password should be same';
              }
              return null;
            },
          ),
        ],
      ),
    );
  }

  Widget term_condition_cheakbox() {
    return Row(
      children: [
        Checkbox(
          activeColor: const Color(0XFF23408F),
          side: const BorderSide(color: Color(0XFFDEDEDE)),
          value: ischeaked,
          onChanged: (value) {
            setState(() {
              ischeaked = value!;
            });
          },
        ),
        RichText(
            text: TextSpan(
                text: 'I Agree with ',
                style: TextStyle(
                    color: Colors.black,
                    fontSize: 15.sp,
                    fontFamily: 'Gilroy',
                    fontWeight: FontWeight.w400),
                children: [
              TextSpan(
                recognizer: TapGestureRecognizer()
                  ..onTap = () {
                    Get.to(const TermCondition());
                  },
                text: 'Terms and condition',
                style: const TextStyle(
                    color: Color(0XFF23408F),
                    fontSize: 17,
                    fontWeight: FontWeight.w700,
                    fontFamily: 'Gilroy'),
              )
            ])),
      ],
    );
  }

  Widget sign_up_button() {
    return Container(
      height: 56.h,
      width: 374.w,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: const Color(0XFF23408F),
      ),
      child: TextButton(
        onPressed: ischeaked
            ? () {
                setState(() {
                  isSubmitPressed = true;
                });
                if (formkey.currentState!.validate()) {
                  if (confirmpassController.value == passwordController.value) {
                    Get.to(const SignInPhonenumber());
                  }
                }
              }
            : () {
                Get.snackbar("Term and condition not accepted by you",
                    "Please agree with terms and conditions");
              },
        child: Text("Sign Up",
            style: TextStyle(
                color: const Color(0XFFFFFFFF),
                fontSize: 18.sp,
                fontWeight: FontWeight.bold,
                fontFamily: 'Gilroy')),
      ),
    );
  }

  Widget already_login_button() {
    return Align(
      alignment: Alignment.center,
      child: RichText(
          text: TextSpan(
              text: 'Already have an account? ',
              style: TextStyle(
                  color: Colors.black, fontSize: 15.sp, fontFamily: 'Gilroy'),
              children: [
            TextSpan(
              recognizer: TapGestureRecognizer()
                ..onTap = () {
                  Get.off(const LoginScreen());
                },
              text: 'Login',
              style: TextStyle(
                  color: const Color(0XFF000000),
                  fontSize: 16.sp,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'Gilroy'),
            )
          ])),
    );
  }

  Widget back_button() {
    return IconButton(
      onPressed: () {
        Get.back();
      },
      icon: const Icon(
        Icons.arrow_back_ios_rounded,
        size: 20,
      ),
    );
  }

  @override
  void dispose() {
    nameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    confirmpassController.dispose();
    super.dispose();
  }
}
