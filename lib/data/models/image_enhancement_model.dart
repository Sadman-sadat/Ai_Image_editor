class ImageEnhancementModel {
  final String apiKey;
  final String image;
  final bool faceEnhance;
  final double scale;

  ImageEnhancementModel({
    required this.apiKey,
    required this.image,
    this.faceEnhance = false,
    this.scale = 3,
  });

  Map<String, dynamic> toJson() => {
    'key': apiKey,
    'init_image': image,
    'face_enhance': faceEnhance,
    'scale': scale,
  };
}