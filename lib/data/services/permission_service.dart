import 'dart:io';
import 'package:flutter/services.dart';
import 'package:permission_handler/permission_handler.dart';

class PermissionService {
  static final PermissionService _instance = PermissionService._internal();
  factory PermissionService() => _instance;
  PermissionService._internal();

  static const _channel = MethodChannel('com.appera.appearai/media_scanner');

  Future<bool> requestInitialPermissions() async {
    if (!Platform.isAndroid) {
      return await Permission.photos.request().isGranted;
    }

    try {
      final androidVersion = await getAndroidSDKVersion();

      if (androidVersion >= 33) {
        final status = await Permission.photos.request();
        return status.isGranted;
      } else {
        final status = await Permission.storage.request();
        return status.isGranted;
      }
    } catch (e) {
      print('Permission request error: $e');
      return false;
    }
  }

  Future<int> getAndroidSDKVersion() async {
    if (!Platform.isAndroid) return 0;

    try {
      final platformVersion = await _channel.invokeMethod<String>('getSDKVersion');
      return int.parse(platformVersion ?? '0');
    } catch (e) {
      print('Failed to get Android SDK version: $e');
      return 0;
    }
  }

  Future<bool> checkPermissionStatus() async {
    if (!Platform.isAndroid) {
      return await Permission.photos.status.isGranted;
    }

    final androidVersion = await getAndroidSDKVersion();

    if (androidVersion >= 33) {
      return await Permission.photos.status.isGranted;
    } else {
      return await Permission.storage.status.isGranted;
    }
  }
}
