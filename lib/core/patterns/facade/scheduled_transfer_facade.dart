import 'dart:convert';
import 'package:get/get.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import '../../../core/constants/app_links.dart';
import '../../../data/apis/transaction/scheduled_transfer_api.dart';
import '../../../data/models/payment/scheduled_transfer.dart';

class ScheduledTransferFacade {
  final ScheduledTransferApi _api = ScheduledTransferApi();
  final storage = FlutterSecureStorage();

  Future<List<ScheduledTransfer>> getAllScheduledTransfers() async {
    try {
      return await _api.getScheduledTransfers();
    } catch (e) {
      Get.snackbar('Error', 'Failed to load scheduled transfers');
      rethrow;
    }
  }

  Future<ScheduledTransfer> createTransfer({
    required String sourceAccountId,
    required String? destinationAccountId,
    required String type,
    required double amount,
    required String description,
    String frequency = 'monthly',
    int interval = 1,
    int? dayOfMonth,
    String runTime = '00:00',
  }) async {
    try {
      final data = {
        'source_account_public_id': sourceAccountId,
        'destination_account_public_id': destinationAccountId,
        'amount': amount,
        'description': description,
        'frequency': frequency,
        'interval': interval,
        'day_of_month': dayOfMonth,
        'run_time': runTime,
      };

      return await _api.createScheduledTransfer(data);
    } catch (e) {
      Get.snackbar('Error', 'Failed to create scheduled transfer');
      rethrow;
    }
  }

  Future<void> updateStatus(String publicId, String status) async {
    try {
      await _api.updateScheduledTransferStatus(publicId, status);
      Get.snackbar('Success', 'Status updated successfully');
    } catch (e) {
      Get.snackbar('Error', 'Failed to update status');
      rethrow;
    }
  }

  Future<void> deleteTransfer(String publicId) async {
    try {
      await _api.deleteScheduledTransfer(publicId);
      Get.snackbar('Success', 'Transfer deleted successfully');
    } catch (e) {
      Get.snackbar('Error', 'Failed to delete transfer');
      rethrow;
    }
  }


}
