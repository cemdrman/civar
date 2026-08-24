import 'package:flutter/material.dart';

/// Closest sRGB approximations of the design's OKLCH tokens.
/// Hifi reference, not pixel-perfect — see design_handoff_civar/README.md.
class AppColors {
  AppColors._();

  static const bg = Color(0xFFF7F3EF);
  static const surface = Color(0xFFFDFBF9);
  static const surface2 = Color(0xFFF1ECE7);
  static const border = Color(0xFFDDD5CC);
  static const text = Color(0xFF2A231D);
  static const textSecondary = Color(0xFF7C7268);
  static const textFaint = Color(0xFFA79D91);

  // Accent (coral / energy)
  static const accent = Color(0xFFE0603A);
  static const accentSoft = Color(0xFFFAE0D4);
  static const accentDark = Color(0xFFB84A2C);

  // Accent2 (teal / discovery) — used for place-tag pills
  static const accent2 = Color(0xFF1E93A0);
  static const accent2Soft = Color(0xFFDCEFEF);

  static const danger = Color(0xFFC0392B);
}
