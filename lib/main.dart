import 'package:bankingplatform/presentation/controller/account_controller.dart';
import 'package:bankingplatform/presentation/controller/approval_controller.dart';
import 'package:bankingplatform/presentation/controller/report_controller.dart';
import 'package:bankingplatform/presentation/controller/transaction_controller.dart';
import 'package:bankingplatform/presentation/pages/account_management_page.dart';
import 'package:bankingplatform/presentation/pages/approvals_page.dart';
import 'package:bankingplatform/presentation/pages/home_page.dart';
import 'package:bankingplatform/presentation/pages/onboard_customer_page.dart';
import 'package:bankingplatform/presentation/pages/reports_page.dart';
import 'package:bankingplatform/presentation/pages/transaction_history_page.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'data/datasource/api_account_data_source.dart';
import 'data/repositories/account_repository_impl.dart';
import 'data/repositories/report_repository_impl.dart';

void main() async {
  await GetStorage.init();
  runApp(BankingApp());
}

// In main.dart, update BankingApp:
class BankingApp extends StatelessWidget {
  BankingApp({super.key});

  @override
  Widget build(BuildContext context) {
    // Initialize dependencies
    final accountDataSource = ApiAccountDataSource();
    final accountRepository = AccountRepositoryImpl(dataSource: accountDataSource);
    final reportRepository = ReportRepositoryImpl();

    // Initialize ApprovalController early
    final approvalController = ApprovalController(repository: accountRepository);

    // Fetch pending approvals on app start
    approvalController.fetchPendingApprovals();

    return GetMaterialApp(
      title: 'Banking System',
      theme: ThemeData(
        primarySwatch: Colors.teal,
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.teal,
          foregroundColor: Colors.white,
        ),
      ),
      initialRoute: '/',
      getPages: [
        GetPage(name: '/', page: () => HomePage()),
        GetPage(
          name: '/accounts',
          page: () => AccountManagementPage(),
          binding: BindingsBuilder(() {
            Get.put(AccountController(repository: accountRepository));
            Get.put(approvalController); // Add approval controller here
          }),
        ),
        GetPage(
          name: '/accounts/onboard',
          page: () => OnboardCustomerPage(),
        ),
        GetPage(
          name: '/reports',
          page: () => ReportsPage(),
          binding: BindingsBuilder(() {
            Get.put(ReportController(repository: reportRepository));
          }),
        ),
        GetPage(
          name: '/transactions',
          page: () => TransactionsPage(),
          binding: BindingsBuilder(() {
            Get.put(TransactionController(repository: accountRepository));
          }),
        ),
        GetPage(
          name: '/approvals',
          page: () => ApprovalsPage(),
          binding: BindingsBuilder(() {
            Get.put(approvalController);
          }),
        ),
      ],
      debugShowCheckedModeBanner: false,
    );
  }
}