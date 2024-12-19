class FaceSwapModel {
  final String apiKey;
  final String initImage;
  final String targetImage;
  final String? webhook;
  final String? trackId;

  FaceSwapModel({
    required this.apiKey,
    required this.initImage,
    required this.targetImage,
    this.webhook,
    this.trackId,
  });

  Map<String, dynamic> toJson() => {
    'key': apiKey,
    'init_image': initImage,
    'target_image': targetImage,
    'webhook': webhook,
    'track_id': trackId,
  };
}