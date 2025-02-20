class ProcessingSteps {
  static const List<String> uploadSteps = [
    'Uploading your image',
    'Processing file',
    'Validating format',
    'Preparing for editing',
    'Almost ready',
    'Setting things up',
    'Getting started'
  ];

  static Map<String, List<String>> steps = {
    'backgroundRemoval': [
      'Analyzing your image',
      'Detecting objects and boundaries',
      'Isolating the subject',
      'Removing background elements',
      'Polishing the edges',
      'Almost there',
      'Preparing final result'
    ],
    'imageEnhancement': [
      'Analyzing image quality',
      'Optimizing color balance',
      'Adjusting contrast and brightness',
      'Enhancing details',
      'Reducing noise',
      'Applying final touches',
      'Getting ready to show you'
    ],
    'objectRemoval': [
      'Scanning the image',
      'Identifying selected area',
      'Analyzing surrounding context',
      'Removing unwanted objects',
      'Reconstructing the background',
      'Smoothing the transitions',
      'Final cleanup in progress'
    ],
    'headShotGen': [
      'Analyzing facial features',
      'Processing your request',
      'Generating new elements',
      'Applying style adjustments',
      'Refining details',
      'Adding finishing touches',
      'Preparing your headshot'
    ],
    'relighting': [
      'Analyzing lighting conditions',
      'Calculating light sources',
      'Adjusting shadows and highlights',
      'Applying lighting effects',
      'Balancing exposure',
      'Fine-tuning the atmosphere',
      'Almost ready to show you'
    ],
    'avatarGen': [
      'Processing your photo',
      'Extracting key features',
      'Generating avatar style',
      'Adding artistic elements',
      'Refining character details',
      'Applying final touches',
      'Creating your unique avatar'
    ],
    'faceSwap': [
      'Analyzing source faces',
      'Mapping facial features',
      'Aligning expressions',
      'Blending seamlessly',
      'Adjusting skin tones',
      'Fine-tuning details',
      'Finalizing your swap'
    ],
    'interiorDesignGen': [
      'Analyzing room layout',
      'Processing design elements',
      'Generating new concepts',
      'Applying style preferences',
      'Adding design details',
      'Refining the space',
      'Preparing final visualization'
    ]
  };
}