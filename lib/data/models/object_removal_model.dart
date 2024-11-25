class ObjectRemovalModel {
  final String apiKey;
  final String initImage;
  final String maskImage;
  final String? trackId;
  final String? webhook;

  ObjectRemovalModel({
    required this.apiKey,
    required this.initImage,
    required this.maskImage,
    this.trackId,
    this.webhook,
  });

  Map<String, dynamic> toJson() => {
    'key': apiKey,
    'init_image': initImage,
    'mask_image': maskImage,
    'track_id': trackId,
    'webhook': webhook,
  };
}