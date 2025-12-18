import 'package:dio/dio.dart';
import 'account_data_source.dart';
import '../model/account_model.dart';
import '../../domain/entities/account_entity.dart';
import '../../domain/enums/account_type_enum.dart';
import '../../domain/dtos/onboard_customer_dto.dart';

class ApiAccountDataSource implements AccountDataSource {
  final Dio _dio = Dio(BaseOptions(
    baseUrl: 'http://127.0.0.1:8000/api/v1',
    connectTimeout: const Duration(seconds: 30),
    receiveTimeout: const Duration(seconds: 30),
    headers: {
      'Accept': 'application/json',
      'Content-Type': 'application/json',
    },
  ));

  // التوكن الثابت - في الواقع يجب أن يأتي من خدمة المصادقة
  static const String _authToken = '1|oev4N3FtHvg5vuOzi4OxdcKkmY0cfMqNU7c5J2mt5d033291';

  ApiAccountDataSource() {
    _dio.interceptors.add(InterceptorsWrapper(
      onRequest: (options, handler) {
        // إضافة التوكن للطلبات
        options.headers['Authorization'] = 'Bearer $_authToken';
        return handler.next(options);
      },
      onError: (error, handler) {
        // معالجة الأخطاء
        if (error.response?.statusCode == 401) {
          // معالجة انتهاء صلاحية التوكن
          // في الواقع يجب إعادة المصادقة هنا
        }
        return handler.next(error);
      },
    ));
  }

  @override
  Future<List<AccountEntity>> fetchAccounts() async {
    try {
      final response = await _dio.get('/accounts');

      // تحقق من بنية الرد (قد تكون البيانات في 'data' أو مباشرة)
      if (response.data is Map && response.data.containsKey('data')) {
        final List<dynamic> data = response.data['data'];
        return data.map((json) => AccountModel.fromJson(json)).toList();
      } else if (response.data is List) {
        return (response.data as List)
            .map((json) => AccountModel.fromJson(json))
            .toList();
      }

      throw Exception('Invalid response format');
    } on DioException catch (e) {
      if (e.response != null) {
        throw Exception('Failed to fetch accounts: ${e.response!.data}');
      } else {
        throw Exception('Failed to fetch accounts: ${e.message}');
      }
    }
  }

  @override
  Future<AccountEntity?> fetchAccount(String publicId) async {
    try {
      final response = await _dio.get('/accounts/$publicId');

      if (response.data is Map && response.data.containsKey('data')) {
        return AccountModel.fromJson(response.data['data']);
      }

      return AccountModel.fromJson(response.data);
    } on DioException catch (e) {
      if (e.response?.statusCode == 404) {
        return null;
      }
      throw Exception('Failed to fetch account: $e');
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

      if (response.data is Map && response.data.containsKey('data')) {
        return AccountModel.fromJson(response.data['data']);
      }

      return AccountModel.fromJson(response.data);
    } on DioException catch (e) {
      if (e.response != null) {
        throw Exception('Failed to create account: ${e.response!.data}');
      } else {
        throw Exception('Failed to create account: ${e.message}');
      }
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

      if (response.data is Map && response.data.containsKey('data')) {
        return AccountModel.fromJson(response.data['data']);
      }

      return AccountModel.fromJson(response.data);
    } on DioException catch (e) {
      if (e.response != null) {
        throw Exception('Failed to update account: ${e.response!.data}');
      } else {
        throw Exception('Failed to update account: ${e.message}');
      }
    }
  }
// في ملف api_account_data_source.dart، أضف هذه الدالة:
  @override
  Future<AccountEntity> createUserAccount({
    required int userId,
    required AccountTypeEnum type,
    String? dailyLimit,
    String? monthlyLimit,
  }) async {
    try {
      final response = await _dio.post('/accounts/users/$userId', data: {
        'type': type.value,
        'daily_limit': dailyLimit,
        'monthly_limit': monthlyLimit,
      });

      if (response.data is Map && response.data.containsKey('data')) {
        return AccountModel.fromJson(response.data['data']);
      }

      return AccountModel.fromJson(response.data);
    } on DioException catch (e) {
      if (e.response != null) {
        throw Exception('Failed to create user account: ${e.response!.data}');
      } else {
        throw Exception('Failed to create user account: ${e.message}');
      }
    }
  }
  @override
  Future<void> deleteAccount(String publicId) async {
    try {
      await _dio.delete('/accounts/$publicId');
    } on DioException catch (e) {
      if (e.response != null) {
        throw Exception('Failed to delete account: ${e.response!.data}');
      } else {
        throw Exception('Failed to delete account: ${e.message}');
      }
    }
  }

  // API الجديدة لإضافة عميل جديد
// API الجديدة لإضافة عميل جديد
  Future<Map<String, dynamic>> onboardCustomer(OnboardCustomerData data) async {
    try {
      final Map<String, dynamic> requestData = {
        'customer': {
          'name': data.customer.name,
          'email': data.customer.email,
          'phone': data.customer.phone,
        },
        'accounts': data.accounts.map((account) {
          final Map<String, dynamic> accountData = {
            'type': account.type.value,
          };

          if (account.dailyLimit != null && account.dailyLimit!.isNotEmpty) {
            // حاول تحويل النص إلى رقم
            try {
              accountData['daily_limit'] = double.parse(account.dailyLimit!);
            } catch (e) {
              // إذا فشل التحويل، أرسله كنص
              accountData['daily_limit'] = account.dailyLimit;
            }
          }

          if (account.monthlyLimit != null && account.monthlyLimit!.isNotEmpty) {
            // حاول تحويل النص إلى رقم
            try {
              accountData['monthly_limit'] = double.parse(account.monthlyLimit!);
            } catch (e) {
              // إذا فشل التحويل، أرسله كنص
              accountData['monthly_limit'] = account.monthlyLimit;
            }
          }

          return accountData;
        }).toList(),
      };

      print('Sending data to API: $requestData'); // للتصحيح
      final response = await _dio.post('/accounts/onboard', data: requestData);

      return response.data;
    } on DioException catch (e) {
      if (e.response != null) {
        final errorData = e.response!.data;
        final errorMessage = errorData is Map && errorData.containsKey('message')
            ? errorData['message']
            : 'Failed to onboard customer';
        throw Exception('$errorMessage (${e.response!.statusCode})');
      } else {
        throw Exception('Failed to onboard customer: ${e.message}');
      }
    }
  }
  // Additional methods matching backend API
  @override
  Future<AccountEntity> updateState(String publicId, String newState) async {
    try {
      final response = await _dio.patch(
        '/accounts/$publicId/state',
        data: {'state': newState},
      );

      if (response.data is Map && response.data.containsKey('data')) {
        return AccountModel.fromJson(response.data['data']);
      }

      return AccountModel.fromJson(response.data);
    } on DioException catch (e) {
      if (e.response != null) {
        throw Exception('Failed to update state: ${e.response!.data}');
      } else {
        throw Exception('Failed to update state: ${e.message}');
      }
    }
  }

  @override
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

      if (response.data is Map && response.data.containsKey('data')) {
        return AccountModel.fromJson(response.data['data']);
      }

      return AccountModel.fromJson(response.data);
    } on DioException catch (e) {
      if (e.response != null) {
        throw Exception('Failed to create child account: ${e.response!.data}');
      } else {
        throw Exception('Failed to create child account: ${e.message}');
      }
    }
  }
}