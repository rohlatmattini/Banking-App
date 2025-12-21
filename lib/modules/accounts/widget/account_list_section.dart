// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import '../../home/controller/home_page_controller.dart';
// import 'account_card.dart';
// import 'account_info_dialog.dart';
//
// class AccountsListSection extends StatelessWidget {
//   const AccountsListSection({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     final HomePageController controller = Get.find<HomePageController>();
//
//     return Padding(
//       padding: const EdgeInsets.all(16),
//       child: Obx(() =>
//           Column(
//             children: controller.accounts
//                 .map((account) =>
//                 AccountCard(
//                   accountName: account.name,
//                   accountNumber: account.number,
//                   balance: account.balance,
//                   currency: account.currency,
//                   accountType: account.type,
//                   icon: controller.getIconFromCode(account.icon),
//                   onTap: () =>AccountInfoDialog.show(
//                     context: context, // ← مهم: تمرير context
//                     accountName: account.name,
//                     accountNumber: account.number,
//                     balance: account.balance,
//                     currency: account.currency,
//                     accountType: account.type,
//                     icon: controller.getIconFromCode(account.icon),
//                   ),
//                 ))
//                 .toList(),
//           )),
//     );
//   }
//
//
// }


// accounts_list_section.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/patterns/composite/account_component.dart';
import '../../home/controller/home_page_controller.dart';
import 'account_card.dart';
import 'account_info_dialog.dart';
class AccountsListSection extends StatelessWidget {
  const AccountsListSection({super.key});

  Widget buildAccount(AccountComponent account, HomePageController controller) {
    // حساب عادي (Leaf)
    if (account.children.isEmpty) {
      return AccountCard(
        accountName: account.name,
        accountNumber: account.id,
        balance: account.balance,
        currency: '\$',
        accountType: account.type,
        icon: controller.getIconFromType(account.type),
        onTap: () => AccountInfoDialog.show(
          context: Get.context!,
          accountName: account.name,
          accountNumber: account.id,
          balance: account.balance,
          state: account.state,
          currency: '\$',
          accountType: account.type,
          icon: controller.getIconFromType(account.type),
        ),
      );
    }

    return Padding(
      padding: const EdgeInsets.all(15),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: account.children
            .map((child) => buildAccount(child, controller))
            .toList(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<HomePageController>();

    return Obx(() {
      if (controller.isLoading.value) {
        return const Center(child: CircularProgressIndicator());
      }

      return Column(
        children: controller.accounts
            .map((account) => buildAccount(account, controller))
            .toList(),
      );
    });
  }
}
