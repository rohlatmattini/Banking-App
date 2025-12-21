import 'package:get/get.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../../data/apis/auth/auth_api.dart';
import '../../core/services/auth/user_service.dart';
import '../../core/patterns/facade/auth_facade.dart';
import '../../modules/auth/controller/signin_controller.dart';

class AuthBinding extends Bindings {
  @override
  void dependencies() {
    // Services / APIs
    Get.lazyPut<AuthApi>(() => AuthApi(), fenix: true);
    Get.lazyPut<UserService>(() => UserService(), fenix: true);

    // Facades
    Get.lazyPut<AuthFacade>(() => AuthFacade(
      api: Get.find<AuthApi>(),
      storage: const FlutterSecureStorage(),
      userService: Get.find<UserService>(),
    ), fenix: true);

    // Get.lazyPut<PasswordRecoveryFacade>(() => PasswordRecoveryFacade(
    //   Get.find<AuthApi>() ,
    // ), fenix: true);

    // Controllers
    Get.lazyPut<SignInController>(() => SignInController(), fenix: true);
  }
}
