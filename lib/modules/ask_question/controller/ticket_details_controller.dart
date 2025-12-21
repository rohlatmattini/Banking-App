import 'package:get/get.dart';
import '../../../core/patterns/facade/support_ticket_facade.dart';

class TicketDetailsController extends GetxController {
  final SupportFacade _facade = SupportFacade();

  var isLoading = false.obs;
  var ticketData = <String, dynamic>{}.obs;

  Future<void> loadTicketDetails(String token, String ticketId) async {
    try {
      isLoading.value = true;
      final data = await _facade.fetchTicketDetails(token: token, ticketId: ticketId);
      ticketData.value = data;
    } catch (e) {
      Get.snackbar('Error', 'Failed to load ticket details');
      print('Error loading ticket: $e');
    } finally {
      isLoading.value = false;
    }
  }
}
