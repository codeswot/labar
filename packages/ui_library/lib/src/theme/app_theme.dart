import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:moon_design/moon_design.dart';

class AppTheme {
  // Primary colors - adjusted for better contrast
  static const Color primaryMint =
      Color(0xFF2D8A4F); // Darker mint for visibility on light bg
  static const Color primaryMintDark =
      Color(0xFF7FE5A3); // Lighter mint for visibility on dark bg
  static const Color primaryMint60 = Color(0x8F2D8A4F);
  static const Color primaryMint10 = Color(0x142D8A4F);
  static const Color primaryMintDark60 = Color(0x8F7FE5A3);
  static const Color primaryMintDark10 = Color(0x147FE5A3);

  // Accent colors - improved contrast
  static const Color accentTeal =
      Color(0xFF00A896); // Darker teal for better contrast
  static const Color accentTealDark =
      Color(0xFF4ECDC4); // Lighter teal for dark mode

  // Background colors
  static const Color backgroundLight =
      Color(0xFFFAFDFB); // Slightly off-white with mint tint
  static const Color backgroundDark =
      Color(0xFF0A1612); // Very dark green-black

  // Surface colors
  static const Color surfaceLight = Color(0xFFFFFFFF);
  static const Color surfaceDark =
      Color(0xFF152820); // Darker surface for better contrast
  static const Color surfaceVariantLight = Color(0xFFF0F7F3);
  static const Color surfaceVariantDark = Color(0xFF1F3329);

  // Border colors - higher contrast
  static const Color borderLight = Color(0xFFB8D4C1); // More visible border
  static const Color borderDark =
      Color(0xFF2D4A38); // Lighter border for dark mode

  // Text colors - ensuring WCAG AA compliance
  static const Color textPrimaryLight = Color(0xFF0D1F14);
  static const Color textPrimaryDark = Color(0xFFE8F5EC);
  static const Color textSecondaryLight =
      Color(0xFF4A5C4F); // Darker for better contrast
  static const Color textSecondaryDark =
      Color(0xFFB8D4C1); // Lighter for dark mode

  // Hover effect colors - more visible
  static const Color hoverPrimaryLight = Color(0x1F2D8A4F);
  static const Color hoverPrimaryDark = Color(0x1F7FE5A3);
  static const Color hoverSecondaryLight = Color(0x0A0D1F14);
  static const Color hoverSecondaryDark = Color(0x14E8F5EC);

  // Overlay colors
  static const Color overlayLight = Color(0x8F0D1F14);
  static const Color overlayDark = Color(0x8F000000);

  // Semantic colors - Success (high contrast green)
  static const Color successGreen =
      Color(0xFF2E7D32); // Darker for better contrast
  static const Color successGreenDark =
      Color(0xFF66BB6A); // Lighter for dark mode
  static const Color successGreen60 = Color(0x8F2E7D32);
  static const Color successGreen10 = Color(0x142E7D32);
  static const Color successGreenDark60 = Color(0x8F66BB6A);
  static const Color successGreenDark10 = Color(0x1466BB6A);

  // Semantic colors - Error (high contrast red)
  static const Color errorRed =
      Color(0xFFC62828); // Darker red for better contrast
  static const Color errorRedDark =
      Color(0xFFEF5350); // Lighter red for dark mode
  static const Color errorRed60 = Color(0x8FC62828);
  static const Color errorRed10 = Color(0x14C62828);
  static const Color errorRedDark60 = Color(0x8FEF5350);
  static const Color errorRedDark10 = Color(0x14EF5350);

  // Semantic colors - Warning (high contrast orange)
  static const Color warningOrange =
      Color(0xFFE65100); // Darker orange for better contrast
  static const Color warningOrangeDark =
      Color(0xFFFF9800); // Lighter orange for dark mode
  static const Color warningOrange60 = Color(0x8FE65100);
  static const Color warningOrange10 = Color(0x14E65100);
  static const Color warningOrangeDark60 = Color(0x8FFF9800);
  static const Color warningOrangeDark10 = Color(0x14FF9800);

  // Semantic colors - Info (high contrast blue)
  static const Color infoBlue =
      Color(0xFF1565C0); // Darker blue for better contrast
  static const Color infoBlueDark =
      Color(0xFF42A5F5); // Lighter blue for dark mode
  static const Color infoBlue60 = Color(0x8F1565C0);
  static const Color infoBlue10 = Color(0x141565C0);
  static const Color infoBlueDark60 = Color(0x8F42A5F5);
  static const Color infoBlueDark10 = Color(0x1442A5F5);

  // Supportive colors
  static const Color supportRed = Color(0xFFD32F2F);
  static const Color supportRed60 = Color(0x8FD32F2F);
  static const Color supportRed10 = Color(0x14D32F2F);

  static const Color supportTeal = Color(0xFF26A69A);
  static const Color supportTeal60 = Color(0x8F26A69A);
  static const Color supportTeal10 = Color(0x1426A69A);

  static const Color supportBrown = Color(0xFF8D6E63);
  static const Color supportBrown60 = Color(0x8F8D6E63);
  static const Color supportBrown10 = Color(0x148D6E63);

  static const Color supportGray = Color(0xFF616161);
  static const Color supportGray60 = Color(0x8F616161);
  static const Color supportGray10 = Color(0x14616161);

  static final MoonTokens lightTokens = MoonTokens.light.copyWith(
    colors: MoonColors.light.copyWith(
      piccolo: primaryMint,
      hit: accentTeal,
      beerus: borderLight,
      goku: surfaceLight,
      gohan: surfaceVariantLight,
      goten: surfaceLight,
      bulma: textPrimaryLight,
      trunks: textSecondaryLight,
      popo: textPrimaryLight,
      jiren: hoverPrimaryLight,
      heles: hoverSecondaryLight,
      zeno: overlayLight,
      krillin: warningOrange,
      krillin60: warningOrange60,
      krillin10: warningOrange10,
      chichi: errorRed,
      chichi60: errorRed60,
      chichi10: errorRed10,
      roshi: successGreen,
      roshi60: successGreen60,
      roshi10: successGreen10,
      whis: infoBlue,
      whis60: infoBlue60,
      whis10: infoBlue10,
      dodoria: supportRed,
      dodoria60: supportRed60,
      dodoria10: supportRed10,
      cell: supportTeal,
      cell60: supportTeal60,
      cell10: supportTeal10,
      raditz: supportBrown,
      raditz60: supportBrown60,
      raditz10: supportBrown10,
      frieza: primaryMint,
      frieza60: primaryMint60,
      frieza10: primaryMint10,
      nappa: supportGray,
      nappa60: supportGray60,
      nappa10: supportGray10,
      textPrimary: textPrimaryLight,
      textSecondary: textSecondaryLight,
      iconPrimary: textPrimaryLight,
      iconSecondary: textSecondaryLight,
    ),
  );

  static final MoonTokens darkTokens = MoonTokens.dark.copyWith(
    colors: MoonColors.dark.copyWith(
      piccolo: primaryMintDark,
      hit: accentTealDark,
      beerus: borderDark,
      goku: surfaceDark,
      gohan: surfaceVariantDark,
      goten: surfaceDark,
      bulma: textPrimaryDark,
      trunks: textSecondaryDark,
      popo: textPrimaryDark,
      jiren: hoverPrimaryDark,
      heles: hoverSecondaryDark,
      zeno: overlayDark,
      krillin: warningOrangeDark,
      krillin60: warningOrangeDark60,
      krillin10: warningOrangeDark10,
      chichi: errorRedDark,
      chichi60: errorRedDark60,
      chichi10: errorRedDark10,
      roshi: successGreenDark,
      roshi60: successGreenDark60,
      roshi10: successGreenDark10,
      whis: infoBlueDark,
      whis60: infoBlueDark60,
      whis10: infoBlueDark10,
      dodoria: supportRed,
      dodoria60: supportRed60,
      dodoria10: supportRed10,
      cell: supportTeal,
      cell60: supportTeal60,
      cell10: supportTeal10,
      raditz: supportBrown,
      raditz60: supportBrown60,
      raditz10: supportBrown10,
      frieza: primaryMintDark,
      frieza60: primaryMintDark60,
      frieza10: primaryMintDark10,
      nappa: supportGray,
      nappa60: supportGray60,
      nappa10: supportGray10,
      textPrimary: textPrimaryDark,
      textSecondary: textSecondaryDark,
      iconPrimary: textPrimaryDark,
      iconSecondary: textSecondaryDark,
    ),
  );

  static ThemeData lightTheme() {
    return ThemeData.light(useMaterial3: true).copyWith(
      textTheme: GoogleFonts.interTextTheme(),
      scaffoldBackgroundColor: backgroundLight,
      colorScheme: ColorScheme.light(
        primary: primaryMint,
        secondary: accentTeal,
        surface: surfaceLight,
        error: errorRed,
        onPrimary: Colors.white,
        onSecondary: Colors.white,
        onSurface: textPrimaryLight,
        onError: Colors.white,
      ),
      extensions: [MoonTheme(tokens: lightTokens)],
    );
  }

  static ThemeData darkTheme() {
    return ThemeData.dark(useMaterial3: true).copyWith(
      textTheme: GoogleFonts.interTextTheme(ThemeData.dark().textTheme),
      scaffoldBackgroundColor: backgroundDark,
      colorScheme: ColorScheme.dark(
        primary: primaryMintDark,
        secondary: accentTealDark,
        surface: surfaceDark,
        error: errorRedDark,
        onPrimary: textPrimaryLight,
        onSecondary: textPrimaryLight,
        onSurface: textPrimaryDark,
        onError: Colors.white,
      ),
      extensions: [MoonTheme(tokens: darkTokens)],
    );
  }
}
