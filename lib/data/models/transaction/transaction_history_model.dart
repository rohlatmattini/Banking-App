class TransactionHistoryModel {
  final String publicId;
  final String type;
  final String status;
  final String amount;
  final String currency;
  final String createdAt;

  TransactionHistoryModel({
    required this.publicId,
    required this.type,
    required this.status,
    required this.amount,
    required this.currency,
    required this.createdAt,
  });

  factory TransactionHistoryModel.fromJson(Map<String, dynamic> json) {
    return TransactionHistoryModel(
      publicId: json['public_id'],
      type: json['type'],
      status: json['status'],
      amount: json['amount'],
      currency: json['currency'],
      createdAt: json['created_at'],
    );
  }
}
