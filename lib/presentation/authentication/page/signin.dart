import 'package:auto_route/auto_route.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:medicine_application/common/bloc/auth_bloc/auth_bloc.dart';
import 'package:medicine_application/common/constant/config.dart';
import 'package:medicine_application/presentation/authentication/widget/auth_agreement.dart';
import 'package:medicine_application/presentation/authentication/widget/auth_with_social.dart';
import 'package:medicine_application/presentation/authentication/widget/signin_form.dart';
import '../../../common/ui.dart';

@RoutePage()
class SignIn extends StatefulWidget {
  const SignIn({super.key});

  @override
  State<SignIn> createState() => _SignInState();
}

class _SignInState extends State<SignIn>
    with _UsernamePasswordFormStateMixin<SignIn> {
  final _emailFocusNode = FocusNode();
  final _passwordFocusNode = FocusNode();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _firstAgreement = false;
  bool _secondAgreement = false;
  bool _isEnable = false;

  @override
  void initState() {
    super.initState();
    _emailController.addListener(
      () =>
          _isEnable = validate(_emailController.text, _passwordController.text),
    );
    _passwordController.addListener(
      () =>
          _isEnable = validate(_emailController.text, _passwordController.text),
    );
  }

  @override
  void dispose() {
    super.dispose();
    _emailFocusNode.dispose();
    _passwordFocusNode.dispose();
    _emailController.dispose();
    _passwordController.dispose();
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    body: BlocListener<AuthenticationBloc, AuthenticationState>(
      listener: (context, state) {
        state.mapOrNull(
          authenticated: (_) =>
              context.router.replace(NamedRoute('HomeScreen')),
          error: (error) => ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text(error.message))),
        );
      },
      child: SafeArea(
        child: Center(
          child: LayoutBuilder(
            builder: (context, constraints) => SingleChildScrollView(
              child: switch (constraints.maxWidth) {
                final width when width < 656 => Padding(
                  padding: EdgeInsets.only(
                    left: constraints.maxWidth > 528
                        ? (constraints.maxWidth - (400 + 64))
                        : 64,
                    right: 64,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      SignInForm(
                        emailFocusNode: _emailFocusNode,
                        passwordFocusNode: _passwordFocusNode,
                        emailController: _emailController,
                        passwordController: _passwordController,
                        constraints: constraints,
                      ),
                      AuthAgreement(
                        firstAgreement: _firstAgreement,
                        secondAgreement: _secondAgreement,
                        onChangedFirst: (value) {
                          setState(() {
                            _firstAgreement = value!;
                          });
                        },
                        onChangedSecond: (value) {
                          setState(() {
                            _secondAgreement = value!;
                          });
                        },
                      ),
                      const SizedBox(height: 32),
                      BaseButton(
                        onPressed: () {
                          signIn(
                            _emailController.text,
                            _passwordController.text,
                          );
                        },
                        isEnable:
                            _isEnable && _firstAgreement && _secondAgreement,
                        widget:
                            BlocBuilder<
                              AuthenticationBloc,
                              AuthenticationState
                            >(
                              builder: (context, state) {
                                return state.maybeMap(
                                  orElse: () => Text('Continue'),
                                  loading: (_) => const Center(
                                    child: CircularProgressIndicator(),
                                  ),
                                );
                              },
                            ),
                      ),
                      const SizedBox(height: 32),
                      const AuthWithSocial(),
                    ],
                  ),
                ),
                _ => Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: (constraints.maxWidth - 656) / 2,
                      ),
                      child: const Image(
                        image: AssetImage('assets/icons/microsoft.png'),
                      ),
                    ),
                    Flexible(
                      child: Padding(
                        padding: EdgeInsets.symmetric(horizontal: 64),
                        child: Column(
                          children: [
                            SignInForm(
                              emailFocusNode: _emailFocusNode,
                              passwordFocusNode: _passwordFocusNode,
                              emailController: _emailController,
                              passwordController: _passwordController,
                              constraints: constraints,
                            ),
                            AuthAgreement(
                              firstAgreement: _firstAgreement,
                              secondAgreement: _secondAgreement,
                              onChangedFirst: (value) {
                                setState(() {
                                  _firstAgreement = value!;
                                });
                              },
                              onChangedSecond: (value) {
                                setState(() {
                                  _secondAgreement = value!;
                                });
                              },
                            ),
                            const SizedBox(height: 32),
                            BaseButton(
                              onPressed: () {
                                signIn(
                                  _emailController.text,
                                  _passwordController.text,
                                );
                              },
                              isEnable:
                                  _isEnable &&
                                  _firstAgreement &&
                                  _secondAgreement,
                              widget:
                                  BlocBuilder<
                                    AuthenticationBloc,
                                    AuthenticationState
                                  >(
                                    builder: (context, state) {
                                      return state.isLoading
                                          ? const Center(
                                              child:
                                                  CircularProgressIndicator(),
                                            )
                                          : const Text('Continue');
                                    },
                                  ),
                            ),
                            const SizedBox(height: 32),
                            const AuthWithSocial(),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              },
            ),
          ),
        ),
      ),
    ),
  );
}

mixin _UsernamePasswordFormStateMixin<T extends StatefulWidget> on State<T> {
  bool isValidate = false;

  static String? _usernameValidator(String username) {
    if (username.isEmpty) return 'Username is required.';

    if (!Config.emailValidate.hasMatch(username)) {
      return 'Must be a valid email.';
    }
    return null;
  }

  static String? _passwordValidator(String password) {
    const passwordMinLength = Config.passwordMinLength,
        passwordMaxLength = Config.passwordMaxLength;
    final length = switch (password.length) {
      0 => 'Password is required.',
      < passwordMinLength => 'Password must be 8 characters or more.',
      > passwordMaxLength => 'Password must be 32 characters or less.',
      _ => null,
    };
    if (length != null) return length;
    if (!password.contains(RegExp('[A-Z]'))) {
      return 'Password must have at least one uppercase character.';
    }
    if (!password.contains(RegExp('[a-z]'))) {
      return 'Password must have at least one lowercase character.';
    }
    return null;
  }

  // ignore: unused_field
  String? _usernameError, _passwordError;

  bool validate(String username, String password) {
    _usernameError = _usernameValidator(username);
    _passwordError = _passwordValidator(password);
    return _usernameError == null && _usernameError == null;
  }

  void signIn(String email, String password) {
    context.read<AuthenticationBloc>().add(
      AuthenticationEvent.signInWithEmailAndPassword(
        email: email,
        password: password,
      ),
    );
  }
}
