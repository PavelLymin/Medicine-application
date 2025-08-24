part of 'theme.dart';

class ThemeColors extends ThemeExtension<ThemeColors> {
  const ThemeColors({
    required this.borderInputTextColor,
    required this.containerChatsColor,
    required this.disableButtonColor,
    required this.disableTextColor,
    required this.buttonSocialColor,
  });

  final Color borderInputTextColor;
  final Color containerChatsColor;
  final Color disableButtonColor;
  final Color disableTextColor;
  final Color buttonSocialColor;

  @override
  ThemeExtension<ThemeColors> copyWith({
    Color? borderInputTextColor,
    Color? containerChatsColor,
    Color? disableButtonColor,
    Color? disableTextColor,
    Color? buttonSocialColor,
  }) => ThemeColors(
    borderInputTextColor: borderInputTextColor ?? this.borderInputTextColor,
    containerChatsColor: containerChatsColor ?? this.containerChatsColor,
    disableButtonColor: disableButtonColor ?? this.disableButtonColor,
    disableTextColor: disableTextColor ?? this.disableTextColor,
    buttonSocialColor: buttonSocialColor ?? this.buttonSocialColor,
  );

  @override
  ThemeExtension<ThemeColors> lerp(
    covariant ThemeExtension<ThemeColors>? other,
    double t,
  ) {
    if (other is! ThemeColors) return this;

    return ThemeColors(
      borderInputTextColor: Color.lerp(
        borderInputTextColor,
        other.borderInputTextColor,
        t,
      )!,
      containerChatsColor: Color.lerp(
        containerChatsColor,
        other.containerChatsColor,
        t,
      )!,
      disableButtonColor: Color.lerp(
        disableButtonColor,
        other.disableButtonColor,
        t,
      )!,
      disableTextColor: Color.lerp(
        disableTextColor,
        other.disableTextColor,
        t,
      )!,
      buttonSocialColor: Color.lerp(
        buttonSocialColor,
        other.buttonSocialColor,
        t,
      )!,
    );
  }

  static ThemeColors get light => ThemeColors(
    borderInputTextColor: AppColors.white,
    containerChatsColor: AppColors.containerColorLight,
    disableButtonColor: AppColors.grey,
    disableTextColor: AppColors.darkGrey,
    buttonSocialColor: AppColors.white,
  );

  static ThemeColors get dark => ThemeColors(
    borderInputTextColor: AppColors.black,
    containerChatsColor: AppColors.containerColorDark,
    disableButtonColor: AppColors.grey,
    disableTextColor: AppColors.darkGrey,
    buttonSocialColor: AppColors.white,
  );
}
