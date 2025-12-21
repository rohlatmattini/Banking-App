import '../../../data/models/transaction/transaction_request.dart';
//
// abstract class ApprovalHandler {
//   ApprovalHandler? nextHandler;
//
//   void setNext(ApprovalHandler handler) {
//     nextHandler = handler;
//   }
//
//   Future<ApprovalResult> handle(TransferRequest request);
//
//   Future<ApprovalResult> passToNext(TransferRequest request) async {
//     if (nextHandler != null) {
//       return await nextHandler!.handle(request);
//     }
//
//     return ApprovalResult(
//       isApproved: true,
//       message: 'Auto-approved',
//       approvedBy: 'System',
//     );
//   }
// }
//
//
class ApprovalResult {
  final bool isApproved;
  final String message;
  final String approvedBy;
  final DateTime timestamp;

  ApprovalResult({
    required this.isApproved,
    required this.message,
    required this.approvedBy,
  }) : timestamp = DateTime.now();
}

// // Handler للتحويلات الصغيرة
// class SmallAmountHandler extends ApprovalHandler {
//   final double maxAmount;
//
//   SmallAmountHandler({this.maxAmount = 1000});
//
//   @override
//   Future<ApprovalResult> handle(TransferRequest request) async {
//     if (request.amount <= maxAmount) {
//       print('✅ SmallAmountHandler: Transaction approved (amount: \$${request.amount})');
//       return ApprovalResult(
//         isApproved: true,
//         message: 'Auto-approved - amount within limit',
//         approvedBy: 'SmallAmountHandler',
//       );
//     }
//
//     print('➡️ SmallAmountHandler: Passing to next handler (amount: \$${request.amount})');
//     return passToNext(request);
//   }
// }
//
// // // Handler للتحويلات المتوسطة
// // class ManagerApprovalHandler extends ApprovalHandler {
// //   final double maxAmount;
// //
// //   ManagerApprovalHandler({this.maxAmount = 10000});
// //
// //   @override
// //   Future<ApprovalResult> handle(TransferRequest request) async {
// //     if (request.amount <= maxAmount) {
// //       // هنا بتظهر رسالة إنه لازم موافقة المدير
// //       print('⏳ ManagerApprovalHandler: Requires manager approval');
// //       return ApprovalResult(
// //         isApproved: false, // مش approved لحد ما المدير يوافق
// //         message: 'Pending manager approval',
// //         approvedBy: 'Pending',
// //       );
// //     }
// //
// //     print('➡️ ManagerApprovalHandler: Passing to next handler (large amount: \$${request.amount})');
// //     return passToNext(request);
// //   }
// // }
//
// // Handler للتحويلات الكبيرة
// class AdminApprovalHandler extends ApprovalHandler {
//   @override
//   Future<ApprovalResult> handle(TransferRequest request) async {
//     print('⚠️ AdminApprovalHandler: Requires admin approval');
//     return ApprovalResult(
//       isApproved: false,
//       message: 'Pending admin approval - large transaction detected',
//       approvedBy: 'Pending',
//     );
//   }
// }

abstract class ApprovalHandler {
  ApprovalHandler? nextHandler;

  void setNext(ApprovalHandler handler) {
    nextHandler = handler;
  }

  Future<ApprovalResult> handle(TransferRequest request);

  Future<ApprovalResult> passToNext(TransferRequest request) async {
    if (nextHandler != null) {
      return await nextHandler!.handle(request);
    }

    return ApprovalResult(
      isApproved: true,
      message: 'Auto-approved',
      approvedBy: 'System',
    );
  }
}

// تعديل Handlers للإشعار فقط
class SmallAmountHandler extends ApprovalHandler {
  final double maxAmount;

  SmallAmountHandler({this.maxAmount = 1000});

  @override
  Future<ApprovalResult> handle(TransferRequest request) async {
    if (request.amount <= maxAmount) {
      return ApprovalResult(
        isApproved: true,
        message: 'Transaction will be processed immediately',
        approvedBy: 'System',
      );
    }

    return passToNext(request);
  }
}

class AdminApprovalHandler extends ApprovalHandler {
  @override
  Future<ApprovalResult> handle(TransferRequest request) async {
    // هذا للإشعار فقط، لا يمنع الإرسال
    return ApprovalResult(
      isApproved: false,
      message: 'Transaction requires admin approval. It has been submitted and is pending review.',
      approvedBy: 'Pending',
    );
  }
}