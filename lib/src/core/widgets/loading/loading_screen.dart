import 'package:ehsan_chat/main.dart';
import 'package:flutter/material.dart';

import 'loading_screen_controller.dart';

class LoadingScreen {
  LoadingScreen._sharedInstance();
  static final LoadingScreen _shared = LoadingScreen._sharedInstance();
  factory LoadingScreen.instance() => _shared;

  LoadingScreenController? controller;

  void show(BuildContext context) {
    if (controller?.update() ?? false) {
      return;
    } else {
      controller = showOverlay(
        context: context,
      );
    }
  }

  void hide() {
    controller?.close();
    controller = null;
  }

  LoadingScreenController showOverlay({
    required BuildContext context,
  }) {
    // final _text = StreamController<String>();
    // _text.add(text);

    final state = Overlay.of(context);
    final renderBox = context.findRenderObject() as RenderBox;
    final size = renderBox.size;

    final overlay = OverlayEntry(
      builder: (context) {
        return Material(
          color: Colors.black.withAlpha(150),
          child: Center(
            child: IntrinsicHeight(
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
                    vertical: size.height * .03,
                    horizontal: size.width * .05,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Expanded(
                        flex: 2,
                        child: Text(
                          "Your request was sent. Please wait",
                          textAlign: TextAlign.center,
                          style: Theme.of(context).textTheme.bodySmall,
                        ),
                      ),
                      Expanded(
                        child: Align(
                          alignment: Alignment.center,
                          child: CircularProgressIndicator.adaptive(
                            valueColor: AlwaysStoppedAnimation(
                                Theme.of(context).primaryColor),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );

    state.insert(overlay);

    return LoadingScreenController(
      close: () {
        // _text.close();
        overlay.remove();
        return true;
      },
      update: () {
        // _text.add(text);
        return true;
      },
    );
  }
}
