class AvatarGenModel {
  final String apiKey;
  final String prompt;
  final String? negativePrompt;
  final String initImage;
  final int width;
  final int height;
  final int samples;
  final int numInferenceSteps;
  final bool safetyChecker;
  final bool base64;
  final int? seed;
  final double guidanceScale;
  final double identityNetStrengthRatio;
  final double adapterStrengthRatio;
  final double poseStrength;
  final double cannyStrength;
  final String? controlnetSelection;
  final String? webhook;
  final String? trackId;

  AvatarGenModel({
    required this.apiKey,
    required this.prompt,
    required this.initImage,
    this.negativePrompt = 'anime, cartoon, drawing, big nose, long nose, fat, ugly, big lips, big mouth, face proportion mismatch, unrealistic, monochrome, lowres, bad anatomy, worst quality, low quality, blurry',
    this.width = 512,
    this.height = 512,
    this.samples = 1,
    this.numInferenceSteps = 21,
    this.safetyChecker = false,
    this.base64 = false,
    this.seed,
    this.guidanceScale = 7.5,
    this.identityNetStrengthRatio = 1.0,
    this.adapterStrengthRatio = 1.0,
    this.poseStrength = 0.4,
    this.cannyStrength = 0.3,
    this.controlnetSelection = 'pose',
    this.webhook,
    this.trackId,
  });

  Map<String, dynamic> toJson() => {
    'key': apiKey,
    'prompt': prompt,
    'negative_prompt': negativePrompt,
    'init_image': initImage,
    'width': width.toString(),
    'height': height.toString(),
    'samples': samples.toString(),
    'num_inference_steps': numInferenceSteps.toString(),
    'safety_checker': safetyChecker,
    'base64': base64,
    'seed': seed,
    'guidance_scale': guidanceScale,
    'identitynet_strength_ratio': identityNetStrengthRatio,
    'adapter_strength_ratio': adapterStrengthRatio,
    'pose_strength': poseStrength,
    'canny_strength': cannyStrength,
    'controlnet_selection': controlnetSelection,
    'webhook': webhook,
    'track_id': trackId,
  };
}