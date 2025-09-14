import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class Pin extends StatefulWidget {
  const Pin({super.key});

  @override
  State<Pin> createState() => _PinState();
}

class _PinState extends State<Pin> with PinCodeLogic {
  late List<TextEditingController> _controllers;
  late List<FocusNode> _focusNodes;

  bool get isValidate => isAllFieldFill(_controllers);
  String get pinCode => getPinCode(_controllers);

  @override
  void initState() {
    super.initState();
    _controllers = List.generate(6, (_) => TextEditingController());
    _focusNodes = List.generate(
      6,
      (index) => FocusNode(
        onKeyEvent: (node, event) =>
            _onKeyEvent(node, event, index, _controllers, _focusNodes),
      ),
    );
  }

  @override
  void dispose() {
    _dispose(_controllers, _focusNodes);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => Row(
    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
    crossAxisAlignment: CrossAxisAlignment.center,
    children: List.generate(
      6,
      (index) => PinInput(
        controller: _controllers[index],
        focusNode: _focusNodes[index],
        onChange: (value) {
          _listen(_controllers, _focusNodes, index);
          setState(() {});
        },
      ),
    ),
  );
}

class PinInput extends StatelessWidget {
  const PinInput({
    super.key,
    required this.controller,
    required this.focusNode,
    required this.onChange,
  });

  final TextEditingController controller;
  final FocusNode focusNode;
  final Function(String) onChange;

  bool get _hasText => controller.text.isNotEmpty;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: _hasText ? 60 : 50,
      width: _hasText ? 50 : 40,
      child: TextField(
        controller: controller,
        focusNode: focusNode,
        textAlign: TextAlign.center,
        keyboardType: TextInputType.number,
        inputFormatters: [FilteringTextInputFormatter.digitsOnly],
        maxLines: 1,
        maxLength: 1,
        onChanged: onChange,
        decoration: InputDecoration(
          counterText: '',
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(
              color: _hasText ? Colors.green : Colors.grey,
            ),
            borderRadius: BorderRadius.circular(8),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.green),
            borderRadius: BorderRadius.circular(8),
          ),
        ),
      ),
    );
  }
}

mixin PinCodeLogic on State<Pin> {
  bool isAllFieldFill(List<TextEditingController> controllers) {
    for (var controller in controllers) {
      if (controller.text.isEmpty) return false;
    }
    return true;
  }

  String getPinCode(List<TextEditingController> controllers) =>
      controllers.map((e) => e.text).join();

  void _listen(
    List<TextEditingController> controllers,
    List<FocusNode> focusNodes,
    int index,
  ) {
    if (controllers[index].text.isNotEmpty && index < 5) {
      focusNodes[index + 1].requestFocus();
    }
  }

  // Внутри mixin PinCodeLogic
  KeyEventResult _onKeyEvent(
    FocusNode node,
    KeyEvent event,
    int index,
    List<TextEditingController> controllers,
    List<FocusNode> focusNodes,
  ) {
    if (event is! KeyDownEvent) {
      return KeyEventResult.ignored;
    }
    if (event.logicalKey == LogicalKeyboardKey.backspace) {
      if (controllers[index].text.isEmpty && index > 0) {
        focusNodes[index - 1].requestFocus();
        controllers[index - 1].clear();
        setState(() {});
        return KeyEventResult.handled;
      }
    }
    return KeyEventResult.ignored;
  }

  void _dispose(
    List<TextEditingController> controllers,
    List<FocusNode> focusNodes,
  ) {
    for (var controller in controllers) {
      controller.dispose();
    }
    for (final focusNode in focusNodes) {
      focusNode.dispose();
    }
  }
}
