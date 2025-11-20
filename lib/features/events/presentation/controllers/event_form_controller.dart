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

  var selectedDate = DateTime.now().add(const Duration(days: 1)).obs; // Default tomorrow
  var selectedImagePath = ''.obs; // Local path (Gallery se)
  var uploadedImageUrl = ''.obs;  // Server URL (Edit case mein)
  var isLoading = false.obs;
  var isEditMode = false.obs;
  String? eventId; // Edit mode mein use hoga

  @override
  void onInit() {
    super.onInit();
    // Controllers initialize karein
    titleController = TextEditingController();
    descController = TextEditingController();
    locationController = TextEditingController();
    priceController = TextEditingController();

    // Check karein agar koi Event Edit ke liye pass kiya gaya hai
    final EventEntity? eventToEdit = Get.arguments;
    
    if (eventToEdit != null) {
      isEditMode.value = true;
      eventId = eventToEdit.id;
      
      // Pre-fill Data
      titleController.text = eventToEdit.title;
      descController.text = eventToEdit.description;
      locationController.text = eventToEdit.location;
      priceController.text = eventToEdit.price;
      selectedDate.value = eventToEdit.date;
      uploadedImageUrl.value = eventToEdit.imageUrl; // Existing URL
    }
  }

  // 📸 1. Image Picker Logic
  Future<void> pickImage(ImageSource source) async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: source);

    if (image != null) {
      // Local path save karein taake UI par preview dikha sakein
      selectedImagePath.value = image.path;
    }
  }

  // 📅 2. Date Picker Logic
  Future<void> pickDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate.value,
      firstDate: DateTime.now(),
      lastDate: DateTime(2101),
    );
    if (picked != null && picked != selectedDate.value) {
      selectedDate.value = picked;
    }
  }

  // 💾 3. Submit Logic (Create or Edit)
  Future<void> submitForm() async {
    if (!formKey.currentState!.validate()) return;

    // Validation: Image Check
    if (selectedImagePath.value.isEmpty && uploadedImageUrl.value.isEmpty) {
      Get.snackbar('Error', 'Please select an image', backgroundColor: Colors.red.withOpacity(0.2));
      return;
    }

    isLoading.value = true;
    String finalImageUrl = uploadedImageUrl.value;

    // Step A: Agar nayi image select ki hai, to pehle Upload karein
    if (selectedImagePath.value.isNotEmpty) {
      final uploadResult = await _repository.uploadImage(selectedImagePath.value);
      
      // uploadResult is Either<Failure, String>
      final success = uploadResult.fold(
        (failure) {
          Get.snackbar('Upload Failed', failure.message);
          isLoading.value = false;
          return false;
        },
        (url) {
          finalImageUrl = url;
          return true;
        },
      );
      
      if (!success) return; // Agar upload fail hua to ruk jayen
    }

    // Step B: Create Entity Object
    final eventEntity = EventEntity(
      id: eventId ?? '', // New event ke liye ID empty (Server dega)
      title: titleController.text,
      description: descController.text,
      date: selectedDate.value,
      location: locationController.text,
      imageUrl: finalImageUrl, // MockAPI URL or Uploaded URL
      price: priceController.text,
    );

    // Step C: Call Repository (Update or Create)
    final result = isEditMode.value
        ? await _repository.updateEvent(eventEntity)
        : await _repository.createEvent(eventEntity);

    result.fold(
      (failure) {
        isLoading.value = false;
        Get.snackbar('Error', failure.message);
      },
      (savedEvent) {
        isLoading.value = false;
        Get.back(); 
        Get.snackbar('Success', isEditMode.value ? 'Event Updated' : 'Event Created');
        
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

  @override
  void onClose() {
    titleController.dispose();
    descController.dispose();
    locationController.dispose();
    priceController.dispose();
    super.onClose();
  }
}