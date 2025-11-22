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
    final theme = Theme.of(context);
    final h = MediaQuery.of(context).size.height;
    final w = MediaQuery.of(context).size.width;

    return Scaffold(
      body: Obx(() {
        return Stack(
          children: [
            CustomScrollView(
              slivers: [
                SliverAppBar(
                  surfaceTintColor: Colors.transparent,
                  expandedHeight: h * 0.15,
                  pinned: true,
                  backgroundColor: theme.scaffoldBackgroundColor,
                  leading: Container(
                    margin: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: theme.cardColor,
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          blurRadius: 10,
                        ),
                      ],
                    ),
                    child: IconButton(
                      icon: Icon(
                        Icons.arrow_back,
                        color: theme.iconTheme.color,
                      ),
                      onPressed: () => Get.back(),
                    ),
                  ),
                  flexibleSpace: FlexibleSpaceBar(
                    title: Text(
                      controller.isEditMode.value
                          ? 'Edit Event'
                          : 'Create Event',
                      style: theme.textTheme.headlineSmall?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: theme.textTheme.bodyLarge?.color,
                      ),
                    ),
                    centerTitle: true,
                  ),
                ),

                SliverToBoxAdapter(
                  child: Container(
                    decoration: BoxDecoration(
                      color: theme.scaffoldBackgroundColor,
                      borderRadius: const BorderRadius.vertical(
                        top: Radius.circular(30),
                      ),
                    ),
                    padding: EdgeInsets.all(w * 0.05),
                    child: Form(
                      key: controller.formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          GestureDetector(
                            onTap: () =>
                                _showImagePickerOptions(context, controller),
                            child: Container(
                              height: h * 0.28,
                              decoration: BoxDecoration(
                                color: theme.cardColor,
                                borderRadius: BorderRadius.circular(24),
                                border: Border.all(
                                  color: theme.dividerColor.withOpacity(0.2),
                                  width: 1.5,
                                ),
                                boxShadow: [
                                  BoxShadow(
                                    color: theme.primaryColor.withOpacity(0.05),
                                    blurRadius: 20,
                                    offset: const Offset(0, 5),
                                  ),
                                ],
                              ),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(22),
                                child: Stack(
                                  fit: StackFit.expand,
                                  children: [
                                    _buildImagePreview(controller),

                                    if (controller
                                            .selectedImagePath
                                            .value
                                            .isNotEmpty ||
                                        controller
                                            .uploadedImageUrl
                                            .value
                                            .isNotEmpty)
                                      Container(
                                        color: Colors.black26,
                                        child: const Center(
                                          child: Icon(
                                            Icons.camera_alt,
                                            color: Colors.white,
                                            size: 40,
                                          ),
                                        ),
                                      ),
                                  ],
                                ),
                              ),
                            ),
                          ),

                          const SizedBox(height: 32),

                          _buildSectionTitle(context, "Event Details"),
                          const SizedBox(height: 16),

                          _buildTextField(
                            context,
                            controller: controller.titleController,
                            label: 'Event Title',
                            icon: Icons.title,
                            validator: (v) => (v == null || v.length < 5)
                                ? "Min 5 characters"
                                : null,
                          ),
                          const SizedBox(height: 16),

                          _buildTextField(
                            context,
                            controller: controller.descController,
                            label: 'Description',
                            icon: Icons.description,
                            maxLines: 4,
                            validator: (v) => (v == null || v.length < 10)
                                ? "Min 10 characters"
                                : null,
                          ),
                          const SizedBox(height: 16),

                          GestureDetector(
                            onTap: () => controller.pickDate(context),
                            child: Container(
                              padding: const EdgeInsets.all(16),
                              decoration: BoxDecoration(
                                color: theme.cardColor,
                                borderRadius: BorderRadius.circular(16),
                                border: Border.all(
                                  color: theme.dividerColor.withOpacity(0.2),
                                ),
                              ),
                              child: Row(
                                children: [
                                  Icon(
                                    Icons.calendar_month,
                                    color: theme.dividerColor.withOpacity(0.2),
                                  ),
                                  const SizedBox(width: 12),
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        "Date",
                                        style: theme.textTheme.bodySmall
                                            ?.copyWith(color: Colors.grey),
                                      ),
                                      Text(
                                        DateFormat(
                                          'EEEE, d MMMM yyyy',
                                        ).format(controller.selectedDate.value),
                                        style: theme.textTheme.bodyLarge
                                            ?.copyWith(
                                              fontWeight: FontWeight.bold,
                                            ),
                                      ),
                                    ],
                                  ),
                                  const Spacer(),
                                  Icon(
                                    Icons.arrow_forward_ios,
                                    size: 16,
                                    color: Colors.grey[400],
                                  ),
                                ],
                              ),
                            ),
                          ),
                          const SizedBox(height: 16),

                          Row(
                            children: [
                              Expanded(
                                child: _buildTextField(
                                  context,
                                  controller: controller.locationController,
                                  label: 'City',
                                  icon: Icons.location_on,
                                  validator: (v) => (v == null || v.isEmpty)
                                      ? "Required"
                                      : null,
                                ),
                              ),
                              const SizedBox(width: 16),
                              Expanded(
                                child: _buildTextField(
                                  context,
                                  controller: controller.priceController,
                                  label: 'Price',
                                  icon: Icons.attach_money,
                                  isNumber: true,
                                  validator: (v) => (v == null || v.isEmpty)
                                      ? "Required"
                                      : null,
                                ),
                              ),
                            ],
                          ),

                          SizedBox(height: h * 0.15),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),

            if (controller.isLoading.value)
              Container(
                color: Colors.black54,
                child: const Center(child: CircularProgressIndicator()),
              ),
          ],
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
              borderRadius: BorderRadius.circular(18),
              boxShadow: [
                BoxShadow(
                  color: theme.primaryColor.withOpacity(0.3),
                  blurRadius: 12,
                  offset: const Offset(0, 6),
                ),
              ],
            ),
            child: ElevatedButton(
              onPressed: controller.submitForm,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.transparent,
                shadowColor: Colors.transparent,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(18),
                ),
              ),
              child: Obx(
                () => Text(
                  controller.isEditMode.value ? 'Update Event' : 'Create Event',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(
    BuildContext context, {
    required TextEditingController controller,
    required String label,
    required IconData icon,
    String? Function(String?)? validator,
    int maxLines = 1,
    bool isNumber = false,
  }) {
    final theme = Theme.of(context);
    return TextFormField(
      controller: controller,
      maxLines: maxLines,
      keyboardType: isNumber ? TextInputType.number : TextInputType.text,
      validator: validator,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon, color: theme.dividerColor.withOpacity(0.2)),
        filled: true,
        fillColor: theme.cardColor,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide(color: theme.dividerColor.withOpacity(0.5)),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide(color: theme.dividerColor.withOpacity(0.2)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide(color: theme.dividerColor.withOpacity(0.5)),
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 20,
          vertical: 16,
        ),
      ),
    );
  }

  Widget _buildImagePreview(EventFormController controller) {
    if (controller.selectedImagePath.value.isNotEmpty) {
      return Image.file(
        File(controller.selectedImagePath.value),
        fit: BoxFit.cover,
      );
    }
    if (controller.uploadedImageUrl.value.isNotEmpty) {
      return CachedNetworkImage(
        imageUrl: controller.uploadedImageUrl.value,
        fit: BoxFit.cover,
        placeholder: (_, __) =>
            const Center(child: CircularProgressIndicator()),
        errorWidget: (_, __, ___) => const Icon(Icons.broken_image, size: 50),
      );
    }
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(
          Icons.add_photo_alternate_outlined,
          size: 50,
          color: Colors.grey[400],
        ),
        const SizedBox(height: 8),
        Text(
          "Add Photo",
          style: TextStyle(
            color: Colors.grey[600],
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }

  void _showImagePickerOptions(
    BuildContext context,
    EventFormController controller,
  ) {
    final theme = Theme.of(context);
    Get.bottomSheet(
      Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: theme.scaffoldBackgroundColor,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              "Upload Photo",
              style: theme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildOptionButton(context, Icons.camera_alt, "Camera", () {
                  Get.back();
                  controller.pickImage(ImageSource.camera);
                }),
                _buildOptionButton(context, Icons.photo_library, "Gallery", () {
                  Get.back();
                  controller.pickImage(ImageSource.gallery);
                }),
              ],
            ),
            const SizedBox(height: 12),
          ],
        ),
      ),
    );
  }

  Widget _buildOptionButton(
    BuildContext context,
    IconData icon,
    String label,
    VoidCallback onTap,
  ) {
    final theme = Theme.of(context);
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: theme.primaryColor.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, size: 30, color: theme.dividerColor),
          ),
          const SizedBox(height: 8),
          Text(
            label,
            style: theme.textTheme.bodyMedium?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(BuildContext context, String title) {
    return Text(
      title,
      style: Theme.of(context).textTheme.titleMedium?.copyWith(
        fontWeight: FontWeight.bold,
        color: Colors.grey,
      ),
    );
  }
}
