import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../core/patterns/composite/account_leaf.dart';
import '../../../../core/utils/custom_text_form_field.dart';
import '../../../home/controller/home_page_controller.dart';
import '../../../payment/controller/payment_controller.dart';
import '../../controller/transaction_controller.dart';
import '../submit_button.dart';

class ExternalTransferForm extends StatelessWidget {
  const ExternalTransferForm({super.key});

  @override
  Widget build(BuildContext context) {
    final TransactionController controller = Get.find();
    final PaymentController _controller = Get.find<PaymentController>();
    final homeController = Get.find<HomePageController>();

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
         Obx(()=> CustomTextFormField<AccountLeaf>(
            isExpanded: true,
            label: 'Select Account',
            hint: 'Choose account',
            prefixIcon: Icons.account_balance,
            dropdownItems: homeController.accounts
                .expand((group) => group.children) // نحصل على الـ leaves فقط
                .map((accountLeaf) => DropdownMenuItem<AccountLeaf>(
              value: AccountLeaf(
                id: accountLeaf.id,
                name: accountLeaf.name,
                // number: accountLeaf.id, // أو رقم فعلي لو موجود
                balance: accountLeaf.balance,
                type: accountLeaf.type,
                state: accountLeaf.state,
                // currency: '\$',
                // icon: 'default',
              ),
              child: Text('${accountLeaf.name} (${accountLeaf.id})'),
            ))
                .toList(),
            onDropdownChanged: (account) {
              if (account != null) {
                controller.selectedFromAccount.value = account.id;
                // _controller.accountController.text = account.id;
              }
            },
          ),
         ),
          SizedBox(height: 15,),
          // Recipient Name
          // CustomTextFormField(
          //   label: 'Recipient Name',
          //   hint: 'Enter recipient name',
          //   prefixIcon: Icons.person,
          //   onChanged: (value) => controller.externalAccountName.value = value,
          // ),
          // SizedBox(height: 15,),
          // Account Number
          CustomTextFormField(
            label: 'Account Number',
            hint: 'Enter account number',
            prefixIcon: Icons.numbers,
            keyboardType: TextInputType.number,
            onChanged: (value) => controller.externalAccountNumber.value = value,
          ),
          SizedBox(height: 15,),

          // Amount
          CustomTextFormField(
            label: 'Amount',
            hint: 'Enter amount',
            prefixIcon: Icons.monetization_on,
            keyboardType: TextInputType.number,
            onChanged: (value) {
              controller.amount.value = double.tryParse(value) ?? 0;
            },

            // onChanged: (value) => controller.setAmount(value),
          ),

          const SizedBox(height: 24),

          // Transfer Type Selector
          // ExternalTransferTypeSelector(controller: controller),

          const SizedBox(height: 16),

          // Transfer Purpose (multiline)
          CustomTextFormField(
            label: 'Transfer Purpose',
            hint: 'Enter transfer purpose',
            prefixIcon: Icons.description,
            maxLines: 3, // 👈 بدل الـ MultilineField
            onChanged: (value) => controller.transactionDescription.value = value,
          ),

          const SizedBox(height: 32),

          // Submit Button
          SubmitButton(
            text: 'Complete External Transfer',
            onPressed: controller.makeExternalTransfer,
          ),
        ],
      ),
    );
  }
}
