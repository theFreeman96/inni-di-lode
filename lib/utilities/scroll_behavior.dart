import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';

class MyScrollBehavior extends ScrollBehavior {
  @override
  Set<PointerDeviceKind> get dragDevices {
    return {
      PointerDeviceKind.touch,
      PointerDeviceKind.mouse,
      PointerDeviceKind.trackpad,
    };
  }

  @override
  Widget buildOverscrollIndicator(
      BuildContext context, Widget child, ScrollableDetails details) {
    return child;
  }
}
