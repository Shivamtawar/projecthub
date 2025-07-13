// ignore_for_file: deprecated_member_use

import 'dart:developer';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:projecthub/view/profile/provider/user_provider.dart';
import 'package:projecthub/constant/app_text.dart';
import 'package:projecthub/constant/app_textfield_border.dart';
import 'package:projecthub/view/profile/controller/user_controller.dart';
import 'package:projecthub/model/user_info_model.dart';
import 'package:projecthub/utils/app_shared_preferences.dart';
import 'package:projecthub/utils/screen_size.dart';
import 'package:projecthub/view/app_navigation_bar/app_navigation_bar.dart';
import 'package:projecthub/view/loading_screen/loading_screen.dart';
import 'package:provider/provider.dart';
import '../../app_providers/creation_provider.dart';
import 'term_and_condition.dart';

class SignUpAddUserScreen extends StatefulWidget {
  final String phoneNumber;
  const SignUpAddUserScreen({super.key, required this.phoneNumber});

  @override
  State<SignUpAddUserScreen> createState() => _SignUpAddUserScreenState();
}

class _SignUpAddUserScreenState extends State<SignUpAddUserScreen> {
  final formkey = GlobalKey<FormState>();
  TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController confirmpassController = TextEditingController();
  final UserController _userController = UserController();
  bool _showCircularIndicater = false;
  bool ischeaked = false;
  bool ispassHiden = true;
  bool ispassHiden1 = true;
  bool isSubmitPressed = false;
  String passworderror = '';

  fetchData(int uid) async {
    await Provider.of<UserInfoProvider>(context, listen: false)
        .fetchUserDetails(uid);
    await Provider.of<GeneralCreationProvider>(context, listen: false)
        .fetchGeneralCreations(uid, 1, 10);
    await Provider.of<RecentCreationProvider>(context, listen: false)
        .fetchRecentCreations(uid, 1, 10);
    await Provider.of<TreandingCreationProvider>(context, listen: false)
        .fetchTrendingCreations(uid, 1, 10);
  }

  Future<void> addUserOnServer(NewUserInfo newUserInfo) async {
    try {
      Map responce = await _userController.addUser(newUserInfo);
      if (responce['isadded']) {
        log(responce['data'].toString());

        PrefData.setLogin(responce['data']['user_id']);
        PrefData.setIntro(true);

        Get.offAll(() => LoadingScreen(userId: responce['data']['user_id']));
        await fetchData(responce['data']['user_id']);
        Get.offAll(() => AppNavigationScreen());
      } else {
        Get.snackbar("Something went wrong", "Unable to create account");
      }
    } catch (e) {
      Get.snackbar("Something went wrong", "Unable to create account");
      setState(() {
        _showCircularIndicater = false;
      });
    }
  }

  onSignUpPressed() async {
    setState(() {
      FocusScope.of(context).unfocus();
      isSubmitPressed = true;
    });
    if (formkey.currentState!.validate()) {
      if (confirmpassController.value == passwordController.value) {
        setState(() {
          _showCircularIndicater = true;
        });
        NewUserInfo newUserInfo = NewUserInfo.fromJson({
          'user_name': nameController.text.trim(),
          'user_password': passwordController.text.trim(),
          'user_contact': widget.phoneNumber,
          'role': 'end_user',
        });
        await addUserOnServer(newUserInfo);
        setState(() {
          _showCircularIndicater = false;
        });
      }
    }
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

  @override
  void dispose() {
    nameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    confirmpassController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    initializeScreenSize(context);
    return WillPopScope(
      onWillPop: () {
        return Future.value(true);
      },
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        body: GestureDetector(
          onTap: () {
            FocusScope.of(context).unfocus();
          },
          child: Padding(
            padding: EdgeInsets.only(left: 20.w, right: 20.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 60.h),
                SizedBox(height: 20.h),
                Center(
                  child: Text(
                    "Create an account",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 24.sp,
                      fontFamily: 'Gilroy',
                      color: const Color(0XFF000000),
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
                Expanded(
                  child: ListView(
                    children: [
                      detailform(),
                      SizedBox(height: 25.h),
                      termConditionCheakbox(),
                      SizedBox(height: 25.h),
                      signUpButton(),
                      SizedBox(height: 100.h),
                      if (_showCircularIndicater)
                        const Center(child: CircularProgressIndicator())
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
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
            onTapOutside: (p) {
              FocusScope.of(context).unfocus();
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

          // TextFormField(
          //   onChanged: (value) {
          //     if (isSubmitPressed) {
          //       formkey.currentState!.validate();
          //     }
          //   },
          //   controller: emailController,
          //   decoration: InputDecoration(
          //     hintText: 'Email',
          //     hintStyle: AppText.textFieldHintTextStyle,
          //     focusedErrorBorder: AppTextfieldBorder.focusedErrorBorder,
          //     errorBorder: AppTextfieldBorder.errorBorder,
          //     focusedBorder: AppTextfieldBorder.focusedBorder,
          //     enabledBorder: AppTextfieldBorder.enabledBorder,
          //     filled: true,
          //     fillColor: const Color(0xFFF5F5F5),
          //     contentPadding:
          //         EdgeInsets.only(left: 20.w, top: 20.h, bottom: 20.h),
          //   ),
          //   validator: (val) {
          //     if (val!.isEmpty) {
          //       return 'Enter the  email';
          //     } else {
          //       if (!RegExp(
          //               r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
          //           .hasMatch(val)) {
          //         return "Please enter valid email address";
          //       }
          //     }
          //     return null;
          //   },
          // ),
          SizedBox(height: 20.h),
          TextFormField(
            onChanged: (value) {
              if (isSubmitPressed) {
                formkey.currentState!.validate();
              }
            },
            onTapOutside: (p) {
              FocusScope.of(context).unfocus();
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
              hintText: 'Set Password',
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
            onTapOutside: (p) {
              FocusScope.of(context).unfocus();
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
          SizedBox(height: 20.h),
        ],
      ),
    );
  }

  Widget termConditionCheakbox() {
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

  Widget signUpButton() {
    return Container(
      height: 56.h,
      width: 374.w,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: const Color(0XFF23408F),
      ),
      child: TextButton(
        onPressed: ischeaked
            ? onSignUpPressed
            : () {
                Get.snackbar("Term and condition not accepted by you",
                    "Please agree with terms and conditions");
              },
        child: Text(
          "Sign Up",
          style: TextStyle(
              color: const Color(0XFFFFFFFF),
              fontSize: 18.sp,
              fontWeight: FontWeight.bold,
              fontFamily: 'Gilroy'),
        ),
      ),
    );
  }
}
