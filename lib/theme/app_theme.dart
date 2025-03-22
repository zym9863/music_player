import 'package:flutter/material.dart';

class AppTheme {
  // 主色调
  static const Color primaryColor = Color(0xFF1A1F71); // 深邃夜空蓝
  static const Color accentColor = Color(0xFFFF6F61); // 活力橙
  static const Color textColor = Color(0xFFF5F5F5); // 清新白
  static const Color secondaryTextColor = Color(0xFFB0B0B0); // 浅灰
  static const Color darkGrey = Color(0xFF2D2D2D); // 深灰
  static const Color lightGrey = Color(0xFFB0B0B0); // 浅灰
  
  // 渐变色
  static const LinearGradient backgroundGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFF1A1F71), Color(0xFF6B5B95)], // 从深蓝到浅紫
  );
  
  // 主题数据
  static ThemeData get themeData {
    return ThemeData(
      primaryColor: primaryColor,
      scaffoldBackgroundColor: primaryColor,
      colorScheme: ColorScheme.dark(
        primary: primaryColor,
        secondary: accentColor,
        surface: darkGrey,
        background: primaryColor,
        onPrimary: textColor,
        onSecondary: textColor,
        onSurface: textColor,
        onBackground: textColor,
      ),
      textTheme: TextTheme(
        displayLarge: TextStyle(color: textColor, fontWeight: FontWeight.w500, fontSize: 24),
        displayMedium: TextStyle(color: textColor, fontWeight: FontWeight.w500, fontSize: 20),
        displaySmall: TextStyle(color: textColor, fontWeight: FontWeight.w500, fontSize: 18),
        bodyLarge: TextStyle(color: textColor, fontWeight: FontWeight.w400, fontSize: 16),
        bodyMedium: TextStyle(color: textColor, fontWeight: FontWeight.w400, fontSize: 14),
        bodySmall: TextStyle(color: secondaryTextColor, fontWeight: FontWeight.w400, fontSize: 12),
        labelLarge: TextStyle(color: textColor, fontWeight: FontWeight.w700, fontSize: 16),
        labelMedium: TextStyle(color: textColor, fontWeight: FontWeight.w700, fontSize: 14),
      ),
      sliderTheme: SliderThemeData(
        activeTrackColor: accentColor,
        inactiveTrackColor: lightGrey,
        thumbColor: accentColor,
        overlayColor: accentColor.withOpacity(0.2),
        trackHeight: 4.0,
      ),
      iconTheme: IconThemeData(
        color: textColor,
        size: 24,
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: Colors.transparent,
        elevation: 0,
        titleTextStyle: TextStyle(color: textColor, fontWeight: FontWeight.w500, fontSize: 20),
        iconTheme: IconThemeData(color: textColor),
      ),
      useMaterial3: true,
      fontFamily: 'Roboto',
    );
  }
}