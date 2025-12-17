import '../enums/account_type_enum.dart';
import '../patterns/states/account_state.dart';


abstract class AccountEntity {
  final int id;
  final String publicId;
  final int userId;
  final int? parentId;
  final AccountTypeEnum type;
  double balance;
  AccountState state;
  final String? dailyLimit;
  final String? monthlyLimit;
  final DateTime? closedAt;
  final DateTime createdAt;
  final DateTime updatedAt;

  AccountEntity({
    required this.id,
    required this.publicId,
    required this.userId,
    this.parentId,
    required this.type,
    required this.balance,
    required this.state,
    this.dailyLimit,
    this.monthlyLimit,
    this.closedAt,
    required this.createdAt,
    required this.updatedAt,
  });

  // Check if account is a group
  bool get isGroup => type == AccountTypeEnum.GROUP;

  // State transition methods (matching backend)
  bool canTransitionTo(String targetState) {
    return state.canTransitionTo(targetState);
  }

  String transitionError(String targetState) {
    return state.transitionError(targetState);
  }

  // Change state with validation
  void changeState(String newState) {
    if (!canTransitionTo(newState)) {
      throw StateError(transitionError(newState));
    }
    // State will be changed by repository
  }

  // Business operations (will be handled by use cases)
  String deposit(double amount) {
    if (!state.canDeposit) {
      throw StateError('لا يمكن الإيداع: الحساب ${state.arabicName}');
    }

    // Update balance
    balance += amount;

    return 'تم إيداع \$${amount.toStringAsFixed(2)} بنجاح';
  }

  String withdraw(double amount) {
    if (!state.canWithdraw) {
      throw StateError('لا يمكن السحب: الحساب ${state.arabicName}');
    }

    if (amount > balance) {
      throw StateError('رصيد غير كافي');
    }

    balance -= amount;
    return 'تم سحب \$${amount.toStringAsFixed(2)} بنجاح';
  }

  // Helper properties for UI
  String get holderName => 'User $userId'; // Would come from user service
  String get status => state.arabicName;
  String get statusColorHex => state.colorHex;

  // Check if account can be deleted (only closed accounts)
  bool get canDelete => state.name == 'closed';
}

// Transaction entity (if needed)
class Transaction {
  final String id;
  final String type; // deposit, withdrawal, transfer
  final double amount;
  final DateTime date;
  final String description;
  final double balanceAfter;

  Transaction({
    required this.id,
    required this.type,
    required this.amount,
    required this.date,
    required this.description,
    required this.balanceAfter,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'type': type,
      'amount': amount,
      'date': date.toIso8601String(),
      'description': description,
      'balanceAfter': balanceAfter,
    };
  }

  factory Transaction.fromJson(Map<String, dynamic> json) {
    return Transaction(
      id: json['id'],
      type: json['type'],
      amount: json['amount'].toDouble(),
      date: DateTime.parse(json['date']),
      description: json['description'],
      balanceAfter: json['balanceAfter'].toDouble(),
    );
  }
}