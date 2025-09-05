import 'package:google_fonts/google_fonts.dart';
import '../../ui.dart';
part 'contsants.dart';
part 'dark_theme.dart';
part 'light_theme.dart';
part 'text_theme.dart';
part 'theme_extension.dart';

InputDecorationTheme createInputTheme(Color fillColor) => InputDecorationTheme(
  filled: true,
  fillColor: fillColor,
  contentPadding: const EdgeInsets.only(left: 16),
  labelStyle: bodyLarge,
  enabledBorder: OutlineInputBorder(
    borderSide: const BorderSide(color: AppColors.green),
    borderRadius: BorderRadius.circular(8),
  ),
  focusedBorder: OutlineInputBorder(
    borderSide: const BorderSide(color: AppColors.green),
    borderRadius: BorderRadius.circular(8),
  ),
  errorBorder: OutlineInputBorder(
    borderSide: const BorderSide(color: AppColors.red),
    borderRadius: BorderRadius.circular(8),
  ),
  focusedErrorBorder: OutlineInputBorder(
    borderSide: const BorderSide(color: AppColors.red),
    borderRadius: BorderRadius.circular(8),
  ),
);
