import 'package:flutter/material.dart';
import 'package:foodie_fly/presentation/components/loading_overlay.dart';

class LoadingOverlayController {
  static OverlayEntry? _overlayEntry;
  static bool _isVisible = false;

  static void show(BuildContext context, {String? message}) {
    if (!_isVisible) {
      _overlayEntry = OverlayEntry(
        builder: (context) => const LoadingOverlay(),
      );

      Overlay.of(context).insert(_overlayEntry!);
      _isVisible = true;
    }
  }

  static void hide() {
    if (_isVisible) {
      _overlayEntry?.remove();
      _overlayEntry = null;
      _isVisible = false;
    }
  }
}
