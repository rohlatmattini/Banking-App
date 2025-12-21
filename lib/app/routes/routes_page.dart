
import 'package:banking_system/app/routes/routes.dart';
import 'package:get/get.dart';

import '../../modules/ask_question/ask_question_screen.dart';
import '../../modules/auth/view/forgot_password.dart';
import '../../modules/auth/view/login_screen.dart';
import '../../modules/auth/view/reset_password.dart';
import '../../modules/home/view/home_page_screen.dart';
import '../../modules/onboarding/view/onboarding_screen.dart';
import '../../modules/payment/widget/add_payment/add_payment_page.dart';
import '../../modules/transaction_history/view/transaction_details_screen.dart';
import '../../modules/transaction_history/view/transaction_history_screen.dart';
import '../bindings/home_binding.dart';
import '../bindings/transaction_details_binding.dart';
import '../bindings/transaction_history_binding.dart';


class AppPages {
  static final pages = [
    GetPage(name: AppRoute.onboarding, page: () => OnBoarding()),
    GetPage(name: AppRoute.login, page: () => LoginScreen()),
    GetPage(name: AppRoute.home, page: () => HomePageScreen() ,  binding: HomeBinding(),),
    // GetPage(name: AppRoute.setting, page: () => SettingScreen()),
    // GetPage(name: AppRoute.forgotPassword, page: () => ForgotPasswordScreen()),
    // GetPage(name: AppRoute.resetPassword, page: () => ResetPasswordScreen()),
    GetPage(name: AppRoute.addPayment, page: () => AddPaymentPage()),
    GetPage(name: AppRoute.askQuestion, page: () => AskQuestionScreen()),
    GetPage(name: AppRoute.transactionHistory, page: () => TransactionHistoryScreen(), binding: TransactionHistoryBinding(),),
    GetPage(name: AppRoute.transactionDetails, page: () => TransactionDetailsScreen(), binding: TransactionDetailsBinding(),),
  ];
}
