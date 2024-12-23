import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:ehsan_chat/src/core/resources/data_state.dart';
import 'package:ehsan_chat/src/core/utils/constants.dart';
import 'package:ehsan_chat/src/data/services/remote/auth_service.dart';
import 'package:ehsan_chat/src/model/media_file.dart';


class UploadMediaService {
  UploadMediaService(this._dio);
  final Dio _dio;

  static const _prefix = 'message';

  Future<DataState> uploadMedia(MediaFile media) async {
    var data = FormData.fromMap(
      {
        'media': [
          await MultipartFile.fromFile(media.path, filename: media.name),
        ],
        'type': media.type,
      },
    );
    try {
      final res = await _dio.post(
        '${Constants.baseUrlV1}/$_prefix/upload-media',
        data: data,
        options: Options(headers: {
          'authorization': AuthService.inst.accessToken,
        }),
      );
     
      if (res.statusCode == HttpStatus.ok) {
        return DataSuccess(res.data as Map<String, dynamic>);
      }
      return DataFailed([res.data]);
    } catch (e) {
      log(e.toString());
      return DataFailed([e.toString()]);
    }
  }
}
