part of 'theme.dart';

ThemeData createLightTheme() {
  return ThemeData(
    brightness: Brightness.light,
    scaffoldBackgroundColor: AppColors.white,
    hintColor: AppColors.white,
    textTheme: createTextTheme(),
    appBarTheme: AppBarTheme(backgroundColor: AppColors.white),
    primaryColor: AppColors.white,
    progressIndicatorTheme: ProgressIndicatorThemeData(color: AppColors.white),
    textSelectionTheme: TextSelectionThemeData(cursorColor: AppColors.darkGrey),
    switchTheme: SwitchThemeData(
      thumbColor: WidgetStatePropertyAll<Color>(AppColors.white),
      trackColor: WidgetStatePropertyAll<Color>(AppColors.black),
      trackOutlineColor: WidgetStatePropertyAll(AppColors.black),
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
        elevation: WidgetStatePropertyAll(0),
        shadowColor: WidgetStatePropertyAll<Color>(AppColors.transparent),
        shape: WidgetStatePropertyAll<OutlinedBorder>(
          RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        ),
        backgroundColor: WidgetStatePropertyAll<Color>(AppColors.green),
        foregroundColor: WidgetStatePropertyAll<Color>(AppColors.white),
      ),
    ),
    inputDecorationTheme: createInputTheme(),
    extensions: [ThemeColors.light],
  );
}
