class ImageEnhancementModel {
  final String apiKey;
  final String image;
  final bool faceEnhance;
  final double scale;
  final String? webhook;
  final String? trackId;
  final String? modelId;

  ImageEnhancementModel({
    required this.apiKey,
    required this.image,
    this.faceEnhance = false,
    this.scale = 2,
    this.webhook,
    this.trackId,
    this.modelId = 'RealESRGAN_x4plus',
  });

  Map<String, dynamic> toJson() => {
    'key': apiKey,
    'init_image': image,
    'face_enhance': faceEnhance,
    'scale': scale,
    'webhook': webhook,
    'track_id': trackId,
    'model_id': modelId,
  };
}