import 'package:get/get.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';
import 'package:flutter/material.dart';
import '../../../core/patterns/facade/support_ticket_facade.dart';
import '../../../data/models/support/support_ticket_model.dart';

class AskQuestionController extends GetxController {
  final SupportFacade _supportFacade = SupportFacade();
  final FlutterSecureStorage _secureStorage = const FlutterSecureStorage();

  final questionController = TextEditingController();

  final RxList<SupportTicket> tickets = <SupportTicket>[].obs;
  final RxBool isLoading = false.obs;
  final RxString token = ''.obs; // استخدام observable للتتبع

  @override
  void onInit() {
    super.onInit();
    loadTokenAndFetchTickets();
  }

  Future<void> loadTokenAndFetchTickets() async {
    try {
      // تحميل التوكن من التخزين الآمن
      final savedToken = await _secureStorage.read(key: 'token');

      if (savedToken != null && savedToken.isNotEmpty) {
        token.value = savedToken;
        await fetchTickets();
      } else {
        _showAuthError('No authentication token found. Please login.');
      }
    } catch (e) {
      _showAuthError('Error loading token: $e');
    }
  }

  Future<void> fetchTickets() async {
    if (token.isEmpty) {
      _showAuthError('Please login first');
      return;
    }

    try {
      isLoading.value = true;
      final result = await _supportFacade.fetchTickets(token.value);
      tickets.assignAll(result);
    } catch (e) {
      // إذا كان الخطأ 401، قد يكون التوكن منتهي الصلاحية
      if (e.toString().contains('401') || e.toString().contains('Unauthenticated')) {
        await _handleTokenExpired();
      } else {
        Get.snackbar(
          'Error',
          'Failed to fetch tickets: ${e.toString()}',
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
      }
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> sendQuestion() async {
    if (token.isEmpty) {
      _showAuthError('Please login first');
      return;
    }

    if (questionController.text.trim().isEmpty) {
      Get.snackbar(
        'Warning',
        'Please enter your question',
        backgroundColor: Colors.orange,
        colorText: Colors.white,
      );
      return;
    }

    try {
      await _supportFacade.createTicket(
        token: token.value,
        subject: questionController.text.trim(),
        message: questionController.text.trim(),
      );

      questionController.clear();
      await fetchTickets();

      Get.snackbar(
        'Success',
        'Ticket created successfully',
        backgroundColor: Colors.green,
        colorText: Colors.white,
      );
    } catch (e) {
      // إذا كان الخطأ 401، قد يكون التوكن منتهي الصلاحية
      if (e.toString().contains('401') || e.toString().contains('Unauthenticated')) {
        await _handleTokenExpired();
      } else {
        Get.snackbar(
          'Error',
          'Failed to create ticket',
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
      }
      print('Error in sendQuestion: $e');
    }
  }

  Future<void> closeTicket(String ticketId) async {
    if (token.isEmpty) return;

    try {
      await _supportFacade.closeTicket(
        token: token.value,
        ticketId: ticketId,
      );

      await fetchTickets();
      Get.snackbar(
        'Success',
        'Ticket closed successfully',
        backgroundColor: Colors.green,
        colorText: Colors.white,
      );
    } catch (e) {
      if (e.toString().contains('401') || e.toString().contains('Unauthenticated')) {
        await _handleTokenExpired();
      } else {
        Get.snackbar(
          'Error',
          'Failed to close ticket',
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
      }
    }
  }

  Future<void> _handleTokenExpired() async {
    // مسح التوكن المنتهي
    await _secureStorage.delete(key: 'token');
    token.value = '';

    Get.snackbar(
      'Session Expired',
      'Your session has expired. Please login again.',
      backgroundColor: Colors.red,
      colorText: Colors.white,
      duration: Duration(seconds: 5),
    );

    // إعادة التوجيه لشاشة تسجيل الدخول بعد تأخير
    Future.delayed(Duration(seconds: 2), () {
      Get.offAllNamed('/login');
    });
  }

  void _showAuthError(String message) {
    Get.snackbar(
      'Authentication Error',
      message,
      backgroundColor: Colors.red,
      colorText: Colors.white,
      duration: Duration(seconds: 3),
    );
  }

  // دالة لتحديث التوكن إذا تم تجديده
  Future<void> updateToken(String newToken) async {
    await _secureStorage.write(key: 'token', value: newToken);
    token.value = newToken;
  }



}