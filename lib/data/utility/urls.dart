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

  static const String interiorDesign  = 'https://modelslab.com/api/v6/interior/make';

  static String fetchQueued(String queuedId) => 'https://modelslab.com/api/v6/realtime/fetch/$queuedId';

  static const String base64Conversion = 'https://modelslab.com/api/v3/base64_crop';

  static const String playStoreRating = 'https://play.google.com/store/apps/details?id=com.appera.appearai.appear_ai_image_editor';
  static const String discordUrl = 'https://discord.gg/6sUWkXC8WG';
  static const String instagramUrl = 'https://www.instagram.com/visionai_official/';
  static const String facebookUrl = 'https://www.facebook.com/apperatech';
  static const String website = 'http://www.appera-technologies.com/';

  static const String privacyPolicyUrl = 'https://www.ddvai.com/privacy-policy';
}