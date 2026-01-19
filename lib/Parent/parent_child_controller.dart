import 'package:get/get.dart';

class ParentChildController extends GetxController {
  final RxString selectedChildName = ''.obs; // Empty by default - no child selected
  final RxString selectedChildBatch = ''.obs;
  final RxString selectedChildId = ''.obs;

  bool get hasSelectedChild => selectedChildName.value.isNotEmpty;

  void switchChild({
    required String name,
    required String batch,
    required String studentId,
  }) {
    selectedChildName.value = name;
    selectedChildBatch.value = batch;
    selectedChildId.value = studentId;
    update();
  }

  Map<String, String> get currentChild => {
        'name': selectedChildName.value,
        'batch': selectedChildBatch.value,
        'studentId': selectedChildId.value,
      };
}
