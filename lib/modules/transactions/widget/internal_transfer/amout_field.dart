import 'package:banking_system/core/patterns/composite/account_component.dart';
import 'package:flutter/material.dart';
import '../../../../core/utils/custom_text_form_field.dart';
import '../../controller/transaction_controller.dart';

class AmountField extends StatelessWidget {
  final TransactionController controller;

  const AmountField({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return  CustomTextFormField(
      isExpanded: true,
      label: 'Enter amount',
      hint: 'Enter amount',
      prefixIcon: Icons.monetization_on_rounded,
      keyboardType: TextInputType.number,
      onChanged: (value) {
        controller.amount.value = double.tryParse(value) ?? 0;
      },

    );
  }
}
