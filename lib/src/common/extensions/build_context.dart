import '../../../ui/ui.dart';

extension BuildContextExt on BuildContext {
  BuildContextExtention get extentions => BuildContextExtention(
    themeColors: Theme.of(this).extension<ThemeColors>()!,
    themeDecorationInput: Theme.of(this).extension<ThemeDecorationInput>()!,
    themeText: Theme.of(this).textTheme,
  );
}

class BuildContextExtention {
  BuildContextExtention({
    required this.themeColors,
    required this.themeDecorationInput,
    required this.themeText,
  });

  final ThemeColors themeColors;
  final ThemeDecorationInput themeDecorationInput;
  final TextTheme themeText;
}
