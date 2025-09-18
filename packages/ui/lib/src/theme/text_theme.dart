part of 'theme.dart';

TextTheme createTextTheme() {
  return GoogleFonts.latoTextTheme().copyWith(
    titleLarge: GoogleFonts.oswald(textStyle: titleLarge),
    titleMedium: GoogleFonts.oswald(textStyle: titleMedium),
    bodyLarge: GoogleFonts.oswald(textStyle: bodyLarge),
    bodyMedium: GoogleFonts.oswald(textStyle: bodyMedium),
    bodySmall: GoogleFonts.lato(textStyle: bodySmall),
    labelLarge: GoogleFonts.lato(textStyle: labelLarge),
    labelMedium: GoogleFonts.lato(textStyle: labelMedium),
    labelSmall: GoogleFonts.lato(textStyle: labelSmall),
  );
}
