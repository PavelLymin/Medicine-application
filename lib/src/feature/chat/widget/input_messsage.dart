import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:medicine_application/src/common/extensions/build_context.dart';
import 'package:medicine_application/src/feature/chat/model/chat_entity.dart';
import 'package:medicine_application/src/feature/chat/model/message_entity.dart';
import 'package:ui/ui.dart';
import '../state_management/message_bloc/message_bloc.dart';

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
    return ColoredBox(
      color: AppColors.lightgrey,
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.only(left: 8, top: 8, right: 8),
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
                child: SizedBox(
                  height: 50,
                  child: TextField(
                    style: TextStyle(color: AppColors.darkGrey),
                    controller: messageController,
                    focusNode: messageFocusNode,
                    maxLines: null,
                    decoration: context
                        .extentions
                        .themeDecorationInput
                        .chatInputDecoration,
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
        ),
      ),
    );
  }
}
