import 'package:dio/dio.dart';
import 'package:retrofit/http.dart';
import 'package:smart_real_estate/features/client/add_reviews/data/review_model.dart';
import 'package:smart_real_estate/features/client/add_reviews/data/review_response_model.dart';

import '../../../../../core/constant/app_constants.dart';


part 'rating_repository.g.dart';

@RestApi(baseUrl: AppConstants.baseUrl)
abstract class RatingRepository{
  factory RatingRepository(Dio dio, {String baseUrl}) = _RatingRepository;

  @POST("api/review/create/")
  Future<ReviewResponseModel> postReview(
      @Body() Review review,
      @Header("Authorization")String token
      );
}