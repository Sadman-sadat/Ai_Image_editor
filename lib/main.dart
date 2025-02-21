import 'package:appear_ai_image_editor/app.dart';
import 'package:appear_ai_image_editor/data/permission_service.dart';
import 'package:appear_ai_image_editor/data/services/image_storage_service.dart';
import 'package:flutter/material.dart';
import 'package:device_preview/device_preview.dart' show DevicePreview;
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

void main() async {
  try {
    WidgetsFlutterBinding.ensureInitialized();
    await GetStorage.init();

    Get.put(ImageStorageService());

    final permissionService = PermissionService();
    await permissionService.requestInitialPermissions();

    runApp(
      DevicePreview(
        enabled: false,
        tools: const [...DevicePreview.defaultTools],
        builder: (context) => const AIImageEditor(),
      ),
    );
  } catch (e) {
    print('Error during app initialization: $e');
  }
}
