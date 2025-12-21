// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
//
// import '../../../core/constants/app_color.dart';
// import '../controller/transaction_controller.dart';
//
// class TransactionTypeSelector extends StatelessWidget {
//   final TransactionController controller;
//
//   const TransactionTypeSelector({
//     super.key,
//     required this.controller,
//   });
//
//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         const Text(
//           'Transaction Type',
//           style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
//         ),
//         const SizedBox(height: 12),
//         Wrap(
//           spacing: 8,
//           runSpacing: 8,
//           children: TransactionController.transactionTypes.map((type) {
//             return Obx(() => ChoiceChip(
//               label: Text(type),
//               selected: controller.transactionType.value == type,
//               onSelected: (selected) {
//                 if (selected) controller.setTransactionType(type);
//               },
//               selectedColor: AppColor.darkgreen,
//               labelStyle: TextStyle(
//                 color: controller.transactionType.value == type
//                     ? AppColor.white
//                     : AppColor.black,
//               ),
//             ));
//           }).toList(),
//         ),
//       ],
//     );
//   }
// }