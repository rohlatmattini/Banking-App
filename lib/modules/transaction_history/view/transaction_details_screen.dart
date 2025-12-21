import 'package:banking_system/core/constants/app_color.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/utils/load_indicator.dart';
import '../controller/transaction_details_history.dart';

class TransactionDetailsScreen extends StatelessWidget {
  const TransactionDetailsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<TransactionDetailsController>();

    return Scaffold(
      appBar: AppBar(title:  Text('Transaction Details',style: TextStyle(color: AppColor.darkgreen,fontWeight: FontWeight.bold),)),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        final data = controller.details;

        if (data.isEmpty) {
          return const Center(child: Text('No details available'));
        }

        return AppRefreshIndicator(
          onRefresh: controller.fetchDetails,
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            padding: const EdgeInsets.all(16),
            child: Padding(
              padding: const EdgeInsets.all(10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _infoTile('Public ID', data['public_id']?.toString()),
                  _infoTile('Type', data['type']?.toString()),
                  _infoTile('Status', data['status']?.toString()),
                  _infoTile(
                    'Amount',
                    '${data['amount']?.toString() ?? '-'} ${data['currency']?.toString() ?? ''}',
                  ),
                  _infoTile('Description', data['description']?.toString() ?? '-'),
                  _infoTile('Created At', data['created_at']?.toString() ?? '-'),
                  _infoTile('Posted At', data['posted_at']?.toString() ?? '-'),

                  const SizedBox(height: 24),
                   Align(
                     alignment: AlignmentGeometry.center,
                       child: Text('Account', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold,color: AppColor.darkgreen))),
                  const SizedBox(height: 12),
                  ...((data['ledger_entries'] as List<dynamic>?) ?? []).asMap().entries.map((entry) {
                    final index = entry.key;
                    final item = entry.value;

                    String label = '';
                    if (index == 0) {
                      label = 'From';
                    } else if (index == 1) {
                      label = 'To';
                    }

                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        if (label.isNotEmpty)
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 4),
                            child: Text(label, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                          ),
                        Card(
                          margin: const EdgeInsets.only(bottom: 8),
                          child: ListTile(
                            title: Text(
                              '${item['direction']?.toString().toUpperCase() ?? '-'} - '
                                  '${item['amount']?.toString() ?? '-'} ${item['currency']?.toString() ?? ''}',
                            ),
                            subtitle: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('Account: ${item['account_public_id']?.toString() ?? '-'}'),
                                Text('At: ${item['created_at']?.toString() ?? '-'}'),
                              ],
                            ),
                          ),
                        ),
                      ],
                    );
                  }).toList(),

                ],
              ),
            ),
          ),
        );
      }),
    );
  }

  Widget _infoTile(String title, String? value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 120,
            child: Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
          ),
          Expanded(child: Text(value ?? '-')),
        ],
      ),
    );
  }
}
