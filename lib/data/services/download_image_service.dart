import 'dart:io';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:path/path.dart' as path;

class DownloadImageService {
  static const _channel = MethodChannel('com.daydreamers.aiImgtools/media_scanner');

  Future<String> downloadAndSaveImage(String imageUrl) async {
    try {
      // Request permissions
      if (!await _requestPermissions()) {
        throw Exception('Required permissions not granted');
      }

      // Download image
      final response = await http.get(Uri.parse(imageUrl));
      if (response.statusCode != 200) {
        throw Exception('Failed to download image: ${response.statusCode}');
      }

      // Get storage directory
      final directory = Platform.isAndroid
          ? await getExternalStorageDirectory()
          : await getApplicationDocumentsDirectory();

      if (directory == null) {
        throw Exception('Could not access storage directory');
      }

      // Create AI Images directory if it doesn't exist
      final aiImagesDir = Directory('${directory.path}/AI_Images');
      if (!await aiImagesDir.exists()) {
        await aiImagesDir.create(recursive: true);
      }

      // Create unique filename
      final filename = 'AI_edited_${DateTime.now().millisecondsSinceEpoch}.jpg';
      final filePath = path.join(aiImagesDir.path, filename);

      // Save the file
      final file = File(filePath);
      await file.writeAsBytes(response.bodyBytes);

      // Make file visible in gallery (Android only)
      if (Platform.isAndroid) {
        try {
          await _scanFile(filePath);
        } catch (e) {
          print('Media scanner error: $e');
          // Continue even if scan fails - file is still saved
        }
      }

      return filePath;
    } catch (e) {
      throw Exception('Download failed: $e');
    }
  }

  Future<bool> _requestPermissions() async {
    if (Platform.isIOS) {
      final photosStatus = await Permission.photos.request();
      return photosStatus.isGranted;
    } else {
      // For Android
      final storageStatus = await Permission.storage.request();

      // For Android 10 and below, storage permission is enough
      if (storageStatus.isGranted) return true;

      // For Android 11+, try to request manage external storage
      try {
        final managedStorageStatus = await Permission.manageExternalStorage.request();
        return managedStorageStatus.isGranted;
      } catch (e) {
        // If permission doesn't exist or fails, fall back to regular storage permission
        return storageStatus.isGranted;
      }
    }
  }

  Future<void> _scanFile(String filePath) async {
    try {
      final result = await _channel.invokeMethod('scanFile', {'path': filePath});
      print('Media scan completed: $result');
    } catch (e) {
      print('Failed to scan file: $e');
      rethrow;
    }
  }
}