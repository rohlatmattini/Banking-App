import 'package:banking_system/modules/accounts/widget/account_list_section.dart';
import 'package:flutter/material.dart';

import '../widget/account_info_container.dart';

class AccountInfoScreen extends StatelessWidget {
  const AccountInfoScreen({super.key});

  @override
  Widget build(BuildContext context) {

    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const AccountInfoContainer(),
          AccountsListSection(),
        ],
      ),
    );
  }

}