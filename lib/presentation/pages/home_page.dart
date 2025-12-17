import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
class HomePage extends StatelessWidget {
  HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('نظام البنك المتقدم', style: TextStyle(fontFamily: 'Cairo',color: Colors.white)),
        centerTitle: true,
        backgroundColor: Colors.teal[700],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.account_balance, size: 100, color: Colors.teal),
            const SizedBox(height: 30),
            const Text(
              'مرحبًا بك في نظام البنك المتقدم',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold,color: Colors.teal),
            ),
            const SizedBox(height: 10),
            const Text(
              'نظام متكامل لإدارة الحسابات والمعاملات والتقارير',
              style: TextStyle(fontSize: 16, color: Colors.grey),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 40),
            SizedBox(
              width: 300,
              child: Column(
                children: [
                  ElevatedButton.icon(
                    onPressed: () => Get.toNamed('/accounts'),
                    icon: const Icon(Icons.account_balance_wallet,color: Colors.teal),
                    label: const Text('إدارة الحسابات',style: TextStyle(color: Colors.teal ),),
                    style: ElevatedButton.styleFrom(
                      minimumSize: const Size(double.infinity, 50),
                    ),
                  ),
                  const SizedBox(height: 15),
                  ElevatedButton.icon(
                    onPressed: () => Get.toNamed('/reports'),
                    icon: const Icon(Icons.assessment,color: Colors.teal,),
                    label: const Text('التقارير والتحليلات',style:TextStyle(color: Colors.teal )),
                    style: ElevatedButton.styleFrom(
                      minimumSize: const Size(double.infinity, 50),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}