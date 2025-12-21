import '../../../data/apis/transaction/transaction_history_api.dart';
import '../../../data/models/transaction/transaction_history_model.dart';

class TransactionHistoryFacade {
  final TransactionHistoryApi api;

  TransactionHistoryFacade(this.api);

  Future<List<TransactionHistoryModel>> fetchMyTransactions() async {
    final response = await api.getMyTransactions();
    final List items = response['items'];

    return items
        .map((e) => TransactionHistoryModel.fromJson(e))
        .toList();
  }

  Future<Map<String, dynamic>> fetchTransactionDetails(
      String publicId) async {
    final response = await api.getTransactionDetails(publicId);
    return response['data'];
  }
}
