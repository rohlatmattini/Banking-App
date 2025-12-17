import '../../entities/account_entity.dart';
import 'account_component.dart';

class AccountLeaf implements AccountComponent {
  final AccountEntity account;

  AccountLeaf(this.account);

  @override
  String publicId() {
    return account.publicId;
  }

  @override
  String type() {
    return account.type.value;
  }

  @override
  String state() {
    return account.state.name;
  }

  @override
  String balance() {
    return account.balance.toStringAsFixed(2);
  }

  @override
  String totalBalance() {
    return account.balance.toStringAsFixed(2);
  }

  @override
  List<AccountComponent> children() {
    return [];
  }
}