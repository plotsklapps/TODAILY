import 'package:flex_color_scheme/flex_color_scheme.dart';
import 'package:hive_ce/hive.dart';
import 'package:todaily/models/settings_model.dart';
import 'package:todaily/themes/flexscheme.dart';
import 'package:wakelock_plus/wakelock_plus.dart';

class SettingsService {
  late Box<Settings> _settingsBox;

  Future<void> init() async {
    _settingsBox = await Hive.openBox<Settings>('settingsBox');

    final Settings? settings = _settingsBox.get('settings');

    if (settings != null) {
      sWakelock.value = settings.wakelock;
      sDarkMode.value = settings.darkMode;
      sFlexScheme.value = settings.flexScheme;
      sFont.value = settings.font;
    } else {
      // Set defaults
      sWakelock.value = true;
      sDarkMode.value = false;
      sFlexScheme.value = FlexScheme.material;
      sFont.value = 'Roboto';
    }

    // Apply initial wakelock
    if (sWakelock.value) {
      await WakelockPlus.enable();
    } else {
      await WakelockPlus.disable();
    }
  }

  Future<void> _saveSettings() async {
    final Settings settings = Settings(
      wakelock: sWakelock.value,
      darkMode: sDarkMode.value,
      flexSchemeIndex: sFlexScheme.value.index,
      font: sFont.value,
    );
    await _settingsBox.put('settings', settings);
  }

  Future<void> toggleWakelock({required bool value}) async {
    if (value) {
      await WakelockPlus.enable();
    } else {
      await WakelockPlus.disable();
    }
    sWakelock.value = value;
    await _saveSettings();
  }

  Future<void> toggleThemeMode({required bool value}) async {
    sDarkMode.value = value;
    await _saveSettings();
  }

  Future<void> updateFlexScheme(FlexScheme scheme) async {
    sFlexScheme.value = scheme;
    await _saveSettings();
  }

  Future<void> updateFont(String font) async {
    sFont.value = font;
    await _saveSettings();
  }
}

final SettingsService settingsService = SettingsService();
