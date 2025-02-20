import 'package:appear_ai_image_editor/presentation/controllers/main_bottom_nav_bar_controller.dart';
//import 'package:appear_ai_image_editor/presentation/controllers/splash_screen_controller.dart';
import 'package:appear_ai_image_editor/presentation/controllers/comparison_controller.dart';
import 'package:appear_ai_image_editor/presentation/controllers/interior_design_controller.dart';
import 'package:appear_ai_image_editor/presentation/controllers/subscription_controller.dart';
import 'package:appear_ai_image_editor/data/services/download_image_service.dart';
import 'package:appear_ai_image_editor/presentation/controllers/avatar_gen_controller.dart';
import 'package:appear_ai_image_editor/presentation/controllers/background_removal_controller.dart';
import 'package:appear_ai_image_editor/presentation/controllers/base64_image_conversion_controller.dart';
import 'package:appear_ai_image_editor/presentation/controllers/image_processing_carousel_controller.dart';
import 'package:appear_ai_image_editor/presentation/controllers/face_swap_controller.dart';
import 'package:appear_ai_image_editor/presentation/controllers/fetch_queued_image_controller.dart';
import 'package:appear_ai_image_editor/presentation/controllers/head_shot_gen_controller.dart';
import 'package:appear_ai_image_editor/presentation/controllers/home_screen_controller.dart';
import 'package:appear_ai_image_editor/presentation/controllers/image_enhancement_controller.dart';
import 'package:appear_ai_image_editor/presentation/controllers/object_removal_controller.dart';
import 'package:appear_ai_image_editor/presentation/controllers/relighting_controller.dart';
import 'package:appear_ai_image_editor/presentation/controllers/ads/ad_controller.dart';
import 'package:appear_ai_image_editor/presentation/controllers/ads/banner_ad_controller.dart';
import 'package:appear_ai_image_editor/presentation/controllers/ads/interstitial_ad_controller.dart';
import 'package:appear_ai_image_editor/presentation/controllers/ads/rewarded_ad_controller.dart';
import 'package:appear_ai_image_editor/presentation/controllers/image_processing_settings_controller.dart';
import 'package:get/get.dart';

class ControllerBinder extends Bindings {
  @override
  void dependencies() {
    //Get.lazyPut(() => SplashController(), fenix: true);
    Get.lazyPut(() => MainBottomNavBarController(), fenix: true);
    Get.lazyPut(() => HomeScreenController(), fenix: true);
    Get.lazyPut(() => ImageProcessingCarouselController(), fenix: true);
    Get.lazyPut(() => Base64ImageConversionController(), fenix: true);
    Get.lazyPut(() => BackgroundRemovalController(), fenix: true);
    Get.lazyPut(() => ImageEnhancementController(), fenix: true);
    Get.lazyPut(() => ObjectRemovalController(), fenix: true);
    Get.lazyPut(() => HeadShotGenController(), fenix: true);
    Get.lazyPut(() => RelightingController(), fenix: true);
    Get.lazyPut(() => AvatarGenController(), fenix: true);
    Get.lazyPut(() => FaceSwapController(), fenix: true);
    Get.lazyPut(() => InteriorDesignController(), fenix: true);
    Get.lazyPut(() => FetchQueuedImageController(), fenix: true);
    Get.lazyPut(() => DownloadImageService(), fenix: true);
    Get.lazyPut(() => ComparisonController(), fenix: true);
    Get.lazyPut(() => ImageProcessingSettingsController(), fenix: true);
    Get.lazyPut(() => AdController(), fenix: true);
    Get.lazyPut(() => BannerAdController(), fenix: true);
    Get.lazyPut(() => InterstitialAdController(), fenix: true);
    Get.lazyPut(() => RewardedAdController(), fenix: true);
    Get.lazyPut(() => SubscriptionController(), fenix: true);
  }
}