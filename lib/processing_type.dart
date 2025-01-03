enum ProcessingType {
  backgroundRemoval,
  imageEnhancement,
  objectRemoval,
  headShotGen,
  relighting,
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
    }
  }

  String get storageKey {
    switch (this) {
      case ProcessingType.backgroundRemoval:
        return 'background_removal';
      case ProcessingType.imageEnhancement:
        return 'image_enhancement';
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
    }
  }
}