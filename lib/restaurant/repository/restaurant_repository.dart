import 'package:codefactory/common/model/cursor_pagination_model.dart';
import 'package:codefactory/restaurant/model/restaurant_detail_model.dart';
import 'package:codefactory/restaurant/model/restaurant_model.dart';
import 'package:dio/dio.dart' hide Headers;
import 'package:retrofit/retrofit.dart';

part 'restaurant_repository.g.dart';

@RestApi()
abstract class RestaurantRepository {
  // http://$ip/restaurant
  factory RestaurantRepository(Dio dio, {String baseUrl}) =
      _RestaurantRepository;

  // http://$ip/restaurant/
  @GET('/')
  @Headers({
    'accessToken': 'true',
  })
  Future<CursorPagination<RestaurantModel>> paginate();

  // http://$ip/restaurant/:id
  @GET('/{id}')
  @Headers({
    'accessToken': 'true',
  })
  Future<RestaurantDetailModel> getRestaurantdetail({
    @Path() required String id,
  });
}
