import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:medicine_application/src/feature/chat/state_management/message_bloc/message_bloc.dart';
import 'package:medicine_application/ui/src/theme/theme.dart';
import 'package:medicine_application/src/feature/chat/model/chat_entity.dart';
import 'package:medicine_application/src/feature/chat/model/message_entity.dart';

class InputMesssage extends StatelessWidget {
  const InputMesssage({
    super.key,
    required this.messageController,
    required this.messageFocusNode,
    required this.chat,
  });

  final TextEditingController messageController;
  final FocusNode messageFocusNode;
  final FullChatEntity chat;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          IconButton(
            icon: const Icon(
              Icons.attach_file,
              color: AppColors.green,
              size: 36,
            ),
            onPressed: () {},
          ),
          Expanded(
            child: TextField(
              controller: messageController,
              focusNode: messageFocusNode,
              maxLines: null,
              decoration: InputDecoration(
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(32),
                  borderSide: const BorderSide(color: AppColors.grey),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(32),
                  borderSide: const BorderSide(color: AppColors.darkGrey),
                ),
              ),
            ),
          ),
          IconButton(
            icon: const Icon(Icons.send, color: AppColors.green, size: 36),
            onPressed: () {
              if (messageController.text.isEmpty) return;
              final message = CreatedMessageEntity(
                chatId: chat.id,
                senderId: chat.interlocutor.uid,
                content: messageController.text,
                createdAt: DateTime.now(),
              );
              context.read<MessageBloc>().add(
                MessageEvent.send(message: message),
              );
              messageController.clear();
            },
          ),
        ],
      ),
    );
  }
}
