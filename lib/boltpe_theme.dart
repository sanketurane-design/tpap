import 'package:flutter/material.dart';

/// Flutter handoff generated from `variablesBoltpe.json`.
///
/// Assumptions used while mapping tokens:
/// - `Responsive -> Mobile` drives spacing and typography.
/// - `Mode 1` is the light theme source.
/// - `regular/medium/semibold/bold` map to 400/500/600/700 weights.
/// - Non-Material component colors remain available as static constants.
abstract final class BoltPeTheme {
  static ThemeData get lightTheme {
    const colorScheme = ColorScheme.light(
      primary: BoltPeColors.primary500,
      onPrimary: BoltPeColors.white,
      primaryContainer: BoltPeColors.primary50,
      onPrimaryContainer: BoltPeColors.primary900,
      secondary: BoltPeColors.accent500,
      onSecondary: BoltPeColors.white,
      secondaryContainer: BoltPeColors.accent50,
      onSecondaryContainer: BoltPeColors.accent900,
      tertiary: BoltPeColors.surfaceTextInformation,
      onTertiary: BoltPeColors.white,
      tertiaryContainer: BoltPeColors.cardBgInformation,
      onTertiaryContainer: BoltPeColors.surfaceTextInformation,
      error: BoltPeColors.inputBorderNegative,
      onError: BoltPeColors.white,
      errorContainer: BoltPeColors.cardBgNegative,
      onErrorContainer: BoltPeColors.surfaceTextNegative,
      surface: BoltPeColors.surfaceBgPrimary,
      onSurface: BoltPeColors.surfaceTextPrimary,
    );

    final textTheme = BoltPeTypography.mobileTextTheme();
    final defaultInputBorder = _inputBorder(BoltPeColors.inputBorderDefault);
    final focusInputBorder = _inputBorder(BoltPeColors.inputBorderFocus);
    final disabledInputBorder = _inputBorder(BoltPeColors.inputBorderDisabled);
    final errorInputBorder = _inputBorder(BoltPeColors.inputBorderNegative);

    return ThemeData(
      useMaterial3: true,
      fontFamily: BoltPeTypography.fontFamily,
      colorScheme: colorScheme,
      textTheme: textTheme,
      scaffoldBackgroundColor: BoltPeColors.surfaceBgPrimary,
      canvasColor: BoltPeColors.surfaceBgPrimary,
      primaryColor: BoltPeColors.primary500,
      cardColor: BoltPeColors.cardBgDefault,
      dividerColor: BoltPeColors.surfaceBorderDefault,
      disabledColor: BoltPeColors.surfaceTextDisabled,
      splashColor: BoltPeColors.primary50,
      hoverColor: BoltPeColors.surfaceBgHover,
      highlightColor: BoltPeColors.surfaceBgSelected,
      appBarTheme: AppBarTheme(
        backgroundColor: BoltPeColors.surfaceBgPrimary,
        foregroundColor: BoltPeColors.surfaceTextPrimary,
        elevation: 0,
        scrolledUnderElevation: 0,
        centerTitle: false,
        surfaceTintColor: Colors.transparent,
        titleTextStyle: BoltPeTypography.headingSm.copyWith(
          color: BoltPeColors.surfaceTextPrimary,
        ),
      ),
      cardTheme: CardThemeData(
        color: BoltPeColors.cardBgDefault,
        elevation: 0,
        margin: EdgeInsets.zero,
        surfaceTintColor: Colors.transparent,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(BoltPeRadii.lg),
          side: const BorderSide(color: BoltPeColors.cardBorderDefault),
        ),
      ),
      dividerTheme: const DividerThemeData(
        color: BoltPeColors.surfaceBorderDefault,
        thickness: 1,
        space: 1,
      ),
      floatingActionButtonTheme: const FloatingActionButtonThemeData(
        backgroundColor: BoltPeColors.primary500,
        foregroundColor: BoltPeColors.white,
      ),
      progressIndicatorTheme: const ProgressIndicatorThemeData(
        color: BoltPeColors.primary500,
        linearTrackColor: BoltPeColors.surfaceBgTertiary,
      ),
      snackBarTheme: SnackBarThemeData(
        behavior: SnackBarBehavior.floating,
        backgroundColor: BoltPeColors.toastBgNeutral,
        contentTextStyle: BoltPeTypography.bodyMd.copyWith(
          color: BoltPeColors.toastFgNeutral,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(BoltPeRadii.md),
        ),
      ),
      bottomSheetTheme: BottomSheetThemeData(
        backgroundColor: BoltPeColors.bottomSheetBgDefault,
        modalBackgroundColor: BoltPeColors.bottomSheetBgDefault,
        surfaceTintColor: Colors.transparent,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            top: Radius.circular(BoltPeRadii.xl),
          ),
        ),
      ),
      navigationBarTheme: NavigationBarThemeData(
        backgroundColor: BoltPeColors.navigationBgDefault,
        indicatorColor: BoltPeColors.navigationIndicatorActive,
        height: 72,
        labelBehavior: NavigationDestinationLabelBehavior.alwaysShow,
        labelTextStyle: WidgetStateProperty.resolveWith<TextStyle?>((states) {
          final isSelected = states.contains(WidgetState.selected);
          return BoltPeTypography.labelSm.copyWith(
            color: isSelected
                ? BoltPeColors.navigationFgActive
                : BoltPeColors.navigationFgInactive,
          );
        }),
        iconTheme: WidgetStateProperty.resolveWith<IconThemeData?>((states) {
          final isSelected = states.contains(WidgetState.selected);
          return IconThemeData(
            color: isSelected
                ? BoltPeColors.navigationFgActive
                : BoltPeColors.navigationFgInactive,
            size: 24,
          );
        }),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: BoltPeColors.inputBgDefault,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: BoltPeSpacing.md,
          vertical: BoltPeSpacing.sm,
        ),
        hintStyle: BoltPeTypography.bodyMd.copyWith(
          color: BoltPeColors.inputFgPlaceholder,
        ),
        labelStyle: BoltPeTypography.labelLg.copyWith(
          color: BoltPeColors.inputLabelDefault,
        ),
        helperStyle: BoltPeTypography.bodySm.copyWith(
          color: BoltPeColors.inputHelperDefault,
        ),
        errorStyle: BoltPeTypography.bodySm.copyWith(
          color: BoltPeColors.inputHelperNegative,
        ),
        prefixIconColor: BoltPeColors.inputFgPrefix,
        suffixIconColor: BoltPeColors.inputFgPrefix,
        enabledBorder: defaultInputBorder,
        focusedBorder: focusInputBorder,
        disabledBorder: disabledInputBorder,
        errorBorder: errorInputBorder,
        focusedErrorBorder: errorInputBorder,
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: _buttonStyle(
          textStyle: BoltPeTypography.labelLg,
          defaultBackgroundColor: BoltPeColors.buttonPrimaryBgDefault,
          hoveredBackgroundColor: BoltPeColors.buttonPrimaryBgHover,
          pressedBackgroundColor: BoltPeColors.buttonPrimaryBgPressed,
          disabledBackgroundColor: BoltPeColors.buttonPrimaryBgDisabled,
          defaultForegroundColor: BoltPeColors.buttonPrimaryFgDefault,
          hoveredForegroundColor: BoltPeColors.buttonPrimaryFgHover,
          pressedForegroundColor: BoltPeColors.buttonPrimaryFgPressed,
          disabledForegroundColor: BoltPeColors.buttonPrimaryFgDisabled,
          defaultBorderColor: BoltPeColors.buttonPrimaryBgDefault,
          hoveredBorderColor: BoltPeColors.buttonPrimaryBgHover,
          pressedBorderColor: BoltPeColors.buttonPrimaryBgPressed,
          disabledBorderColor: BoltPeColors.buttonPrimaryBgDisabled,
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: _buttonStyle(
          textStyle: BoltPeTypography.labelLg,
          defaultBackgroundColor: BoltPeColors.buttonSecondaryBgDefault,
          hoveredBackgroundColor: BoltPeColors.buttonSecondaryBgHover,
          pressedBackgroundColor: BoltPeColors.buttonSecondaryBgPressed,
          disabledBackgroundColor: BoltPeColors.inputBgDisabled,
          defaultForegroundColor: BoltPeColors.buttonSecondaryFgDefault,
          hoveredForegroundColor: BoltPeColors.buttonSecondaryFgHover,
          pressedForegroundColor: BoltPeColors.buttonSecondaryFgPressed,
          disabledForegroundColor: BoltPeColors.surfaceTextDisabled,
          defaultBorderColor: BoltPeColors.buttonSecondaryFgDefault,
          hoveredBorderColor: BoltPeColors.buttonSecondaryFgHover,
          pressedBorderColor: BoltPeColors.buttonSecondaryFgPressed,
          disabledBorderColor: BoltPeColors.surfaceBorderDefault,
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: ButtonStyle(
          foregroundColor: const WidgetStatePropertyAll(
            BoltPeColors.surfaceTextLink,
          ),
          textStyle: WidgetStatePropertyAll(
            BoltPeTypography.labelLg.copyWith(
              color: BoltPeColors.surfaceTextLink,
            ),
          ),
          padding: const WidgetStatePropertyAll(
            EdgeInsets.symmetric(
              horizontal: BoltPeSpacing.xs,
              vertical: BoltPeSpacing.xs,
            ),
          ),
          overlayColor: WidgetStateProperty.resolveWith<Color?>((states) {
            if (states.contains(WidgetState.pressed)) {
              return BoltPeColors.primary100;
            }
            if (states.contains(WidgetState.hovered)) {
              return BoltPeColors.primary50;
            }
            return null;
          }),
        ),
      ),
    );
  }

  static final ButtonStyle negativeButtonStyle = _buttonStyle(
    textStyle: BoltPeTypography.labelLg,
    defaultBackgroundColor: BoltPeColors.buttonNegativeBgDefault,
    hoveredBackgroundColor: BoltPeColors.buttonNegativeBgHover,
    pressedBackgroundColor: BoltPeColors.buttonNegativeBgPressed,
    disabledBackgroundColor: BoltPeColors.inputBgDisabled,
    defaultForegroundColor: BoltPeColors.buttonNegativeFgDefault,
    hoveredForegroundColor: BoltPeColors.buttonNegativeFgHover,
    pressedForegroundColor: BoltPeColors.buttonNegativeFgPressed,
    disabledForegroundColor: BoltPeColors.surfaceTextDisabled,
    defaultBorderColor: BoltPeColors.buttonNegativeBgDefault,
    hoveredBorderColor: BoltPeColors.buttonNegativeBgHover,
    pressedBorderColor: BoltPeColors.buttonNegativeBgPressed,
    disabledBorderColor: BoltPeColors.surfaceBorderDefault,
  );

  static ButtonStyle _buttonStyle({
    required TextStyle textStyle,
    required Color defaultBackgroundColor,
    required Color hoveredBackgroundColor,
    required Color pressedBackgroundColor,
    required Color disabledBackgroundColor,
    required Color defaultForegroundColor,
    required Color hoveredForegroundColor,
    required Color pressedForegroundColor,
    required Color disabledForegroundColor,
    required Color defaultBorderColor,
    required Color hoveredBorderColor,
    required Color pressedBorderColor,
    required Color disabledBorderColor,
  }) {
    return ButtonStyle(
      elevation: const WidgetStatePropertyAll(0),
      minimumSize: const WidgetStatePropertyAll(Size.fromHeight(48)),
      padding: const WidgetStatePropertyAll(
        EdgeInsets.symmetric(
          horizontal: BoltPeSpacing.lg,
          vertical: BoltPeSpacing.sm,
        ),
      ),
      textStyle: WidgetStatePropertyAll(textStyle),
      shape: WidgetStatePropertyAll(
        RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(BoltPeRadii.md),
        ),
      ),
      backgroundColor: WidgetStateProperty.resolveWith<Color>((states) {
        if (states.contains(WidgetState.disabled)) {
          return disabledBackgroundColor;
        }
        if (states.contains(WidgetState.pressed)) {
          return pressedBackgroundColor;
        }
        if (states.contains(WidgetState.hovered)) {
          return hoveredBackgroundColor;
        }
        return defaultBackgroundColor;
      }),
      foregroundColor: WidgetStateProperty.resolveWith<Color>((states) {
        if (states.contains(WidgetState.disabled)) {
          return disabledForegroundColor;
        }
        if (states.contains(WidgetState.pressed)) {
          return pressedForegroundColor;
        }
        if (states.contains(WidgetState.hovered)) {
          return hoveredForegroundColor;
        }
        return defaultForegroundColor;
      }),
      side: WidgetStateProperty.resolveWith<BorderSide>((states) {
        if (states.contains(WidgetState.disabled)) {
          return BorderSide(color: disabledBorderColor);
        }
        if (states.contains(WidgetState.pressed)) {
          return BorderSide(color: pressedBorderColor);
        }
        if (states.contains(WidgetState.hovered)) {
          return BorderSide(color: hoveredBorderColor);
        }
        return BorderSide(color: defaultBorderColor);
      }),
      overlayColor: WidgetStateProperty.resolveWith<Color?>((states) {
        if (states.contains(WidgetState.pressed)) {
          return defaultForegroundColor.withValues(alpha: 0.08);
        }
        if (states.contains(WidgetState.hovered)) {
          return defaultForegroundColor.withValues(alpha: 0.04);
        }
        return null;
      }),
    );
  }

  static OutlineInputBorder _inputBorder(Color color) {
    return OutlineInputBorder(
      borderRadius: BorderRadius.circular(BoltPeRadii.md),
      borderSide: BorderSide(color: color),
    );
  }
}

abstract final class BoltPeTypography {
  static const String fontFamily = 'Geist';

  static const FontWeight regular = FontWeight.w400;
  static const FontWeight medium = FontWeight.w500;
  static const FontWeight semibold = FontWeight.w600;
  static const FontWeight bold = FontWeight.w700;

  static const TextStyle display2xl = TextStyle(
    fontFamily: fontFamily,
    fontSize: 40,
    height: 1.2,
    fontWeight: semibold,
  );

  static const TextStyle displayXl = TextStyle(
    fontFamily: fontFamily,
    fontSize: 32,
    height: 1.25,
    fontWeight: semibold,
  );

  static const TextStyle headingXl = TextStyle(
    fontFamily: fontFamily,
    fontSize: 28,
    height: 32 / 28,
    fontWeight: semibold,
  );

  static const TextStyle headingLg = TextStyle(
    fontFamily: fontFamily,
    fontSize: 24,
    height: 28 / 24,
    fontWeight: semibold,
  );

  static const TextStyle headingMd = TextStyle(
    fontFamily: fontFamily,
    fontSize: 20,
    height: 1.2,
    fontWeight: semibold,
  );

  static const TextStyle headingSm = TextStyle(
    fontFamily: fontFamily,
    fontSize: 18,
    height: 20 / 18,
    fontWeight: semibold,
  );

  static const TextStyle bodyLg = TextStyle(
    fontFamily: fontFamily,
    fontSize: 18,
    height: 20 / 18,
    fontWeight: regular,
  );

  static const TextStyle bodyMd = TextStyle(
    fontFamily: fontFamily,
    fontSize: 16,
    height: 1.25,
    fontWeight: regular,
  );

  static const TextStyle bodySm = TextStyle(
    fontFamily: fontFamily,
    fontSize: 12,
    height: 16 / 12,
    fontWeight: regular,
  );

  static const TextStyle labelLg = TextStyle(
    fontFamily: fontFamily,
    fontSize: 14,
    height: 20 / 14,
    fontWeight: medium,
  );

  static const TextStyle labelMd = TextStyle(
    fontFamily: fontFamily,
    fontSize: 12,
    height: 16 / 12,
    fontWeight: medium,
  );

  static const TextStyle labelSm = TextStyle(
    fontFamily: fontFamily,
    fontSize: 10,
    height: 1.6,
    fontWeight: medium,
  );

  static const TextStyle caption = TextStyle(
    fontFamily: fontFamily,
    fontSize: 10,
    height: 1.6,
    fontWeight: regular,
  );

  static TextTheme mobileTextTheme() {
    return TextTheme(
      displayLarge: display2xl.copyWith(color: BoltPeColors.surfaceTextPrimary),
      displayMedium: displayXl.copyWith(color: BoltPeColors.surfaceTextPrimary),
      displaySmall: headingXl.copyWith(color: BoltPeColors.surfaceTextPrimary),
      headlineLarge: headingLg.copyWith(color: BoltPeColors.surfaceTextPrimary),
      headlineMedium: headingMd.copyWith(
        color: BoltPeColors.surfaceTextPrimary,
      ),
      headlineSmall: headingSm.copyWith(color: BoltPeColors.surfaceTextPrimary),
      titleLarge: headingSm.copyWith(color: BoltPeColors.surfaceTextPrimary),
      titleMedium: labelLg.copyWith(color: BoltPeColors.surfaceTextPrimary),
      titleSmall: labelMd.copyWith(color: BoltPeColors.surfaceTextSecondary),
      bodyLarge: bodyLg.copyWith(color: BoltPeColors.surfaceTextPrimary),
      bodyMedium: bodyMd.copyWith(color: BoltPeColors.surfaceTextPrimary),
      bodySmall: bodySm.copyWith(color: BoltPeColors.surfaceTextSecondary),
      labelLarge: labelLg.copyWith(color: BoltPeColors.surfaceTextPrimary),
      labelMedium: labelMd.copyWith(color: BoltPeColors.surfaceTextSecondary),
      labelSmall: labelSm.copyWith(color: BoltPeColors.surfaceTextSecondary),
    );
  }
}

abstract final class BoltPeSpacing {
  static const double none = 0;
  static const double xxxs = 2;
  static const double xxs = 4;
  static const double xs = 8;
  static const double sm = 12;
  static const double md = 16;
  static const double lg = 20;
  static const double xl = 24;
  static const double xxl = 32;
  static const double xxxl = 36;
  static const double pageX = 16;
  static const double pageY = 16;
  static const double section = 24;
  static const double cardGap = 12;
  static const double stack = 16;
}

abstract final class BoltPeRadii {
  static const double none = 0;
  static const double xxs = 2;
  static const double xs = 4;
  static const double sm = 8;
  static const double md = 12;
  static const double lg = 16;
  static const double xl = 20;
  static const double xxl = 24;
  static const double full = 999;
}

abstract final class BoltPeColors {
  static const Color white = Color(0xFFFFFFFF);
  static const Color black = Color(0xFF070707);

  static const Color primary50 = Color(0xFFFFEADE);
  static const Color primary100 = Color(0xFFFFDECC);
  static const Color primary200 = Color(0xFFFFBE9A);
  static const Color primary300 = Color(0xFFFF9D67);
  static const Color primary400 = Color(0xFFFF7D35);
  static const Color primary500 = Color(0xFFFF5C02);
  static const Color primary600 = Color(0xFFE05000);
  static const Color primary700 = Color(0xFFBF4400);
  static const Color primary800 = Color(0xFF9E3800);
  static const Color primary900 = Color(0xFF7D2C00);
  static const Color primary1000 = Color(0xFF5C2100);

  static const Color accent50 = Color(0xFFF2ECFF);
  static const Color accent100 = Color(0xFFE1D4FE);
  static const Color accent200 = Color(0xFFC2A9FC);
  static const Color accent300 = Color(0xFFA47EFB);
  static const Color accent400 = Color(0xFF8553F9);
  static const Color accent500 = Color(0xFF6728F8);
  static const Color accent600 = Color(0xFF4F08F3);
  static const Color accent700 = Color(0xFF4307CE);
  static const Color accent800 = Color(0xFF3706AA);
  static const Color accent900 = Color(0xFF2C0486);
  static const Color accent1000 = Color(0xFF200361);

  static const Color neutral100 = Color(0xFFF8F8F8);
  static const Color neutral200 = Color(0xFFDDDDDD);
  static const Color neutral300 = Color(0xFFC2C2C2);
  static const Color neutral400 = Color(0xFFA8A8A8);
  static const Color neutral500 = Color(0xFF8D8D8D);
  static const Color neutral600 = Color(0xFF727272);
  static const Color neutral700 = Color(0xFF575757);
  static const Color neutral800 = Color(0xFF3D3D3D);
  static const Color neutral900 = Color(0xFF222222);

  static const Color surfaceBorderDefault = Color(0xFFDDDDDD);
  static const Color surfaceBorderStrong = Color(0xFFA8A8A8);
  static const Color surfaceBorderSubtle = Color(0xFFF8F8F8);
  static const Color surfaceBorderFocus = Color(0xFFFF5C02);

  static const Color surfaceBgPrimary = Color(0xFFFFFFFF);
  static const Color surfaceBgSecondary = Color(0xFFF8F8F8);
  static const Color surfaceBgTertiary = Color(0xFFDDDDDD);
  static const Color surfaceBgInverse = Color(0xFF222222);
  static const Color surfaceBgBrand = Color(0xFFFF5C02);
  static const Color surfaceBgHover = Color(0xFFF8F8F8);
  static const Color surfaceBgSelected = Color(0xFFFFEADE);
  static const Color surfaceBgSkeleton = Color(0xFFDDDDDD);

  static const Color surfaceTextPrimary = Color(0xFF222222);
  static const Color surfaceTextSecondary = Color(0xFF727272);
  static const Color surfaceTextTertiary = Color(0xFFA8A8A8);
  static const Color surfaceTextInverse = Color(0xFFFFFFFF);
  static const Color surfaceTextDisabled = Color(0xFFC2C2C2);
  static const Color surfaceTextLink = Color(0xFFFF5C02);
  static const Color surfaceTextAccent = Color(0xFF6728F8);
  static const Color surfaceTextPositive = Color(0xFF0A710C);
  static const Color surfaceTextNegative = Color(0xFF7C0606);
  static const Color surfaceTextNotice = Color(0xFF735104);
  static const Color surfaceTextInformation = Color(0xFF1256A1);

  static const Color surfaceIconDefault = Color(0xFF727272);
  static const Color surfaceIconSubtle = Color(0xFFA8A8A8);
  static const Color surfaceIconInverse = Color(0xFFFFFFFF);
  static const Color surfaceIconDisabled = Color(0xFFC2C2C2);
  static const Color surfaceIconPrimary = Color(0xFFFF5C02);
  static const Color surfaceIconPositive = Color(0xFF0E9D10);
  static const Color surfaceIconNegative = Color(0xFFAE0808);
  static const Color surfaceIconNotice = Color(0xFFA17106);
  static const Color surfaceIconInformation = Color(0xFF1976D2);

  static const Color scrim = Color(0xFF070707);

  static const Color buttonPrimaryBgDefault = Color(0xFFFF5C02);
  static const Color buttonPrimaryBgHover = Color(0xFFE05000);
  static const Color buttonPrimaryBgPressed = Color(0xFFBF4400);
  static const Color buttonPrimaryBgDisabled = Color(0xFFDDDDDD);

  static const Color buttonPrimaryFgDefault = Color(0xFFFFFFFF);
  static const Color buttonPrimaryFgHover = Color(0xFFF8F8F8);
  static const Color buttonPrimaryFgPressed = Color(0xFFDDDDDD);
  static const Color buttonPrimaryFgDisabled = Color(0xFFA8A8A8);

  static const Color buttonSecondaryBgDefault = Color(0xFFFFFFFF);
  static const Color buttonSecondaryBgHover = Color(0xFFF8F8F8);
  static const Color buttonSecondaryBgPressed = Color(0xFFDDDDDD);

  static const Color buttonSecondaryFgDefault = Color(0xFFFF5C02);
  static const Color buttonSecondaryFgHover = Color(0xFFE05000);
  static const Color buttonSecondaryFgPressed = Color(0xFFBF4400);

  static const Color buttonNegativeBgDefault = Color(0xFFAE0808);
  static const Color buttonNegativeBgHover = Color(0xFF7C0606);
  static const Color buttonNegativeBgPressed = Color(0xFF710505);

  static const Color buttonNegativeFgDefault = Color(0xFFFFFFFF);
  static const Color buttonNegativeFgHover = Color(0xFFF8F8F8);
  static const Color buttonNegativeFgPressed = Color(0xFFDDDDDD);

  static const Color inputBgDefault = Color(0xFFFFFFFF);
  static const Color inputBgDisabled = Color(0xFFF8F8F8);
  static const Color inputBgNegative = Color(0xFFFFE3E3);
  static const Color inputBgPositive = Color(0xFFDEFFDF);
  static const Color inputBgNotice = Color(0xFFFFF4DC);

  static const Color inputFgDefault = Color(0xFF222222);
  static const Color inputFgPlaceholder = Color(0xFFA8A8A8);
  static const Color inputFgDisabled = Color(0xFFC2C2C2);
  static const Color inputFgPrefix = Color(0xFF727272);

  static const Color inputBorderDefault = Color(0xFFDDDDDD);
  static const Color inputBorderHover = Color(0xFFA8A8A8);
  static const Color inputBorderFocus = Color(0xFFFF5C02);
  static const Color inputBorderDisabled = Color(0xFFF8F8F8);
  static const Color inputBorderNegative = Color(0xFFE00A0A);
  static const Color inputBorderPositive = Color(0xFF0E9D10);
  static const Color inputBorderNotice = Color(0xFFA17106);

  static const Color inputHelperDefault = Color(0xFF727272);
  static const Color inputHelperNegative = Color(0xFFAE0808);
  static const Color inputHelperPositive = Color(0xFF0E9D10);
  static const Color inputHelperNotice = Color(0xFFA17106);
  static const Color inputLabelDefault = Color(0xFF575757);

  static const Color cardBgDefault = Color(0xFFFFFFFF);
  static const Color cardBgSubtle = Color(0xFFF8F8F8);
  static const Color cardBgHover = Color(0xFFDDDDDD);
  static const Color cardBgBrand = Color(0xFFFFEADE);
  static const Color cardBgPositive = Color(0xFFDEFFDF);
  static const Color cardBgNotice = Color(0xFFFFF4DC);
  static const Color cardBgNegative = Color(0xFFFFE3E3);
  static const Color cardBgInformation = Color(0xFFE8F4FD);

  static const Color cardBorderDefault = Color(0xFFDDDDDD);
  static const Color cardBorderSubtle = Color(0xFFF8F8F8);
  static const Color cardBorderBrand = Color(0xFFFFBE9A);
  static const Color cardBorderSelected = Color(0xFFFF5C02);

  static const Color navigationBgDefault = Color(0xFFFFFFFF);
  static const Color navigationBgHover = Color(0xFFF8F8F8);
  static const Color navigationFgActive = Color(0xFFFF5C02);
  static const Color navigationFgInactive = Color(0xFFA8A8A8);
  static const Color navigationBorderTop = Color(0xFFDDDDDD);
  static const Color navigationIndicatorActive = Color(0xFFFFDECC);

  static const Color badgeBgPrimary = Color(0xFFFFEADE);
  static const Color badgeBgPositive = Color(0xFFDEFFDF);
  static const Color badgeBgNegative = Color(0xFFFFE3E3);
  static const Color badgeBgNotice = Color(0xFFFFF4DC);
  static const Color badgeBgInformation = Color(0xFFE8F4FD);
  static const Color badgeBgNeutral = Color(0xFFDDDDDD);

  static const Color badgeFgPrimary = Color(0xFFE05000);
  static const Color badgeFgPositive = Color(0xFF0A710C);
  static const Color badgeFgNegative = Color(0xFF7C0606);
  static const Color badgeFgNotice = Color(0xFF735104);
  static const Color badgeFgInformation = Color(0xFF1256A1);
  static const Color badgeFgNeutral = Color(0xFF575757);

  static const Color toastBgPositive = Color(0xFFDEFFDF);
  static const Color toastBgNegative = Color(0xFFFFE3E3);
  static const Color toastBgNotice = Color(0xFFFFF4DC);
  static const Color toastBgInformation = Color(0xFFE8F4FD);
  static const Color toastBgNeutral = Color(0xFFF8F8F8);

  static const Color toastFgPositive = Color(0xFF0A710C);
  static const Color toastFgNegative = Color(0xFF7C0606);
  static const Color toastFgNotice = Color(0xFF735104);
  static const Color toastFgInformation = Color(0xFF1256A1);
  static const Color toastFgNeutral = Color(0xFF575757);

  static const Color toastIconPositive = Color(0xFF0E9D10);
  static const Color toastIconNegative = Color(0xFFAE0808);
  static const Color toastIconNotice = Color(0xFFA17106);
  static const Color toastIconInformation = Color(0xFF1976D2);
  static const Color toastIconNeutral = Color(0xFF8D8D8D);

  static const Color bottomSheetBgDefault = Color(0xFFFFFFFF);
  static const Color bottomSheetScrimDefault = Color(0xFF070707);
  static const Color bottomSheetHandleDefault = Color(0xFFDDDDDD);
}
