import 'package:ehsan_chat/src/core/resources/api_client.dart';
import 'package:ehsan_chat/src/core/resources/error_handler.dart';
import 'package:ehsan_chat/src/core/resources/result.dart';
import 'package:ehsan_chat/src/core/utils/locator.dart';
import 'package:ehsan_chat/src/model/conversation.dart';

import '../../../core/utils/constants.dart';

class UserService {
  UserService();
  final ApiClient _apiClient = di();

  static const _prefix = 'user';
  // Future<DataState> searchUsersByUsername(String username) async {
  //   try {
  //     final response = await _dio.get(
  //       '${Constants.baseUrlV1}/$_prefix/$username',
  //       options: Options(headers: {
  //         'authorization': AuthService.inst.accessToken,
  //       }),
  //     );
  //     if (response.statusCode == HttpStatus.ok) {
  //       final list = response.data as List<dynamic>;

  //       final mapList =
  //           list.map((e) => {'user': e as Map<String, dynamic>}).toList();

  //       return DataSuccess(
  //         mapList.map(Conversation.createConversationByType).toList(),
  //       );
  //     } else {
  //       return DataFailed(response.data['message']);
  //     }
  //   } catch (e) {
  //     log(e.toString());
  //     // return ErrorHandler.handle(e).failure;
  //     throw Exception();
  //   }
  // }

  Future<Result<List<Conversation>>> searchUsersByUsername(
      String username) async {
    try { 
      final endpoint = '${Constants.baseUrlV1}/$_prefix/$username';
      parser(data) {
        final list = data as List<dynamic>;
        final mapList =
            list.map((e) => {'user': e as Map<String, dynamic>}).toList();
        return mapList.map(Conversation.createConversationByType).toList();
      }

      final users = await _apiClient.makeGetRequest<List<Conversation>>(
        endpoint: endpoint,
        parser: (data) => parser(data),
      );

      return Result.ok(users);
    } on NetworkException catch (e) {
      return Result.error(e);
    } catch (e) {
      return Result.error(AppException(message: 'Unexpected error occured'));
    }
  }
}
