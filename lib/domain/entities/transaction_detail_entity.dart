// lib/domain/entities/transaction_detail_entity.dart
import 'package:bankingplatform/domain/entities/transaction_entity.dart';

import 'ledger_entry_entity.dart';

class TransactionDetailEntity extends TransactionEntity {
  final List<LedgerEntryEntity> ledgerEntries;
  final dynamic approval; // Can be null or approval data

  TransactionDetailEntity({
    required super.publicId,
    required super.type,
    required super.status,
    required super.amount,
    required super.currency,
    required super.description,
    required super.postedAt,
    required super.createdAt,
    super.sourceAccountId,
    super.destinationAccountId,
    required super.initiatorUserId,
    required this.ledgerEntries,
    this.approval,
  });
}