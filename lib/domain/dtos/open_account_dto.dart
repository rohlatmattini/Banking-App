import '../enums/account_type_enum.dart';

class OpenAccountData {
  final AccountTypeEnum type;
  final String? dailyLimit;
  final String? monthlyLimit;

  OpenAccountData({
    required this.type,
    this.dailyLimit,
    this.monthlyLimit,
  });
}