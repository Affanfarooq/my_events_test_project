import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:my_events_test_project/features/events/presentation/controllers/event_form_controller.dart';

class EventFormScreen extends StatelessWidget {
  const EventFormScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(EventFormController());
    
    // Responsive Helpers
    final h = MediaQuery.of(context).size.height;
    final w = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
        title: Obx(() => Text(controller.isEditMode.value ? 'Edit Event' : 'Create Event')),
      ),
      body: Obx(() {
        // Loading State (Full Screen Overlay)
        return Stack(
          children: [
            SingleChildScrollView(
              padding: EdgeInsets.all(w * 0.05),
              child: Form(
                key: controller.formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // 📸 1. Image Picker Area
                    GestureDetector(
                      onTap: () => _showImagePickerOptions(context, controller),
                      child: Container(
                        height: h * 0.25,
                        decoration: BoxDecoration(
                          color: Colors.grey[200],
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: Colors.grey[400]!),
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(12),
                          child: _buildImagePreview(controller),
                        ),
                      ),
                    ),
                    SizedBox(height: h * 0.01),
                    const Center(child: Text("Tap to upload image", style: TextStyle(color: Colors.grey))),
                    
                    SizedBox(height: h * 0.03),

                    // 📝 2. Title Field
                    TextFormField(
                      controller: controller.titleController,
                      decoration: const InputDecoration(labelText: 'Event Title'),
                      validator: (v) => (v == null || v.length < 5) ? "Min 5 characters required" : null,
                    ),
                    SizedBox(height: h * 0.02),

                    // 📝 3. Description Field
                    TextFormField(
                      controller: controller.descController,
                      maxLines: 3,
                      decoration: const InputDecoration(labelText: 'Description'),
                      validator: (v) => (v == null || v.length < 10) ? "Min 10 characters required" : null,
                    ),
                    SizedBox(height: h * 0.02),

                    // 📅 4. Date Picker
                    InkWell(
                      onTap: () => controller.pickDate(context),
                      child: InputDecorator(
                        decoration: const InputDecoration(
                          labelText: 'Event Date',
                          suffixIcon: Icon(Icons.calendar_today),
                        ),
                        child: Text(
                          DateFormat('yyyy-MM-dd').format(controller.selectedDate.value),
                        ),
                      ),
                    ),
                    SizedBox(height: h * 0.02),

                    // 📍 5. Location & Price Row
                    Row(
                      children: [
                        Expanded(
                          child: TextFormField(
                            controller: controller.locationController,
                            decoration: const InputDecoration(labelText: 'Location (City)'),
                            validator: (v) => (v == null || v.isEmpty) ? "Required" : null,
                          ),
                        ),
                        SizedBox(width: w * 0.04),
                        Expanded(
                          child: TextFormField(
                            controller: controller.priceController,
                            keyboardType: TextInputType.number,
                            decoration: const InputDecoration(labelText: 'Price (\$)'),
                            validator: (v) => (v == null || v.isEmpty) ? "Required" : null,
                          ),
                        ),
                      ],
                    ),
                    
                    SizedBox(height: h * 0.05),

                    // 💾 6. Submit Button
                    ElevatedButton(
                      onPressed: controller.submitForm,
                      style: ElevatedButton.styleFrom(
                        padding: EdgeInsets.symmetric(vertical: h * 0.02),
                        backgroundColor: Colors.blue,
                      ),
                      child: Text(
                        controller.isEditMode.value ? 'Update Event' : 'Create Event',
                        style: const TextStyle(color: Colors.white, fontSize: 16),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            
            // Loading Indicator Overlay
            if (controller.isLoading.value)
              Container(
                color: Colors.black.withOpacity(0.5),
                child: const Center(child: CircularProgressIndicator()),
              ),
          ],
        );
      }),
    );
  }

  // Helper Widget: Image Preview Logic
  Widget _buildImagePreview(EventFormController controller) {
    // Case A: New Local Image Selected
    if (controller.selectedImagePath.value.isNotEmpty) {
      return Image.file(File(controller.selectedImagePath.value), fit: BoxFit.cover);
    }
    // Case B: Edit Mode (Existing URL)
    if (controller.uploadedImageUrl.value.isNotEmpty) {
      return CachedNetworkImage(
        imageUrl: controller.uploadedImageUrl.value,
        fit: BoxFit.cover,
        placeholder: (_, __) => const Center(child: CircularProgressIndicator()),
        errorWidget: (_, __, ___) => const Icon(Icons.broken_image, size: 50),
      );
    }
    // Case C: No Image
    return const Center(child: Icon(Icons.add_a_photo, size: 50, color: Colors.grey));
  }

  // Helper Function: Bottom Sheet for Camera/Gallery
  void _showImagePickerOptions(BuildContext context, EventFormController controller) {
    Get.bottomSheet(
      Container(
        color: Colors.white,
        padding: const EdgeInsets.all(16),
        child: Wrap(
          children: [
            ListTile(
              leading: const Icon(Icons.camera_alt),
              title: const Text('Camera'),
              onTap: () {
                Get.back();
                controller.pickImage(ImageSource.camera);
              },
            ),
            ListTile(
              leading: const Icon(Icons.photo_library),
              title: const Text('Gallery'),
              onTap: () {
                Get.back();
                controller.pickImage(ImageSource.gallery);
              },
            ),
          ],
        ),
      ),
    );
  }
}