import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:medicine_application/src/common/constant/config.dart';
import 'package:ui/ui.dart';
import '../../../../ui/ui.dart';
import '../state_management/bloc/verification_phone_bloc.dart';

class UpdatePhoneNumberScreen extends StatefulWidget {
  const UpdatePhoneNumberScreen({super.key});

  @override
  State<UpdatePhoneNumberScreen> createState() =>
      _UpdatePhoneNumberScreenState();
}

class _UpdatePhoneNumberScreenState extends State<UpdatePhoneNumberScreen>
    with _PhoneNumberFormStateMixin {
  final _phoneNumberController = TextEditingController();

  @override
  void initState() {
    super.initState();
    validate(_phoneNumberController);
  }

  @override
  void dispose() {
    _phoneNumberController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => SafeArea(
    child: SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 64),
      child: Column(
        children: [
          const SizedBox(height: 16),
          const BaseScroller(),
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
              context.read<VerificationPhoneBloc>().add(
                VerificationPhoneEvent.verifyPhoneNumber(
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
  );
}

mixin _PhoneNumberFormStateMixin on State<UpdatePhoneNumberScreen> {
  String? _phoneNumberError;

  bool _isValidate = false;

  String? _validatePhoneNumber(String phoneNumber) {
    RegExp regExp = Config.phoneNumberValidate;
    if (phoneNumber.isEmpty) {
      return 'Please enter mobile number';
    } else if (!regExp.hasMatch(phoneNumber)) {
      return 'Please enter valid mobile number';
    }

    return null;
  }

  bool validate(TextEditingController controller) {
    controller.addListener(() {
      setState(() {
        _phoneNumberError = _validatePhoneNumber(controller.text);
        _isValidate = _phoneNumberError == null;
      });
    });

    return _isValidate;
  }
}
