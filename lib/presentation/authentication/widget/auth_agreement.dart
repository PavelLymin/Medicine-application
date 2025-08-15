import 'package:flutter/material.dart';
import 'package:medicine_application/common/extencions/build_context.dart';

class AuthAgreement extends StatelessWidget {
  const AuthAgreement({
    required this.firstAgreement,
    required this.secondAgreement,
    required this.onChangedFirst,
    required this.onChangedSecond,

    super.key,
  });
  final bool firstAgreement;
  final bool secondAgreement;
  final Function(bool?)? onChangedFirst;
  final Function(bool?)? onChangedSecond;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            Checkbox(onChanged: onChangedFirst, value: firstAgreement),
            Expanded(
              child: Text(
                'I consent to the processing of personal data,the use of cokies, agree to the terms and conditions,and aknowledge the privacy policy.',
                style: context.themeText.bodyMedium,
              ),
            ),
          ],
        ),
        Row(
          children: [
            Checkbox(onChanged: onChangedSecond, value: secondAgreement),
            Expanded(
              child: Text(
                'I knowledge that my consulation is with an AI and not a licensed medical profeccional.',
                style: context.themeText.bodyMedium,
              ),
            ),
          ],
        ),
      ],
    );
  }
}
