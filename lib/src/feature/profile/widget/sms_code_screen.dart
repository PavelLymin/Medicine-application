import 'package:ui/ui.dart';

class SmsCodeScreen extends StatefulWidget {
  const SmsCodeScreen({super.key});

  @override
  State<SmsCodeScreen> createState() => _SmsCodeScreenState();
}

class _SmsCodeScreenState extends State<SmsCodeScreen> {
  @override
  Widget build(BuildContext context) => Scaffold(
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
                onPressed: () {},
                isEnable: true,
                widget: const Text('Continue'),
              );
            },
          ),
        ],
      ),
    ),
  );
}
