import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:my_events_test_project/app/core/utils/offline_banner.dart';
import 'package:my_events_test_project/app/navigation/app_routes.dart';
import 'package:my_events_test_project/features/events/presentation/controllers/event_list_controller.dart';
import 'package:my_events_test_project/features/events/presentation/widgets/event_card.dart';
import 'package:my_events_test_project/features/events/presentation/widgets/event_list_skeleton.dart';

class EventListScreen extends StatelessWidget {
  const EventListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(EventListController());
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        title: const Text('My Events', style: TextStyle(fontWeight: FontWeight.bold)),
        centerTitle: true,
        elevation: 0,
        scrolledUnderElevation: 0,
        backgroundColor: theme.scaffoldBackgroundColor,
        actions: [
          IconButton(
            icon: Icon(Icons.logout, color: theme.iconTheme.color),
            onPressed: controller.logout,
          ),
        ],
      ),
      body: Column(
        children: [
          const OfflineBanner(),
          Expanded(
            child: RefreshIndicator(
              color: theme.dividerColor,
              onRefresh: controller.fetchEvents,
              child: Obx(() {
                if (controller.isLoading.value) return const EventListSkeleton();

                if (controller.events.isEmpty) {
                  return LayoutBuilder(
                    builder: (context, constraints) {
                      return SingleChildScrollView(
                        physics: const AlwaysScrollableScrollPhysics(),
                        child: ConstrainedBox(
                          constraints: BoxConstraints(
                            minHeight: constraints.maxHeight
                          ),
                          child: Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(Icons.event_busy, size: 80, color: theme.disabledColor),
                                const SizedBox(height: 16),
                                Text('No events found', style: theme.textTheme.bodyLarge),
                                const SizedBox(height: 8),
                                const Text('Pull down to refresh', style: TextStyle(color: Colors.grey)),
                              ],
                            ),
                          ),
                        ),
                      );
                    }
                  );
                }

                return ListView.builder(
                  controller: controller.scrollController,
                  physics: const BouncingScrollPhysics(),
                  itemCount: controller.events.length + (controller.isMoreLoading.value ? 1 : 0),
                  itemBuilder: (context, index) {
                    if (index == controller.events.length) {
                      return Center(
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: CircularProgressIndicator(color: theme.primaryColor)
                        )
                      );
                    }
                    return EventCard(event: controller.events[index]);
                  },
                );
              }),
            ),
          ),
        ],
      ),
      floatingActionButton: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12),
        child: FloatingActionButton(
          onPressed: () => Get.toNamed(AppRoutes.eventForm),
          backgroundColor: theme.primaryColor.withBlue(600),
          child: const Icon(Icons.add, color: Colors.white),
        ),
      ),
    );
  }
}