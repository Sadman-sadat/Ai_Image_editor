import 'dart:convert';
import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:appear_ai_image_editor/data/models/base64_image_conversion_model.dart';
import 'package:appear_ai_image_editor/data/services/base64_image_conversion_service.dart';
import 'package:appear_ai_image_editor/data/utility/urls.dart';
import 'package:appear_ai_image_editor/presentation/widgets/snack_bar_message.dart';
import 'package:appear_ai_image_editor/processing_type.dart';

class MaskDrawingController extends GetxController {
  List<Offset> _drawPoints = [];
  bool _isMaskDrawingMode = false;
  String _base64MaskImage = '';
  String _processedMaskUrl = '';
  ProcessingType processingType;
  bool _isLoading = false;

  Size? _imageSize;
  Size? _canvasSize;
  Offset? _imageOffset;
  Rect? _imageBounds;
  Size? _renderSize;

  final Base64ImageConversionService _base64ImageService = Base64ImageConversionService();

  MaskDrawingController({required this.processingType});

  // Updated getters
  List<Offset> get drawPoints => _drawPoints;
  bool get isMaskDrawingMode => _isMaskDrawingMode;
  String get base64MaskImage => _base64MaskImage;
  String get processedMaskUrl => _processedMaskUrl;
  bool get isLoading => _isLoading;

  Size? get imageSize => _imageSize;
  Size? get canvasSize => _canvasSize;
  Rect? get imageBounds => _imageBounds;
  Size? get renderSize => _renderSize;

  void startMaskDrawing({
    required Size imageSize,
    required Size canvasSize,
    Offset? imageOffset,
    Rect? imageBounds,
    Size? renderSize,
  }) {
    _isMaskDrawingMode = true;
    _drawPoints = [];
    _base64MaskImage = '';
    _processedMaskUrl = '';
    _imageSize = imageSize;
    _canvasSize = canvasSize;
    _imageOffset = imageOffset ?? Offset.zero;
    _imageBounds = imageBounds;
    _renderSize = renderSize;
    update();
  }

  void addDrawPoint(Offset point) {
    if (_imageOffset != null &&
        _imageSize != null &&
        _canvasSize != null &&
        _imageBounds != null &&
        _renderSize != null) {

      // Check if the point is within the image bounds
      if (_imageBounds!.contains(point)) {
        // Calculate relative position within the render size
        final relativeX = (point.dx - _imageBounds!.left) / _renderSize!.width;
        final relativeY = (point.dy - _imageBounds!.top) / _renderSize!.height;

        // Scale to original image size
        final scaledPoint = Offset(
          relativeX * _imageSize!.width,
          relativeY * _imageSize!.height,
        );

        // Debug prints
        print('Raw Point: $point');
        print('Image Bounds: $_imageBounds');
        print('Render Size: $_renderSize');
        print('Image Size: $_imageSize');
        print('Scaled Point: $scaledPoint');

        _drawPoints.add(scaledPoint);
        update();
      }
    }
  }

  void clearDrawPoints() {
    _drawPoints = [];
    _base64MaskImage = '';
    _processedMaskUrl = '';
    update();
  }

  void resetMaskDrawing() {
    _drawPoints = [];
    _base64MaskImage = '';
    _processedMaskUrl = '';
    _imageSize = null;
    _canvasSize = null;
    _imageOffset = null;
    _imageBounds = null;
    _renderSize = null;
    _isMaskDrawingMode = false;
    update();
  }

  Future<String?> generateMaskImage() async {
    if (_drawPoints.isEmpty || _imageSize == null) return null;

    try {
      // Create a picture recorder and canvas with full image dimensions
      final ui.PictureRecorder recorder = ui.PictureRecorder();
      final Canvas canvas = Canvas(recorder, Rect.fromLTWH(0, 0, _imageSize!.width, _imageSize!.height));

      // Create a black background
      final backgroundPaint = Paint()..color = Colors.black;
      canvas.drawRect(Rect.fromLTWH(0, 0, _imageSize!.width, _imageSize!.height), backgroundPaint);

      // Prepare drawing paint for mask
      final maskPaint = Paint()
        ..color = Colors.white
        ..strokeCap = StrokeCap.round
        ..strokeWidth = 50.0 // Adjust this value if needed
        ..style = PaintingStyle.stroke;

      // Draw the mask lines directly on the full-size canvas
      if (_drawPoints.length > 1) {
        for (int i = 0; i < _drawPoints.length - 1; i++) {
          canvas.drawLine(_drawPoints[i], _drawPoints[i + 1], maskPaint);
        }
      }

      // End recording and convert to image
      final picture = recorder.endRecording();
      final image = await picture.toImage(
        _imageSize!.width.toInt(),
        _imageSize!.height.toInt(),
      );

      // Convert to base64
      final byteData = await image.toByteData(format: ui.ImageByteFormat.png);
      final base64Mask = base64Encode(byteData!.buffer.asUint8List());

      // Debug prints
      print('Draw Points Count: ${_drawPoints.length}');
      print('Image Size: $_imageSize');
      print('Base64 Mask Length: ${base64Mask.length}');

      _base64MaskImage = base64Mask;
      update();

      return base64Mask;
    } catch (e) {
      print('Error generating mask image: $e');
      return null;
    }
  }

  Future<bool> uploadMaskImage(String base64Image) async {
    if (_base64MaskImage.isEmpty) {
      showSnackBarMessage(
        title: 'Error',
        message: 'Please draw a mask first',
      );
      return false;
    }

    try {
      _isLoading = true;
      update();
      final model = Base64ImageConversionModel(
        apiKey: Urls.api_Key, // Replace with your actual API key
        imageBase64: _base64MaskImage,
        crop: false,
      );

      final imageUrl = await _base64ImageService.convertImageToBase64(model);
      _processedMaskUrl = imageUrl;
      _isMaskDrawingMode = false;

      _isLoading = false;
      update();

      return true;
    } catch (e) {
      _isLoading = false;
      update();

      showSnackBarMessage(
        title: 'Error',
        message: 'Failed to upload mask image: $e',
      );
      return false;
    }
  }
}
