import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:my_events_test_project/features/events/domain/entities/event_entity.dart';
import 'package:my_events_test_project/features/events/domain/repositories/event_repository.dart';
import 'package:my_events_test_project/features/events/presentation/controllers/event_detail_controller.dart';
import 'package:my_events_test_project/features/events/presentation/controllers/event_list_controller.dart';

class EventFormController extends GetxController {
  final EventRepository _repository = Get.find<EventRepository>();
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  late TextEditingController titleController;
  late TextEditingController descController;
  late TextEditingController locationController;
  late TextEditingController priceController;

  var selectedDate = DateTime.now().add(const Duration(days: 1)).obs;
  var selectedImagePath = ''.obs;
  var uploadedImageUrl = ''.obs;
  var isLoading = false.obs;
  var isEditMode = false.obs;
  String? eventId;

  @override
  void onInit() {
    super.onInit();
    titleController = TextEditingController();
    descController = TextEditingController();
    locationController = TextEditingController();
    priceController = TextEditingController();

    final EventEntity? eventToEdit = Get.arguments;

    if (eventToEdit != null) {
      isEditMode.value = true;
      eventId = eventToEdit.id;
      titleController.text = eventToEdit.title;
      descController.text = eventToEdit.description;
      locationController.text = eventToEdit.location;
      priceController.text = eventToEdit.price;
      selectedDate.value = eventToEdit.date;
      uploadedImageUrl.value = eventToEdit.imageUrl;
    }
  }

  Future<void> pickImage(ImageSource source) async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: source);

    if (image != null) {
      selectedImagePath.value = image.path;
    }
  }

  Future<void> submitForm() async {
    if (!formKey.currentState!.validate()) return;

    if (selectedImagePath.value.isEmpty && uploadedImageUrl.value.isEmpty) {
      Get.snackbar(
        'Error',
        'Please select an image',
        backgroundColor: Colors.red.withOpacity(0.2),
      );
      return;
    }

    isLoading.value = true;
    String finalImageUrl = uploadedImageUrl.value;

    if (selectedImagePath.value.isNotEmpty) {
      print("📸 Uploading new image...");

      final uploadResult = await _repository.uploadImage(
        selectedImagePath.value,
      );

      final success = uploadResult.fold(
        (failure) {
          print("❌ Upload Failed: ${failure.message}");
          Get.snackbar('Upload Failed', failure.message);
          isLoading.value = false;
          return false;
        },
        (url) {
          print("✅ Upload Success! New URL: $url");
          finalImageUrl = url;
          return true;
        },
      );

      if (!success) return;
    } else {
      print("ℹ️ Using existing image URL: $finalImageUrl");
    }

    // 3. Create Entity
    final eventEntity = EventEntity(
      id: eventId ?? '',
      title: titleController.text,
      description: descController.text,
      date: selectedDate.value,
      location: locationController.text,
      imageUrl: finalImageUrl,
      price: priceController.text,
      attendeeCount: isEditMode.value
          ? (Get.arguments as EventEntity).attendeeCount
          : 0,
      isFavorite: isEditMode.value
          ? (Get.arguments as EventEntity).isFavorite
          : false,
      organizerName: isEditMode.value
          ? (Get.arguments as EventEntity).organizerName
          : "Me",
      latitude: isEditMode.value
          ? (Get.arguments as EventEntity).latitude
          : 0.0,
      longitude: isEditMode.value
          ? (Get.arguments as EventEntity).longitude
          : 0.0,
    );

    print("🚀 Sending Event to API with Image: ${eventEntity.imageUrl}");

    // 4. Call Repository
    final result = isEditMode.value
        ? await _repository.updateEvent(eventEntity)
        : await _repository.createEvent(eventEntity);

    result.fold(
      (failure) {
        isLoading.value = false;
        Get.snackbar('Error', failure.message);
      },
      (savedEvent) {
        print("✅ API Success! Saved Image URL: ${savedEvent.imageUrl}");

        isLoading.value = false;
        Get.back();
        Get.snackbar(
          'Success',
          isEditMode.value ? 'Event Updated' : 'Event Created',
        );

        if (Get.isRegistered<EventListController>()) {
          final listController = Get.find<EventListController>();
          if (isEditMode.value) {
            listController.updateEventLocally(savedEvent);
          } else {
            listController.addNewEventLocally(savedEvent);
          }
        }

        if (Get.isRegistered<EventDetailController>()) {
          Get.find<EventDetailController>().updateEventLocally(savedEvent);
        }
      },
    );
  }

  Future<void> pickDate(BuildContext context) async {
    final theme = Theme.of(context);

    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate.value,
      firstDate: DateTime.now(),
      lastDate: DateTime(2101),
      builder: (context, child) {
        return Theme(
          data: theme.copyWith(
            colorScheme: theme.colorScheme.copyWith(
              primary: theme.primaryColor,
              onPrimary: Colors.white,
              surface: theme.scaffoldBackgroundColor,
              onSurface: theme.textTheme.bodyLarge?.color,
            ),
            dialogBackgroundColor: theme.scaffoldBackgroundColor,
          ),
          child: child!,
        );
      },
    );

    if (picked != null && picked != selectedDate.value) {
      selectedDate.value = picked;
    }
  }

  @override
  void onClose() {
    titleController.dispose();
    descController.dispose();
    locationController.dispose();
    priceController.dispose();
    super.onClose();
  }
}
