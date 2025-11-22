import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:my_events_test_project/app/core/utils/offline_banner.dart';
import 'package:my_events_test_project/app/navigation/app_routes.dart';
import 'package:my_events_test_project/features/events/presentation/controllers/event_detail_controller.dart';
import 'package:my_events_test_project/features/events/presentation/widgets/event_detail_skeleton.dart';
import 'package:url_launcher/url_launcher.dart';

class EventDetailScreen extends StatelessWidget {
  const EventDetailScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(EventDetailController());
    final h = MediaQuery.of(context).size.height;
    final w = MediaQuery.of(context).size.width;
    final theme = Theme.of(context);

    return Scaffold(
      body: Obx(() {
        if (controller.isLoading.value) {
          return const EventDetailSkeleton();
        }
        if (controller.event.value == null) {
          return const Center(child: Text("Event not found"));
        }

        final event = controller.event.value!;

        return SafeArea(
          child: Column(
            children: [
              const OfflineBanner(),
              Expanded(
                child: CustomScrollView(
                  slivers: [
                    SliverAppBar(
                      expandedHeight: h * 0.4,
                      pinned: true,
                      surfaceTintColor: Colors.transparent,
                      backgroundColor: theme.scaffoldBackgroundColor,
                      leading: Container(
                        margin: const EdgeInsets.all(8),
                        decoration: const BoxDecoration(
                          color: Colors.black45,
                          shape: BoxShape.circle,
                        ),
                        child: IconButton(
                          icon: const Icon(
                            Icons.arrow_back,
                            color: Colors.white,
                            size: 20,
                          ),
                          onPressed: () => Get.back(),
                        ),
                      ),
                      actions: [
                        Container(
                          margin: const EdgeInsets.all(8),
                          decoration: const BoxDecoration(
                            color: Colors.black45,
                            shape: BoxShape.circle,
                          ),
                          child: IconButton(
                            icon: const Icon(
                              Icons.edit,
                              color: Colors.white,
                              size: 20,
                            ),
                            onPressed: () => Get.toNamed(
                              AppRoutes.eventForm,
                              arguments: event,
                            ),
                          ),
                        ),
                      ],
                      flexibleSpace: FlexibleSpaceBar(
                        background: Hero(
                          tag: 'event_img_${event.id}',
                          child: CachedNetworkImage(
                            imageUrl: event.imageUrl,
                            fit: BoxFit.cover,
                            placeholder: (_, __) =>
                                Container(color: Colors.grey[200]),
                            errorWidget: (_, __, ___) =>
                                const Icon(Icons.broken_image),
                          ),
                        ),
                      ),
                    ),
          
                    SliverToBoxAdapter(
                      child: Transform.translate(
                        offset: const Offset(0, -24),
                        child: Container(
                          decoration: BoxDecoration(
                            color: theme.scaffoldBackgroundColor,
                            borderRadius: const BorderRadius.vertical(
                              top: Radius.circular(32),
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.05),
                                blurRadius: 10,
                                offset: const Offset(0, -5),
                              ),
                            ],
                          ),
                          padding: EdgeInsets.symmetric(
                            horizontal: w * 0.05,
                            vertical: 24,
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const SizedBox(height: 30),
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Expanded(
                                    child: Text(
                                      event.title,
                                      style: theme.textTheme.headlineSmall
                                          ?.copyWith(
                                            fontWeight: FontWeight.w800,
                                            height: 1.2,
                                          ),
                                    ),
                                  ),
                                  const SizedBox(width: 16),
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 12,
                                      vertical: 6,
                                    ),
                                    decoration: BoxDecoration(
                                      color: theme.primaryColor.withOpacity(0.1),
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    child: Text(
                                      "\$${event.price}",
                                      style: theme.textTheme.titleLarge?.copyWith(
                                        color: theme.primaryColor,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
          
                              const SizedBox(height: 12),
          
                              _buildInfoTile(
                                context,
                                Icons.calendar_month_rounded,
                                Colors.blue,
                                DateFormat(
                                  'EEEE, d MMMM yyyy',
                                ).format(event.date),
                              ),
                              const SizedBox(height: 12),
                              _buildInfoTile(
                                context,
                                Icons.access_time_rounded,
                                Colors.orange,
                                DateFormat('hh:mm a').format(event.date),
                              ),
                              const SizedBox(height: 12),
                              _buildInfoTile(
                                context,
                                Icons.location_on_rounded,
                                Colors.red,
                                event.location,
                              ),
          
                              const SizedBox(height: 20),
          
                              _buildSectionTitle(context, "Organizer"),
                              const SizedBox(height: 20),
                              Container(
                                padding: const EdgeInsets.all(16),
                                decoration: BoxDecoration(
                                  color: theme.cardColor,
                                  borderRadius: BorderRadius.circular(24),
                                  border: Border.all(
                                    color: theme.dividerColor.withOpacity(0.2),
                                  ),
          
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black.withOpacity(0.03),
                                      blurRadius: 15,
                                      offset: const Offset(0, 5),
                                    ),
                                  ],
                                ),
                                child: Row(
                                  children: [
                                    Container(
                                      padding: const EdgeInsets.all(10),
                                      decoration: BoxDecoration(
                                        shape: BoxShape.circle,
          
                                        gradient: LinearGradient(
                                          begin: Alignment.topLeft,
                                          end: Alignment.bottomRight,
                                          colors: [
                                            Colors.blue,
                                            Colors.blue.withOpacity(0.6),
                                          ],
                                          stops: const [0.3, 1.0],
                                        ),
          
                                        boxShadow: [
                                          BoxShadow(
                                            color: theme.primaryColor.withOpacity(
                                              0.4,
                                            ),
                                            blurRadius: 12,
                                            offset: const Offset(0, 6),
                                            spreadRadius: 0,
                                          ),
                                        ],
                                      ),
          
                                      child: const Icon(
                                        Icons.person,
                                        color: Colors.white,
                                        size: 24,
                                      ),
                                    ),
                                    const SizedBox(width: 16),
          
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          event.organizerName,
                                          style: theme.textTheme.titleMedium
                                              ?.copyWith(
                                                fontWeight: FontWeight.bold,
                                              ),
                                        ),
                                        const SizedBox(height: 2),
                                        Text(
                                          "Event Host",
                                          style: theme.textTheme.bodySmall
                                              ?.copyWith(color: Colors.grey),
                                        ),
                                      ],
                                    ),
          
                                    const Spacer(),
          
                                    // ✨ STYLED CALL BUTTON
                                    Container(
                                      decoration: BoxDecoration(
                                        gradient: LinearGradient(
                                          colors: [
                                            Colors.green.shade400,
                                            Colors.green.shade600,
                                          ],
                                          begin: Alignment.topLeft,
                                          end: Alignment.bottomRight,
                                        ),
                                        borderRadius: BorderRadius.circular(14),
                                        boxShadow: [
                                          BoxShadow(
                                            color: Colors.green.withOpacity(0.3),
                                            blurRadius: 8,
                                            offset: const Offset(0, 4),
                                          ),
                                        ],
                                      ),
                                      child: Padding(
                                        padding: const EdgeInsets.all(10),
                                        child: Icon(
                                          Icons.phone,
                                          color: Colors.white,
                                          size: 24,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(height: 24),
          
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  _buildSectionTitle(context, "Attendees"),
                                  TextButton(
                                    onPressed: () {},
                                    child: Text(
                                      "See All",
                                      style: TextStyle(color: theme.primaryColor),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 8),
                              SizedBox(
                                height: 50,
                                child: ListView.builder(
                                  scrollDirection: Axis.horizontal,
                                  itemCount: event.attendeeCount > 6
                                      ? 6
                                      : event.attendeeCount,
                                  itemBuilder: (context, index) {
                                    return Container(
                                      margin: const EdgeInsets.only(right: 12),
                                      decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        border: Border.all(
                                          color: theme.scaffoldBackgroundColor,
                                          width: 2,
                                        ),
                                        boxShadow: [
                                          BoxShadow(
                                            color: Colors.black.withOpacity(0.1),
                                            blurRadius: 5,
                                          ),
                                        ],
                                      ),
                                      child: CircleAvatar(
                                        radius: 22,
                                        backgroundColor: theme.dividerColor.withOpacity(0.2),
                                        backgroundImage: NetworkImage(
                                          "https://i.pravatar.cc/150?u=${event.id}$index",
                                        ),
                                      ),
                                    );
                                  },
                                ),
                              ),
          
                              const SizedBox(height: 24),
          
                              _buildSectionTitle(context, "About Event"),
                              const SizedBox(height: 12),
                              Text(
                                event.description,
                                style: theme.textTheme.bodyMedium?.copyWith(
                                  height: 1.6,
                                  color: theme.textTheme.bodyMedium?.color
                                      ?.withOpacity(0.7),
                                ),
                              ),
          
                              const SizedBox(height: 24),
          
                              _buildSectionTitle(context, "Location Map"),
                              const SizedBox(height: 20),
                              GestureDetector(
                               onTap: () async {
                                final Uri googleMapsUrl = Uri.parse(
                                    "https://www.google.com/maps/search/?api=1&query=${event.latitude},${event.longitude}");

                                try {
                                  if (!await launchUrl(googleMapsUrl, mode: LaunchMode.externalApplication)) {
                                    throw Exception('Could not launch maps');
                                  }
                                } catch (e) {
                                  debugPrint("Map Error: $e");
                                  Get.snackbar(
                                    "Error", 
                                    "Could not open maps. Please ensure Google Maps or a browser is installed.",
                                    backgroundColor: Colors.red.withOpacity(0.1),
                                    colorText: Colors.red,
                                    snackPosition: SnackPosition.BOTTOM,
                                  );
                                }
                              },
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(20),
                                  child: Container(
                                    height: 180,
                                    width: double.infinity,
                                    decoration: BoxDecoration(
                                      color: theme
                                          .colorScheme
                                          .surfaceContainerHighest,
                                      borderRadius: BorderRadius.circular(20),
                                      border: Border.all(
                                        color: theme.dividerColor.withOpacity(
                                          0.1,
                                        ),
                                      ),
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.black.withOpacity(0.05),
                                          blurRadius: 10,
                                          offset: const Offset(0, 4),
                                        ),
                                      ],
                                    ),
                                    child: Stack(
                                      fit: StackFit.expand,
                                      children: [
                                        Image.network(
                                          "https://images.unsplash.com/photo-1524661135-423995f22d0b?q=80&w=800&auto=format&fit=crop",
                                          fit: BoxFit.cover,
                                          loadingBuilder:
                                              (context, child, loadingProgress) {
                                                if (loadingProgress == null)
                                                  return child;
                                                return Center(
                                                  child:
                                                      CircularProgressIndicator(
                                                        color: theme.primaryColor,
                                                      ),
                                                );
                                              },
                                          errorBuilder: (_, __, ___) =>
                                              Container(color: context.theme.primaryColor.withOpacity(0.1)),
                                        ),
          
                                        Container(
                                          decoration: BoxDecoration(
                                            gradient: LinearGradient(
                                              begin: Alignment.topCenter,
                                              end: Alignment.bottomCenter,
                                              colors: [
                                                Colors.transparent,
                                                Colors.black.withOpacity(0.3),
                                              ],
                                            ),
                                          ),
                                        ),
          
                                        Center(
                                          child: Icon(
                                            Icons.location_on,
                                            size: 48,
                                            color: Colors.green,
                                            shadows: const [
                                              Shadow(
                                                color: Colors.black26,
                                                blurRadius: 10,
                                                offset: Offset(0, 4),
                                              ),
                                            ],
                                          ),
                                        ),
          
                                        Positioned(
                                          bottom: 12,
                                          right: 12,
                                          child: Container(
                                            padding: const EdgeInsets.symmetric(
                                              horizontal: 12,
                                              vertical: 8,
                                            ),
                                            decoration: BoxDecoration(
                                              color: Colors.white,
                                              borderRadius: BorderRadius.circular(
                                                12,
                                              ),
                                              boxShadow: [
                                                BoxShadow(
                                                  color: Colors.black.withOpacity(
                                                    0.1,
                                                  ),
                                                  blurRadius: 8,
                                                  offset: const Offset(0, 2),
                                                ),
                                              ],
                                            ),
                                            child: Row(
                                              mainAxisSize: MainAxisSize.min,
                                              children: [
                                                Text(
                                                  "Open in Maps",
                                                  style: TextStyle(
                                                    color: theme.primaryColor,
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 12,
                                                  ),
                                                ),
                                                const SizedBox(width: 4),
                                                Icon(
                                                  Icons.open_in_new,
                                                  size: 14,
                                                  color: theme.primaryColor,
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                              SizedBox(height: h * 0.12),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      }),

      bottomSheet: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: theme.scaffoldBackgroundColor,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: const Offset(0, -5),
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.only(bottom: 20),
          child: Container(
            width: double.infinity,
            height: 56,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [theme.primaryColor, theme.primaryColor.withBlue(255)],
              ),
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: theme.primaryColor.withOpacity(0.3),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: ElevatedButton(
              onPressed: () =>
                  Get.find<EventDetailController>().registerForEvent(),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.transparent,
                shadowColor: Colors.transparent,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
              ),
              child: const Text(
                "Register Now",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildInfoTile(
    BuildContext context,
    IconData icon,
    Color color,
    String text,
  ) {
    final theme = Theme.of(context);

    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: theme.cardColor,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: theme.dividerColor.withOpacity(0.2)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [color.withOpacity(0.8), color.withOpacity(0.4)],
              ),
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: color.withOpacity(0.3),
                  blurRadius: 8,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Icon(icon, color: Colors.white, size: 22),
          ),

          const SizedBox(width: 16),

          Expanded(
            child: Text(
              text,
              style: theme.textTheme.bodyLarge?.copyWith(
                fontWeight: FontWeight.w600,
                height: 1.2,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(BuildContext context, String title) {
    return Text(
      title,
      style: Theme.of(
        context,
      ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
    );
  }
}
