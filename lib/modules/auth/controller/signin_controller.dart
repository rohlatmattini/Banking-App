

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../app/routes/routes.dart';
import '../../../core/patterns/state/auth_state.dart';
import '../../../core/patterns/strategy/auth_validation.dart';
import '../../../core/patterns/facade/auth_facade.dart';
import '../../../data/models/auth/signin_model.dart';

class SignInController extends GetxController {
  final formKey = GlobalKey<FormState>();

  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  RxBool obscureText = true.obs;
  RxBool rememberPassword = true.obs;

  final Rx<AuthState> state = Rx<AuthState>(AuthIdle());

  final emailValidator = EmailValidationStrategy();
  final passwordValidator = PasswordValidationStrategy();

  late final AuthFacade authFacade;

  @override
  void onInit() {
    super.onInit();
    authFacade = Get.find<AuthFacade>();
  }

  void togglePasswordVisibility() => obscureText.value = !obscureText.value;
  void toggleRemember(bool? value) => rememberPassword.value = value ?? false;

  void submitForm() async {
    if (!formKey.currentState!.validate()) return;

    state.value = AuthLoading();

    final model = LoginModel(
      email: emailController.text.trim(),
      password: passwordController.text.trim(),
      rememberMe: rememberPassword.value,
    );

    final user = await authFacade.login(model);

    if (user != null) {
      state.value = AuthSuccess(user);
      Get.offAllNamed(AppRoute.home);
    } else {
      state.value = AuthError("Login failed");
    }
  }
}
