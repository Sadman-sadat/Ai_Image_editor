class Urls{
  static const String _baseUrl = 'https://modelslab.com/api/v6/image_editing';
  static const String api_Key = 'hW5cDbYCE6Yoq9dBnpMRns1JVDXL1icqKgCFyVBEZI7UpH2sGdl9us5oVRmZ';

  static const String backgroundRemoval = '$_baseUrl/removebg_mask';
  static const String imageEnhancement = '$_baseUrl/super_resolution';
  static const String objectRemoval = '$_baseUrl/object_removal';
  static const String headShotGen = '$_baseUrl/head_shot';
  static const String avatarGen = '$_baseUrl/avatar_gen';
  static const String relighting = '$_baseUrl/relighting';

  static const String faceSwap = 'https://modelslab.com/api/v6/deepfake/multiple_face_swap';

  static String fetchQueued(String queuedId) => 'https://modelslab.com/api/v6/realtime/fetch/$queuedId';

  static const String base64Conversion = 'https://modelslab.com/api/v3/base64_crop';
}