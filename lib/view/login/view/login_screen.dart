import 'dart:developer';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:projecthub/constant/app_color.dart';
import 'package:projecthub/view/login/controller/login_controller.dart';
import 'package:projecthub/utils/app_shared_preferences.dart';
import 'package:projecthub/widgets/app_primary_button.dart';
import '../../../constant/app_text.dart';
import '../../../constant/app_textfield_border.dart';
import 'forgot_password.dart';
import '../../permission_screen/permission_screen.dart';
import '../../sign_up/sign_in_phonenumber.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _loginController = LoginController();

  bool _showCircularIndicator = false;
  bool _isPasswordHidden = true;
  bool _isSubmitPressedOnce = false;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _checkLoginDetails() async {
    setState(() {
      _isSubmitPressedOnce = true;
    });

    FocusScope.of(context).unfocus();

    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _showCircularIndicator = true;
    });

    try {
      final res = await _loginController.checkLogindetails(
        _emailController.text.trim(),
        _passwordController.text.trim(),
      );

      if (res['status'] == 'True') {
        log(res['data'][0].toString());
        PrefData.setLogin(res['data'][0]['user_id']);
        PrefData.setIntro(true);
        Get.offAll(() => PermissionRequestScreen(
              userId: res['data'][0]['user_id'],
            ));
      } else {
        final title = _emailController.text.contains('@')
            ? "Email or Password is wrong"
            : "Mobile number/Email or Password is wrong";
        Get.snackbar(title, "Please enter correct details");
      }
    } finally {
      if (mounted) {
        setState(() {
          _showCircularIndicator = false;
        });
      }
    }
  }

  void _togglePasswordVisibility() {
    setState(() {
      _isPasswordHidden = !_isPasswordHidden;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: WillPopScope(
        onWillPop: () async => false,
        child: SafeArea(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 20.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 16.h),
                Expanded(
                  child: _buildMainContent(),
                ),
                Padding(
                  padding: EdgeInsets.only(bottom: 30.h),
                  child: _buildSignUpText(),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildMainContent() {
    return ListView(
      physics: const ClampingScrollPhysics(),
      children: [
        SizedBox(height: 20.h),
        _buildLoginHeader(),
        SizedBox(height: 16.h),
        _buildWelcomeText(),
        SizedBox(height: 10.h),
        _buildLoginForm(),
        SizedBox(height: 21.h),
        _buildForgotPassword(),
        SizedBox(height: 40.h),
        AppPrimaryElevetedButton(
          onPressed: _checkLoginDetails,
          title: "Log in",
        ),
        SizedBox(height: 40.h),
        _buildOrSignInWith(),
        SizedBox(height: 41.h),
        _buildSocialLoginButton(
          asset: "assets/images/google.png",
          text: "Login with Google",
        ),
        SizedBox(height: 20.h),
        _buildSocialLoginButton(
          asset: "assets/images/facebook.png",
          text: "Login with Facebook",
        ),
        SizedBox(height: 30.h),
        if (_showCircularIndicator)
          Center(
            child: CircularProgressIndicator(
              color: AppColor.primaryColor,
            ),
          ),
      ],
    );
  }

  Widget _buildLoginHeader() {
    return Center(
      child: Text(
        "Login",
        style: TextStyle(
          fontWeight: FontWeight.w700,
          fontSize: 24.sp,
          fontFamily: 'Gilroy',
          color: const Color(0XFF000000),
        ),
      ),
    );
  }

  Widget _buildWelcomeText() {
    return Center(
      child: Text(
        "Glad to meet you again!",
        style: TextStyle(
          fontWeight: FontWeight.w500,
          color: const Color(0XFF000000),
          fontSize: 15.sp,
          fontFamily: 'Gilroy',
        ),
      ),
    );
  }

  Widget _buildLoginForm() {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          TextFormField(
            controller: _emailController,
            onChanged: (_) {
              if (_isSubmitPressedOnce) _formKey.currentState!.validate();
            },
            decoration: InputDecoration(
              hintText: 'Mobile number / Email',
              hintStyle: AppText.textFieldHintTextStyle,
              focusedErrorBorder: AppTextfieldBorder.focusedErrorBorder,
              errorBorder: AppTextfieldBorder.errorBorder,
              focusedBorder: AppTextfieldBorder.focusedBorder,
              enabledBorder: AppTextfieldBorder.enabledBorder,
              filled: true,
              fillColor: const Color(0xFFF5F5F5),
              contentPadding: EdgeInsets.symmetric(
                horizontal: 20.w,
                vertical: 20.h,
              ),
            ),
            validator: (val) =>
                val!.isEmpty ? 'Enter Mobile number or email' : null,
          ),
          SizedBox(height: 15.h),
          TextFormField(
            controller: _passwordController,
            obscureText: _isPasswordHidden,
            onChanged: (_) => _formKey.currentState!.validate(),
            decoration: InputDecoration(
              hintText: 'Password',
              hintStyle: AppText.textFieldHintTextStyle,
              focusedErrorBorder: AppTextfieldBorder.focusedErrorBorder,
              errorBorder: AppTextfieldBorder.errorBorder,
              focusedBorder: AppTextfieldBorder.focusedBorder,
              enabledBorder: AppTextfieldBorder.enabledBorder,
              filled: true,
              fillColor: const Color(0xFFF5F5F5),
              contentPadding: EdgeInsets.symmetric(
                horizontal: 20.w,
                vertical: 20.h,
              ),
              suffixIcon: IconButton(
                icon: Icon(
                  _isPasswordHidden ? Icons.visibility : Icons.visibility_off,
                  color: const Color.fromARGB(255, 171, 170, 170),
                ),
                onPressed: _togglePasswordVisibility,
              ),
            ),
            validator: (val) => val!.isEmpty ? 'Enter the password' : null,
          ),
        ],
      ),
    );
  }

  Widget _buildForgotPassword() {
    return GestureDetector(
      onTap: () => Get.to(const ForgotPassword()),
      child: Align(
        alignment: Alignment.centerRight,
        child: Text(
          "Forgot password ?",
          style: TextStyle(
            fontFamily: 'Gilroy',
            fontWeight: FontWeight.w700,
            fontSize: 15.sp,
            color: const Color(0XFF23408F),
          ),
        ),
      ),
    );
  }

  Widget _buildOrSignInWith() {
    return Row(
      children: [
        Expanded(
          child: Divider(
            thickness: 2,
            endIndent: 20.w,
            color: const Color(0XFFDEDEDE),
          ),
        ),
        Text(
          "Or Sign in with",
          style: TextStyle(
            color: const Color(0XFF000000),
            fontSize: 15.sp,
            fontWeight: FontWeight.w400,
            fontFamily: 'Gilroy',
          ),
        ),
        Expanded(
          child: Divider(
            thickness: 2,
            indent: 20.w,
            color: const Color(0XFFDEDEDE),
          ),
        ),
      ],
    );
  }

  Widget _buildSocialLoginButton({
    required String asset,
    required String text,
  }) {
    return GestureDetector(
      onTap: () {},
      child: Container(
        height: 56.h,
        width: 374.w,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          color: Colors.grey.withOpacity(0.1),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image(image: AssetImage(asset)),
            SizedBox(width: 10.w),
            Text(
              text,
              style: TextStyle(
                color: const Color(0XFF000000),
                fontSize: 18.sp,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSignUpText() {
    return Center(
      child: RichText(
        text: TextSpan(
          text: 'Already have an account?',
          style: TextStyle(
            color: Colors.black,
            fontSize: 15.sp,
            fontFamily: 'Gilroy',
          ),
          children: [
            TextSpan(
              text: '  Sign up',
              style: TextStyle(
                color: const Color(0XFF000000),
                fontSize: 15.sp,
                fontWeight: FontWeight.bold,
                fontFamily: 'Gilroy',
              ),
              recognizer: TapGestureRecognizer()
                ..onTap = () => Get.to(const SignInPhonenumber()),
            ),
          ],
        ),
      ),
    );
  }
}
