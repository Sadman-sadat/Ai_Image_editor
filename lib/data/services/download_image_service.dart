import 'dart:io';
import 'package:appear_ai_image_editor/data/services/permission_service.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';

class DownloadImageService {
  static const _channel = MethodChannel('com.appera.appearai/media_scanner');
  final PermissionService _permissionService = PermissionService();

  Future<String> downloadAndSaveImage(String imageUrl) async {
    try {
      final hasPermission = await _permissionService.checkPermissionStatus();
      if (!hasPermission) {
        throw Exception('Permission to save images is not granted. Please grant permission in app settings.');
      }

      final response = await http.get(Uri.parse(imageUrl));
      if (response.statusCode != 200) {
        throw Exception('Failed to download image: ${response.statusCode}');
      }

      final savedPath = await _saveImageToGallery(response.bodyBytes);
      if (savedPath == null) {
        throw Exception('Failed to save image to gallery');
      }

      return savedPath;
    } catch (e) {
      throw Exception('Download failed: $e');
    }
  }

  Future<String?> _saveImageToGallery(Uint8List imageBytes) async {
    try {
      final androidVersion = await _permissionService.getAndroidSDKVersion();

      if (Platform.isAndroid && androidVersion >= 33) {
        // Use MediaStore API for Android 13+
        final fileName = 'AI_edited_${DateTime.now().millisecondsSinceEpoch}.jpg';
        final result = await _channel.invokeMethod('saveImageToGallery', {
          'fileName': fileName,
          'imageBytes': imageBytes,
        });
        return result as String?;
      } else {
        // For older Android versions and iOS, use direct file access
        final directory = await _getGalleryDirectory();
        if (directory == null) {
          throw Exception('Unable to access media directory');
        }

        if (!await directory.exists()) {
          await directory.create(recursive: true);
        }

        final fileName = 'AI_edited_${DateTime.now().millisecondsSinceEpoch}.jpg';
        final filePath = '${directory.path}/$fileName';

        final file = File(filePath);
        await file.writeAsBytes(imageBytes);

        if (Platform.isAndroid) {
          await _notifyGallery(filePath);
        }

        return filePath;
      }
    } catch (e) {
      print('Error saving file: $e');
      throw Exception('Failed to save image');
    }
  }

  Future<Directory?> _getGalleryDirectory() async {
    if (Platform.isAndroid) {
      final androidVersion = await _permissionService.getAndroidSDKVersion();
      if (androidVersion >= 33) {
        final appDir = await getExternalStorageDirectory();
        return Directory('${appDir?.path}/Pictures');
      } else {
        return Directory('/storage/emulated/0/Pictures');
      }
    } else if (Platform.isIOS) {
      return await getApplicationDocumentsDirectory();
    }
    return null;
  }

  Future<void> _notifyGallery(String filePath) async {
    if (Platform.isAndroid) {
      try {
        await _channel.invokeMethod('scanFile', {'path': filePath});
      } catch (e) {
        print('Media scanner error: $e');
      }
    }
  }
}
