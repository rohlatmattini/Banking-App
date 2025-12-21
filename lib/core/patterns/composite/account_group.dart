import 'account_component.dart';

class AccountGroup extends AccountComponent {
  @override
  final String id;
  @override
  final String name;
  @override
  final double balance;
  @override
  final String type;
  @override
  final String state;

  final List<AccountComponent> _children = [];

  AccountGroup({
    required this.id,
    required this.name,
    required this.balance,
    required this.type,
    required this.state,
  });

  @override
  List<AccountComponent> get children => _children;

  @override
  void add(AccountComponent child) {
    _children.add(child);
  }

  @override
  void remove(AccountComponent child) {
    _children.remove(child);
  }

  @override
  void deposit(double amount) {
    for (var child in _children) {
      child.deposit(amount);
    }

    notifier.notifyObservers(
      "Group Deposit",
      "A deposit of $amount was applied to the group",
    );
  }

  @override
  void withdraw(double amount) {
    for (var child in _children) {
      child.withdraw(amount);
    }

    notifier.notifyObservers(
      "Group Withdrawal",
      "A withdrawal of $amount was applied to the group",
    );
  }

}
