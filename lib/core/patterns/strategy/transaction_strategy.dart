import 'validation_strategy.dart';

class RequiredFieldValidationStrategy implements ValidationStrategy {
  final String fieldName;

  RequiredFieldValidationStrategy({required this.fieldName});

  @override
  String? validate(String? value) {
    if (value == null || value.isEmpty) {
      return '$fieldName is required';
    }
    return null;
  }
}

// التحقق من أن المبلغ أكبر من صفر
class AmountValidationStrategy implements ValidationStrategy {
  @override
  String? validate(String? value) {
    if (value == null || value.isEmpty) return 'Amount is required';
    final amount = double.tryParse(value);
    if (amount == null || amount <= 0) return 'Amount must be greater than 0';
    return null;
  }
}
