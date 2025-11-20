import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:my_events_test_project/app/navigation/navigations/app_routes.dart';
import 'package:my_events_test_project/features/events/presentation/controllers/event_list_controller.dart';
import 'package:my_events_test_project/features/events/presentation/widgets/event_card.dart';
import 'package:my_events_test_project/features/events/presentation/widgets/event_list_skeleton.dart';

class EventListScreen extends StatelessWidget {
  const EventListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(EventListController());

    return Scaffold(
      appBar: AppBar(
        title: const Text('My Events'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: controller.logout,
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: controller.fetchEvents,
        child: Obx(() {
          if (controller.isLoading.value) {
            return const EventListSkeleton();
          }

          if (controller.events.isEmpty) {
            return const Center(child: Text('No events found'));
          }

          return ListView.builder(
            controller: controller.scrollController,
            itemCount:
                controller.events.length +
                (controller.isMoreLoading.value ? 1 : 0),
            itemBuilder: (context, index) {
              if (index == controller.events.length) {
                return const Center(
                  child: Padding(
                    padding: EdgeInsets.all(16.0),
                    child: CircularProgressIndicator(),
                  ),
                );
              }

              return EventCard(event: controller.events[index]);
            },
          );
        }),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => Get.toNamed(AppRoutes.eventForm),
        child: const Icon(Icons.add),
      ),
    );
  }
}
