// enum PaymentType { transfer, withdraw, deposit }
//
// class PaymentModel {
//   final int id;
//   final String title;
//   final double amount;
//   final DateTime executionDate;
//   final bool isPaid;
//   final PaymentType type;
//   final String accountId;
//   final int? targetAccount; // للـ transfer فقط
//
//   PaymentModel({
//     required this.id,
//     required this.title,
//     required this.amount,
//     required this.executionDate,
//     required this.isPaid,
//     required this.type,
//     required this.accountId,
//     this.targetAccount,
//   });
//
//   factory PaymentModel.fromJson(Map<String, dynamic> json) {
//     return PaymentModel(
//       id: json['id'],
//       title: json['title'],
//       amount: (json['amount'] as num).toDouble(),
//       executionDate: DateTime.parse(json['execution_date']),
//       isPaid: json['is_paid'],
//       type: PaymentType.values.firstWhere(
//             (e) => e.name == json['type'],
//       ),
//       accountId: json['account_id'],
//       targetAccount: json['target_account'],
//     );
//   }
// }
