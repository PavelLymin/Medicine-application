import 'package:auto_route/auto_route.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:medicine_application/common/bloc/message_bloc/message_bloc.dart';
import 'package:medicine_application/main.dart';
import 'package:medicine_application/model/chat_entity.dart';
import '../../../common/ui.dart';
import '../widget/input_messsage.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key, required this.chatEntity});

  final FullChatEntity chatEntity;

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  late MessageBloc _bloc;
  final _messageController = TextEditingController();
  final _messageFocusNode = FocusNode();
  late FullChatEntity chat;

  @override
  void initState() {
    super.initState();
    chat = widget.chatEntity;
    _bloc = DepenciesScope.of(context).messageBloc;
    _bloc.add(MessageEvent.load(chatId: chat.id));
  }

  @override
  void dispose() {
    _messageController.dispose();
    _messageFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: _bloc,
      child: BlocBuilder<MessageBloc, MessageState>(
        builder: (context, state) {
          return state.maybeMap(
            orElse: () => Scaffold(
              appBar: AppBar(
                leading: BackButton(onPressed: () => context.router.pop()),
              ),
              body: const Center(child: CircularProgressIndicator()),
            ),
            loaded: (state) => Scaffold(
              appBar: AppBar(
                title: Text(chat.interlocutor.displayName ?? ''),
                centerTitle: false,
                leading: BackButton(onPressed: () => context.router.pop()),
              ),
              body: Column(
                children: [
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 24,
                        vertical: 8,
                      ),
                      child: ListView.builder(
                        itemCount: state.messages.length,
                        itemBuilder: (context, index) =>
                            SentMessage(message: state.messages[index].content),
                      ),
                    ),
                  ),
                  SafeArea(
                    child: InputMesssage(
                      messageController: _messageController,
                      messageFocusNode: _messageFocusNode,
                      chat: chat,
                    ),
                  ),
                ],
              ),
            ),
            error: (state) => Scaffold(body: Center(child: Text(state.error))),
          );
        },
      ),
    );
  }
}

class SentMessage extends StatelessWidget {
  const SentMessage({super.key, required this.message});

  final String message;

  @override
  Widget build(BuildContext context) => Align(
    alignment: Alignment.centerRight,
    child: Container(
      margin: const EdgeInsets.only(right: 8, top: 8, bottom: 8),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.green,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Text(message),
    ),
  );
}

class ResentMessage extends StatelessWidget {
  const ResentMessage({super.key, required this.message});

  final String message;

  @override
  Widget build(BuildContext context) => Align(
    alignment: Alignment.centerLeft,
    child: Container(
      margin: const EdgeInsets.only(left: 8, top: 8, bottom: 8),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.grey,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Text(message),
    ),
  );
}
