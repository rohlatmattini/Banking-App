import '../../domain/entities/account_entity.dart';

abstract class AccountDataSource {
  Future<List<AccountEntity>> fetchAccounts();
  Future<AccountEntity?> fetchAccount(String publicId);
  Future<AccountEntity> createAccount(AccountEntity account);
  Future<AccountEntity> updateAccount(AccountEntity account);
  Future<void> deleteAccount(String publicId);
}