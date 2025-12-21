import 'notification_observer.dart';

class NotificationSubject {
  final List<NotificationObserver> _observers = [];

  void addObserver(NotificationObserver observer) {
    _observers.add(observer);
  }

  void removeObserver(NotificationObserver observer) {
    _observers.remove(observer);
  }

  void notifyObservers(String title, String message) {
    for (final observer in _observers) {
      observer.onNotify(title, message);
    }
  }
}
