import 'package:flutter/material.dart';
import '../../domain/entities/account_entity.dart';
import '../../domain/patterns/states/account_state.dart';

class StateHelper {
  static Color hexToColor(String hexColor) {
    hexColor = hexColor.replaceAll("#", "");
    if (hexColor.length == 6) {
      hexColor = "FF$hexColor";
    }
    return Color(int.parse(hexColor, radix: 16));
  }

  static IconData getIconForState(AccountState state) {
    switch (state.name) {
      case 'active':
        return Icons.check_circle;
      case 'frozen':
        return Icons.ac_unit;
      case 'suspended':
        return Icons.pause_circle;
      case 'closed':
        return Icons.cancel;
      default:
        return Icons.error;
    }
  }

  static Color getColorForState(AccountState state) {
    return hexToColor(state.colorHex);
  }

  static Color getColorForType(AccountEntity account) {
    return hexToColor(account.type.colorHex);
  }

  static IconData getIconForType(AccountEntity type) {
    switch (type.type.value) {
      case 'savings':
        return Icons.savings;
      case 'checking':
        return Icons.account_balance;
      case 'loan':
        return Icons.money;
      case 'investment':
        return Icons.trending_up;
      case 'group':
        return Icons.account_balance_wallet;
      default:
        return Icons.account_balance_wallet;
    }
  }



}