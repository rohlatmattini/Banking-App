class TransactionModel {
  final String id;
  final String fromAccount;
  final String toAccount;
  final double amount;
  final String type;
  final DateTime date;
  final String? description;
  final String? status; // <-- أضف هذا
  final String? message; // <-- أضف هذا

  TransactionModel({
    required this.id,
    required this.fromAccount,
    required this.toAccount,
    required this.amount,
    required this.type,
    required this.date,
    this.description,
    this.status,
    this.message,
  });

  factory TransactionModel.fromJson(Map<String, dynamic> json) {
    return TransactionModel(
      id: json['transaction_public_id'] ?? json['id'],
      fromAccount: json['fromAccount'] ?? '',
      toAccount: json['toAccount'] ?? '',
      amount: (json['amount'] ?? 0.0).toDouble(),
      type: json['type'] ?? 'Transfer',
      date: DateTime.parse(json['date'] ?? DateTime.now().toIso8601String()),
      description: json['description'],
      status: json['status'],
      message: json['message'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'fromAccount': fromAccount,
      'toAccount': toAccount,
      'amount': amount,
      'type': type,
      'date': date.toIso8601String(),
      'description': description,
      'status': status,
      'message': message,
    };
  }
}