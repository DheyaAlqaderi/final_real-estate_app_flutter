
import 'package:dio/dio.dart';
import 'package:retrofit/http.dart';
import 'package:smart_real_estate/features/client/feedback/data/models/request_feedback.dart';
import '../../../../../core/constant/app_constants.dart';
import '../models/response_feedback_model.dart';
import '../models/types/type_feedback_model.dart';

part 'feedback_api.g.dart';

@RestApi(baseUrl: AppConstants.baseUrl2)
abstract class FeedbackApi{
  factory FeedbackApi(Dio dio, {String baseUrl}) = _FeedbackApi;

  @POST('api/ticket/create/')
  Future<FeedbackResponse> postFeedback(
      @Body() RequestFeedback requestFeedback,
      );

  
  @GET('api/ticket/ticket-type/')
  Future<List<TypesFeedbackModel>> getFeedbackTypes();


}