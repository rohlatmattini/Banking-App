import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../controller/report_controller.dart';

class ReportsPage extends StatelessWidget {
  final ReportController controller = Get.find<ReportController>();

  ReportsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.white),
        title: const Text('Reports and Analytics', style: TextStyle(fontFamily: 'Cairo', color: Colors.white)),
        centerTitle: true,
        backgroundColor: Colors.teal,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh, color: Colors.white),
            onPressed: () => controller.loadAllReports(),
            tooltip: 'Refresh',
          ),
          PopupMenuButton<String>(
            icon: const Icon(Icons.more_vert, color: Colors.white),
            onSelected: (format) => _exportReport(format),
            itemBuilder: (context) => const [
              PopupMenuItem(value: 'PDF', child: Text('Export PDF')),
              PopupMenuItem(value: 'Excel', child: Text('Export Excel')),
              PopupMenuItem(value: 'CSV', child: Text('Export CSV')),
              PopupMenuItem(value: 'print', child: Text('Print')),
            ],
          ),
        ],
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CircularProgressIndicator(),
                SizedBox(height: 16),
                Text('Loading reports...'),
              ],
            ),
          );
        }

        return SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // System Summary
              _buildSystemSummaryCard(),
              const SizedBox(height: 20),

              // Daily Report
              _buildDailyReportsCard(),
              const SizedBox(height: 20),

              // Account Summaries
              _buildAccountSummariesCard(),
              const SizedBox(height: 20),

              // Audit Logs
              _buildAuditLogsCard(),
            ],
          ),
        );
      }),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _selectDate(),
        backgroundColor: Colors.teal,
        child: const Icon(Icons.calendar_today, color: Colors.white),
      ),
    );
  }

  // ==================== System Summary Card ====================
  Widget _buildSystemSummaryCard() {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(Icons.assessment, color: Colors.teal, size: 24),
                const SizedBox(width: 8),
                const Text('System Summary', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                const Spacer(),
                Chip(
                  label: Text(
                    '${DateFormat('dd/MM/yyyy').format(DateTime.now())}',
                    style: const TextStyle(fontSize: 12, color: Colors.white),
                  ),
                  backgroundColor: Colors.teal,
                ),
              ],
            ),
            const SizedBox(height: 16),
            GridView.count(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              crossAxisCount: 2,
              childAspectRatio: 3,
              mainAxisSpacing: 10,
              crossAxisSpacing: 10,
              children: [
                _buildSummaryItem(
                  'Total Accounts',
                  '${controller.systemSummary['totalAccounts'] ?? 0}',
                  Icons.account_balance_wallet,
                  Colors.teal,
                ),
                _buildSummaryItem(
                  'Active Accounts',
                  '${controller.systemSummary['activeAccounts'] ?? 0}',
                  Icons.check_circle,
                  Colors.green,
                ),
                _buildSummaryItem(
                  'Total Balance',
                  '\$${_formatMoney(controller.systemSummary['totalBalance'] ?? 0)}',
                  Icons.monetization_on,
                  Colors.amber,
                ),
                _buildSummaryItem(
                  'Today\'s Transactions',
                  '${controller.systemSummary['todayTransactions'] ?? 0}',
                  Icons.swap_horiz,
                  Colors.blue,
                ),
                _buildSummaryItem(
                  'Today\'s Deposits',
                  '\$${_formatMoney(controller.systemSummary['todayDeposits'] ?? 0)}',
                  Icons.arrow_upward,
                  Colors.green,
                ),
                _buildSummaryItem(
                  'Today\'s Withdrawals',
                  '\$${_formatMoney(controller.systemSummary['todayWithdrawals'] ?? 0)}',
                  Icons.arrow_downward,
                  Colors.orange,
                ),
                _buildSummaryItem(
                  'System Uptime',
                  '${controller.systemSummary['systemUptime'] ?? "0%"}',
                  Icons.timer,
                  Colors.purple,
                ),
                _buildSummaryItem(
                  'Last Backup',
                  _formatDate(controller.systemSummary['lastBackup']),
                  Icons.backup,
                  Colors.red,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSummaryItem(String title, String value, IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: color.withOpacity(0.2)),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(6),
            decoration: BoxDecoration(
              color: color.withOpacity(0.2),
              borderRadius: BorderRadius.circular(6),
            ),
            child: Icon(icon, size: 20, color: color),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  value,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: color,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 12,
                    color: Colors.grey,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ==================== Daily Reports Card ====================
  Widget _buildDailyReportsCard() {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    const Icon(Icons.today, color: Colors.teal),
                    const SizedBox(width: 8),
                    const Text('Daily Report', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  ],
                ),
                TextButton.icon(
                  onPressed: _selectDate,
                  icon: const Icon(Icons.calendar_today, size: 16),
                  label: Text(
                    DateFormat('dd/MM/yyyy').format(controller.selectedDate.value),
                    style: const TextStyle(fontSize: 14),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            if (controller.dailyReports.isEmpty)
              const Center(
                child: Column(
                  children: [
                    Icon(Icons.report_problem, size: 50, color: Colors.grey),
                    SizedBox(height: 8),
                    Text('No data available for this date'),
                  ],
                ),
              ),
            ...controller.dailyReports.map((report) => _buildDailyReportItem(report)),
          ],
        ),
      ),
    );
  }

  Widget _buildDailyReportItem(Map<String, dynamic> report) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey[200]!),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Date: ${_formatDate(report['date'])}',
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildMetricItem(
                'Transactions',
                '${report['totalTransactions']}',
                Icons.swap_horiz,
                Colors.teal,
              ),
              _buildMetricItem(
                'Deposits',
                '\$${_formatMoney(report['totalDeposits'] ?? 0)}',
                Icons.arrow_upward,
                Colors.green,
              ),
              _buildMetricItem(
                'Withdrawals',
                '\$${_formatMoney(report['totalWithdrawals'] ?? 0)}',
                Icons.arrow_downward,
                Colors.orange,
              ),
              _buildMetricItem(
                'New Accounts',
                '${report['newAccounts']}',
                Icons.add,
                Colors.blue,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildMetricItem(String label, String value, IconData icon, Color color) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            shape: BoxShape.circle,
          ),
          child: Icon(icon, size: 20, color: color),
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
        Text(
          label,
          style: const TextStyle(fontSize: 11, color: Colors.grey),
        ),
      ],
    );
  }

  // ==================== Account Summaries Card ====================
  Widget _buildAccountSummariesCard() {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Row(
              children: [
                Icon(Icons.pie_chart, color: Colors.teal),
                SizedBox(width: 8),
                Text('Account Summaries', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              ],
            ),
            const SizedBox(height: 16),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: DataTable(
                columnSpacing: 30,
                horizontalMargin: 0,
                columns: const [
                  DataColumn(label: Text('Type')),
                  DataColumn(label: Text('Count'), numeric: true),
                  DataColumn(label: Text('Total Balance'), numeric: true),
                  DataColumn(label: Text('Average Balance'), numeric: true),
                  DataColumn(label: Text('Percentage'), numeric: true),
                ],
                rows: controller.accountSummaries.map((summary) {
                  final totalCount = controller.accountSummaries.fold<int>(0, (sum, s) => sum + (s['count'] as int));
                  final percentage = ((summary['count'] as int) / totalCount * 100).toStringAsFixed(1);

                  return DataRow(cells: [
                    DataCell(Row(
                      children: [
                        Container(
                          width: 12,
                          height: 12,
                          decoration: BoxDecoration(
                            color: _getTypeColor(summary['type']),
                            shape: BoxShape.circle,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Text(_translateAccountType(summary['type'])),
                      ],
                    )),
                    DataCell(Text('${summary['count']}')),
                    DataCell(Text('\$${_formatMoney(summary['totalBalance'] ?? 0)}')),
                    DataCell(Text('\$${_formatMoney(summary['averageBalance'] ?? 0)}')),
                    DataCell(Text('$percentage%')),
                  ]);
                }).toList(),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ==================== Audit Logs Card ====================
  Widget _buildAuditLogsCard() {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Row(
              children: [
                Icon(Icons.history, color: Colors.teal),
                SizedBox(width: 8),
                Text('Audit Logs', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              ],
            ),
            const SizedBox(height: 16),
            if (controller.auditLogs.isEmpty)
              const Center(
                child: Text('No audit logs available'),
              ),
            ...controller.auditLogs.map((log) => _buildAuditLogItem(log)),
          ],
        ),
      ),
    );
  }

  Widget _buildAuditLogItem(Map<String, dynamic> log) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey[200]!),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: _getActionColor(log['action']).withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(_getActionIcon(log['action']), size: 16, color: _getActionColor(log['action'])),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  log['details'] ?? '',
                  style: const TextStyle(fontWeight: FontWeight.w500),
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    Icon(Icons.person, size: 12, color: Colors.grey[600]),
                    const SizedBox(width: 4),
                    Text(
                      log['user'] ?? '',
                      style: const TextStyle(fontSize: 12, color: Colors.grey),
                    ),
                    const Spacer(),
                    Icon(Icons.access_time, size: 12, color: Colors.grey[600]),
                    const SizedBox(width: 4),
                    Text(
                      _formatTime(log['timestamp']),
                      style: const TextStyle(fontSize: 12, color: Colors.grey),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ==================== Utility Methods ====================
  void _selectDate() {
    showDatePicker(
      context: Get.context!,
      initialDate: controller.selectedDate.value,
      firstDate: DateTime.now().subtract(const Duration(days: 365)),
      lastDate: DateTime.now(),
    ).then((date) {
      if (date != null) {
        controller.changeDate(date);
      }
    });
  }

  void _exportReport(String format) {
    Get.snackbar(
      'Success',
      'Report exported in $format format',
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Colors.teal,
      colorText: Colors.white,
    );
  }

  String _formatDate(dynamic date) {
    if (date is String) {
      try {
        return DateFormat('dd/MM/yyyy').format(DateTime.parse(date).toLocal());
      } catch (e) {
        return date;
      }
    }
    return 'N/A';
  }

  String _formatTime(dynamic timestamp) {
    if (timestamp is String) {
      try {
        return DateFormat('HH:mm').format(DateTime.parse(timestamp).toLocal());
      } catch (e) {
        return '';
      }
    }
    return '';
  }

  String _formatMoney(dynamic amount) {
    if (amount is num) {
      return amount.toStringAsFixed(2);
    }
    return '0.00';
  }

  String _translateAccountType(String type) {
    switch (type) {
      case 'savings': return 'Savings';
      case 'checking': return 'Checking';
      case 'loan': return 'Loan';
      case 'investment': return 'Investment';
      case 'group': return 'Group';
      default: return type;
    }
  }

  Color _getTypeColor(String type) {
    switch (type) {
      case 'savings': return Colors.grey;
      case 'checking': return Colors.grey;
      case 'loan': return Colors.grey;
      case 'investment': return Colors.grey;
      default: return Colors.grey;
    }
  }

  Color _getActionColor(String action) {
    switch (action) {
      case 'LOGIN': return Colors.grey;
      case 'ACCOUNT_CREATE': return Colors.grey;
      case 'TRANSACTION_PROCESS': return Colors.grey;
      case 'REPORT_GENERATE': return Colors.grey;
      default: return Colors.grey;
    }
  }

  IconData _getActionIcon(String action) {
    switch (action) {
      case 'LOGIN': return Icons.login;
      case 'ACCOUNT_CREATE': return Icons.add_circle;
      case 'TRANSACTION_PROCESS': return Icons.swap_horiz;
      case 'REPORT_GENERATE': return Icons.assessment;
      default: return Icons.history;
    }
  }
}