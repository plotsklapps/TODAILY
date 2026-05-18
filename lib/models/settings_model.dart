import 'package:flex_color_scheme/flex_color_scheme.dart';
import 'package:hive_ce/hive.dart';
import 'package:todaily/services/toast_service.dart';

part 'settings_model.g.dart';

@HiveType(typeId: 1)
class Settings extends HiveObject {
  Settings({
    required this.wakelock,
    required this.darkMode,
    required this.flexSchemeName,
    required this.font,
  });
  @HiveField(0, defaultValue: false)
  final bool wakelock;

  @HiveField(1, defaultValue: false)
  final bool darkMode;

  @HiveField(2, defaultValue: '')
  final String flexSchemeName;

  @HiveField(3, defaultValue: 'Questrial')
  final String font;

  FlexScheme get flexScheme {
    try {
      return FlexScheme.values.byName(flexSchemeName);
    } on Exception catch (e) {
      ToastService.showError(
        title: 'FlexScheme Not Found',
        subtitle: '$e',
      );
      return FlexScheme.material;
    }
  }
}
