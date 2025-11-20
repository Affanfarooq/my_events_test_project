import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:my_events_test_project/app/navigation/app_routes.dart';
import 'package:my_events_test_project/features/events/domain/entities/event_entity.dart';

class EventCard extends StatelessWidget {
  final EventEntity event;
  const EventCard({super.key, required this.event});

  @override
  Widget build(BuildContext context) {
    final h = MediaQuery.of(context).size.height;
    final w = MediaQuery.of(context).size.width;
    final isFav = event.isFavorite.obs;
    final theme = Theme.of(context);
    final isDark = Get.isDarkMode;

    return GestureDetector(
      onTap: () => Get.toNamed(AppRoutes.eventDetails, parameters: {'id': event.id}),
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: w * 0.04, vertical: h * 0.012),
        decoration: BoxDecoration(
          color: theme.cardColor,
          borderRadius: BorderRadius.circular(24),
          border: Border.all(
            color: theme.dividerColor.withOpacity(0.1), 
            width: 1.5,
          ),
          boxShadow: [
            BoxShadow(
              color: theme.primaryColor.withOpacity(isDark ? 0.0 : 0.08),
              blurRadius: 20,
              offset: const Offset(0, 8),
              spreadRadius: -2,
            )
          ],
        ),
        child: Column(
          children: [
            Stack(
              children: [
                Hero(
                  tag: 'event_img_${event.id}',
                  child: ClipRRect(
                    borderRadius: const BorderRadius.vertical(top: Radius.circular(22)),
                    child: CachedNetworkImage(
                      imageUrl: event.imageUrl,
                      height: h * 0.22,
                      width: double.infinity,
                      fit: BoxFit.cover,
                      placeholder: (_, __) => Container(color: theme.colorScheme.surfaceContainerHighest),
                      errorWidget: (_, __, ___) => Container(
                          color: theme.colorScheme.surfaceContainerHighest, 
                          child: const Icon(Icons.broken_image)),
                    ),
                  ),
                ),

                Positioned(
                  top: 12,
                  left: 12,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                    decoration: BoxDecoration(
                      color: isDark ? Colors.grey[900] : Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.2),
                          blurRadius: 8,
                          offset: const Offset(0, 4),
                        )
                      ],
                    ),
                    child: Column(
                      children: [
                        Text(
                          DateFormat('dd').format(event.date),
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w900, 
                            fontSize: 18
                          ),
                        ),
                        Text(
                          DateFormat('MMM').format(event.date).toUpperCase(),
                          style: TextStyle(
                            color: isDark ? Colors.grey[400] : Colors.grey[800], 
                            fontSize: 10, 
                            fontWeight: FontWeight.bold,
                            letterSpacing: 1,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                Positioned(
                  top: 10,
                  right: 10,
                  child: Obx(() => Container(
                    decoration: BoxDecoration(
                      color: isDark ? Colors.black54 : Colors.white.withOpacity(0.9),
                      shape: BoxShape.circle,
                    ),
                    child: IconButton(
                      icon: Icon(
                        isFav.value ? Icons.favorite : Icons.favorite_border,
                        color: isFav.value ? Colors.red : Colors.grey,
                        size: 22,
                      ),
                      onPressed: () => isFav.toggle(),
                      constraints: const BoxConstraints(minWidth: 40, minHeight: 40),
                      padding: EdgeInsets.zero,
                    ),
                  )),
                ),

                Positioned(
                  bottom: 12,
                  right: 12,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [theme.primaryColor, theme.primaryColor.withBlue(200)],
                      ),
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(
                          color: theme.primaryColor.withOpacity(0.4), 
                          blurRadius: 8, 
                          offset: const Offset(0, 4)
                        )
                      ],
                    ),
                    child: Text(
                      "\$${event.price}",
                      style: const TextStyle(
                        color: Colors.white, 
                        fontWeight: FontWeight.bold,
                        fontSize: 14
                      ),
                    ),
                  ),
                ),
              ],
            ),

            Padding(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    event.title,
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w800,
                      fontSize: 17,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  
                  const SizedBox(height: 16),
                  
                  Row(
                    children: [
                      _buildInfoCapsule(
                        context, 
                        Icons.group, 
                        "${event.attendeeCount} Going",
                        Colors.blue, 
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: _buildInfoCapsule(
                          context, 
                          Icons.location_on, 
                          event.location,
                          Colors.orange, 
                        ),
                      ),
                    ],
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Helper to build those colored capsules
  Widget _buildInfoCapsule(BuildContext context, IconData icon, String text, Color color) {
    final theme = Theme.of(context);
    final isDark = Get.isDarkMode;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        // Very light background of the accent color
        color: color.withOpacity(isDark ? 0.15 : 0.08),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: color),
          const SizedBox(width: 6),
          Flexible(
            child: Text(
              text,
              style: theme.textTheme.bodySmall?.copyWith(
                color: isDark ? color.withOpacity(0.9) : Colors.black87,
                fontWeight: FontWeight.w600,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }
}