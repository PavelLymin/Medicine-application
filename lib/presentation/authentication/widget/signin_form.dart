import 'package:medicine_application/common/extencions/build_context.dart';
import 'package:medicine_application/common/ui.dart';

class SignInForm extends StatefulWidget {
  const SignInForm({
    required FocusNode emailFocusNode,
    required FocusNode passwordFocusNode,
    required TextEditingController emailController,
    required TextEditingController passwordController,
    required this.constraints,
    super.key,
  }) : _emailFocusNode = emailFocusNode,
       _passwordFocusNode = passwordFocusNode,
       _emailController = emailController,
       _passwordController = passwordController;

  final FocusNode _emailFocusNode;
  final FocusNode _passwordFocusNode;
  final TextEditingController _emailController;
  final TextEditingController _passwordController;
  final BoxConstraints constraints;

  @override
  State<SignInForm> createState() => _SignInFormState();
}

class _SignInFormState extends State<SignInForm> {
  bool _obscureText = true;

  @override
  Widget build(BuildContext context) => Column(
    crossAxisAlignment: CrossAxisAlignment.center,
    children: [
      const SizedBox(height: 16),
      Text('Start using My App today', style: context.themeText.titleLarge!),
      Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          const SizedBox(height: 32),
          TextPlaceholder(
            focusNode: widget._emailFocusNode,
            controller: widget._emailController,
            onChanged: (_) {},
            autofillHints: [AutofillHints.email],
            labelText: 'E-mail',
            hintText: 'Enter your e-mail',
            icon: Icons.email_outlined,
            suffixIcon: widget._emailController.text.isEmpty
                ? null
                : IconButton(
                    icon: const Icon(Icons.clear),
                    onPressed: () {
                      widget._emailController.clear();
                      setState(() {});
                    },
                  ),
          ),
          TextPlaceholder(
            focusNode: widget._passwordFocusNode,
            controller: widget._passwordController,
            onChanged: (_) {},
            autofillHints: [AutofillHints.password],
            labelText: 'Password',
            hintText: 'Enter your password',
            icon: Icons.password_outlined,
            obscureText: _obscureText,
            suffixIcon: IconButton(
              icon: _obscureText
                  ? const Icon(Icons.visibility_off)
                  : const Icon(Icons.visibility),
              onPressed: () {
                setState(() {
                  _obscureText = !_obscureText;
                });
              },
            ),
          ),
          GestureDetector(
            onTap: () {},
            child: Text(
              'Forgot Password?',
              style: context.themeText.bodyMedium!.copyWith(
                color: AppColors.green,
              ),
            ),
          ),
          const SizedBox(height: 16),
        ],
      ),
    ],
  );
}
