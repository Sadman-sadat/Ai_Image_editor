import 'package:flutter/material.dart';
import 'package:device_preview/device_preview.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:image_ai_editor/app.dart';
import 'package:image_ai_editor/data/services/image_storage_service.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await GetStorage.init();
  Get.put(ImageStorageService());

  runApp(
    DevicePreview(
      enabled: false,
      tools: const [
        ...DevicePreview.defaultTools,
      ],
      builder: (context) => const AIImageEditor(),
    ),
  );
}
