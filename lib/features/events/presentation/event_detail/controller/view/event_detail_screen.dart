import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:my_events_test_project/features/events/presentation/event_detail/controller/event_detail_controller.dart';

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
              expandedHeight: h * 0.35,
              pinned: true,
              flexibleSpace: FlexibleSpaceBar(
                title: Text(
                  event.title,
                  style: TextStyle(
                    fontSize: 16,
                    shadows: [Shadow(blurRadius: 10, color: Colors.black)],
                  ),
                ),
                background: CachedNetworkImage(
                  imageUrl: event.imageUrl,
                  fit: BoxFit.cover,
                  placeholder: (_, __) => Container(color: Colors.grey[200]),
                  errorWidget: (_, __, ___) => const Icon(Icons.error),
                ),
              ),
            ),

            SliverToBoxAdapter(
              child: Padding(
                padding: EdgeInsets.all(w * 0.05),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(children: [
                       Icon(Icons.calendar_month, color: Colors.blue, size: w * 0.05),
                       SizedBox(width: w * 0.02),
                       Text(DateFormat('yyyy-MM-dd – kk:mm').format(event.date)),
                    ]),
                    SizedBox(height: h * 0.02),
                    Row(children: [
                       Icon(Icons.location_on, color: Colors.red, size: w * 0.05),
                       SizedBox(width: w * 0.02),
                       Text(event.location),
                    ]),
                    
                    SizedBox(height: h * 0.03),
                    const Divider(),
                    SizedBox(height: h * 0.01),

                    Text("About", style: Theme.of(context).textTheme.titleLarge),
                    SizedBox(height: h * 0.01),
                    Text(
                      event.description,
                      style: TextStyle(fontSize: w * 0.04, height: 1.5, color: Colors.grey[800]),
                    ),
                    SizedBox(height: h * 0.1), 
                  ],
                ),
              ),
            )
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