import 'dart:convert';

import 'package:ehsan_chat/src/model/conversation.dart';
import 'package:flutter/foundation.dart';
import 'package:hive/hive.dart';

class HiveCacheManager {
  static final HiveCacheManager inst = HiveCacheManager._internal();
  factory HiveCacheManager() {
    return inst;
  }
  HiveCacheManager._internal();

  final convBox = Hive.box<String>('conversation');
  final usersBox = Hive.box<Map>('user');
  final chatsBox = Hive.box<Map>('chat');

  Future saveConversation(Conversation conv) async {
    final saveConv = jsonEncode(conv.toMap());
    await convBox.put(conv.id, saveConv);
  }

  Future<List<Conversation>> getConversations() async {
    List<Conversation> convs = [];
    for (var savedConvs in convBox.values) {
      final decodedMap = jsonDecode(savedConvs) as Map<String, dynamic>;
      final conv = Conversation.createConversationByType(decodedMap);
   
      convs.add(conv);
    }
    return convs;
  }

  Future updateMinViewPortSeenIndexOfRoom(
      int min, Conversation selectConv) async {
    // if (saveCancel) {
    //   return;
    // }
    var encodedConv = convBox.get(selectConv.id);
    if (encodedConv == null) return;
    final conv = jsonDecode(encodedConv);
    if (conv['minViewPortSeenIndex'] != min) {
      conv['minViewPortSeenIndex'] = min;
      await convBox.put(conv['id'], jsonEncode(conv));
    }
  }

  Future updateLastIndexOfRoom(int lastIndex, Conversation selectedConv) async {
    // if (saveCancel) {
    //   return;
    // }
    if (kDebugMode) {
      print(
          'updateLastIndexOfRoom (lastIndex: $lastIndex , selectedRoom: ${selectedConv.id})');
    }
    var encodedConv = convBox.get(selectedConv.id);
    if (encodedConv == null) return;
    final conv = jsonDecode(encodedConv) as Map<String, dynamic>;
    if (conv['last_index'] != lastIndex) {
      conv['last_index'] = lastIndex;
      await convBox.put(conv['id'], jsonEncode(conv));
      selectedConv.lastIndex = lastIndex;
    }
  }
}
