import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../core/constants/app_color.dart';

class AuthContainer extends StatelessWidget {
  const AuthContainer({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height:295.h,
      child: Stack(
        children: [
          Positioned(
            left: -20,
            top: -25,
            child: Container(
              width: 200,
              height: 180,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: AppColor.darkgreen,
              ),
            ),
          ),


          Positioned(
            right: -140,
            top:-110 ,
            child: Container(

              width: 400,
              height: 400,
              decoration: BoxDecoration(
                boxShadow: [BoxShadow(color: AppColor.black,blurRadius: 15)],
                shape: BoxShape.circle,
                color: AppColor.green,
              ),
            ),
          ),

        ],
      ),
    );
  }
}
