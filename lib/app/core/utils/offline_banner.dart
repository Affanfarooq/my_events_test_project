import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:my_events_test_project/app/core/network/network_controller.dart';

class OfflineBanner extends StatelessWidget {
  const OfflineBanner({super.key});

  @override
  Widget build(BuildContext context) {
    final NetworkController networkController = Get.find<NetworkController>();

    return Obx(() {
      if (networkController.isConnected.value) {
        return const SizedBox.shrink();
      }

      return Container(
        width: double.infinity,
        color: Colors.red,
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: const Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.wifi_off, color: Colors.white, size: 16),
            SizedBox(width: 8),
            Text(
              "No Internet Connection - Showing Cached Data",
              style: TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      );
    });
  }
}