import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../core/constants/app_color.dart';
import '../../../../core/patterns/composite/account_leaf.dart';
import '../../../../core/patterns/strategy/payment_strategy.dart';
import '../../../../core/utils/custom_text_form_field.dart';
import '../../../home/controller/home_page_controller.dart';
import '../../controller/payment_controller.dart';

class AddPaymentPage extends StatelessWidget {
  AddPaymentPage({Key? key}) : super(key: key);

  final PaymentController _controller = Get.find<PaymentController>();
  final HomePageController _homeController = Get.find<HomePageController>();

  List<AccountLeaf> get accounts =>
      _homeController.accounts.expand((g) => g.children).whereType<AccountLeaf>().toList();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Schedule New Transfer',
          style: TextStyle(color: AppColor.white),
        ),
        backgroundColor: AppColor.darkgreen,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: GlobalKey<FormState>(),
          child: Obx(
                () => Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // ===== Description =====
                CustomTextFormField(
                  label: 'Description',
                  hint: 'Enter description',
                  controller: _controller.titleController,
                  onChanged: _controller.setTitle,
                  validator: (v) => RequiredFieldValidationStrategy(fieldName: 'Description').validate(v),
                ),
                const SizedBox(height: 16),

                // ===== Transaction Type =====
                CustomTextFormField<TransactionType>(
                  isExpanded: true,
                  label: 'Transaction Type',
                  hint: 'Select transaction type',
                  prefixIcon: Icons.swap_horiz,
                  dropdownValue: _controller.selectedTransactionType.value,
                  dropdownItems: TransactionType.values
                      .map((type) => DropdownMenuItem<TransactionType>(
                    value: type,
                    child: Text(_getTypeLabel(type)),
                  ))
                      .toList(),
                  onDropdownChanged: _controller.setTransactionType,
                  validator: (v) => RequiredFieldValidationStrategy(fieldName: 'Transaction Type').validate(v != null ? _getTypeLabel(v as TransactionType) : null),
                ),
                const SizedBox(height: 16),

                // ===== Source Account =====
                CustomTextFormField<String>(
                  isExpanded: true,
                  label: 'Source Account',
                  hint: 'Select source account',
                  prefixIcon: Icons.account_balance,
                  dropdownValue: _controller.selectedSourceAccount.value,
                  dropdownItems: _getAccountDropdownItems(),
                  onDropdownChanged: _controller.setSourceAccount,
                  validator: (v) => RequiredFieldValidationStrategy(fieldName: 'Source Account').validate(v),
                ),
                const SizedBox(height: 16),

                // ===== Destination Account (Transfer Only) =====
                if (_controller.selectedTransactionType.value == TransactionType.transfer)
                  CustomTextFormField<String>(
                    isExpanded: true,
                    label: 'Destination Account',
                    hint: 'Select destination account',
                    prefixIcon: Icons.account_balance_wallet,
                    dropdownValue: _controller.selectedDestinationAccount.value,
                    dropdownItems: _getAccountDropdownItems(
                        exclude: _controller.selectedSourceAccount.value),
                    onDropdownChanged: _controller.setDestinationAccount,
                    validator: (v) => RequiredFieldValidationStrategy(fieldName: 'Destination Account').validate(v),
                  ),
                const SizedBox(height: 16),

                // ===== Amount =====
                CustomTextFormField(
                  label: 'Amount',
                  hint: 'Enter amount',
                  prefixIcon: Icons.monetization_on,
                  controller: _controller.amountController,
                  onChanged: _controller.setAmount,
                  keyboardType: TextInputType.number,
                  validator: (v) {
                    final requiredCheck = RequiredFieldValidationStrategy(fieldName: 'Amount').validate(v);
                    if (requiredCheck != null) return requiredCheck;
                    return AmountValidationStrategy().validate(v);
                  },
                ),
                const SizedBox(height: 16),

                // ===== Frequency =====
                CustomTextFormField<String>(
                  isExpanded: true,
                  label: 'Frequency',
                  hint: 'Select frequency',
                  prefixIcon: Icons.repeat,
                  dropdownValue: _controller.selectedFrequency.value,
                  dropdownItems: const [
                    DropdownMenuItem(value: 'daily', child: Text('Daily')),
                    DropdownMenuItem(value: 'weekly', child: Text('Weekly')),
                    DropdownMenuItem(value: 'monthly', child: Text('Monthly')),
                  ],
                  onDropdownChanged: (value) {
                    if (value != null) _controller.setFrequency(value);
                  },
                  validator: (v) => RequiredFieldValidationStrategy(fieldName: 'Frequency').validate(v),
                ),
                const SizedBox(height: 16),

                // ===== Day of Month =====
                if (_controller.selectedFrequency.value == 'monthly')
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Day of Month',
                        style: TextStyle(
                            fontSize: 14, fontWeight: FontWeight.bold, color: Colors.grey),
                      ),
                      SliderTheme(
                        data: SliderTheme.of(context).copyWith(
                          activeTrackColor: AppColor.darkgreen,
                          thumbColor: AppColor.darkgreen,
                          overlayColor: Colors.blue.withOpacity(0.2),
                          trackHeight: 4,
                        ),
                        child: Slider(
                          value: _controller.selectedDayOfMonth.value.toDouble(),
                          min: 1,
                          max: 31,
                          divisions: 30,
                          label: _controller.selectedDayOfMonth.value.toString(),
                          onChanged: (value) {
                            _controller.setDayOfMonth(value.toInt());
                          },
                        ),
                      ),
                      Text(
                        'Selected day: ${_controller.selectedDayOfMonth.value}',
                        style: const TextStyle(
                            fontWeight: FontWeight.bold, color: AppColor.darkgreen),
                      ),
                    ],
                  ),
                const SizedBox(height: 24),

                // ===== Save Button =====
                ElevatedButton(
                  onPressed: () => _controller.saveTransfer(),
                  style: ElevatedButton.styleFrom(
                      backgroundColor: AppColor.darkgreen,
                      padding: const EdgeInsets.symmetric(vertical: 16)),
                  child: const Text(
                    'Schedule Transfer',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  String _getTypeLabel(TransactionType type) {
    switch (type) {
      case TransactionType.transfer:
        return 'Transfer';
      case TransactionType.withdraw:
        return 'Withdraw';
      case TransactionType.deposit:
        return 'Deposit';
    }
  }

  List<DropdownMenuItem<String>> _getAccountDropdownItems({String? exclude}) {
    final items = accounts
        .where((leaf) => leaf.id != exclude && leaf.id != null && leaf.id!.isNotEmpty)
        .map((leaf) => DropdownMenuItem<String>(
      value: leaf.id!,
      child: Text('${leaf.name} - ${leaf.balance}'),
    ))
        .toList();
    return items;
  }
}