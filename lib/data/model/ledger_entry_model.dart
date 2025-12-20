// lib/data/model/ledger_entry_model.dart
import '../../domain/entities/ledger_entry_entity.dart';

class LedgerEntryModel extends LedgerEntryEntity {
  LedgerEntryModel({
    required super.accountPublicId,
    required super.direction,
    required super.amount,
    required super.currency,
    required super.balanceBefore,
    required super.balanceAfter,
    required super.createdAt,
  });

  factory LedgerEntryModel.fromJson(Map<String, dynamic> json) {
    return LedgerEntryModel(
      accountPublicId: json['account_public_id'] as String,
      direction: EntryDirection.fromValue(json['direction'] as String),
      amount: double.tryParse(json['amount']?.toString() ?? '0') ?? 0.0,
      currency: json['currency'] as String? ?? 'USD',
      balanceBefore: double.tryParse(json['balance_before']?.toString() ?? '0') ?? 0.0,
      balanceAfter: double.tryParse(json['balance_after']?.toString() ?? '0') ?? 0.0,
      createdAt: DateTime.parse(json['created_at'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'account_public_id': accountPublicId,
      'direction': direction.value,
      'amount': amount,
      'currency': currency,
      'balance_before': balanceBefore,
      'balance_after': balanceAfter,
      'created_at': createdAt.toIso8601String(),
    };
  }
}