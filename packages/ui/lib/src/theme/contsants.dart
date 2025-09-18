part of 'theme.dart';

const labelLarge = TextStyle(
  fontWeight: FontWeight.w600,
  fontSize: 32,
  color: AppColors.darkGrey,
);

const labelMedium = TextStyle(
  fontWeight: FontWeight.w500,
  fontSize: 20,
  color: AppColors.darkGrey,
);

const labelSmall = TextStyle(
  fontWeight: FontWeight.w400,
  fontSize: 16,
  color: AppColors.grey,
);

const titleLarge = TextStyle(
  fontWeight: FontWeight.w500,
  fontSize: 24,
  color: AppColors.darkGrey,
);

const titleMedium = TextStyle(
  fontWeight: FontWeight.w400,
  fontSize: 22,
  color: AppColors.darkGrey,
);

const bodyLarge = TextStyle(
  fontWeight: FontWeight.w400,
  fontSize: 18,
  color: AppColors.darkGrey,
);

const bodyMedium = TextStyle(
  fontWeight: FontWeight.w400,
  fontSize: 16,
  color: AppColors.darkGrey,
);

const bodySmall = TextStyle(
  fontWeight: FontWeight.w400,
  fontSize: 12,
  color: AppColors.darkGrey,
);

abstract class AppColors {
  static const white = Colors.white;
  static const black = Colors.black;
  static const red = Colors.red;
  static const lightgrey = Color(0xFFebebeb);
  static const grey = Color(0xFF989898);
  static const darkGrey = Color(0xFF434343);
  static const green = Color(0xFF26d367);
  static const containerColorLight = Color(0xFFB7E4F4);
  static const containerColorDark = Color(0xFF1C282C);
  static const transparent = Colors.transparent;
}
