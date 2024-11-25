class BackgroundRemovalModel {
  final String apiKey;
  final String image;
  final bool onlyMask;
  final bool alphaMatting;

  BackgroundRemovalModel({
    required this.apiKey,
    required this.image,
    this.onlyMask = false,
    this.alphaMatting = false,
  });

  Map<String, dynamic> toJson() => {
    'key': apiKey,
    'image': image,
    'only_mask': onlyMask,
    'alpha_matting': alphaMatting,
  };
}
