import 'package:appear_ai_image_editor/data/models/avatar_gen_model.dart';
import 'package:appear_ai_image_editor/data/models/head_shot_gen_model.dart';
import 'package:appear_ai_image_editor/presentation/widgets/snack_bar_message.dart';
import 'package:appear_ai_image_editor/processing_type.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ImageProcessingPromptActionController extends GetxController {
  final ProcessingType processingType;
  String promptText = '';
  String? _lastInvalidMessage;
  String selectedPositionLighting = 'none';
  final List<String> positionLightingOptions = ['none', 'left', 'right', 'top', 'bottom'];

  ImageProcessingPromptActionController({required this.processingType}) {
    // Set default prompts based on processing type
    if (processingType == ProcessingType.headShotGen) {
      promptText = 'On sea Beach, with my Sports car';
    } else if (processingType == ProcessingType.interiorDesignGen) {
      promptText = 'Orange wall color, Modern style';
    }
  }

  String _getNegativePromptForType() {
    switch (processingType) {
      case ProcessingType.headShotGen:
        return HeadShotGenModel(
          apiKey: '',
          faceImage: '',
          prompt: '',
        ).negativePrompt;
      case ProcessingType.avatarGen:
        return AvatarGenModel(
          apiKey: '',
          prompt: '',
          initImage: '',
        ).negativePrompt ?? '';
      default:
        return '';
    }
  }

  bool _validateAgainstNegativePrompt(String input) {
    if (input.isEmpty) {
      _lastInvalidMessage = null; // Reset when input is cleared
      return true;
    }

    final isValid = _isInputValid(input);
    if (!isValid) {
      final message = 'The following words are not allowed for ${processingType.title}: ${_getProhibitedWords(input)}';

      if (_lastInvalidMessage != message) { // Only show if it's a new error
        _lastInvalidMessage = message;
        showSnackBarMessage(title: 'Invalid Prompt', message: message, colorText: Colors.red);
      }
    } else {
      _lastInvalidMessage = null; // Reset when input becomes valid
    }

    return isValid;
  }


  void setPositionLighting(String value) {
    selectedPositionLighting = value;
    update();
  }

  void setPromptText(String value) {
    promptText = value;

    if (value.isNotEmpty) {
      _validateAgainstNegativePrompt(value);
    } else {
      _lastInvalidMessage = null; // Reset when clearing text
    }

    update();
  }



  String _getProhibitedWords(String input) {
    final negativePrompt = _getNegativePromptForType();
    final prohibitedWords = negativePrompt.split(', ');
    return prohibitedWords.where((word) => input.toLowerCase().contains(word.toLowerCase())).join(', ');
  }

  bool _isInputValid(String input) {
    final negativePrompt = _getNegativePromptForType();
    if (negativePrompt.isEmpty) return true;

    final prohibitedWords = negativePrompt.split(', ');
    for (final word in prohibitedWords) {
      if (input.toLowerCase().contains(word.toLowerCase())) {
        return false;
      }
    }
    return true;
  }

  bool get isValid {
    if (!_isInputValid(promptText)) {
      return false;
    }

    if (processingType == ProcessingType.relighting) {
      return promptText.isNotEmpty && selectedPositionLighting != 'none';
    }
    return promptText.isNotEmpty;
  }
}
