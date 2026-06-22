import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

ThemeData buildFocusTimerTheme({
  required Color seedColor,
  required Brightness brightness,
}) {
  final colorScheme = ColorScheme.fromSeed(
    seedColor: seedColor,
    brightness: brightness,
  );
  final isDark = brightness == Brightness.dark;
  final systemUiStyle = focusTimerSystemUiStyle(brightness);

  Color? stateLayer(Set<WidgetState> states, Color base) {
    if (states.contains(WidgetState.pressed)) {
      return base.withValues(alpha: isDark ? 0.20 : 0.14);
    }
    if (states.contains(WidgetState.hovered)) {
      return base.withValues(alpha: isDark ? 0.14 : 0.08);
    }
    if (states.contains(WidgetState.focused)) {
      return base.withValues(alpha: isDark ? 0.18 : 0.10);
    }
    return null;
  }

  return ThemeData(
    colorScheme: colorScheme,
    useMaterial3: true,
    scaffoldBackgroundColor: colorScheme.surface,
    highlightColor: colorScheme.primary.withValues(alpha: isDark ? 0.18 : 0.10),
    splashColor: colorScheme.primary.withValues(alpha: isDark ? 0.18 : 0.10),
    hoverColor: colorScheme.primary.withValues(alpha: isDark ? 0.12 : 0.06),
    focusColor: colorScheme.primary.withValues(alpha: isDark ? 0.18 : 0.10),
    appBarTheme: AppBarTheme(
      elevation: 0,
      scrolledUnderElevation: 0,
      centerTitle: false,
      backgroundColor: colorScheme.surface,
      foregroundColor: colorScheme.onSurface,
      surfaceTintColor: Colors.transparent,
      systemOverlayStyle: systemUiStyle,
    ),
    iconButtonTheme: IconButtonThemeData(
      style: ButtonStyle(
        overlayColor: WidgetStateProperty.resolveWith(
          (states) => stateLayer(states, colorScheme.primary),
        ),
      ),
    ),
    navigationBarTheme: NavigationBarThemeData(
      height: 66,
      elevation: 0,
      backgroundColor: Colors.transparent,
      indicatorColor: colorScheme.primaryContainer.withValues(
        alpha: isDark ? 0.52 : 0.82,
      ),
      iconTheme: WidgetStateProperty.resolveWith((states) {
        final selected = states.contains(WidgetState.selected);
        return IconThemeData(
          size: selected ? 25 : 24,
          color: selected ? colorScheme.onPrimaryContainer : colorScheme.onSurfaceVariant,
        );
      }),
      labelTextStyle: WidgetStateProperty.resolveWith((states) {
        final selected = states.contains(WidgetState.selected);
        return TextStyle(
          fontSize: 12,
          fontWeight: selected ? FontWeight.w700 : FontWeight.w500,
          color: selected ? colorScheme.onSurface : colorScheme.onSurfaceVariant,
          letterSpacing: 0,
        );
      }),
    ),
    segmentedButtonTheme: SegmentedButtonThemeData(
      style: ButtonStyle(
        backgroundColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return colorScheme.primaryContainer.withValues(
              alpha: isDark ? 0.56 : 0.78,
            );
          }
          return Colors.transparent;
        }),
        foregroundColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return colorScheme.onPrimaryContainer;
          }
          return colorScheme.onSurfaceVariant;
        }),
        overlayColor: WidgetStateProperty.resolveWith(
          (states) => stateLayer(states, colorScheme.primary),
        ),
        side: WidgetStatePropertyAll(
          BorderSide(color: colorScheme.outlineVariant),
        ),
      ),
    ),
    textButtonTheme: TextButtonThemeData(
      style: ButtonStyle(
        overlayColor: WidgetStateProperty.resolveWith(
          (states) => stateLayer(states, colorScheme.primary),
        ),
      ),
    ),
    filledButtonTheme: FilledButtonThemeData(
      style: ButtonStyle(
        overlayColor: WidgetStateProperty.resolveWith(
          (states) => stateLayer(states, colorScheme.onPrimary),
        ),
      ),
    ),
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: ButtonStyle(
        overlayColor: WidgetStateProperty.resolveWith(
          (states) => stateLayer(states, colorScheme.primary),
        ),
      ),
    ),
    popupMenuTheme: PopupMenuThemeData(
      color: colorScheme.surfaceContainerHigh,
      surfaceTintColor: Colors.transparent,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
    ),
    bottomSheetTheme: BottomSheetThemeData(
      backgroundColor: colorScheme.surface,
      surfaceTintColor: Colors.transparent,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(18)),
      ),
    ),
    snackBarTheme: SnackBarThemeData(
      behavior: SnackBarBehavior.floating,
      backgroundColor: colorScheme.inverseSurface,
      contentTextStyle: TextStyle(color: colorScheme.onInverseSurface),
    ),
  );
}

SystemUiOverlayStyle focusTimerSystemUiStyle(Brightness brightness) {
  final isDark = brightness == Brightness.dark;
  return SystemUiOverlayStyle(
    statusBarColor: Colors.transparent,
    systemNavigationBarColor: Colors.transparent,
    systemNavigationBarDividerColor: Colors.transparent,
    statusBarIconBrightness: isDark ? Brightness.light : Brightness.dark,
    statusBarBrightness: isDark ? Brightness.dark : Brightness.light,
    systemNavigationBarIconBrightness: isDark ? Brightness.light : Brightness.dark,
    systemStatusBarContrastEnforced: false,
    systemNavigationBarContrastEnforced: false,
  );
}

Color focusTimerNavSurface(ColorScheme colorScheme, Brightness brightness) {
  return colorScheme.surface.withValues(
    alpha: brightness == Brightness.dark ? 0.92 : 0.96,
  );
}
