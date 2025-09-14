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
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(title: Text('UI')),
    body: Column(children: [const Pin()]),
  );
}
