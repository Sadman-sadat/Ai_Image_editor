class InteriorDesignModel {
  final String apiKey;
  final String prompt;
  final String? negativePrompt;
  final String initImage;
  final int? seed;
  final double guidanceScale;
  final double strength;
  final int numInferenceSteps;
  final bool base64;
  final bool temp;
  final int scaleDown;
  final String? webhook;
  final String? trackId;

  InteriorDesignModel({
    required this.apiKey,
    required this.prompt,
    required this.initImage,
    this.negativePrompt = 'bad quality',
    this.seed = 0,
    this.guidanceScale = 8.0,
    this.strength = 0.99,
    this.numInferenceSteps = 51,
    this.base64 = false,
    this.temp = false,
    this.scaleDown = 6,
    this.webhook,
    this.trackId,
  });

  Map<String, dynamic> toJson() => {
    'key': apiKey,
    'prompt': prompt,
    'negative_prompt': negativePrompt,
    'init_image': initImage,
    'seed': seed,
    'guidance_scale': guidanceScale,
    'strength': strength,
    'num_inference_steps': numInferenceSteps,
    'base64': base64,
    'temp': temp,
    'scale_down': scaleDown,
    'webhook': webhook,
    'track_id': trackId,
  };
}