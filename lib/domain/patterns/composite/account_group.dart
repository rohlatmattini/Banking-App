import '../../entities/account_entity.dart';
import 'account_component.dart';

class AccountGroup implements AccountComponent {
  final List<AccountComponent> _children = [];
  final AccountEntity groupAccount;

  AccountGroup(this.groupAccount);

  void add(AccountComponent child) {
    _children.add(child);
  }

  void remove(AccountComponent child) {
    _children.remove(child);
  }

  @override
  String publicId() {
    return groupAccount.publicId;
  }

  @override
  String type() {
    return groupAccount.type.value;
  }

  @override
  String state() {
    return groupAccount.state.name;
  }

  @override
  String balance() {
    return groupAccount.balance.toStringAsFixed(2);
  }

  @override
  String totalBalance() {
    double sum = 0;
    for (var child in _children) {
      sum += double.parse(child.totalBalance());
    }
    return sum.toStringAsFixed(2);
  }

  @override
  List<AccountComponent> children() {
    return List.from(_children);
  }
}