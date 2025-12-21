
import 'package:get/get_utils/src/get_utils/get_utils.dart';

import 'validation_strategy.dart';

class EmailValidationStrategy implements ValidationStrategy {
  @override
  String? validate(String? value) {
    if (value == null || value.isEmpty) return "Enter email";
    if (!GetUtils.isEmail(value)) return "Invalid email";
    return null;
  }
}

class PasswordValidationStrategy implements ValidationStrategy {
  @override
  String? validate(String? value) {
    if (value == null || value.isEmpty) return "Enter password";
    if (value.length < 6) return "Weak password";
    return null;
  }
}
