import 'package:codefactory/common/const/data.dart';
import 'package:codefactory/common/dio/dio.dart';
import 'package:codefactory/common/model/login_response.dart';
import 'package:codefactory/common/model/token_response.dart';
import 'package:codefactory/common/utils/data_utils.dart';
import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final authRepositoryProvider = Provider<AuthRepository>((ref) {
  final dio = ref.read(dioProvider);

  return AuthRepository(
    dio: dio,
    baseUrl: 'http://$ip/auth',
  );
});

class AuthRepository {
  // http://$ip/auth
  final String baseUrl;
  final Dio dio;

  AuthRepository({
    required this.dio,
    required this.baseUrl,
  });

  Future<LoginResponse> login({
    required String username,
    required String password,
  }) async {
    final serialized = DataUtils.plainToBase64('$username:$password');

    final resp = await dio.post(
      '$baseUrl/login',
      options: Options(
        headers: {'authorization': 'Basic $serialized'},
      ),
    );

    return LoginResponse.fromJson(resp.data);
  }

  Future<TokenResponse> token() async {
    final resp = await dio.post(
      '$baseUrl/token',
      options: Options(
        headers: {'accessToken': 'true'},
      ),
    );

    return TokenResponse.fromJson(resp.data);
  }
}
