import '../observer/notification_subject.dart';

abstract class AccountComponent {
  String get id;
  String get name;
  double get balance;
  String get type;
  String get state;

  final NotificationSubject notifier = NotificationSubject();

  List<AccountComponent> get children => [];

  void deposit(double amount);
  void withdraw(double amount);

  void add(AccountComponent component) {
    throw UnsupportedError('Cannot add to a leaf');
  }

  void remove(AccountComponent component) {
    throw UnsupportedError('Cannot remove from a leaf');
  }
}
