import '../../../data/apis/transaction/transaction_api.dart';
import '../../../data/models/transaction/transaction_model.dart';
import '../../../data/models/transaction/transaction_request.dart';

class TransactionFacade {
  final TransactionApi api;

  TransactionFacade({required this.api});

  Future<TransactionModel> transfer(TransferRequest request) async {
    print('=== TransactionFacade: Starting Transfer ===');

    try {
      final responseData = await api.transfer(request);

      print('=== TransactionFacade: API Response ===');
      print('Response Data: $responseData');

      // إنشاء TransactionModel من الرد
      return TransactionModel.fromJson({
        ...responseData,
        'fromAccount': request.sourceAccountId,
        'toAccount': request.destinationAccountId,
        'amount': request.amount,
        'type': 'Transfer',
        'description': request.description,
        'date': DateTime.now().toIso8601String(),
      });
    } catch (e) {
      print('=== TransactionFacade: Error ===');
      print('Error: $e');
      rethrow;
    }
  }
}