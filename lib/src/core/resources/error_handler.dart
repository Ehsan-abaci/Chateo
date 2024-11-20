import 'package:dio/dio.dart';
import 'package:ehsan_chat/src/core/resources/data_state.dart';

enum DataSource {
  SUCCESS,
  NO_CONTENT,
  BAD_REQUEST,
  FORBIDDEN,
  UNAUTHORISED,
  NOT_FOUND,
  INTERNAL_SERVER_ERROR,
  CONNECT_TIMEOUT,
  CANCEL,
  RECEIVE_TIMEOUT,
  SEND_TIMEOUT,
  CASH_ERROR,
  NO_INTERNET_CONNECTION,
  CONFLICT,
  UNPROCESSABLE,
  DEEFAULT,
}

class ErrorHandler implements Exception {
  late DataFailed failure;

  ErrorHandler.handle(dynamic error) {
    if (error is DioException) {
      failure = _handleError(error);
    }
  }

  DataFailed _handleError(DioError error) {
    List<String>? messages = [];
    if (error.response != null) {
      final errors = (error.response?.data['message']);
      if (errors is Map<String, dynamic>) {
        errors.forEach(
          (key, value) {
            messages.add(value.toString());
          },
        );
      } else {
        messages.add(errors.toString());
      }
    }
    switch (error.type) {
      case DioExceptionType.connectionTimeout:
        return DataSource.CONNECT_TIMEOUT.getFailure();
      case DioExceptionType.sendTimeout:
        return DataSource.SEND_TIMEOUT.getFailure();
      case DioExceptionType.receiveTimeout:
        return DataSource.RECEIVE_TIMEOUT.getFailure();
      case DioExceptionType.badResponse:
        switch (error.response?.statusCode) {
          case ResponseCode.UNPROCESSABLE:
            return DataSource.UNPROCESSABLE.getFailure(messages);
          case ResponseCode.BAD_REQUEST:
            return DataSource.BAD_REQUEST.getFailure();
          case ResponseCode.FORBIDDEN:
            return DataSource.FORBIDDEN.getFailure(messages);
          case ResponseCode.UNAUTHORISED:
            return DataSource.UNAUTHORISED.getFailure(messages);
          case ResponseCode.NOT_FOUND:
            return DataSource.NOT_FOUND.getFailure(messages);
          case ResponseCode.INTERNAL_SERVER_ERROR:
            return DataSource.INTERNAL_SERVER_ERROR.getFailure(messages);
          case ResponseCode.CONFLICT:
            return DataSource.CONFLICT.getFailure(messages);
          default:
            return DataSource.DEEFAULT.getFailure(messages);
        }
      case DioExceptionType.badCertificate:
        return DataSource.CANCEL.getFailure();
      case DioExceptionType.cancel:
        return DataSource.CANCEL.getFailure();
      case DioExceptionType.connectionError:
        return DataSource.NO_INTERNET_CONNECTION.getFailure();
      case DioExceptionType.unknown:
        return DataSource.DEEFAULT.getFailure();
      default:
        return DataSource.DEEFAULT.getFailure();
    }
  }
}

extension DataSourceExtension on DataSource {
  DataFailed getFailure([List<String>? messages]) {
    switch (this) {
      case DataSource.SUCCESS:
        return DataFailed(messages ?? [ResponseMessage.SUCCESS]);
      case DataSource.NO_CONTENT:
        return DataFailed(messages ?? [ResponseMessage.NO_CONTENT]);
      case DataSource.BAD_REQUEST:
        return DataFailed(messages ?? [ResponseMessage.BAD_REQUEST]);
      case DataSource.FORBIDDEN:
        return DataFailed(messages ?? [ResponseMessage.FORBIDDEN]);
      case DataSource.UNAUTHORISED:
        return DataFailed(messages ?? [ResponseMessage.UNAUTHORISED]);
      case DataSource.NOT_FOUND:
        return DataFailed(messages ?? [ResponseMessage.NOT_FOUND]);
      case DataSource.INTERNAL_SERVER_ERROR:
        return DataFailed(messages ?? [ResponseMessage.INTERNAL_SERVER_ERROR]);
      case DataSource.CONNECT_TIMEOUT:
        return DataFailed(messages ?? [ResponseMessage.CONNECT_TIMEOUT]);
      case DataSource.CANCEL:
        return DataFailed(messages ?? [ResponseMessage.CANCEL]);
      case DataSource.RECEIVE_TIMEOUT:
        return DataFailed(messages ?? [ResponseMessage.RECEIVE_TIMEOUT]);
      case DataSource.SEND_TIMEOUT:
        return DataFailed(messages ?? [ResponseMessage.SEND_TIMEOUT]);
      case DataSource.CASH_ERROR:
        return DataFailed(messages ?? [ResponseMessage.CASH_ERROR]);
      case DataSource.CONFLICT:
        return DataFailed(messages ?? [ResponseMessage.CONFLICT]);
      case DataSource.NO_INTERNET_CONNECTION:
        return DataFailed(messages ?? [ResponseMessage.NO_INTERNET_CONNECTION]);
      case DataSource.DEEFAULT:
        return DataFailed(messages ?? [ResponseMessage.UNKNOWN]);
      default:
        return DataFailed(messages ?? [ResponseMessage.UNKNOWN]);
    }
  }
}

class ResponseCode {
  // Api status code
  static const int SUCCESS = 200;
  static const int NO_CONTENT = 201;
  static const int BAD_REQUEST = 400;
  static const int FORBIDDEN = 403;
  static const int UNAUTHORISED = 401;
  static const int NOT_FOUND = 404;
  static const int CONFLICT = 409;
  static const int UNPROCESSABLE = 422;
  static const int INTERNAL_SERVER_ERROR = 500;

  // local status code
  static const int UNKNOWN = -1;
  static const int CONNECT_TIMEOUT = -2;
  static const int CANCEL = -3;
  static const int RECEIVE_TIMEOUT = -4;
  static const int SEND_TIMEOUT = -5;
  static const int CASH_ERROR = -6;
  static const int NO_INTERNET_CONNECTION = -7;
}

class ResponseMessage {
  // Api status code
  static const String SUCCESS = "success";
  static const String NO_CONTENT = "no_content";
  static const String CONFLICT = "conflict";
  static const String BAD_REQUEST = "bad_request_error";
  static const String FORBIDDEN = "forbidden_error";
  static const String UNAUTHORISED = "unauthorized_error";
  static const String NOT_FOUND = "not_found_error";
  static const String INTERNAL_SERVER_ERROR = "internal_server_error";

  // local status code
  static const String UNKNOWN = "unknown_error";
  static const String CONNECT_TIMEOUT = "timeout_error";
  static const String CANCEL = "cancel_error";
  static const String RECEIVE_TIMEOUT = "timeout_error";
  static const String SEND_TIMEOUT = "timeout_error";
  static const String CASH_ERROR = "cache_error";
  static const String NO_INTERNET_CONNECTION = "no_internet_error";
}

class ApiInternalStatus {
  static const int SUCCESS = 0;
  static const int FAILURE = 1;
}
