import 'dart:developer';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:ehsan_chat/src/data/services/remote/auth_service.dart';
import 'package:ehsan_chat/src/model/conversation.dart';

import '../../../core/resources/data_state.dart';
import '../../../core/utils/constants.dart';


class SearchUserService {
  SearchUserService(this._dio);
  final Dio _dio;

  static const _prefix = 'user';
  Future<DataState> searchUsersByUsername(String username) async {
    try {
      final response = await _dio.get(
        '${Constants.baseUrlV1}/$_prefix/$username',
        options: Options(headers: {
          'authorization': AuthService.inst.accessToken,
        }),
      );
      if (response.statusCode == HttpStatus.ok) {
        final list = response.data as List<dynamic>;

        final mapList =
            list.map((e) => {'user': e as Map<String, dynamic>}).toList();

        return DataSuccess(
          mapList.map(Conversation.createConversationByType).toList(),
        );
      } else {
        return DataFailed(response.data['message']);
      }
    } catch (e) {
      log(e.toString());
      // return ErrorHandler.handle(e).failure;
      throw Exception();
    }
  }
}
