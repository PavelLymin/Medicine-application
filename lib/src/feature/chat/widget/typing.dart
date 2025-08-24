import 'package:flutter/material.dart';
import 'package:medicine_application/src/feature/chat/state_management/precent_notify.dart/typing_notify.dart';

class Typing extends StatelessWidget {
  const Typing({
    super.key,
    required this.typingController,
    required this.chatId,
  });

  final TypingController typingController;

  final int chatId;

  @override
  Widget build(BuildContext context) => ListenableBuilder(
    listenable: typingController,
    builder: (BuildContext context, Widget? child) {
      return typingController.state.maybeMap(
        orElse: () => const SizedBox.shrink(),
        startTyping: (controller) => const Text('Typing...'),
        error: (state) => Text(state.error),
      );
    },
  );
}
