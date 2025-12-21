
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

import '../../../core/constants/app_color.dart';
import '../widget/auth_container.dart';
import '../widget/login.dart';

class LoginScreen extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
          child: Column(
            children: [
              AuthContainer(),
          Text("Login",style: TextStyle(color: AppColor.green,fontSize: 25,fontWeight: FontWeight.bold),),
      // TextButton(onPressed: controller.selectLogin, child: Text("Login",style: TextStyle(color: AppColor.green,fontSize: 15),)),
              
              Padding(
                padding: const EdgeInsets.all(20),
                child: LoginFormWidget(),
              )
            
            ],
          ),
        ),

    );
  }
}