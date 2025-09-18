import 'package:ui/ui.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) =>
      MaterialApp(theme: createLightTheme(), home: const _Ui());
}

class _Ui extends StatelessWidget {
  const _Ui();

  @override
  Widget build(BuildContext context) => PinScope(
    child: Scaffold(
      appBar: AppBar(title: Text('UI')),
      body: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
        children: [
          const Pin(),
          const SizedBox(height: 16),
          const Divider(thickness: 2),
          const SizedBox(height: 16),
          const SentMessage(message: 'Hello world!'),
          const SentMessage(message: 'Hello world!'),
          const ReceivedMessage(message: 'Hello world!'),
          const ReceivedMessage(message: 'Hello world!'),
          const SizedBox(height: 16),
          const Divider(thickness: 2),
          const SizedBox(height: 16),
          BaseButton(
            onPressed: () {},
            isEnable: true,
            widget: Text('Continue'),
          ),
          const SizedBox(height: 16),
          BaseButton(
            onPressed: () {},
            isEnable: false,
            widget: const Text('Continue'),
          ),
        ],
      ),
    ),
  );
}
