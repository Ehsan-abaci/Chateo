import 'dart:ui';

import 'package:flutter/material.dart';

class AppCustomScrollBehavior extends MaterialScrollBehavior {
  @override
  Set<PointerDeviceKind> get dragDevices => {
        PointerDeviceKind.trackpad,
        PointerDeviceKind.touch,
        // Allow to drag with mouse on Regions carousel
        PointerDeviceKind.mouse,
      };
}
