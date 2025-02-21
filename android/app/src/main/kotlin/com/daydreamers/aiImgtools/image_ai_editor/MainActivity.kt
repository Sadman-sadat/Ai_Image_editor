package com.appera.appearai.appear_ai_image_editor

import android.content.ContentValues
import android.media.MediaScannerConnection
import android.os.Build
import android.provider.MediaStore
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel

class MainActivity: FlutterActivity() {
    private val CHANNEL = "com.appera.appearai/media_scanner"

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)

        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL).setMethodCallHandler { call, result ->
            when (call.method) {
                "saveImageToGallery" -> {
                    val fileName = call.argument<String>("fileName")
                    val imageBytes = call.argument<ByteArray>("imageBytes")

                    if (fileName == null || imageBytes == null) {
                        result.error("INVALID_ARGUMENTS", "fileName and imageBytes are required", null)
                        return@setMethodCallHandler
                    }

                    try {
                        val contentValues = ContentValues().apply {
                            put(MediaStore.Images.Media.DISPLAY_NAME, fileName)
                            put(MediaStore.Images.Media.MIME_TYPE, "image/jpeg")
                            if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.Q) {
                                put(MediaStore.Images.Media.RELATIVE_PATH, "Pictures/APPEAR")
                                put(MediaStore.Images.Media.IS_PENDING, 1)
                            }
                        }

                        val contentResolver = context.contentResolver
                        val uri = contentResolver.insert(MediaStore.Images.Media.EXTERNAL_CONTENT_URI, contentValues)

                        if (uri != null) {
                            contentResolver.openOutputStream(uri)?.use { outputStream ->
                                outputStream.write(imageBytes)
                            }

                            if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.Q) {
                                contentValues.clear()
                                contentValues.put(MediaStore.Images.Media.IS_PENDING, 0)
                                contentResolver.update(uri, contentValues, null, null)
                            }

                            result.success(uri.toString())
                        } else {
                            result.error("SAVE_FAILED", "Failed to create media store entry", null)
                        }
                    } catch (e: Exception) {
                        result.error("SAVE_ERROR", e.message, null)
                    }
                }
                "getSDKVersion" -> {
                    result.success(Build.VERSION.SDK_INT.toString())
                }
                "scanFile" -> {
                    val path = call.argument<String>("path")
                    if (path != null) {
                        MediaScannerConnection.scanFile(context, arrayOf(path), null, null)
                        result.success(null)
                    } else {
                        result.error("INVALID_PATH", "Path is required", null)
                    }
                }
                else -> result.notImplemented()
            }
        }
    }
}
