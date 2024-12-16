class BackgroundRemovalModel {
  final String apiKey;
  final String image;
  final bool onlyMask;
  final bool alphaMatting;
  final int? seed;
  final bool postProcessMask;
  final String? webhook;
  final String? trackId;

  BackgroundRemovalModel({
    required this.apiKey,
    required this.image,
    this.onlyMask = false,
    this.alphaMatting = false,
    this.seed,
    this.postProcessMask = false,
    this.webhook,
    this.trackId,
  });

  Map<String, dynamic> toJson() => {
    'key': apiKey,
    'image': image,
    'only_mask': onlyMask,
    'alpha_matting': alphaMatting,
    'seed': seed,
    'post_process_mask': postProcessMask,
    'webhook': webhook,
    'track_id': trackId,
  };
}
