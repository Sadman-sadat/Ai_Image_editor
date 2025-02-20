import 'package:appear_ai_image_editor/data/models/interior_design_model.dart';
import 'package:appear_ai_image_editor/data/services/network/api_service_mixin.dart';
import 'package:appear_ai_image_editor/data/utility/urls.dart';

class InteriorDesignService with ApiServiceMixin {
  Future<Map<String, dynamic>> generateInteriorDesign(InteriorDesignModel model) async {
    return makeApiRequest(
      endpoint: Urls.interiorDesign,
      requestData: model.toJson(),
    );
  }
}
