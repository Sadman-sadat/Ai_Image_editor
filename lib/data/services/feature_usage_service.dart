import 'package:shared_preferences/shared_preferences.dart';

class FeatureUsageService {
  static const String _usagePrefix = 'feature_usage_';
  static final Set<String> proFeatures = {
    'head_shot_gen',
    'interior_design_gen',
    'avatar_gen',
  };

  final SharedPreferences _prefs;

  FeatureUsageService(this._prefs);

  static Future<FeatureUsageService> init() async {
    final prefs = await SharedPreferences.getInstance();
    return FeatureUsageService(prefs);
  }

  bool hasUsedFeature(String featureId) {
    return _prefs.getBool('${_usagePrefix}$featureId') ?? false;
  }

  Future<void> markFeatureAsUsed(String featureId) async {
    await _prefs.setBool('${_usagePrefix}$featureId', true);
  }

  Future<void> resetFeatureUsage(String featureId) async {
    await _prefs.remove('${_usagePrefix}$featureId');
  }

  bool isProFeature(String featureId) {
    return proFeatures.contains(featureId);
  }
}