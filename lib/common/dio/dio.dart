import 'package:delivery/common/const/data.dart';
import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class CustomInterceptor extends Interceptor {
  final FlutterSecureStorage storage;

  CustomInterceptor({
    required this.storage,
  });

  // 1) 요청을 보낼 때
  @override
  void onRequest(
      RequestOptions options, RequestInterceptorHandler handler) async {
    print('[REQ] [${options.method}] ${options.uri}');

    if (options.headers['accessToken'] == 'true') {
      options.headers.remove('accessToken');
      final token = await storage.read(key: ACCESS_TOKEN_KEY);
      options.headers.addAll({'authorization': 'Bearer $token'});
    }

    if (options.headers['refreshToken'] == 'true') {
      options.headers.remove('refreshToken');
      final token = await storage.read(key: REFRESH_TOKEN_KEY);
      options.headers.addAll({'authorization': 'Bearer $token'});
    }
    return super.onRequest(options, handler);
  }

// 2) 응답을 받을 때
  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    print(
        '[RES] [${response.requestOptions.method}] ${response.requestOptions.uri}');
    return super.onResponse(response, handler);
  }

// 3) 에러가 났을 때
  @override
  void onError(DioException err, ErrorInterceptorHandler handler) async {
    // 401에러가 났을때 (status code)
    // 토큰을 재발급 받는 시도를 하고 토큰이 재발급되면 다시 새로운 토큰으로 요청을 한다.
    print('[ERR] [${err.requestOptions.method}] ${err.requestOptions.uri}');

    final refreshToken = await storage.read(key: REFRESH_TOKEN_KEY);

    // refreshToken이 없으면 에러를 던진다
    if (refreshToken == null) {
      return handler.reject(err); // 에러를 발생시켜서 돌려주는 코드
    }

    final isStatus401 = err.response?.statusCode == 401;
    final isPathRefresh = err.requestOptions.path == '/auth/token';

    if (isStatus401 && !isPathRefresh) {
      final dio = Dio();

      try {
        final resp = await dio.post(
          'http://$ip/auth/token',
          options: Options(
            headers: {'authorization': 'Bearer $refreshToken'},
          ),
        );

        final accessToken = resp.data['accessToken'];
        final options =
            err.requestOptions; // requestOptions에는 에러를 발생시킨 요청에 대한 모든 옵션이 들어가있음

        options.headers.addAll({'authorization': 'Bearer $accessToken'});

        await storage.write(key: ACCESS_TOKEN_KEY, value: accessToken);

        // 토큰 바꿔끼고 요청 재전송
        final response = await dio.fetch(options);
        return handler.resolve(response);
      } on DioError catch (e) {
        return handler.reject(e);
      }
    }

    return super.onError(err, handler);
  }
}
