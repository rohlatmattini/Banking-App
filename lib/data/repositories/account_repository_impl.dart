// import '../../domain/repositories/account_repository.dart';
// import '../../domain/entities/account_entity.dart';
// import '../../domain/enums/account_type_enum.dart';
// import '../datasource/api_account_data_source.dart';
// import '../model/account_model.dart';
//
// class AccountRepositoryImpl implements AccountRepository {
//   final ApiAccountDataSource dataSource;
//
//   AccountRepositoryImpl({required this.dataSource});
//
//   @override
//   Future<AccountEntity?> findUserGroup(int userId) async {
//     final accounts = await dataSource.fetchAccounts();
//     for (var account in accounts) {
//       if (account.type == AccountTypeEnum.GROUP && account.parentId == null) {
//         return account;
//       }
//     }
//     return null;
//   }
//
//   @override
//   Future<AccountEntity> createGroup(int userId) async {
//     // Note: Group creation is typically handled by backend
//     // This is a simplified version
//     final newAccount = AccountModel.createNew(
//       userId: userId,
//       type: AccountTypeEnum.GROUP,
//     );
//
//     return await dataSource.createAccount(newAccount);
//   }
//
//   @override
//   Future<AccountEntity> createChildAccount({
//     required int userId,
//     required int groupId,
//     required AccountTypeEnum type,
//     String? dailyLimit,
//     String? monthlyLimit,
//   }) async {
//     return await dataSource.createChildAccount(
//       userId: userId,
//       groupId: groupId,
//       type: type,
//       dailyLimit: dailyLimit,
//       monthlyLimit: monthlyLimit,
//     );
//   }
//
//   @override
//   Future<List<AccountEntity>> listByUser(int userId) async {
//     final accounts = await dataSource.fetchAccounts();
//     return accounts.where((account) => account.userId == userId).toList();
//   }
//
//   @override
//   Future<AccountEntity?> findByPublicId(String publicId) async {
//     return await dataSource.fetchAccount(publicId);
//   }
//
//   @override
//   Future<AccountEntity> updateStateByPublicId(
//       String publicId,
//       String newState,
//       ) async {
//     return await dataSource.updateState(publicId, newState);
//   }
// }



import '../../domain/repositories/account_repository.dart';
import '../../domain/entities/account_entity.dart';
import '../../domain/enums/account_type_enum.dart';
import '../datasource/api_account_data_source.dart';
import '../model/account_model.dart';

class AccountRepositoryImpl implements AccountRepository {
  final ApiAccountDataSource dataSource;

  AccountRepositoryImpl({required this.dataSource});

  @override
  Future<AccountEntity> createUserAccount({
    required int userId,
    required AccountTypeEnum type,
    String? dailyLimit,
    String? monthlyLimit,
  }) async {
    return await dataSource.createUserAccount(
      userId: userId,
      type: type,
      dailyLimit: dailyLimit,
      monthlyLimit: monthlyLimit,
    );
  }

  @override
  Future<List<AccountEntity>> listByUser(int userId) async {
    final accounts = await dataSource.fetchAccounts();
    return accounts.where((account) => account.userId == userId).toList();
  }

  @override
  Future<AccountEntity?> findByPublicId(String publicId) async {
    return await dataSource.fetchAccount(publicId);
  }

  @override
  Future<AccountEntity> updateStateByPublicId(
      String publicId,
      String newState,
      ) async {
    // استدعاء API تغيير الحالة
    return await dataSource.updateState(publicId, newState);
  }



  @override
  Future<AccountEntity?> findUserGroup(int userId) async {
    final accounts = await dataSource.fetchAccounts();
    for (var account in accounts) {
      if (account.type == AccountTypeEnum.GROUP && account.parentId == null) {
        return account;
      }
    }
    return null;
  }

  @override
  Future<AccountEntity> createGroup(int userId) async {
    // Note: Group creation is typically handled by backend
    // This is a simplified version
    final newAccount = AccountModel.createNew(
      userId: userId,
      type: AccountTypeEnum.GROUP,
    );

    return await dataSource.createAccount(newAccount);
  }

  @override
  Future<AccountEntity> createChildAccount({
    required int userId,
    required int groupId,
    required AccountTypeEnum type,
    String? dailyLimit,
    String? monthlyLimit,
  }) async {
    return await dataSource.createChildAccount(
      userId: userId,
      groupId: groupId,
      type: type,
      dailyLimit: dailyLimit,
      monthlyLimit: monthlyLimit,
    );
  }


}