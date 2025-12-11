import 'package:flutter/material.dart';

class AppColors {
  // Primary Colors - Based on Cameroon's vibrant culture
  static const Color primary = Color(0xFF1E88E5); // Blue
  static const Color primaryDark = Color(0xFF1565C0);
  static const Color primaryLight = Color(0xFF64B5F6);

  // Secondary Colors
  static const Color secondary = Color(0xFFFFB300); // Gold/Yellow
  static const Color secondaryDark = Color(0xFFFF8F00);
  static const Color secondaryLight = Color(0xFFFFD54F);

  // Accent Colors
  static const Color accent = Color(0xFF00C853); // Green for success
  static const Color accentRed = Color(0xFFE53935); // Red for errors

  // Neutral Colors
  static const Color background = Color(0xFFF5F7FA);
  static const Color surface = Color(0xFFFFFFFF);
  static const Color cardBackground = Color(0xFFFFFFFF);

  // Text Colors
  static const Color textPrimary = Color(0xFF1A1A1A);
  static const Color textSecondary = Color(0xFF6B7280);
  static const Color textTertiary = Color(0xFF9CA3AF);
  static const Color textWhite = Color(0xFFFFFFFF);

  // Input Colors
  static const Color inputFill = Color(0xFFF3F4F6);
  static const Color inputBorder = Color(0xFFE5E7EB);

  // Status Colors
  static const Color success = Color(0xFF10B981);
  static const Color warning = Color(0xFFF59E0B);
  static const Color error = Color(0xFFEF4444);
  static const Color info = Color(0xFF3B82F6);

  // Exam Type Colors
  static const Color gceOLevel = Color(0xFF8B5CF6);
  static const Color gceALevel = Color(0xFFEC4899);
  static const Color bepc = Color(0xFF06B6D4);
  static const Color probatoire = Color(0xFF14B8A6);
  static const Color bac = Color(0xFFF97316);

  // Gradient Colors
  static const LinearGradient primaryGradient = LinearGradient(
    colors: [primary, primaryLight],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient goldGradient = LinearGradient(
    colors: [secondary, secondaryLight],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
}