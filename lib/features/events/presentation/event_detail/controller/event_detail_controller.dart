import 'package:get/get.dart';
import 'package:my_events_test_project/features/events/domain/entities/event_entity.dart';
import 'package:my_events_test_project/features/events/domain/entities/repositories/event_repository.dart';

class EventDetailController extends GetxController {
  final EventRepository _repository = Get.find<EventRepository>();

  var isLoading = true.obs;
  var event = Rxn<EventEntity>(); 

  @override
  void onInit() {
    super.onInit();
    final String eventId = Get.parameters['id'] ?? '';
    if (eventId.isNotEmpty) {
      fetchEventDetails(eventId);
    }
  }

  Future<void> fetchEventDetails(String id) async {
    isLoading.value = true;
    final result = await _repository.getEventDetails(id);

    result.fold(
      (failure) {
        isLoading.value = false;
        Get.snackbar("Error", failure.message);
      },
      (data) {
        event.value = data;
        isLoading.value = false;
      },
    );
  }

  void registerForEvent() {
    Get.snackbar("Success", "Registered for ${event.value?.title}!");
  }
}