import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../state_management/presence_bloc/presence_bloc.dart';

class Typing extends StatelessWidget {
  const Typing({super.key, required this.chatId});

  final int chatId;

  @override
  Widget build(BuildContext context) =>
      BlocBuilder<PresenceBloc, PresenceState>(
        builder: (context, state) {
          return state.maybeMap(
            orElse: () => const SizedBox.shrink(),
            startTyping: (controller) => state.chatId == chatId
                ? const Text('Typing...')
                : const SizedBox.shrink(),
          );
        },
      );
}
