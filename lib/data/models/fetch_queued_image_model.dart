class FetchQueuedImageModel {
  final String apiKey;

  FetchQueuedImageModel({required this.apiKey});

  Map<String, dynamic> toJson() => {
    'key': apiKey,
  };
}
