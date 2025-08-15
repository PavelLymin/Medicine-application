import '../ui.dart';

extension BuildContextExt on BuildContext {
  ThemeColors get color => Theme.of(this).extension<ThemeColors>()!;
  TextTheme get themeText => Theme.of(this).textTheme;
}
