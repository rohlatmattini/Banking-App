import 'customer_dto.dart';
import 'open_account_dto.dart';

class OnboardCustomerData {
  final CustomerData customer;
  final List<OpenAccountData> accounts;

  OnboardCustomerData({
    required this.customer,
    required this.accounts,
  });
}