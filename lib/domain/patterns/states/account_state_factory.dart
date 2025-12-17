import 'account_state.dart';
import 'active_state.dart';
import 'frozen_state.dart';
import 'suspended_state.dart';
import 'closed_state.dart';

class AccountStateFactory {
  static AccountState from(String state) {
    switch (state) {
      case 'active':
        return ActiveState();
      case 'frozen':
        return FrozenState();
      case 'suspended':
        return SuspendedState();
      case 'closed':
        return ClosedState();
      default:
        throw ArgumentError('حالة غير معروفة: $state');
    }
  }
}