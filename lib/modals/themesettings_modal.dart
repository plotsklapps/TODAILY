import 'package:flex_color_scheme/flex_color_scheme.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:signals/signals_flutter.dart';
import 'package:todaily/services/settings_service.dart';
import 'package:todaily/themes/flexscheme.dart';
import 'package:todaily/themes/iconlibrary.dart';

class ThemeSettingsModal extends StatelessWidget {
  const ThemeSettingsModal({super.key});

  @override
  Widget build(BuildContext context) {
    // Watch settings Signals.
    final bool isDarkMode = sDarkMode.watch(context);
    final bool isWakelock = sWakelock.watch(context);
    final FlexScheme flexScheme = sFlexScheme.watch(context);
    final String font = sFont.watch(context);

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        // Scrollable Body.
        SwitchListTile(
          title: isWakelock
              ? const Text('Keep screen on')
              : const Text('Use screensaver'),
          subtitle: isWakelock
              ? const Text('Prevent screen from turning off')
              : const Text('Screen will automatically turn off'),
          secondary: isWakelock ? IconLibrary.iconLight : IconLibrary.iconDark,
          value: isWakelock,
          onChanged: (bool value) async {
            await settingsService.toggleWakelock(value: value);
          },
        ),

        // ThemeMode ListTile.
        SwitchListTile(
          title: isDarkMode
              ? const Text('Use dark mode')
              : const Text('Use light mode'),
          subtitle: isDarkMode
              ? const Text('Dark theme for all screens')
              : const Text('Light theme for all screens'),
          secondary: isDarkMode ? IconLibrary.iconMoon : IconLibrary.iconSun,

          value: isDarkMode,
          onChanged: (bool value) async {
            await settingsService.toggleThemeMode(value: value);
          },
        ),

        const Divider(),
        // Color picker for non-supporters.
        Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 8,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              SizedBox(
                width: double.infinity,
                child: SegmentedButton<FlexScheme>(
                  segments: <ButtonSegment<FlexScheme>>[
                    ButtonSegment<FlexScheme>(
                      value: FlexScheme.shark,
                      label: const Text('Orange'),
                      icon: IconLibrary.iconOrange,
                    ),
                    ButtonSegment<FlexScheme>(
                      value: FlexScheme.greyLaw,
                      label: const Text('Purple'),
                      icon: IconLibrary.iconPurple,
                    ),
                    ButtonSegment<FlexScheme>(
                      value: FlexScheme.sanJuanBlue,
                      label: const Text('Pink'),
                      icon: IconLibrary.iconPink,
                    ),
                  ],
                  selected: <FlexScheme>{flexScheme},
                  onSelectionChanged: (Set<FlexScheme> newSelection) async {
                    await settingsService.updateFlexScheme(
                      newSelection.first,
                    );
                  },
                ),
              ),
            ],
          ),
        ),

        // Font Picker for non-supporters.
        Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 8,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              SizedBox(
                width: double.infinity,
                child: SegmentedButton<String>(
                  segments: <ButtonSegment<String>>[
                    ButtonSegment<String>(
                      value: 'Questrial',
                      label: const Text('Questrial'),
                      icon: IconLibrary.iconFont,
                    ),
                    ButtonSegment<String>(
                      value: 'Cause',
                      label: Text(
                        'Cause',
                        style: TextStyle(
                          fontFamily: GoogleFonts.cause().fontFamily,
                        ),
                      ),
                      icon: IconLibrary.iconFont,
                    ),
                    ButtonSegment<String>(
                      value: 'Nunito',
                      label: Text(
                        'Nunito',
                        style: TextStyle(
                          fontFamily: GoogleFonts.nunito().fontFamily,
                        ),
                      ),
                      icon: IconLibrary.iconFont,
                    ),
                  ],
                  selected: <String>{font},
                  onSelectionChanged: (Set<String> newSelection) async {
                    await settingsService.updateFont(
                      newSelection.first,
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
