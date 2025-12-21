// // core/patterns/chain/transaction_approval_chain.dart
// import 'approval_handler.dart';
// import '../../../data/models/transaction/transaction_request.dart';
// import '../../../data/models/transaction/transaction_request.dart';
//
//
// class TransactionApprovalChain {
//   final ApprovalHandler _chain;
//
//   TransactionApprovalChain()
//       : _chain = SmallAmountHandler(maxAmount: 1000)
//     // ..setNext(ManagerApprovalHandler(maxAmount: 10000))
//     ..setNext(AdminApprovalHandler());
//
//   Future<ApprovalResult> processRequest(TransferRequest request) async {
//     print('🔗 Starting approval chain for transaction...');
//     print('Amount: \$${request.amount}');
//     print('Description: ${request.description}');
//
//     final result = await _chain.handle(request);
//
//     print('📋 Approval Result:');
//     print('  Approved: ${result.isApproved}');
//     print('  Message: ${result.message}');
//     print('  By: ${result.approvedBy}');
//     print('  Time: ${result.timestamp}');
//
//     return result;
//   }
//
//   // دالة لمحاكاة موافقة المدير
//   Future<ApprovalResult> simulateManagerApproval(TransferRequest request) async {
//     print('👔 Manager approving transaction...');
//     return ApprovalResult(
//       isApproved: true,
//       message: 'Approved by branch manager',
//       approvedBy: 'Manager',
//     );
//   }
//
//   // دالة لمحاكاة موافقة الادمن
//   Future<ApprovalResult> simulateAdminApproval(TransferRequest request) async {
//     print('👑 Admin approving transaction...');
//     return ApprovalResult(
//       isApproved: true,
//       message: 'Approved by system administrator',
//       approvedBy: 'Admin',
//     );
//   }
// }

// core/patterns/chain/transaction_approval_chain.dart
import '../../../data/models/transaction/transaction_request.dart';
import 'approval_handler.dart';

class TransactionApprovalChain {
  final ApprovalHandler _chain;

  TransactionApprovalChain()
      : _chain = SmallAmountHandler(maxAmount: 1000)
    ..setNext(AdminApprovalHandler());

  // هذه الدالة للإشعارات فقط، لا تمنع الإرسال
  Future<ApprovalResult> checkForNotifications(TransferRequest request) async {
    print('🔗 Checking approval chain for notifications...');
    print('Amount: \$${request.amount}');
    print('Description: ${request.description}');

    final result = await _chain.handle(request);

    print('📋 Notification Check Result:');
    print('  Approved: ${result.isApproved}');
    print('  Message: ${result.message}');

    return result;
  }
}