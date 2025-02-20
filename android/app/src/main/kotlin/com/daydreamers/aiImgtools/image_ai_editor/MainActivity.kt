package com.appera.appearai.appear_ai_image_editor

import android.media.MediaScannerConnection
import android.os.Build
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel

class MainActivity: FlutterActivity() {
    private val CHANNEL = "com.appera.appearai/media_scanner"

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)

        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL).setMethodCallHandler { call, result ->
            when (call.method) {
                "scanFile" -> {
                    val path = call.argument<String>("path")
                    if (path != null) {
                        MediaScannerConnection.scanFile(
                            context,
                            arrayOf(path),
                            arrayOf("image/jpeg", "image/png")
                        ) { _, uri ->
                            result.success(uri?.toString())
                        }
                    } else {
                        result.error("INVALID_ARGUMENT", "Path cannot be null", null)
                    }
                }
                "getSDKVersion" -> {
                    result.success(Build.VERSION.SDK_INT.toString())
                }
                else -> {
                    result.notImplemented()
                }
            }
        }
    }
}


////package com.daydreamers.aiImgtools.image_ai_editor
////
////import io.flutter.embedding.android.FlutterActivity
////
////class MainActivity: FlutterActivity()
//
//package com.appera.appearai.appear_ai_image_editor
//
//import android.media.MediaScannerConnection
//import io.flutter.embedding.android.FlutterActivity
//import io.flutter.embedding.engine.FlutterEngine
//import io.flutter.plugin.common.MethodChannel
//
//class MainActivity: FlutterActivity() {
//    private val CHANNEL = "com.appera.appearai/media_scanner"
//
//    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
//        super.configureFlutterEngine(flutterEngine)
//
//        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL).setMethodCallHandler { call, result ->
//            when (call.method) {
//                "scanFile" -> {
//                    val path = call.argument<String>("path")
//                    if (path != null) {
//                        MediaScannerConnection.scanFile(
//                            context,
//                            arrayOf(path),
//                            arrayOf("image/jpeg", "image/png")
//                        ) { _, uri ->
//                            result.success(uri?.toString())
//                        }
//                    } else {
//                        result.error("INVALID_ARGUMENT", "Path cannot be null", null)
//                    }
//                }
//                else -> {
//                    result.notImplemented()
//                }
//            }
//        }
//    }
//}