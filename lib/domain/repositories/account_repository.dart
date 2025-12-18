import '../entities/account_entity.dart';
import '../enums/account_type_enum.dart';

abstract class AccountRepository {
  // Group operations
  Future<AccountEntity?> findUserGroup(int userId);
  Future<AccountEntity> createGroup(int userId);

  // Account operations
  Future<AccountEntity> createChildAccount({
    required int userId,
    required int groupId,
    required AccountTypeEnum type,
    String? dailyLimit,
    String? monthlyLimit,
  });

  // New method for creating user account directly
  Future<AccountEntity> createUserAccount({
    required int userId,
    required AccountTypeEnum type,
    String? dailyLimit,
    String? monthlyLimit,
  });

  // Query operations
  Future<List<AccountEntity>> listByUser(int userId);
  Future<AccountEntity?> findByPublicId(String publicId);

  // Update operations
  Future<AccountEntity> updateStateByPublicId(String publicId, String newState);
}