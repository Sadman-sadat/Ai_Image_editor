class Base64ImageConversionModel {
  final String apiKey;
  final String imageBase64;
  final bool crop;

  Base64ImageConversionModel({
    required this.apiKey,
    required this.imageBase64,
    required this.crop,
  });

  Map<String, dynamic> toJson() => {
    'key': apiKey,
    'image': 'data:image/png;base64,$imageBase64',
    'crop': crop.toString(),
  };
}
