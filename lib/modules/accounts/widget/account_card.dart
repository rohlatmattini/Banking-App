
import 'package:flutter/material.dart';

import '../../../core/constants/app_color.dart';

class AccountCard extends StatelessWidget {
  final String accountName;
  final String accountNumber;
  final double balance;
  final String currency;
  final String accountType;
  final IconData icon;
  final Color? iconColor;
  final VoidCallback? onTap;

  const AccountCard({
    super.key,
    required this.accountName,
    required this.accountNumber,
    required this.balance,
    required this.currency,
    required this.accountType,
    required this.icon,
    this.iconColor,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              _buildIconContainer(),
              const SizedBox(width: 16),
              _buildAccountInfo(),
              _buildBalanceInfo(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildIconContainer() {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: (iconColor ?? AppColor.darkgreen).withOpacity(0.2),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Icon(
        icon,
        color: iconColor ?? AppColor.darkgreen,
        size: 30,
      ),
    );
  }

  Widget _buildAccountInfo() {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            accountName,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            accountNumber,
            style: TextStyle(
              fontSize: 14,
              color: AppColor.grey,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBalanceInfo() {
    return Text(
      '$balance $currency',
      style: const TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.bold,
        color: AppColor.lightgreen,
      ),
    );
  }
}