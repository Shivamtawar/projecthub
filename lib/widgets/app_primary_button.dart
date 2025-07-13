import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:projecthub/constant/app_color.dart';

class AppPrimaryButton extends StatefulWidget {
  final dynamic onPressed;
  final String title;
  final Widget? icon;
  final double? height;
  final Color? backgroundImage;
  const AppPrimaryButton({
    super.key,
    required this.title,
    required this.onPressed,
    this.icon,
    this.height,
    this.backgroundImage,
  });

  @override
  State<StatefulWidget> createState() => _AppPrimaryButtonState();
}

class _AppPrimaryButtonState extends State<AppPrimaryButton> {
  @override
  Widget build(BuildContext context) {
    return Expanded(
      flex: 1,
      child: InkWell(
        hoverColor: Colors.white,
        highlightColor: Colors.white,
        focusColor: Colors.white,
        borderRadius: const BorderRadius.all(Radius.circular(10)),
        onTap: widget.onPressed,
        child: Container(
          height: (widget.height != null) ? widget.height : Get.height * 0.06,
          decoration: BoxDecoration(
            color: (widget.backgroundImage != null)
                ? widget.backgroundImage
                : AppColor.primaryColor,
            borderRadius: const BorderRadius.all(
              Radius.circular(10),
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              if (widget.icon != null) widget.icon!,
              SizedBox(
                width: Get.width * 0.018,
              ),
              Text(
                widget.title,
                style: const TextStyle(
                    fontSize: 13,
                    color: Colors.white,
                    fontWeight: FontWeight.w600),
              )
            ],
          ),
        ),
      ),
    );
  }
}

class AppPrimaryElevetedButton extends StatefulWidget {
  final dynamic onPressed;
  final String title;
  final Icon? icon;
  const AppPrimaryElevetedButton(
      {super.key, required this.onPressed, required this.title, this.icon});

  @override
  State<AppPrimaryElevetedButton> createState() =>
      _AppPrimaryElevetedButtonState();
}

class _AppPrimaryElevetedButtonState extends State<AppPrimaryElevetedButton> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(1.0),
      child: ElevatedButton.icon(
        onPressed: widget.onPressed,
        icon: widget.icon,
        
        label: Text(
          widget.title,
          style: const TextStyle(color: Colors.white),
        ),
        style: ElevatedButton.styleFrom(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          backgroundColor: AppColor.iconPrimary,
          padding: const EdgeInsets.symmetric(vertical: 16),
          minimumSize: const Size(double.infinity, 50),
        ),
      ),
    );
  }
}
