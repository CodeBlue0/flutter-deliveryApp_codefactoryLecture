import 'package:codefactory/user/model/user_model.dart';
import 'package:dio/dio.dart' hide Headers;
import 'package:retrofit/retrofit.dart';

part 'user_me_repository.g.dart';

// http://$ip/user/me
@RestApi()
abstract class UserMeRepository {
  factory UserMeRepository(Dio dio, {String baseUrl}) = _UserMeRepository;

  @GET('/')
  @Headers(({'accessToken': 'true'}))
  Future<UserModel> getMe();
}
