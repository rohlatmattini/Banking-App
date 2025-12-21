import 'package:flutter/material.dart';

import '../../../../core/constants/app_color.dart';


class RememberForgotRow extends StatelessWidget {
  final bool rememberPassword;
  final ValueChanged<bool?> onRememberChanged;
  final VoidCallback? onForgotTap;

  const RememberForgotRow({
    super.key,
    required this.rememberPassword,
    required this.onRememberChanged,
    this.onForgotTap,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            Checkbox(
              value: rememberPassword,
              onChanged: onRememberChanged,
              activeColor: AppColor.darkgreen,
            ),
            const Text(
              'Remember me',
              style: TextStyle(color: Colors.black45),
            ),
          ],
        ),
        GestureDetector(
          onTap: onForgotTap,
          child: Text(
            'Forget password?',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: AppColor.darkgreen,
            ),
          ),
        ),
      ],
    );
  }
}
