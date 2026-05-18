import 'package:flex_color_scheme/flex_color_scheme.dart';
import 'package:todaily/themes/flexscheme.dart';
import 'package:wakelock_plus/wakelock_plus.dart';

class SettingsService {
  Future<void> toggleWakelock({required bool value}) async {
    if (value) {
      await WakelockPlus.enable();
    } else {
      await WakelockPlus.disable();
    }
    sWakelock.value = value;
  }

  Future<void> toggleThemeMode({required bool value}) async {
    sDarkMode.value = value;
  }

  Future<void> updateFlexScheme(FlexScheme scheme) async {
    sFlexScheme.value = scheme;
  }

  Future<void> updateFont(String font) async {
    sFont.value = font;
  }
}

final SettingsService settingsService = SettingsService();
