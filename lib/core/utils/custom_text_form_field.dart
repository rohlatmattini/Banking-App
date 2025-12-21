import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:banking_system/core/constants/app_color.dart';

class CustomTextFormField<T> extends StatelessWidget {
  final String label;
  final String hint;
  final TextEditingController? controller;
  final TextInputType keyboardType;
  final bool obscureText;
  final String? Function(String?)? validator;
  final IconData? prefixIcon;
  final IconData? suffixIcon;
  final VoidCallback? onSuffixPressed;
  final void Function(String)? onChanged;
  final int? maxLines;
  final bool? isExpanded;

  // 👇 باراميتر جديد للـ Dropdown
  final List<DropdownMenuItem<T>>? dropdownItems;
  final T? dropdownValue;
  final void Function(T?)? onDropdownChanged;
  final String? Function(T?)? dropdownValidator;

  // 👇 باراميترات جديدة
  final String? initialValue;
  final String? initialDropdownHint;

  const CustomTextFormField({
    super.key,
    required this.label,
    required this.hint,
    this.controller,
    this.keyboardType = TextInputType.text,
    this.obscureText = false,
    this.validator,
    this.prefixIcon,
    this.suffixIcon,
    this.onSuffixPressed,
    this.onChanged,
    this.maxLines,
    this.dropdownItems,
    this.dropdownValue,
    this.onDropdownChanged,
    this.dropdownValidator,
    this.isExpanded,
    this.initialValue,
    this.initialDropdownHint,
  });

  @override
  Widget build(BuildContext context) {
    // إذا في dropdownItems → استخدم DropdownButtonFormField
    if (dropdownItems != null) {
      return DropdownButtonFormField<T>(
        value: dropdownValue,
        items: dropdownItems,
        onChanged: onDropdownChanged,
        validator: dropdownValidator,
        isExpanded: isExpanded ?? false,
        decoration: InputDecoration(
          labelText: label,
          hintText: hint,
          hintStyle: TextStyle(color: AppColor.darkgreen),
          prefixIcon: prefixIcon != null
              ? Icon(prefixIcon, color: AppColor.green)
              : null,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10.r),
            borderSide: const BorderSide(color: AppColor.darkgreen),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10.r),
            borderSide: const BorderSide(color: AppColor.darkgreen),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10.r),
            borderSide: const BorderSide(
              color: AppColor.green,
              width: 2,
            ),
          ),
          floatingLabelStyle: const TextStyle(color: AppColor.green),
        ),
        hint: initialDropdownHint != null
            ? Text(
          initialDropdownHint!,
          style: TextStyle(color: AppColor.darkgreen),
        )
            : null,
      );
    }

    // إذا ما في dropdownItems → استخدم TextFormField العادي
    return TextFormField(
      cursorColor: AppColor.green,
      controller: controller,
      keyboardType: keyboardType,
      obscureText: obscureText,
      validator: validator,
      onChanged: onChanged,
      maxLines: obscureText ? 1 : maxLines,
      initialValue: initialValue, // 👈 إضافة initialValue هنا
      decoration: InputDecoration(
        labelText: label,
        hintText: hint,
        hintStyle: const TextStyle(color: AppColor.darkgreen),
        prefixIcon: prefixIcon != null
            ? Icon(prefixIcon, color: AppColor.green)
            : null,
        suffixIcon: suffixIcon != null
            ? IconButton(
          onPressed: onSuffixPressed,
          icon: Icon(suffixIcon, color: AppColor.green),
        )
            : null,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.r),
          borderSide: const BorderSide(color: AppColor.darkgreen),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.r),
          borderSide: const BorderSide(color: AppColor.darkgreen),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.r),
          borderSide: BorderSide(
            color: AppColor.green,
            width: 2,
          ),
        ),
        floatingLabelStyle: const TextStyle(color: AppColor.green),
      ),
    );
  }
}