import 'dart:ui';
import 'package:flutter/material.dart';
import '../../../data/models/transaction/transaction_history_model.dart';

class TransactionCard extends StatelessWidget {
  final TransactionHistoryModel transaction;
  final VoidCallback onTap;

  const TransactionCard({
    super.key,
    required this.transaction,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        title: Text('${transaction.amount} ${transaction.currency}'),
        subtitle: Text(transaction.createdAt),
        trailing: Text(transaction.status),
        onTap: onTap,
      ),
    );
  }
}
