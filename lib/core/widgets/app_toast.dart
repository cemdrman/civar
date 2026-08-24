import 'package:flutter/material.dart';

import '../theme/app_colors.dart';
import '../theme/app_radii.dart';

/// Inserts a bottom toast overlay that auto-dismisses after 2.4s, matching
/// the design spec. Independent of the navigation stack.
void showAppToast(BuildContext context, String message) {
  final overlay = Overlay.of(context, rootOverlay: true);
  late OverlayEntry entry;
  entry = OverlayEntry(
    builder: (context) => _ToastOverlay(message: message, onDone: () => entry.remove()),
  );
  overlay.insert(entry);
}

class _ToastOverlay extends StatefulWidget {
  const _ToastOverlay({required this.message, required this.onDone});

  final String message;
  final VoidCallback onDone;

  @override
  State<_ToastOverlay> createState() => _ToastOverlayState();
}

class _ToastOverlayState extends State<_ToastOverlay> {
  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(milliseconds: 2400), () {
      if (mounted) widget.onDone();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Positioned(
      left: 18,
      right: 18,
      bottom: 90,
      child: Material(
        color: Colors.transparent,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 13),
          decoration: BoxDecoration(
            color: AppColors.text,
            borderRadius: BorderRadius.circular(AppRadii.iconContainer + 1),
            boxShadow: const [
              BoxShadow(color: Colors.black26, blurRadius: 24, offset: Offset(0, 8)),
            ],
          ),
          child: Text(
            widget.message,
            textAlign: TextAlign.center,
            style: const TextStyle(color: Colors.white, fontSize: 13.5),
          ),
        ),
      ),
    );
  }
}
