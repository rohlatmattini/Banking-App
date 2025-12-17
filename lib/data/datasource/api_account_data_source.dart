import 'package:dio/dio.dart';
import 'account_data_source.dart';
import '../model/account_model.dart';
import '../../domain/entities/account_entity.dart';
import '../../domain/enums/account_type_enum.dart';

class ApiAccountDataSource implements AccountDataSource {
  final Dio _dio = Dio(BaseOptions(
    baseUrl: 'http://your-backend-api.com/api/v1',
    connectTimeout: const Duration(seconds: 10),
    receiveTimeout: const Duration(seconds: 10),
  ));

  // Add authorization interceptor
  ApiAccountDataSource() {
    _dio.interceptors.add(InterceptorsWrapper(
      onRequest: (options, handler) {
        // Add auth token here
        // options.headers['Authorization'] = 'Bearer $token';
        return handler.next(options);
      },
    ));
  }

  @override
  Future<List<AccountEntity>> fetchAccounts() async {
    try {
      final response = await _dio.get('/accounts');
      final List<dynamic> data = response.data['data'] ?? response.data;

      return data.map((json) => AccountModel.fromJson(json)).toList();
    } catch (e) {
      throw Exception('Failed to fetch accounts: $e');
    }
  }

  @override
  Future<AccountEntity?> fetchAccount(String publicId) async {
    try {
      final response = await _dio.get('/accounts/$publicId');
      return AccountModel.fromJson(response.data['data']);
    } catch (e) {
      return null;
    }
  }

  @override
  Future<AccountEntity> createAccount(AccountEntity account) async {
    try {
      final response = await _dio.post('/accounts', data: {
        'type': account.type.value,
        'daily_limit': account.dailyLimit,
        'monthly_limit': account.monthlyLimit,
      });

      return AccountModel.fromJson(response.data['data']);
    } catch (e) {
      throw Exception('Failed to create account: $e');
    }
  }

  @override
  Future<AccountEntity> updateAccount(AccountEntity account) async {
    try {
      final response = await _dio.put('/accounts/${account.publicId}', data: {
        'state': account.state.name,
        'balance': account.balance,
        'daily_limit': account.dailyLimit,
        'monthly_limit': account.monthlyLimit,
      });

      return AccountModel.fromJson(response.data['data']);
    } catch (e) {
      throw Exception('Failed to update account: $e');
    }
  }

  @override
  Future<void> deleteAccount(String publicId) async {
    try {
      await _dio.delete('/accounts/$publicId');
    } catch (e) {
      throw Exception('Failed to delete account: $e');
    }
  }

  // Additional methods matching backend API
  Future<AccountEntity> updateState(String publicId, String newState) async {
    try {
      final response = await _dio.patch(
        '/accounts/$publicId/state',
        data: {'state': newState},
      );

      return AccountModel.fromJson(response.data['data']);
    } catch (e) {
      throw Exception('Failed to update state: $e');
    }
  }

  Future<AccountEntity> createChildAccount({
    required int userId,
    required int groupId,
    required AccountTypeEnum type,
    String? dailyLimit,
    String? monthlyLimit,
  }) async {
    try {
      final response = await _dio.post('/accounts/open', data: {
        'user_id': userId,
        'type': type.value,
        'daily_limit': dailyLimit,
        'monthly_limit': monthlyLimit,
      });

      return AccountModel.fromJson(response.data['data']);
    } catch (e) {
      throw Exception('Failed to create child account: $e');
    }
  }
}