import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:medicine_application/src/feature/authentication/state_manegament/auth_bloc/auth_bloc.dart';
import 'package:medicine_application/src/common/constant/config.dart';
import '../../../../ui/ui.dart';

class UpdateEmailScreen extends StatefulWidget {
  const UpdateEmailScreen({super.key});

  @override
  State<UpdateEmailScreen> createState() => _UpdateEmailScreenState();
}

class _UpdateEmailScreenState extends State<UpdateEmailScreen>
    with _EmailFormStateMixin<UpdateEmailScreen> {
  final _emailController = TextEditingController();
  bool _isValidate = false;

  @override
  void initState() {
    super.initState();
    _emailController.addListener(() {
      setState(() {
        _isValidate = validate(_emailController.text);
      });
    });
  }

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) =>
      BlocListener<AuthenticationBloc, AuthenticationState>(
        listener: (context, state) {
          state.mapOrNull();
        },
        child: SafeArea(
          child: LayoutBuilder(
            builder: (context, constraints) => SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 64),
              child: Column(
                children: [
                  const SizedBox(height: 16),
                  const BaseScroller(),
                  const SizedBox(height: 64),
                  TextPlaceholder(
                    controller: _emailController,
                    onChanged: (text) {},
                    autofillHints: [AutofillHints.email],
                    labelText: 'Email',
                    hintText: 'Enter your email',
                    icon: Icons.numbers,
                  ),
                  const SizedBox(height: 8),
                  BaseButton(
                    onPressed: () {
                      context.read<AuthenticationBloc>().add(
                        AuthenticationEvent.updateEmail(
                          email: _emailController.text,
                        ),
                      );
                    },
                    isEnable: _isValidate,
                    widget: const Text('Continue'),
                  ),
                  const SizedBox(height: 32),
                ],
              ),
            ),
          ),
        ),
      );
}

mixin _EmailFormStateMixin<T extends StatefulWidget> on State<T> {
  String? _validateEmail(String email) {
    if (email.isEmpty) {
      return 'Please enter mobile number';
    } else if (!Config.emailValidate.hasMatch(email)) {
      return 'Please enter valid email';
    }
    return null;
  }

  String? _emailError;

  bool validate(String email) {
    _emailError = _validateEmail(email);
    return _emailError == null;
  }
}
