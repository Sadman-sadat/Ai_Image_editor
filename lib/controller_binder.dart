import 'package:get/get.dart';
import 'package:image_ai_editor/data/services/download_image_service.dart';
import 'package:image_ai_editor/presentation/controllers/background_removal_controller.dart';
import 'package:image_ai_editor/presentation/controllers/fetch_queued_image_controller.dart';
import 'package:image_ai_editor/presentation/controllers/image_enhancement_controller.dart';
import 'package:image_ai_editor/presentation/controllers/object_removal_controller.dart';

import 'presentation/controllers/comparison_controller.dart';

class ControllerBinder extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => BackgroundRemovalController(), fenix: true);
    Get.lazyPut(() => ImageEnhancementController(), fenix: true);
    Get.lazyPut(() => ObjectRemovalController(), fenix: true);
    Get.lazyPut(() => FetchQueuedImageController(), fenix: true);
    Get.lazyPut(() => DownloadImageService(), fenix: true);
    Get.lazyPut(() => ComparisonController(), fenix: true);
  }
}