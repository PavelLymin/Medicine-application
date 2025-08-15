import 'package:flutter_bloc/flutter_bloc.dart';
import '../../cubit/validate_sms_code_cubit/validate_sms_code_cubit.dart';
import '../../ui.dart';

class SmsCodePlaceholder extends StatelessWidget {
  const SmsCodePlaceholder({
    super.key,
    required this.fieldOne,
    required this.fieldTwo,
    required this.fieldThree,
    required this.fieldFour,
  });
  final TextEditingController fieldOne;
  final TextEditingController fieldTwo;
  final TextEditingController fieldThree;
  final TextEditingController fieldFour;
  static final List<String> _smsCode = List.filled(4, '');

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        SmsCodeInput(controller: fieldOne, numberInput: 1),
        SmsCodeInput(controller: fieldTwo, numberInput: 2),
        SmsCodeInput(controller: fieldThree, numberInput: 3),
        SmsCodeInput(controller: fieldFour, numberInput: 4),
      ],
    );
  }
}

class SmsCodeInput extends StatefulWidget {
  const SmsCodeInput({
    this.autoFocus = false,
    required this.controller,
    required this.numberInput,
    super.key,
  });
  final bool autoFocus;
  final TextEditingController controller;
  final int numberInput;

  @override
  State<SmsCodeInput> createState() => _SmsCodeInputState();
}

class _SmsCodeInputState extends State<SmsCodeInput> {
  final FocusNode _focusNode = FocusNode();
  bool _hasFocus = false;
  bool _hasText = false;

  @override
  void initState() {
    super.initState();
    _focusNode.addListener(() {
      setState(() {
        _hasFocus = _focusNode.hasFocus;
      });
    });
    widget.controller.addListener(() {
      _hasText = widget.controller.text.isNotEmpty;
      SmsCodePlaceholder._smsCode[widget.numberInput - 1] =
          widget.controller.text;
      context.read<ValidateSmsCodeCubit>().validateSmsCode(
        smsCodeInput: SmsCodePlaceholder._smsCode.join(),
      );
    });
  }

  @override
  void dispose() {
    super.dispose();
    _focusNode.dispose();
  }

  @override
  Widget build(BuildContext context) => SizedBox(
    height: _hasFocus || _hasText ? 60 : 50,
    width: _hasFocus || _hasText ? 50 : 40,
    child: TextField(
      autofocus: widget.autoFocus,
      focusNode: _focusNode,
      textAlign: TextAlign.center,
      keyboardType: TextInputType.number,
      controller: widget.controller,
      maxLength: 1,
      decoration: InputDecoration(
        counterText: '',
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(
            color: _hasText ? AppColors.green : AppColors.grey,
          ),
          borderRadius: BorderRadius.circular(8),
        ),
      ),
      onChanged: (value) {
        setState(() {});
        if (value.length == 1 && widget.numberInput < 4) {
          FocusScope.of(context).nextFocus();
        }
        if (value.isEmpty && widget.numberInput > 1) {
          FocusScope.of(context).previousFocus();
        }
      },
    ),
  );
}
