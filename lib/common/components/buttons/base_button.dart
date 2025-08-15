import 'package:medicine_application/common/extencions/build_context.dart';
import '../../../common/ui.dart';

class BaseButton extends StatelessWidget {
  const BaseButton({
    required this.onPressed,
    required this.isEnable,
    required this.widget,
    super.key,
  });
  final void Function()? onPressed;
  final bool isEnable;
  final Widget widget;

  @override
  Widget build(BuildContext context) => ElevatedButton(
    onPressed: !isEnable ? null : onPressed,
    style: ButtonStyle(
      foregroundColor: !isEnable
          ? WidgetStatePropertyAll<Color>(context.color.disableTextColor)
          : null,
      textStyle: WidgetStatePropertyAll<TextStyle>(
        context.themeText.bodyMedium!.copyWith(
          color: AppColors.darkGrey,
          fontWeight: FontWeight.w600,
        ),
      ),
      fixedSize: WidgetStatePropertyAll<Size>(Size(double.maxFinite, 60)),
      backgroundColor: !isEnable
          ? WidgetStatePropertyAll<Color>(context.color.disableButtonColor)
          : null,
    ),
    child: widget,
  );
}
