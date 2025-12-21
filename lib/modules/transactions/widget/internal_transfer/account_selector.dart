import 'package:banking_system/core/patterns/composite/account_component.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../core/patterns/composite/account_leaf.dart';
import '../../../../core/utils/custom_text_form_field.dart';
import '../../../home/controller/home_page_controller.dart';
import '../../../payment/controller/payment_controller.dart';
import '../../controller/transaction_controller.dart';

class AccountSelector extends StatelessWidget {
  final HomePageController homeController;
  final TransactionController transactionController;


  const AccountSelector({
    required this.homeController,
    required this.transactionController,
  });

  @override
  Widget build(BuildContext context) {
    final PaymentController _controller = Get.find<PaymentController>();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(height: 10,),
       Obx(()=> CustomTextFormField<AccountLeaf>(
          isExpanded: true,
          label: 'From Account',
          hint: 'Select Account',
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
              state: accountLeaf.state
              // currency: '\$',
              // icon: 'default',
            ),
            child: Text('${accountLeaf.name} (${accountLeaf.id})'),
          ))
              .toList(),

          onDropdownChanged: (account) {
            if (account != null) {
              transactionController.selectedFromAccount.value = account.id;
              // _controller.accountController.text = account.id;
            }
          },
       )
        ),
        SizedBox(height: 30,),
        Obx(()=>CustomTextFormField<AccountLeaf>(
          isExpanded: true,
          label: 'To Account',
          hint: 'Select Account',
          prefixIcon: Icons.call_received,
          dropdownItems: homeController.accounts
              .expand((group) => group.children) // نحصل على الـ leaves فقط
              .map((accountLeaf) => DropdownMenuItem<AccountLeaf>(
            value: AccountLeaf(
                id: accountLeaf.id,
                name: accountLeaf.name,
                // number: accountLeaf.id, // أو رقم فعلي لو موجود
                balance: accountLeaf.balance,
                type: accountLeaf.type,
                state: accountLeaf.state
              // currency: '\$',
              // icon: 'default',
            ),
            child: Text('${accountLeaf.name} (${accountLeaf.id})'),
          ))
              .toList(),

          onDropdownChanged: (account) {
            if (account != null) {
              transactionController.selectedToAccount.value = account.id;
              // _controller.accountController.text = account.id;
            }
          },
        ),)
      ],
    );
  }
}