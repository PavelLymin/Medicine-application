import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:medicine_application/ui/ui.dart';
import '../state_management/validate_sms_code_cubit/validate_sms_code_cubit.dart';

class SmsCodeScreen extends StatefulWidget {
  const SmsCodeScreen({super.key});

  @override
  State<SmsCodeScreen> createState() => _SmsCodeScreenState();
}

class _SmsCodeScreenState extends State<SmsCodeScreen> {
  final _fieldOneController = TextEditingController();
  final _fieldTwoController = TextEditingController();
  final _fieldThreeController = TextEditingController();
  final _fieldFourController = TextEditingController();

  late ValidateSmsCodeCubit _bloc;

  @override
  void initState() {
    super.initState();
    _bloc = ValidateSmsCodeCubit();
  }

  @override
  void dispose() {
    super.dispose();
    _fieldOneController.dispose();
    _fieldTwoController.dispose();
    _fieldThreeController.dispose();
    _fieldFourController.dispose();
  }

  @override
  Widget build(BuildContext context) => BlocProvider(
    create: (context) => _bloc,
    child: Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 64),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SmsCodePlaceholder(
              fieldOne: _fieldOneController,
              fieldTwo: _fieldTwoController,
              fieldThree: _fieldThreeController,
              fieldFour: _fieldFourController,
            ),
            const SizedBox(height: 32),
            BlocBuilder<ValidateSmsCodeCubit, ValidateSmsCodeState>(
              builder: (context, state) {
                return BaseButton(
                  onPressed: () {},
                  isEnable: state.isValidate,
                  widget: const Text('Continue'),
                );
              },
            ),
          ],
        ),
      ),
    ),
  );
}
