import 'package:flex_color_scheme/flex_color_scheme.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:signals/signals_flutter.dart';

const Color kPink = Color(0xFFEBA1A6);
const Color kPurple = Color(0xFF815AA3);
const Color kOrange = Color(0xFFFCB075);

enum FlexSchemes { shark, greyLaw, sanJuanBlue }

extension FlexSchemesExtension on FlexSchemes {
  FlexScheme get libraryScheme {
    switch (this) {
      case FlexSchemes.shark:
        return FlexScheme.shark;
      case FlexSchemes.greyLaw:
        return FlexScheme.greyLaw;
      case FlexSchemes.sanJuanBlue:
        return FlexScheme.sanJuanBlue;
    }
  }
}

final Signal<FlexSchemes> sFlexScheme = Signal<FlexSchemes>(
  FlexSchemes.shark,
  debugLabel: 'sFlexScheme',
);

final Signal<bool> sDarkMode = Signal<bool>(false, debugLabel: 'sDarkMode');

final Signal<bool> sWakelock = Signal<bool>(true, debugLabel: 'sWakelock');

final Signal<String> sFont = Signal<String>(
  'LeagueGothic',
  debugLabel: 'sFont',
);

final Computed<ThemeData> cThemeData = Computed<ThemeData>(() {
  final FlexScheme activeScheme = sFlexScheme.value.libraryScheme;

  if (sDarkMode.value) {
    return FlexThemeData.dark(
      // Using FlexColorScheme built-in FlexScheme enum based colors.
      scheme: activeScheme,
      // Input color modifiers.
      swapLegacyOnMaterial3: true,
      // Convenience direct styling properties.
      bottomAppBarElevation: 0.5,
      // Component theme configurations for dark mode.
      subThemesData: const FlexSubThemesData(
        interactionEffects: true,
        blendOnLevel: 20,
        blendOnColors: true,
        splashType: FlexSplashType.instantSplash,
        splashTypeAdaptive: FlexSplashType.instantSplash,
        adaptiveElevationShadowsBack: FlexAdaptive.all(),
        adaptiveAppBarScrollUnderOff: FlexAdaptive.all(),
        defaultRadius: 6.0,
        elevatedButtonSchemeColor: SchemeColor.onPrimaryContainer,
        elevatedButtonSecondarySchemeColor: SchemeColor.primaryContainer,
        outlinedButtonSchemeColor: SchemeColor.onSurface,
        outlinedButtonOutlineSchemeColor: SchemeColor.outlineVariant,
        toggleButtonsBorderSchemeColor: SchemeColor.outlineVariant,
        segmentedButtonSchemeColor: SchemeColor.primary,
        segmentedButtonBorderSchemeColor: SchemeColor.outlineVariant,
        switchThumbSchemeColor: SchemeColor.onPrimaryContainer,
        switchAdaptiveCupertinoLike: FlexAdaptive.all(),
        unselectedToggleIsColored: true,
        sliderValueTinted: true,
        sliderTrackHeight: 8,
        sliderYear2023: false,
        progressIndicatorYear2023: false,
        inputDecoratorIsDense: true,
        inputDecoratorContentPadding: EdgeInsetsDirectional.fromSTEB(
          12,
          12,
          12,
          12,
        ),
        inputDecoratorBorderSchemeColor: SchemeColor.primary,
        inputDecoratorBorderType: FlexInputBorderType.outline,
        inputDecoratorRadius: 8.0,
        inputDecoratorBorderWidth: 0.5,
        inputDecoratorFocusedBorderWidth: 2.0,
        fabUseShape: true,
        chipSchemeColor: SchemeColor.secondaryContainer,
        chipSelectedSchemeColor: SchemeColor.primaryContainer,
        chipFontSize: 12,
        chipIconSize: 16,
        chipPadding: EdgeInsetsDirectional.fromSTEB(4, 4, 4, 4),
        cardRadius: 12.0,
        cardElevation: 1.0,
        popupMenuRadius: 6.0,
        popupMenuElevation: 4.0,
        alignedDropdown: true,
        tooltipRadius: 6,
        tooltipSchemeColor: SchemeColor.surfaceContainerHigh,
        tooltipOpacity: 0.96,
        dialogBackgroundSchemeColor: SchemeColor.surfaceContainerHigh,
        dialogRadius: 12.0,
        snackBarRadius: 6,
        snackBarElevation: 6,
        snackBarBackgroundSchemeColor: SchemeColor.surfaceContainerLow,
        appBarBackgroundSchemeColor: SchemeColor.surfaceContainerLowest,
        appBarScrolledUnderElevation: 2.5,
        bottomAppBarHeight: 60,
        tabBarIndicatorWeight: 4,
        tabBarIndicatorTopRadius: 4,
        tabBarDividerColor: Color(0x00000000),
        drawerRadius: 0.0,
        drawerElevation: 2.0,
        drawerIndicatorOpacity: 0.5,
        bottomSheetBackgroundColor: SchemeColor.surfaceContainerHigh,
        bottomSheetModalBackgroundColor: SchemeColor.surfaceContainer,
        bottomSheetRadius: 12.0,
        bottomSheetElevation: 4.0,
        bottomSheetModalElevation: 6.0,
        bottomNavigationBarSelectedLabelSchemeColor: SchemeColor.primary,
        bottomNavigationBarMutedUnselectedLabel: true,
        bottomNavigationBarSelectedIconSchemeColor: SchemeColor.primary,
        bottomNavigationBarMutedUnselectedIcon: true,
        bottomNavigationBarBackgroundSchemeColor: SchemeColor.surfaceContainer,
        bottomNavigationBarElevation: 0.0,
        menuRadius: 6.0,
        menuElevation: 4.0,
        menuSchemeColor: SchemeColor.surfaceContainerLowest,
        menuPadding: EdgeInsetsDirectional.fromSTEB(6, 10, 5, 10),
        menuBarRadius: 0.0,
        menuBarElevation: 0.0,
        menuBarShadowColor: Color(0x00000000),
        menuIndicatorBackgroundSchemeColor: SchemeColor.surfaceContainerHigh,
        menuIndicatorRadius: 6.0,
        searchBarElevation: 0.0,
        searchViewElevation: 0.0,
        navigationBarIndicatorSchemeColor: SchemeColor.secondaryContainer,
        navigationBarBackgroundSchemeColor: SchemeColor.surfaceContainer,
        navigationBarElevation: 0.0,
        navigationBarHeight: 72.0,
        navigationRailUseIndicator: true,
        navigationRailIndicatorSchemeColor: SchemeColor.secondaryContainer,
        navigationRailIndicatorOpacity: 1.00,
        navigationRailBackgroundSchemeColor: SchemeColor.surfaceContainer,
      ),
      // ColorScheme seed configuration setup for dark mode.
      keyColors: const FlexKeyColors(
        useSecondary: true,
        useTertiary: true,
        useError: true,
        keepPrimary: true,
        keepSecondary: true,
        keepError: true,
        keepTertiaryContainer: true,
      ),
      tones: FlexSchemeVariant.chroma
          .tones(Brightness.dark)
          .higherContrastFixed()
          .monochromeSurfaces(),
      // Direct ThemeData properties.
      visualDensity: VisualDensity.compact,
      materialTapTargetSize: MaterialTapTargetSize.padded,
      cupertinoOverrideTheme: const CupertinoThemeData(applyThemeToAll: true),
      fontFamily: GoogleFonts.questrial().fontFamily,
    );
  } else {
    return FlexThemeData.light(
      // Using FlexColorScheme built-in FlexScheme enum based colors
      scheme: activeScheme,
      // Input color modifiers.
      swapLegacyOnMaterial3: true,
      // Surface color adjustments.
      lightIsWhite: true,
      // Convenience direct styling properties.
      bottomAppBarElevation: 0.5,
      // Component theme configurations for light mode.
      subThemesData: const FlexSubThemesData(
        interactionEffects: true,
        blendOnLevel: 10,
        splashType: FlexSplashType.instantSplash,
        splashTypeAdaptive: FlexSplashType.instantSplash,
        adaptiveElevationShadowsBack: FlexAdaptive.all(),
        adaptiveAppBarScrollUnderOff: FlexAdaptive.all(),
        defaultRadius: 6.0,
        elevatedButtonSchemeColor: SchemeColor.onPrimaryContainer,
        elevatedButtonSecondarySchemeColor: SchemeColor.primaryContainer,
        outlinedButtonSchemeColor: SchemeColor.onSurface,
        outlinedButtonOutlineSchemeColor: SchemeColor.outlineVariant,
        toggleButtonsBorderSchemeColor: SchemeColor.outlineVariant,
        segmentedButtonSchemeColor: SchemeColor.primary,
        segmentedButtonBorderSchemeColor: SchemeColor.outlineVariant,
        switchThumbSchemeColor: SchemeColor.onPrimaryContainer,
        switchAdaptiveCupertinoLike: FlexAdaptive.all(),
        unselectedToggleIsColored: true,
        sliderValueTinted: true,
        sliderTrackHeight: 8,
        sliderYear2023: false,
        progressIndicatorYear2023: false,
        inputDecoratorIsDense: true,
        inputDecoratorContentPadding: EdgeInsetsDirectional.fromSTEB(
          12,
          12,
          12,
          12,
        ),
        inputDecoratorBorderSchemeColor: SchemeColor.primary,
        inputDecoratorBorderType: FlexInputBorderType.outline,
        inputDecoratorRadius: 8.0,
        inputDecoratorBorderWidth: 0.5,
        inputDecoratorFocusedBorderWidth: 2.0,
        fabUseShape: true,
        chipSchemeColor: SchemeColor.secondaryContainer,
        chipSelectedSchemeColor: SchemeColor.primaryContainer,
        chipFontSize: 12,
        chipIconSize: 16,
        chipPadding: EdgeInsetsDirectional.fromSTEB(4, 4, 4, 4),
        cardRadius: 12.0,
        cardElevation: 1.0,
        popupMenuRadius: 6.0,
        popupMenuElevation: 4.0,
        alignedDropdown: true,
        tooltipRadius: 6,
        tooltipSchemeColor: SchemeColor.surfaceContainerHigh,
        tooltipOpacity: 0.96,
        dialogBackgroundSchemeColor: SchemeColor.surfaceContainerHigh,
        dialogRadius: 12.0,
        snackBarRadius: 6,
        snackBarElevation: 6,
        snackBarBackgroundSchemeColor: SchemeColor.surfaceContainerLow,
        appBarBackgroundSchemeColor: SchemeColor.surfaceContainerLowest,
        appBarScrolledUnderElevation: 0.5,
        bottomAppBarHeight: 60,
        tabBarIndicatorWeight: 4,
        tabBarIndicatorTopRadius: 4,
        tabBarDividerColor: Color(0x00000000),
        drawerRadius: 0.0,
        drawerElevation: 2.0,
        drawerIndicatorOpacity: 0.5,
        bottomSheetBackgroundColor: SchemeColor.surfaceContainerHigh,
        bottomSheetModalBackgroundColor: SchemeColor.surfaceContainer,
        bottomSheetRadius: 12.0,
        bottomSheetElevation: 4.0,
        bottomSheetModalElevation: 6.0,
        bottomNavigationBarSelectedLabelSchemeColor: SchemeColor.primary,
        bottomNavigationBarMutedUnselectedLabel: true,
        bottomNavigationBarSelectedIconSchemeColor: SchemeColor.primary,
        bottomNavigationBarMutedUnselectedIcon: true,
        bottomNavigationBarBackgroundSchemeColor: SchemeColor.surfaceContainer,
        bottomNavigationBarElevation: 0.0,
        menuRadius: 6.0,
        menuElevation: 4.0,
        menuSchemeColor: SchemeColor.surfaceContainerLowest,
        menuPadding: EdgeInsetsDirectional.fromSTEB(6, 10, 5, 10),
        menuBarRadius: 0.0,
        menuBarElevation: 0.0,
        menuBarShadowColor: Color(0x00000000),
        menuIndicatorBackgroundSchemeColor: SchemeColor.surfaceContainerHigh,
        menuIndicatorRadius: 6.0,
        searchBarElevation: 0.0,
        searchViewElevation: 0.0,
        navigationBarIndicatorSchemeColor: SchemeColor.secondaryContainer,
        navigationBarBackgroundSchemeColor: SchemeColor.surfaceContainer,
        navigationBarElevation: 0.0,
        navigationBarHeight: 72.0,
        navigationRailUseIndicator: true,
        navigationRailIndicatorSchemeColor: SchemeColor.secondaryContainer,
        navigationRailIndicatorOpacity: 1.00,
        navigationRailBackgroundSchemeColor: SchemeColor.surfaceContainer,
      ),
      // ColorScheme seed generation configuration for light mode.
      keyColors: const FlexKeyColors(
        useSecondary: true,
        useTertiary: true,
        useError: true,
        keepPrimary: true,
        keepSecondary: true,
        keepError: true,
        keepTertiaryContainer: true,
      ),
      tones: FlexSchemeVariant.chroma
          .tones(Brightness.light)
          .higherContrastFixed()
          .monochromeSurfaces(),
      // Direct ThemeData properties.
      visualDensity: VisualDensity.compact,
      materialTapTargetSize: MaterialTapTargetSize.padded,
      cupertinoOverrideTheme: const CupertinoThemeData(applyThemeToAll: true),
      fontFamily: GoogleFonts.questrial().fontFamily,
    );
  }
});
