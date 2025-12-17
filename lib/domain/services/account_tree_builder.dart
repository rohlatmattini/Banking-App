import '../entities/account_entity.dart';
import '../patterns/composite/account_group.dart';
import '../patterns/composite/account_leaf.dart';
import '../enums/account_type_enum.dart';

class AccountTreeBuilder {
  /// Build account tree for a user
  AccountGroup buildForUser(List<AccountEntity> accounts) {
    final groupEntity = findGroupEntity(accounts);
    final group = AccountGroup(groupEntity);

    for (var account in accounts) {
      if (account.type == AccountTypeEnum.GROUP) {
        continue;
      }

      if (account.parentId == groupEntity.id) {
        group.add(AccountLeaf(account));
      }
    }

    return group;
  }

  /// Find the group account for a user
  AccountEntity findGroupEntity(List<AccountEntity> accounts) {
    for (var account in accounts) {
      if (account.type == AccountTypeEnum.GROUP && account.parentId == null) {
        return account;
      }
    }

    throw Exception('لا يوجد حساب Group للمستخدم. يجب إنشاؤه تلقائيًا عند أول عملية.');
  }
}