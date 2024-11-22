import 'dart:convert';
import 'dart:developer';

import 'package:ehsan_chat/src/core/utils/extensions.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/scheduler.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';
import 'package:web_socket_client/web_socket_client.dart';

import '../cache_manager/hive_cache.dart';
import '../data/remote/auth_date_source.dart';
import '../model/conversation.dart';

class ChatProvider extends ChangeNotifier {
  String connectionState = 'Disconnected';
  List<Conversation> convs = [];
  Conversation? selectedConv;

  WebSocket? _socket;

  WebSocket? get socket => _socket;

  createSocketConnection() {
    final uri = Uri.parse('ws://192.168.52.1:8000/ws');
    const backoff = ConstantBackoff(Duration(seconds: 1));
    return WebSocket(
      uri,
      backoff: backoff,
      headers: {"authorization": AuthDataSource.inst.accessToken},
    );
  }

  void connect() async {
    final loadedConvs = await HiveCacheManager.inst.getConversations();
    convs = loadedConvs;

    _socket = _socket ?? createSocketConnection();

    _socket?.connection.listen((state) {
      if (state is Connected || state is Reconnected) {
        connectionState = 'Connected';
      } else if (state is Reconnecting || state is Connecting) {
        connectionState = 'Connecting...';
      } else if (state is Disconnected) {
        connectionState = 'Disconnected';
      }
      notifyListeners();
    }, onError: (e) {
      connectionState = 'Error';
      notifyListeners();
    });

    _socket?.messages.listen(
      (data) {
        final decodedData = jsonDecode(data);
        final event = decodedData['event'];
        final payload = decodedData['payload'];
        switch (event) {
          case 'connected':
            log(payload['session_id']);
          case 'message-action':
            _onNewMessageHandler(payload);
            break;
        }
      },
    );
  }

  _onNewMessageHandler(payload) async {
    final recievedConv = json.decode(payload) as List<dynamic>;

    for (final conv in recievedConv) {
      final newConv = Conversation.createConversationByType(conv);
      int existedConvIndex = convs.indexWhere((c) => c.id == newConv.id);

      if (existedConvIndex == -1) {
        convs = [...convs, newConv];
        existedConvIndex = convs.indexOf(newConv);
        notifyListeners();
      }
      for (final msg in newConv.msgList) {
        // Check if there is any message with the same id in the list
        if (!convs[existedConvIndex].msgList.any((e) => e.id == msg.id)) {
          convs[existedConvIndex].msgList = [
            ...convs[existedConvIndex].msgList,
            msg
          ];
        }
      }
      convs[existedConvIndex].msgList.sortByTime();

      convs[existedConvIndex].lastMsg = convs[existedConvIndex].msgList.first;

      HiveCacheManager.inst.saveConversation(convs[existedConvIndex]);
    }

    if (selectedConv != null && minIndexOfChatListOnViewPort == 0) {
      if (!chatListScrollController.isAttached) return;
      await chatListScrollController.scrollTo(
        index: 0,
        duration: const Duration(milliseconds: 50),
      );
      SchedulerBinding.instance.addPostFrameCallback((_) {
        saveLastViewPortSeenIndex(selectedConv!);
      });
    }
  }

  final ItemScrollController chatListScrollController = ItemScrollController();
  final ItemPositionsListener chatListScrollListener =
      ItemPositionsListener.create();

  int get maxIndexOfChatListOnViewPort => chatListScrollListener
      .itemPositions.value
      .where((ItemPosition position) => position.itemLeadingEdge < 1)
      .reduce((ItemPosition max, ItemPosition position) =>
          position.itemLeadingEdge > max.itemLeadingEdge ? position : max)
      .index;

  int get minIndexOfChatListOnViewPort => chatListScrollListener
      .itemPositions.value
      .where((ItemPosition position) => position.itemTrailingEdge > 0)
      .reduce((ItemPosition min, ItemPosition position) =>
          position.itemTrailingEdge < min.itemTrailingEdge ? position : min)
      .index;

  selectConv(Conversation conv) {
    selectedConv = conv;
    notifyListeners();
  }

  void listenOnChatScroll() async {
    if (selectedConv == null) return;

    // final convs = state.convs;
    // convs[currentConvIndex!].capacity += 50;
    // send(
    //   event: 'load-more',
    //   payload: {
    //     'conversation_id': state.convs[currentConvIndex!].id,
    //     'first_message_time': state
    //         .convs[currentConvIndex!].msgList.last.createdAt
    //         .toIso8601String(),
    //   },
    // );
    // }
  }

  Future saveLastViewPortSeenIndex(Conversation selectConv) async {
    print('saveLastViewPortSeenIndex');
    try {
      if (selectConv.msgList.isNotEmpty) {
        if (selectConv.minViewPortSeenIndex != minIndexOfChatListOnViewPort) {
          // save on database
          HiveCacheManager.inst.updateMinViewPortSeenIndexOfRoom(
            minIndexOfChatListOnViewPort,
            selectConv,
          );
          // save to local list
          selectConv.minViewPortSeenIndex = minIndexOfChatListOnViewPort;
        }

        if ((selectConv.lastIndex ?? -1) <=
            selectConv.msgList.length - 1 - minIndexOfChatListOnViewPort) {
          // save on database
          Future.microtask(() {
            HiveCacheManager.inst.updateLastIndexOfRoom(
              selectConv.msgList.length - 1 - minIndexOfChatListOnViewPort,
              selectConv,
            );
          });

          List<Conversation> conversations = _updateConvs(selectConv);

          selectedConv = selectConv;
          convs = conversations;
          notifyListeners();
        }
      }
    } catch (e) {
      if (kDebugMode) {
        print('saveLastViewPortSeenIndex exception $e');
      }
    }
  }

  List<Conversation> _updateConvs(Conversation selectConv) {
    final conversations = convs
      ..[convs.indexWhere(
        (c) => c.id == selectConv.id,
      )] = selectConv;
    return conversations;
  }

  void deselectConv() {
    selectedConv = null;
    notifyListeners();
  }

  void disconnect() {
    _socket?.close();
    _socket = null;
  }

  void send({required String event, dynamic payload}) {
    _socket?.send(jsonEncode({'event': event, 'payload': payload}));
  }

  void joinRoom({required String roomId}) {
    _socket?.send(jsonEncode({'event': 'join-room', 'room': roomId}));
  }

  @override
  void dispose() {
    disconnect();
    super.dispose();
  }
}
