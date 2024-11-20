import 'package:dio/dio.dart';
import 'package:ehsan_chat/src/core/utils/constants.dart';

class ApiClient {
  static Dio getDio() {
    Dio dio = Dio(
      BaseOptions(
        baseUrl: Constants.baseUrlV1,
      ),
    );
    return dio;
  }
}

