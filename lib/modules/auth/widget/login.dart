import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../../app/routes/routes.dart';
import '../../../core/constants/app_color.dart';
import '../../../core/utils/custom_text_form_field.dart';
import '../../onboarding/widget/custombutton.dart';
import '../controller/signin_controller.dart';
import 'forget_password.dart';

class LoginFormWidget extends StatelessWidget {
  const LoginFormWidget({super.key});

  @override
  Widget build(BuildContext context) {

    final SignInController controller = Get.put(SignInController());

    return Form(
      key: controller.formKey,
      child: Column(
        children: [

          CustomTextFormField(
            label: 'Email'.tr,
            hint: 'Enter Email'.tr,
            controller: controller.emailController,
            keyboardType: TextInputType.emailAddress,
            prefixIcon: Icons.email,
            validator: controller.emailValidator.validate,
          ),
          SizedBox(height: 25.h),

          // Password Field
          Obx(() => CustomTextFormField(
            label: 'Password'.tr,
            hint: 'Enter Password'.tr,
            controller: controller.passwordController,
            obscureText: controller.obscureText.value,
            prefixIcon: Icons.lock,
            suffixIcon: controller.obscureText.value
                ? Icons.visibility
                : Icons.visibility_off,
            onSuffixPressed: controller.togglePasswordVisibility,
            validator: controller.passwordValidator.validate,

          )),
          SizedBox(height: 25.h),

          // Remember / Forgot
          Obx(() => RememberForgotRow(
            rememberPassword: controller.rememberPassword.value,
            onRememberChanged: controller.toggleRemember,
            onForgotTap: () {
              Get.toNamed(AppRoute.forgotPassword);
            },
          )),
          SizedBox(height: 25.h),

          CustomButton(
            text: "Login",

            onPressed:controller.submitForm,
            width: 200.w,
            height: 50.h,
            color: AppColor.green,
            borderRadius: 20.r,
            textColor: Colors.white,
            fontSize: 18.sp,
            fontWeight: FontWeight.bold,
          ),
        ]),
    );
  }
}
