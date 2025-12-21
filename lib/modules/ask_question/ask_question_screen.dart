import 'package:banking_system/modules/ask_question/ticket_details_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../core/constants/app_color.dart';
import '../../core/utils/custom_text_form_field.dart';
import 'controller/ask_question_controller.dart';

class AskQuestionScreen extends StatelessWidget {
  AskQuestionScreen({super.key});

  final AskQuestionController controller = Get.put(AskQuestionController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          // 🔥 الجزء العلوي (ثابت)
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Ask a Question',
                  style: TextStyle(
                    color: AppColor.darkgreen,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 12),

                CustomTextFormField(
                  controller: controller.questionController,
                  maxLines: 3, // 🔥 قللت من 4 إلى 3
                  label: 'Type your question here...',
                  hint: '',
                ),

                const SizedBox(height: 10), // 🔥 قللت من 12 إلى 10

                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: controller.sendQuestion,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColor.darkgreen,
                      padding: const EdgeInsets.symmetric(vertical: 12), // 🔥 قللت
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: const Text(
                      'Send Question',
                      style: TextStyle(color: AppColor.white),
                    ),
                  ),
                ),
              ],
            ),
          ),

          const Divider(height: 1),

          // 🔥 القائمة فقط (مع مساحة أكبر)
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Obx(() {
                if (controller.isLoading.value) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (controller.tickets.isEmpty) {
                  return const Center(child: Text('No tickets found'));
                }

                return ListView.separated(
                  physics: const BouncingScrollPhysics(),
                  itemCount: controller.tickets.length,
                  separatorBuilder: (context, index) =>
                  const SizedBox(height: 6),
                  itemBuilder: (context, index) {
                    final ticket = controller.tickets[index];
                    return Card(
                    elevation: 1,
                    child: ListTile(
                      onTap: () {
                        // هنا لما تضغط على الكارد تفتح شاشة التفاصيل
                        Get.to(() => TicketDetailsScreen(
                          ticketId: ticket.publicId,
                          token: controller.token.value,
                        ));
                      },
                      minLeadingWidth: 0,
                      leading: Container(
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                          color: ticket.status == 'open'
                              ? AppColor.darkgreen.withOpacity(0.1)
                              : Colors.grey.withOpacity(0.1),
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          Icons.support_agent,
                          color: ticket.status == 'open'
                              ? AppColor.darkgreen
                              : Colors.grey,
                          size: 20,
                        ),
                      ),
                      title: Text(
                        ticket.subject,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      subtitle: Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                            decoration: BoxDecoration(
                              color: ticket.status == 'open'
                                  ? Colors.orange.withOpacity(0.1)
                                  : Colors.green.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: Text(
                              ticket.status.toUpperCase(),
                              style: TextStyle(
                                fontSize: 10,
                                fontWeight: FontWeight.bold,
                                color: ticket.status == 'open' ? Colors.orange : Colors.green,
                              ),
                            ),
                          ),
                        ],
                      ),
                      trailing: ticket.status == 'open'
                          ? IconButton(
                        icon: Container(
                          padding: const EdgeInsets.all(6),
                          decoration: BoxDecoration(
                            color: Colors.red.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: const Icon(
                            Icons.close,
                            size: 18,
                            color: Colors.red,
                          ),
                        ),
                        onPressed: () => controller.closeTicket(ticket.publicId),
                      )
                          : null,
                    ),
                    );

                  },
                );
              }),
            ),
          ),
        ],
      ),
    );
  }
}