import 'dart:ui';
import 'package:get/get.dart';

import '../../main.dart';

class MyLocaleController extends GetxController {
  var currentLang = 'en'.obs;

  Rx<Locale> currentLocale = Rx<Locale>(const Locale('en')); // Default

  Locale get initialLocale {
    String? lang = sharedpref!.getString("lang");
    return lang == "ar" ? const Locale("ar") : const Locale("en");
  }

  void changeLang(String languageCode) {
    Locale locale = Locale(languageCode);
    sharedpref!.setString("lang", languageCode);
    currentLocale.value = locale;
    Get.updateLocale(locale);
  }

  String get currentLangFromPref {
    return sharedpref!.getString("lang") ?? "en";
  }

}
