import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:my_events_test_project/app/navigation/navigations/app_routes.dart';
import 'package:my_events_test_project/features/events/presentation/controllers/event_detail_controller.dart';

class EventDetailScreen extends StatelessWidget {
  const EventDetailScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(EventDetailController());

    final h = MediaQuery.of(context).size.height;
    final w = MediaQuery.of(context).size.width;

    return Scaffold(
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        if (controller.event.value == null) {
          return const Center(child: Text("Event not found"));
        }

        final event = controller.event.value!;

        return CustomScrollView(
          slivers: [
            SliverAppBar(
              actions: [
                IconButton(
                  icon: const Icon(Icons.edit),
                  onPressed: () {
                    if (controller.event.value != null) {
                      Get.toNamed(
                        AppRoutes.eventForm,
                        arguments: controller.event.value,
                      );
                    }
                  },
                ),
              ],
              expandedHeight: h * 0.35,
              pinned: true,
              
              flexibleSpace: FlexibleSpaceBar(
                title: Text(
                  event.title,
                  style: const TextStyle(
                    fontSize: 16,
                    color: Colors.white,
                    shadows: [Shadow(blurRadius: 10, color: Colors.black)],
                  ),
                ),
                titlePadding: const EdgeInsets.only(left: 16, bottom: 16),
                
                background: Stack(
                  fit: StackFit.expand,
                  children: [
                    CachedNetworkImage(
                      imageUrl: event.imageUrl,
                      fit: BoxFit.cover, 
                      
                      placeholder: (context, url) => Container(
                        color: Colors.grey[200],
                        child: const Center(child: CircularProgressIndicator()),
                      ),
                      
                      errorWidget: (context, url, error) {
                        return Container(
                          color: Colors.grey[300],
                          child: const Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.broken_image, size: 40, color: Colors.grey),
                              SizedBox(height: 8),
                              Text("Could not load image", style: TextStyle(fontSize: 12)),
                            ],
                          ),
                        );
                      },
                    ),

                    Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            Colors.transparent,
                            Colors.black.withOpacity(0.7),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
           
            ),

            SliverToBoxAdapter(
              child: Padding(
                padding: EdgeInsets.all(w * 0.05),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(
                          Icons.calendar_month,
                          color: Colors.blue,
                          size: w * 0.05,
                        ),
                        SizedBox(width: w * 0.02),
                        Text(
                          DateFormat('yyyy-MM-dd – kk:mm').format(event.date),
                        ),
                      ],
                    ),
                    SizedBox(height: h * 0.02),
                    Row(
                      children: [
                        Icon(
                          Icons.location_on,
                          color: Colors.red,
                          size: w * 0.05,
                        ),
                        SizedBox(width: w * 0.02),
                        Text(event.location),
                      ],
                    ),

                    SizedBox(height: h * 0.03),
                    const Divider(),
                    SizedBox(height: h * 0.01),

                    Text(
                      "About",
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    SizedBox(height: h * 0.01),
                    Text(
                      event.description,
                      style: TextStyle(
                        fontSize: w * 0.04,
                        height: 1.5,
                        color: Colors.grey[800],
                      ),
                    ),
                    SizedBox(height: h * 0.1),
                  ],
                ),
              ),
            ),
          ],
        );
      }),

      floatingActionButton: FloatingActionButton.extended(
        onPressed: controller.registerForEvent,
        label: const Text("Register Now"),
        icon: const Icon(Icons.check),
      ),
    );
  }
}
