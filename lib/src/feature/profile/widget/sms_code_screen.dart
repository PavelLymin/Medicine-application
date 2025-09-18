import 'dart:async';
import 'package:auto_route/auto_route.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ui/ui.dart';
import '../../../common/scopes/dependencies_scope.dart';
import '../state_management/bloc/verification_phone_bloc.dart';

class SmsCodeScreen extends StatefulWidget {
  const SmsCodeScreen({super.key});

  @override
  State<SmsCodeScreen> createState() => _SmsCodeScreenState();
}

class _SmsCodeScreenState extends State<SmsCodeScreen> {
  bool _isEnable = false;
  late VerificationPhoneBloc _verificationPhoneBloc;
  StreamSubscription? _streamSubscription;

  @override
  void initState() {
    _verificationPhoneBloc = DependeciesScope.of(context).verificationPhoneBloc;
    _streamSubscription = PinScope.of(context).pin.isValidate.listen((data) {
      setState(() {
        _isEnable = data;
      });
    });
    super.initState();
  }

  @override
  void dispose() {
    _streamSubscription?.cancel();
    _streamSubscription = null;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => BlocProvider.value(
    value: _verificationPhoneBloc,
    child: BlocListener<VerificationPhoneBloc, VerificationPhoneState>(
      listener: (context, state) {
        state.mapOrNull(
          success: (state) => context.router.replace(NamedRoute("Profile")),
        );
      },
      child: Scaffold(
        appBar: AppBar(title: const Text('SMS code')),
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Pin(), // Виджет с полями ввода
              const SizedBox(height: 32),
              Builder(
                builder: (context) {
                  return BaseButton(
                    onPressed: () =>
                        context.read<VerificationPhoneBloc>().state.mapOrNull(
                          smsCodeSent: (state) => _verificationPhoneBloc.add(
                            VerificationPhoneEvent.updatePhoneNumber(
                              verificationId: state.verificationId,
                              smsCode: PinScope.of(context).pin.pinCode,
                            ),
                          ),
                        ),
                    isEnable: _isEnable,
                    widget: const Text('Continue'),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    ),
  );
}
