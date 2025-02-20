// logger.dart
import 'package:flutter/foundation.dart';
import 'dart:developer' as developer;

class Logger {
  static const bool _showDebugLogs = true;
  static const bool _productionMode = kReleaseMode;

  static void debug(String message, {String? tag}) {
    if (!_showDebugLogs || _productionMode) return;
    _log(message, tag: tag, level: 'DEBUG', color: '\x1B[34m');
  }

  static void info(String message, {String? tag}) {
    if (_productionMode) return;
    _log(message, tag: tag, level: 'INFO', color: '\x1B[32m');
  }

  static void warning(String message, {String? tag}) {
    _log(message, tag: tag, level: 'WARNING', color: '\x1B[33m');
  }

  static void error(String message, {String? tag, Object? error, StackTrace? stackTrace}) {
    _log(message, tag: tag, level: 'ERROR', color: '\x1B[31m', error: error, stackTrace: stackTrace);
  }

  static void _log(
      String message, {
        String? tag,
        required String level,
        required String color,
        Object? error,
        StackTrace? stackTrace,
      }) {
    final timestamp = DateTime.now().toIso8601String();
    final logTag = tag != null ? '[$tag] ' : '';
    final formattedMessage = '$color[$timestamp] [$level] $logTag$message\x1B[0m';

    if (kDebugMode) {
      developer.log(
        formattedMessage,
        time: DateTime.now(),
        name: level,
        error: error,
        stackTrace: stackTrace,
      );
    } else {
      print(formattedMessage);
    }

    if (error != null) {
      developer.log('$color$error\x1B[0m', name: 'ERROR');
    }
    if (stackTrace != null) {
      developer.log('$color$stackTrace\x1B[0m', name: 'STACKTRACE');
    }
  }
}