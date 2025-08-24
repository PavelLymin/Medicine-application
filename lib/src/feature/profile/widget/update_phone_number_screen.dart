import 'package:auto_route/auto_route.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:medicine_application/src/feature/authentication/state_manegament/auth_bloc/auth_bloc.dart';
import 'package:medicine_application/src/common/constant/config.dart';
import '../../../../ui/ui.dart';

class UpdatePhoneNumberScreen extends StatefulWidget {
  const UpdatePhoneNumberScreen({super.key});

  @override
  State<UpdatePhoneNumberScreen> createState() =>
      _UpdatePhoneNumberScreenState();
}

class _UpdatePhoneNumberScreenState extends State<UpdatePhoneNumberScreen>
    with _PhoneNumberFormStateMixin<UpdatePhoneNumberScreen> {
  final _phoneNumberController = TextEditingController();
  bool _isValidate = false;

  @override
  void initState() {
    super.initState();
    _phoneNumberController.addListener(() {
      setState(() {
        _isValidate = validate(_phoneNumberController.text);
      });
    });
  }

  @override
  void dispose() {
    _phoneNumberController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) =>
      BlocListener<AuthenticationBloc, AuthenticationState>(
        listener: (context, state) {
          state.mapOrNull(
            smsCodeSent: (state) =>
                context.router.replace(NamedRoute('SmsCodeScreen')),
          );
        },
        child: SafeArea(
          child: LayoutBuilder(
            builder: (context, constraints) => SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 64),
              child: Column(
                children: [
                  const SizedBox(height: 16),
                  BaseScroller(),
                  const SizedBox(height: 64),
                  TextPlaceholder(
                    controller: _phoneNumberController,
                    autofillHints: [AutofillHints.telephoneNumber],
                    labelText: 'Phone Number',
                    hintText: 'Enter your phone number',
                    icon: Icons.numbers,
                  ),
                  const SizedBox(height: 8),
                  BaseButton(
                    onPressed: () {
                      context.read<AuthenticationBloc>().add(
                        AuthenticationEvent.verifyPhoneNumber(
                          phoneNumber: _phoneNumberController.text,
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

mixin _PhoneNumberFormStateMixin<T extends StatefulWidget> on State<T> {
  String? _validatePhoneNumber(String phoneNumber) {
    RegExp regExp = Config.phoneNumberValidate;
    if (phoneNumber.isEmpty) {
      return 'Please enter mobile number';
    } else if (!regExp.hasMatch(phoneNumber)) {
      return 'Please enter valid mobile number';
    }
    return null;
  }

  String? _phoneNumberError;

  bool validate(String phoneNumber) {
    _phoneNumberError = _validatePhoneNumber(phoneNumber);
    return _phoneNumberError == null;
  }
}
