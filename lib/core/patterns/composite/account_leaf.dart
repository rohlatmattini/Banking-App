import 'account_component.dart';

class AccountLeaf extends AccountComponent {
  @override
  String id;
  @override
  String name;
  @override
  double balance;
  @override
  String type;
  @override
  String state;


  AccountLeaf({
    required this.id,
    required this.name,
    required this.balance,
    required this.type,
    required this.state,
  });

  @override
  void deposit(double amount) {
    balance += amount;

    // إشعار تغيّر الرصيد
    notifier.notifyObservers(
      "Balance Updated",
      "Your new balance is $balance",
    );

    // إشعار عملية كبيرة
    if (amount >= 1000) {
      notifier.notifyObservers(
        "Large Transaction Alert",
        "A large deposit of $amount was made",
      );
    }
  }

  @override
  void withdraw(double amount) {
    balance -= amount;

    notifier.notifyObservers(
      "Balance Updated",
      "Your new balance is $balance",
    );

    if (amount >= 1000) {
      notifier.notifyObservers(
        "Large Transaction Alert",
        "A large withdrawal of $amount was made",
      );
    }
  }
}