import '../../../ui.dart';

class TextPlaceholder extends StatelessWidget {
  const TextPlaceholder({
    required this.controller,
    required this.autofillHints,
    required this.labelText,
    required this.hintText,
    required this.icon,
    this.width = double.infinity,
    this.height = 28,
    this.enabled = true,
    this.textInputType = TextInputType.text,
    this.obscureText = false,
    this.focusNode,
    this.onChanged,
    this.suffixIcon,
    super.key,
  });

  final FocusNode? focusNode;
  final TextEditingController controller;
  final Function(String text)? onChanged;
  final List<String> autofillHints;
  final String labelText;
  final String hintText;
  final IconData icon;
  final double width;
  final double height;
  final bool enabled;
  final TextInputType textInputType;
  final bool obscureText;
  final Widget? suffixIcon;

  @override
  Widget build(BuildContext context) => TextField(
    onChanged: onChanged,
    focusNode: focusNode,
    enabled: enabled,
    maxLines: 1,
    minLines: 1,
    controller: controller,
    autocorrect: false,
    autofillHints: autofillHints,
    keyboardType: textInputType,
    obscureText: obscureText,
    // inputFormatters: _usernameFormatters,
    decoration: InputDecoration(
      labelText: labelText,
      hintText: hintText,
      helperText: '',
      helperMaxLines: 1,
      prefixIcon: Icon(icon),
      // errorText: _usernameError ?? state.error,
      errorMaxLines: 1,
      suffixIcon: suffixIcon,
    ),
  );
}
