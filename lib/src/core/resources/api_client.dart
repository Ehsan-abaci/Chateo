import 'dart:async';
import 'dart:developer';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:ehsan_chat/src/core/resources/error_handler.dart';

class ApiClient {
  final Dio _dio;

  ApiClient(this._dio);

  Future<T> makeGetRequest<T>({
    required String endpoint,
    required T Function(dynamic json) parser,
    Object? data,
    Options? options,
  }) async {
    try {
      final response = await _dio.get(
        endpoint,
        data: data,
        options: options,
      );
      return parser(response.data);
    } on DioException catch (e) {
      log(e.response?.data['message']);
      throw NetworkException.fromStatusCode(
        e.response?.statusCode ?? 500
        // e.response?.data['message'],
      );
    } on SocketException {
      throw NetworkException(
        message: 'No internet connction',
        code: 'NO_INTERNET',
      );
    } on TimeoutException {
      throw NetworkException(
        message: 'Request timed out',
        code: 'TIMEOUT',
      );
    }
  }

  Future<T> makePostRequest<T>({
    required String endpoint,
    required T Function(dynamic json) parser,
    Object? data,
    Options? options,
  }) async {
    try {
      final response = await _dio.post(
        endpoint,
        data: data,
        options: options,
      );
      return parser(response.data);
    } on DioException catch (e) {
      log(e.response?.data['message']);
      throw NetworkException.fromStatusCode(
        e.response?.statusCode ?? 500,
        "sfdfsd",
      );
    } on SocketException {
      throw NetworkException(
        message: 'No internet connction',
        code: 'NO_INTERNET',
      );
    } on TimeoutException {
      throw NetworkException(
        message: 'Request timed out',
        code: 'TIMEOUT',
      );
    }
  }
}
