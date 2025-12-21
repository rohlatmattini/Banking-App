import 'package:get/get.dart';

import '../../core/services/notification/notification_service.dart';

class NotificationBinding extends Bindings {
  @override
  void dependencies() {
    Get.put<NotificationService>(
      NotificationService(),
      permanent: true,
    );
  }
}
