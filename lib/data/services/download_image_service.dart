import 'dart:io';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';

class DownloadImageService {
  static const _channel = MethodChannel('com.appera.appearai/media_scanner');

  Future<String> downloadAndSaveImage(String imageUrl) async {
    try {
      // Force permission check before proceeding
      final hasPermission = await _forceCheckPermissions();
      if (!hasPermission) {
        throw Exception('Storage permission required.');
      }

      // Download the image
      final response = await http.get(Uri.parse(imageUrl));
      if (response.statusCode != 200) {
        throw Exception('Failed to download image: ${response.statusCode}');
      }

      // Save the image to the gallery
      final savedPath = await _saveImageToGallery(response.bodyBytes);
      if (savedPath == null) {
        throw Exception('Failed to save image to gallery');
      }

      return savedPath;
    } catch (e) {
      throw Exception('Download failed: $e');
    }
  }

  Future<bool> _forceCheckPermissions() async {
    if (!Platform.isAndroid) {
      return await Permission.photos.request().isGranted;
    }

    // Get Android version
    final androidVersion = await _getAndroidSDKVersion();

    // For Android 13 and above (API 33+)
    if (androidVersion >= 33) {
      final status = await Permission.photos.status;
      if (status.isDenied) {
        final result = await Permission.photos.request();
        return result.isGranted;
      }
      return status.isGranted;
    }
    // For Android 12 and below
    else {
      // First check if permission is already granted
      final storageStatus = await Permission.storage.status;
      if (storageStatus.isDenied) {
        // Force show the permission dialog
        final result = await [
          Permission.storage,
          Permission.manageExternalStorage,
        ].request();

        // Check if all permissions are granted
        return result.values.every((status) => status.isGranted);
      }
      return storageStatus.isGranted;
    }
  }

  Future<int> _getAndroidSDKVersion() async {
    if (!Platform.isAndroid) return 0;

    try {
      final platformVersion = await _channel.invokeMethod<String>('getSDKVersion');
      return int.parse(platformVersion ?? '0');
    } catch (e) {
      print('Failed to get Android SDK version: $e');
      return 0;
    }
  }

  Future<String?> _saveImageToGallery(Uint8List imageBytes) async {
    final directory = await _getGalleryDirectory();
    if (directory == null) {
      throw Exception('Unable to access media directory');
    }

    // Ensure directory exists
    if (!await directory.exists()) {
      await directory.create(recursive: true);
    }

    final fileName = 'AI_edited_${DateTime.now().millisecondsSinceEpoch}.jpg';
    final filePath = '${directory.path}/$fileName';

    try {
      final file = File(filePath);
      await file.writeAsBytes(imageBytes);
      await _notifyGallery(filePath);
      return filePath;
    } catch (e) {
      print('Error saving file: $e');
      throw Exception('Failed to save image');
    }
  }

  Future<Directory?> _getGalleryDirectory() async {
    if (Platform.isAndroid) {
      // For Android, use the Pictures directory
      final androidVersion = await _getAndroidSDKVersion();
      if (androidVersion >= 33) {
        // For Android 13+, use app-specific directory
        final appDir = await getExternalStorageDirectory();
        return Directory('${appDir?.path}/Pictures/APPEAR');
      } else {
        // For Android 12 and below, use public directory
        return Directory('/storage/emulated/0/Pictures/APPEAR');
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