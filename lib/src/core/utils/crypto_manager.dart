import 'dart:convert';
import 'package:convert/convert.dart' show hex;
import 'package:encrypt/encrypt.dart' as encrypt;
import 'package:flutter/foundation.dart';

class CryptoManager {

  static String get _globalEncryptKey => 'jwudownwaodw21ewje2elq2ekwamkwda';

  final _encryptor = encrypt.Encrypter(
    encrypt.AES(
      encrypt.Key.fromUtf8(_globalEncryptKey),
      mode: encrypt.AESMode.ctr,
      padding: null,
    ),
  );

  String? decryptData(Map mapHash) {
    try {
      final decrypted = _encryptor.decryptBytes(
          encrypt.Encrypted(Uint8List.fromList(hex.decode(mapHash['content']))),
          iv: encrypt.IV(Uint8List.fromList(hex.decode(mapHash['iv']))));
      return utf8.decode(decrypted);
    } catch (e) {
      if (kDebugMode) {
        print("decryptData exception $e");
      }
      return null;
    }
  }

  Map? encryptData(String data) {
    try {
      final iv = encrypt.IV.fromSecureRandom(16);
      final encrypted = _encryptor.encrypt(data, iv: iv);
      return EncryptModel(hex.encode(encrypted.bytes), hex.encode(iv.bytes))
          .toMap();
    } catch (e) {
      return null;
    }
  }
}

class EncryptModel {
  String hash, iv;
  EncryptModel(this.hash, this.iv);
  toMap() => {'content': hash, 'iv': iv};
}
