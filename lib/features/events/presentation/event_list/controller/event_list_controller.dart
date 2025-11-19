import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:my_events_test_project/app/navigation/navigations/app_routes.dart';
import 'package:my_events_test_project/app/services/storage_service.dart';
import 'package:my_events_test_project/features/events/domain/entities/event_entity.dart';
import 'package:my_events_test_project/features/events/domain/entities/repositories/event_repository.dart';

class EventListController extends GetxController {
  final EventRepository _repository = Get.find<EventRepository>();
  final StorageService _storage = Get.find<StorageService>();

  var events = <EventEntity>[].obs;
  var isLoading = true.obs; 
  var isMoreLoading = false.obs; 
  
  int _page = 1;
  final int _limit = 10;
  bool _hasMore = true;
  final ScrollController scrollController = ScrollController();

  @override
  void onInit() {
    super.onInit();
    fetchEvents();
    
    scrollController.addListener(() {
      if (scrollController.position.pixels == scrollController.position.maxScrollExtent && 
          !isMoreLoading.value && 
          _hasMore) {
        loadMoreEvents();
      }
    });
  }

  Future<void> fetchEvents() async {
    isLoading.value = true;
    _page = 1;
    _hasMore = true;
    
    final result = await _repository.getEvents(page: _page, limit: _limit);
    
    result.fold(
      (failure) {
        isLoading.value = false;
        Get.snackbar("Error", failure.message);
      },
      (data) {
        events.value = data;
        isLoading.value = false;
        if (data.length < _limit) _hasMore = false;
      },
    );
  }

  Future<void> loadMoreEvents() async {
    isMoreLoading.value = true;
    _page++;

    final result = await _repository.getEvents(page: _page, limit: _limit);

    result.fold(
      (failure) {
        isMoreLoading.value = false;
        Get.snackbar("Error", failure.message);
      },
      (data) {
        if (data.isEmpty) {
          _hasMore = false;
        } else {
          events.addAll(data);
          if (data.length < _limit) _hasMore = false;
        }
        isMoreLoading.value = false;
      },
    );
  }

  void logout() {
    _storage.deleteAuthToken();
    Get.offAllNamed(AppRoutes.auth);
  }
  
  @override
  void onClose() {
    scrollController.dispose();
    super.onClose();
  }
}