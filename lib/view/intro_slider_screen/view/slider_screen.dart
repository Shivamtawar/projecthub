import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:projecthub/view/intro_slider_screen/model/slider_info_model.dart';
import 'package:projecthub/utils/screen_size.dart';
import 'package:projecthub/utils/slider_screen_data.dart';
import 'package:projecthub/utils/app_shared_preferences.dart';
import '../../login/view/login_screen.dart';

class SlidePage extends StatefulWidget {
  const SlidePage({super.key});

  @override
  State<SlidePage> createState() => _SlidePageState();
}

class _SlidePageState extends State<SlidePage> {
  late final List<Sliders> pages;
  int currentpage = 0;
  final PageController controller = PageController();

  @override
  void initState() {
    super.initState();
    pages = Utils.getSliderPages();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  void _onChanged(int index) {
    setState(() {
      currentpage = index;
    });
  }

  void _handleButtonPress() {
    if (currentpage == pages.length - 1) {
      PrefData.setIntro(true);
      Get.to(
        const LoginScreen(),
        transition: Transition.rightToLeftWithFade,
      );
    } else {
      controller.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    initializeScreenSize(context);
    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            _buildPageView(),
            Positioned(
              bottom: 42.h,
              left: 20.w,
              right: 20.w,
              child: _buildBottomControls(),
            ),
            if (currentpage != pages.length - 1) _buildSkipButton(),
          ],
        ),
      ),
    );
  }

  Widget _buildPageView() {
    return PageView.builder(
      itemCount: pages.length,
      controller: controller,
      onPageChanged: _onChanged,
      itemBuilder: (context, index) {
        final page = pages[index];
        return Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            ConstrainedBox(
              constraints: BoxConstraints(
                maxWidth: Get.width,
                maxHeight: Get.height * 0.7,
              ),
              child: Image.asset(
                page.image!,
                width: Get.width,
                fit: BoxFit.contain,
              ),
            ),
            SizedBox(height: 20.h),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 35.w),
              child: Column(
                children: [
                  Text(
                    page.name!,
                    style: TextStyle(
                      fontFamily: 'Gilroy',
                      fontWeight: FontWeight.w700,
                      color: const Color(0XFF000000),
                      fontSize: 22.sp,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 10.h),
                  Text(
                    page.title!,
                    style: TextStyle(
                      fontFamily: 'Gilroy',
                      fontWeight: FontWeight.w700,
                      color: const Color(0XFF000000),
                      fontSize: 15.sp,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildBottomControls() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        _buildPageIndicator(),
        _buildActionButton(),
      ],
    );
  }

  Widget _buildPageIndicator() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(pages.length, (index) {
        return AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          height: 10.h,
          width: (index == currentpage) ? 20.w : 10.w,
          margin: EdgeInsets.symmetric(horizontal: 4.w),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(5.h),
            color: (index == currentpage)
                ? const Color(0XFF23408F)
                : const Color(0XFFDEDEDE),
          ),
        );
      }),
    );
  }

  Widget _buildActionButton() {
    return Material(
      borderRadius: BorderRadius.circular(22.h),
      color: const Color(0XFF23408F),
      child: InkWell(
        borderRadius: BorderRadius.circular(22.h),
        onTap: _handleButtonPress,
        child: Container(
          height: 56.h,
          width: 177.w,
          alignment: Alignment.center,
          child: Text(
            currentpage == pages.length - 1 ? "Get Started" : "Next",
            style: TextStyle(
              color: const Color(0XFFFFFFFF),
              fontSize: 18.sp,
              fontFamily: 'Gilroy',
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSkipButton() {
    return Positioned(
      top: 25.h,
      right: 20.w,
      child: GestureDetector(
        onTap: () {
          controller.animateToPage(
            pages.length - 1,
            duration: const Duration(milliseconds: 500),
            curve: Curves.easeInOut,
          );
        },
        child: Container(
          height: 40.h,
          width: 68.w,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20.h),
            color: const Color(0XFFFFFFFF),
          ),
          child: Center(
            child: Text(
              "Skip",
              style: TextStyle(
                fontFamily: 'Gilroy',
                fontWeight: FontWeight.w500,
                fontSize: 15.sp,
                color: const Color(0xFF000000),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
