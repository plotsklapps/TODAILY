import 'package:flex_color_scheme/flex_color_scheme.dart';
import 'package:hive_ce/hive.dart';

part 'settings_model.g.dart';

@HiveType(typeId: 1)
class Settings extends HiveObject {
  @HiveField(0)
  final bool wakelock;

  @HiveField(1)
  final bool darkMode;

  @HiveField(2)
  final int flexSchemeIndex;

  @HiveField(3)
  final String font;

  Settings({
    required this.wakelock,
    required this.darkMode,
    required this.flexSchemeIndex,
    required this.font,
  });

  FlexScheme get flexScheme => FlexScheme.values[flexSchemeIndex];
}
