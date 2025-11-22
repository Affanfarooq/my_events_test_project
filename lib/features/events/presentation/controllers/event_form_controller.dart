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

  // Text Editing Controllers
  late TextEditingController titleController;
  late TextEditingController descController;
  late TextEditingController locationController;
  late TextEditingController priceController;

  // Reactive State Variables
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

    // Check if we are in Edit Mode (passed via arguments)
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

  Future<void> submitForm() async {
    if (!formKey.currentState!.validate()) return;

    if (selectedImagePath.value.isEmpty && uploadedImageUrl.value.isEmpty) {
      Get.snackbar('Error', 'Please select an image', backgroundColor: Colors.red.withOpacity(0.2));
      return;
    }

    isLoading.value = true;
    String finalImageUrl = uploadedImageUrl.value;

    // Upload Image (if a new local file is selected)
    if (selectedImagePath.value.isNotEmpty) {
      final uploadResult = await _repository.uploadImage(selectedImagePath.value);
      
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
      
      if (!success) return; 
    }

    final eventEntity = EventEntity(
      id: eventId ?? '', 
      title: titleController.text,
      description: descController.text,
      date: selectedDate.value,
      location: locationController.text,
      imageUrl: finalImageUrl,
      price: priceController.text,
      attendeeCount: isEditMode.value ? (Get.arguments as EventEntity).attendeeCount : 0,
      isFavorite: isEditMode.value ? (Get.arguments as EventEntity).isFavorite : false,
      organizerName: isEditMode.value ? (Get.arguments as EventEntity).organizerName : "Me",
      latitude: isEditMode.value ? (Get.arguments as EventEntity).latitude : 0.0,
      longitude: isEditMode.value ? (Get.arguments as EventEntity).longitude : 0.0,
    );

    // Call Repository to Create or Update
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
        
        // Refresh the list screen locally without API call
        if (Get.isRegistered<EventListController>()) {
          final listController = Get.find<EventListController>();
          if (isEditMode.value) {
            listController.updateEventLocally(savedEvent);
          } else {
            listController.addNewEventLocally(savedEvent);
          }
        }

        // Refresh the detail screen if it's open
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