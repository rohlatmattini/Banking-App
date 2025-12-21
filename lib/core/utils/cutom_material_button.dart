// import 'package:flutter/material.dart';
//
// class CustomMaterialButton extends StatelessWidget {
//   final text;
//   final width;
//   final height;
//   final Color? textColor;
//   final VoidCallback  onPressed;
//
//    CustomMaterialButton({
//     super.key,
//     required this.text,
//     required this.width,
//     required this.height,
//     required this.onPressed,
//     this.textColor,
//   });
//   @override
//   Widget build(BuildContext context) {
//     return ElevatedButton(
//       onPressed: onPressed,
//       style: ElevatedButton.styleFrom(
//         minimumSize: Size(width, height), // العرض - الارتفاع
//       ),
//       child: Text(text),
//     );
//   }
// }



import 'package:flutter/material.dart';

import '../constants/app_color.dart';

class CustomMaterialButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;
  final Color? backgroundColor;
  final Color? textColor;
  final Color? disabledColor;
  final double? elevation;
  final EdgeInsetsGeometry? padding;
  final double? borderRadius;
  final double? height;
  final double? width;
  final bool isLoading;
  final Widget? icon;
  final bool expanded;

  const CustomMaterialButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.backgroundColor,
    this.textColor,
    this.disabledColor,
    this.elevation,
    this.padding,
    this.borderRadius,
    this.height,
    this.width,
    this.isLoading = false,
    this.icon,
    this.expanded = false,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height ?? 50,
      width: expanded ? double.infinity : width,
      child: MaterialButton(
        onPressed: isLoading ? null : onPressed,
        color: backgroundColor ?? AppColor.darkgreen,
        disabledColor: disabledColor ?? Colors.grey.shade400,
        elevation: elevation ?? 0,
        padding: padding ?? const EdgeInsets.symmetric(horizontal: 24),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(borderRadius ?? 10),
        ),
        child: isLoading
            ? SizedBox(
          height: 24,
          width: 24,
          child: CircularProgressIndicator(
            color: textColor ?? Colors.white,
            strokeWidth: 3,
          ),
        )
            : Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (icon != null) ...[
              icon!,
              const SizedBox(width: 8),
            ],
            Text(
              text,
              style: TextStyle(
                color: textColor ?? Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}