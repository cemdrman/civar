import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'app_colors.dart';

/// Headings/CTA use Space Grotesk, body text uses Manrope — per design tokens.
TextTheme buildAppTextTheme() {
  final base = GoogleFonts.manropeTextTheme().apply(
    bodyColor: AppColors.text,
    displayColor: AppColors.text,
  );
  final display = GoogleFonts.spaceGroteskTextTheme();

  return base.copyWith(
    displayLarge: display.displayLarge?.copyWith(fontWeight: FontWeight.w700),
    displayMedium: display.displayMedium?.copyWith(fontWeight: FontWeight.w700),
    displaySmall: display.displaySmall?.copyWith(fontWeight: FontWeight.w700),
    headlineLarge: display.headlineLarge?.copyWith(fontWeight: FontWeight.w700),
    headlineMedium: display.headlineMedium?.copyWith(fontWeight: FontWeight.w700),
    headlineSmall: display.headlineSmall?.copyWith(fontWeight: FontWeight.w700),
    titleLarge: display.titleLarge?.copyWith(fontWeight: FontWeight.w700),
    titleMedium: display.titleMedium?.copyWith(fontWeight: FontWeight.w600),
    titleSmall: display.titleSmall?.copyWith(fontWeight: FontWeight.w600),
    labelLarge: display.labelLarge?.copyWith(fontWeight: FontWeight.w600),
  );
}
