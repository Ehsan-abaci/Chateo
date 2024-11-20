import 'dart:async';

import 'package:ehsan_chat/src/core/widgets/chateo_rounded_button.dart';
import 'package:ehsan_chat/src/core/widgets/error/error_screen_controller.dart';
import 'package:flutter/material.dart';
class ErrorScreen {
  ErrorScreen._internal();
  static final ErrorScreen _inst = ErrorScreen._internal();
  factory ErrorScreen.inst() => _inst;

  ErrorScreenController? controller;
  void show({
    required BuildContext context,
    required String title,
    required List<String> texts,
  }) {
    if (controller?.update(texts) ?? false) {
      return;
    } else {
      controller = showOverlay(
        context: context,
        title: title,
        texts: texts,
      );
    }
  }

  void _hide() {
    controller?.close();
    controller = null;
  }

  ErrorScreenController showOverlay({
    required BuildContext context,
    required String title,
    required List<String> texts,
  }) {
    final text = StreamController<List<String>>();
    text.add(texts);

    final state = Overlay.of(context);
    final renderBox = context.findRenderObject() as RenderBox;
    final size = renderBox.size;

    final overlay = OverlayEntry(
      builder: (context) {
        return Material(
          color: Colors.black.withAlpha(150),
          child: Center(
            child: Container(
              width: size.width * .8,
              decoration: ShapeDecoration(
                color: Theme.of(context).scaffoldBackgroundColor,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
              ),
              child: Padding(
                padding: EdgeInsets.symmetric(
                  vertical: size.height * .01,
                  horizontal: size.width * .05,
                ),
                child: StreamBuilder<List<String>>(
                    stream: text.stream,
                    builder: (context, snapshot) {
                      if (!snapshot.hasData) {
                        return const SizedBox.shrink();
                      }
                      final text = snapshot.data!;
                      return Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Text(
                              title,
                              style: Theme.of(context).textTheme.titleLarge,
                            ),
                            const SizedBox(height: 10),
                            ...text.map(
                              (e) => Text(
                                "● $e",
                                style: const TextStyle(
                                    color: Colors.red,
                                    fontWeight: FontWeight.w500,
                                    fontSize: 12),
                              ),
                            ),
                            const SizedBox(height: 20),
                            SizedBox(
                              height: 35,
                              child: ChateoRoundedButton(
                                text: 'Close',
                                function: _hide,
                              ),
                            )
                          ]);
                    }),
              ),
            ),
          ),
        );
      },
    );

    state.insert(overlay);

    return ErrorScreenController(
      close: () {
        // _text.close();
        overlay.remove();
        return true;
      },
      update: (texts) {
        text.add(texts);
        return true;
      },
    );
  }
}
