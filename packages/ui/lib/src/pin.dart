import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class PinScope extends StatefulWidget {
  const PinScope({super.key, required this.child});

  final Widget child;

  // ignore: library_private_types_in_public_api
  static _PinInherited of(BuildContext context, {bool listen = false}) {
    if (listen) {
      return context.dependOnInheritedWidgetOfExactType<_PinInherited>()!;
    } else {
      return context.getInheritedWidgetOfExactType<_PinInherited>()!;
    }
  }

  @override
  State<PinScope> createState() => _PinScopeState();
}

class _PinScopeState extends State<PinScope> with PinCodeLogic {
  late List<TextEditingController> _controllers;
  late List<FocusNode> _focusNodes;

  Stream<bool> get isValidate => isAllFieldFill(_controllers);
  String get pinCode => getPinCode(_controllers);

  void _onTextChanged(
    List<TextEditingController> controllers,
    List<FocusNode> focusNodes,
    int index,
  ) {
    _listen(controllers, focusNodes, index);
  }

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
  Widget build(BuildContext context) =>
      _PinInherited(pin: this, child: widget.child);
}

class _PinInherited extends InheritedWidget {
  const _PinInherited({required this.pin, required super.child});

  final _PinScopeState pin;

  @override
  bool updateShouldNotify(covariant _PinInherited oldWidget) =>
      pin.isValidate != oldWidget.pin.isValidate ||
      pin.pinCode != oldWidget.pin.pinCode;
}

class Pin extends StatefulWidget {
  const Pin({super.key});

  @override
  State<Pin> createState() => _PinState();
}

class _PinState extends State<Pin> {
  late _PinInherited state;

  @override
  void initState() {
    state = PinScope.of(context);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: List.generate(
        6,
        (index) => PinInput(
          index: index,
          controller: state.pin._controllers[index],
          focusNode: state.pin._focusNodes[index],
          onChange: (value) {
            state.pin._onTextChanged(
              state.pin._controllers,
              state.pin._focusNodes,
              index,
            );
          },
        ),
      ),
    );
  }
}

class PinInput extends StatefulWidget {
  const PinInput({
    super.key,
    required this.index,
    required this.controller,
    required this.focusNode,
    required this.onChange,
  });

  final int index;
  final TextEditingController controller;
  final FocusNode focusNode;
  final Function(String) onChange;

  @override
  State<PinInput> createState() => _PinInputState();
}

class _PinInputState extends State<PinInput> {
  bool _hasText = false;

  @override
  void initState() {
    widget.controller.addListener(() {
      setState(() {
        _hasText = widget.controller.text.isNotEmpty;
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: _hasText ? 60 : 50,
      width: _hasText ? 50 : 40,
      child: TextField(
        controller: widget.controller,
        focusNode: widget.focusNode,
        textAlign: TextAlign.center,
        keyboardType: TextInputType.number,
        inputFormatters: [FilteringTextInputFormatter.digitsOnly],
        maxLines: 1,
        maxLength: 1,
        onChanged: widget.onChange,
        decoration: InputDecoration(
          counterText: '',
          disabledBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.grey),
            borderRadius: BorderRadius.circular(8),
          ),
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

mixin PinCodeLogic<T extends StatefulWidget> on State<T> {
  void _checkAllFields(
    List<TextEditingController> controllers,
    StreamController streamController,
  ) {
    final allFilled = controllers.every((c) => c.text.isNotEmpty);
    streamController.add(allFilled);
  }

  void _cleanup(
    List<TextEditingController> controllers,
    StreamController streamController,
    bool isStreamClosed,
  ) {
    if (!isStreamClosed) {
      isStreamClosed = true;
      for (final controller in controllers) {
        controller.removeListener(() {
          _checkAllFields(controllers, streamController);
        });
      }
    }
  }

  Stream<bool> isAllFieldFill(List<TextEditingController> controllers) {
    final streamController = StreamController<bool>.broadcast();
    var isStreamClosed = false;
    for (final controller in controllers) {
      controller.addListener(() {
        _checkAllFields(controllers, streamController);
      });
    }
    _checkAllFields(controllers, streamController);
    streamController.onCancel = () {
      _cleanup(controllers, streamController, isStreamClosed);
      streamController.close();
    };

    return streamController.stream;
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
