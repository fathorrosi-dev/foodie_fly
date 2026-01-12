import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';
import 'package:foodie_fly/utils/screen_utils.dart';

class AppScrollBehavior extends ScrollBehavior {
  @override
  Set<PointerDeviceKind> get dragDevices => {
    PointerDeviceKind.touch,
    PointerDeviceKind.mouse,
    PointerDeviceKind.trackpad,
  };

  @override
  ScrollPhysics getScrollPhysics(BuildContext context) =>
      const BouncingScrollPhysics();

  @override
  Widget buildScrollbar(
    BuildContext context,
    Widget child,
    ScrollableDetails details,
  ) {
    if (ScreenUtils.isMobile(context)) return child;

    return RawScrollbar(
      controller: details.controller,
      thumbVisibility: true,
      thickness: 8,
      radius: const Radius.circular(4),
      interactive: true,
      child: child,
    );
  }
}
