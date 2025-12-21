import '../../../data/apis/account/account_api.dart';
import '../composite/account_component.dart';
import '../composite/account_group.dart';
import '../composite/account_leaf.dart';

class AccountFacade {
  final AccountApi api;

  AccountFacade({required this.api});

  Future<List<AccountComponent>> fetchAccounts() async {
    final data = await api.fetchAccountsRaw();

    AccountGroup? rootGroup;
    final List<AccountComponent> result = [];

    for (var item in data) {
      if (item['type'] == 'group') {
        rootGroup = AccountGroup(
          id: item['id'],
          name: 'My Accounts',
          balance: double.parse(item['balance']),
          type: 'group',
            state: item['state'],
        );
        result.add(rootGroup);
        break;
      }
    }

    for (var item in data) {
      if (item['type'] != 'group') {
        final leaf = AccountLeaf(
          id: item['id'],
          name: item['type'],
          balance: double.parse(item['balance']),
          type: item['type'],
            state: item['state'],

        );

        if (rootGroup != null) {
          rootGroup.add(leaf);
        } else {
          result.add(leaf);
        }
      }
    }

    return result;
  }
}
