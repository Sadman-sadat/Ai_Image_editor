import 'package:appear_ai_image_editor/presentation/utility/processing_steps.dart';

enum ProcessingType {
  backgroundRemoval,
  imageEnhancement,
  objectRemoval,
  headShotGen,
  relighting,
  interiorDesignGen,
  avatarGen,
  faceSwap;

  String get title {
    switch (this) {
      case ProcessingType.backgroundRemoval:
        return 'Background Removal';
      case ProcessingType.imageEnhancement:
        return 'Image Enhancement';
      case ProcessingType.objectRemoval:
        return 'Object Removal';
      case ProcessingType.headShotGen:
        return 'Face gen';
      case ProcessingType.relighting:
        return 'Relighting';
      case ProcessingType.avatarGen:
        return 'Avatar Generation';
      case ProcessingType.faceSwap:
        return 'Face Swap';
      case ProcessingType.interiorDesignGen:
        return 'Interior Design Generation';
    }
  }

  String get storageKey {
    switch (this) {
      case ProcessingType.backgroundRemoval:
        return 'background_removal';
      case ProcessingType.imageEnhancement:
        return 'image_enhancement';
      case ProcessingType.objectRemoval:
        return 'object_removal';
      case ProcessingType.headShotGen:
        return 'face_gen';
      case ProcessingType.relighting:
        return 'relighting';
      case ProcessingType.avatarGen:
        return 'avatar_gen';
      case ProcessingType.faceSwap:
        return 'face_swap';
      case ProcessingType.interiorDesignGen:
        return 'interior_design_gen';
    }
  }

  String get processingText {
    switch (this) {
      case ProcessingType.backgroundRemoval:
        return 'Removing background...';
      case ProcessingType.imageEnhancement:
        return 'Enhancing image...';
      case ProcessingType.objectRemoval:
        return 'Removing object...';
      case ProcessingType.headShotGen:
        return 'Generating Face...';
      case ProcessingType.relighting:
        return 'Relighting...';
      case ProcessingType.avatarGen:
        return 'Generating Avatar...';
      case ProcessingType.faceSwap:
        return 'Swapping Face...';
      case ProcessingType.interiorDesignGen:
        return 'Generating Interior...';
    }
  }

  List<String> get processingSteps {
    switch (this) {
      case ProcessingType.backgroundRemoval:
        return ProcessingSteps.steps['backgroundRemoval']!;
      case ProcessingType.imageEnhancement:
        return ProcessingSteps.steps['imageEnhancement']!;
      case ProcessingType.objectRemoval:
        return ProcessingSteps.steps['objectRemoval']!;
      case ProcessingType.headShotGen:
        return ProcessingSteps.steps['headShotGen']!;
      case ProcessingType.relighting:
        return ProcessingSteps.steps['relighting']!;
      case ProcessingType.avatarGen:
        return ProcessingSteps.steps['avatarGen']!;
      case ProcessingType.faceSwap:
        return ProcessingSteps.steps['faceSwap']!;
      case ProcessingType.interiorDesignGen:
        return ProcessingSteps.steps['interiorDesignGen']!;
    }
  }
}
