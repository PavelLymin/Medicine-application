part of 'theme.dart';

ThemeData createDarkTheme() {
  return ThemeData(
    useMaterial3: true,
    brightness: Brightness.dark,
    scaffoldBackgroundColor: AppColors.black,
    hintColor: AppColors.white,
    textTheme: createTextTheme(),
    appBarTheme: AppBarTheme(
      backgroundColor: AppColors.black,
      titleTextStyle: GoogleFonts.oswald(textStyle: labelLarge),
    ),
    progressIndicatorTheme: ProgressIndicatorThemeData(color: AppColors.white),
    switchTheme: SwitchThemeData(
      thumbColor: WidgetStatePropertyAll(AppColors.black),
      trackColor: WidgetStatePropertyAll(AppColors.white),
      trackOutlineColor: WidgetStatePropertyAll(AppColors.white),
    ),
    checkboxTheme: CheckboxThemeData(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
      fillColor: WidgetStateProperty.resolveWith<Color>((state) {
        return state.contains(WidgetState.selected)
            ? AppColors.green
            : AppColors.white;
      }),
      checkColor: WidgetStateProperty.resolveWith<Color>((state) {
        return state.contains(WidgetState.selected)
            ? AppColors.white
            : AppColors.green;
      }),
      side: WidgetStateBorderSide.resolveWith(
        (states) => BorderSide(width: 1, color: AppColors.green),
      ),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ButtonStyle(
        textStyle: WidgetStatePropertyAll<TextStyle>(
          GoogleFonts.oswald(textStyle: labelMedium),
        ),
        shape: WidgetStatePropertyAll<OutlinedBorder>(
          RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        ),
        backgroundColor: WidgetStatePropertyAll(AppColors.green),
        foregroundColor: WidgetStatePropertyAll(AppColors.white),
      ),
    ),
    inputDecorationTheme: createInputTheme(AppColors.darkGrey),
    extensions: [ThemeColors.light, ThemeDecorationInput.dark],
  );
}
