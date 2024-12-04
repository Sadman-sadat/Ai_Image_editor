class HeadShotGenModel {
  final String apiKey;
  final String faceImage;
  final String prompt;
  final String negativePrompt;
  final int width;
  final int height;
  final int samples;
  final int numInferenceSteps;
  final bool safetyChecker;
  final bool base64;
  final int? seed;
  final double guidanceScale;
  final String? webhook;
  final String? trackId;

  HeadShotGenModel({
    required this.apiKey,
    required this.faceImage,
    required this.prompt,
    this.negativePrompt = 'anime, cartoon, drawing, big nose, long nose, fat, ugly, big lips, big mouth, face proportion mismatch, unrealistic, monochrome, lowres, bad anatomy, worst quality, low quality, blurry',
    this.width = 512,
    this.height = 512,
    this.samples = 1,
    this.numInferenceSteps = 21,
    this.safetyChecker = false,
    this.base64 = false,
    this.seed,
    this.guidanceScale = 7.5,
    this.webhook,
    this.trackId,
  });

  Map<String, dynamic> toJson() => {
    'key': apiKey,
    'face_image': faceImage,
    'prompt': prompt,
    'negative_prompt': negativePrompt,
    'width': width.toString(),
    'height': height.toString(),
    'samples': samples.toString(),
    'num_inference_steps': numInferenceSteps.toString(),
    'safety_checker': safetyChecker,
    'base64': base64,
    'seed': seed,
    'guidance_scale': guidanceScale,
    'webhook': webhook,
    'track_id': trackId,
  };
}
