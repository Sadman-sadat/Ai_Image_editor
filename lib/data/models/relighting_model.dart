class RelightingModel {
  final String apiKey;
  final String initImage;
  final String lighting;
  final String prompt;
  final int height;
  final int width;
  final int samples;
  final bool base64;
  final String? webhook;
  final String? trackId;

  RelightingModel({
    required this.apiKey,
    required this.initImage,
    required this.lighting,
    required this.prompt,
    this.height = 512,
    this.width = 1024,
    this.samples = 1,
    this.base64 = false,
    this.webhook,
    this.trackId,
  });

  Map<String, dynamic> toJson() => {
    'key': apiKey,
    'init_image': initImage,
    'lighting': lighting,
    'prompt': prompt,
    'height': height.toString(),
    'width': width.toString(),
    'samples': samples.toString(),
    'base64': base64,
    'webhook': webhook,
    'track_id': trackId,
  };
}