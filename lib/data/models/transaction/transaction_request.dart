class TransferRequest {
  final String sourceAccountId;
  final String destinationAccountId;
  final double amount;
  final String? description;

  TransferRequest({
    required this.sourceAccountId,
    required this.destinationAccountId,
    required this.amount,
    this.description,
  });

  Map<String, dynamic> toJson() {
    return {
      "source_account_public_id": sourceAccountId,
      "destination_account_public_id": destinationAccountId,
      "amount": amount,
      "description": description ?? '',
    };
  }
}