import 'package:auto_route/auto_route.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../common/scopes/dependencies_scope.dart';
import '../../../../ui/ui.dart';
import '../model/chat_entity.dart';
import '../state_management/message_bloc/message_bloc.dart';
import '../state_management/presence_bloc/presence_bloc.dart';
import 'button_down.dart';
import 'input_messsage.dart';
import 'typing.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key, required this.chatEntity});

  final FullChatEntity chatEntity;

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final _messageController = TextEditingController();
  final _messageFocusNode = FocusNode();
  final _scrollController = ScrollController();
  late FullChatEntity _chat;
  late MessageBloc _messageBloc;
  late PresenceBloc _presenceBloc;

  @override
  void initState() {
    super.initState();
    _chat = widget.chatEntity;
    _messageBloc = DependeciesScope.of(context).messageBloc;
    _presenceBloc = DependeciesScope.of(context).presenceBloc;
    DependeciesScope.of(context).authenticationBloc.state.currentUser.map(
      notAuthenticatedUser: (_) {},
      authenticatedUser: (user) {
        _messageBloc.add(MessageEvent.load(chatId: _chat.id, userId: user.uid));
        _onTextChanged(_chat.id, user.uid);
      },
    );
  }

  void _onTextChanged(int chatId, String userId) {
    _messageController.addListener(() {
      _presenceBloc.add(
        PresenceEvent.onTextChangedEvent(
          userId: userId,
          chatId: chatId,
          text: _messageController.text,
        ),
      );
    });
  }

  @override
  void dispose() {
    _messageController.dispose();
    _messageFocusNode.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider.value(value: _messageBloc),
        BlocProvider.value(value: _presenceBloc),
      ],
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
                title: Text(_chat.interlocutor.displayName ?? ''),
                centerTitle: false,
                leading: BackButton(onPressed: () => context.router.pop()),
              ),
              body: Column(
                children: [
                  Expanded(
                    child: Stack(
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          child: ListView.builder(
                            shrinkWrap: true,
                            reverse: true,
                            dragStartBehavior: DragStartBehavior.down,
                            controller: _scrollController,
                            itemCount: state.messages.length,
                            itemBuilder: (context, index) => SentMessage(
                              message: state.messages[index].content,
                            ),
                          ),
                        ),
                        Align(
                          alignment: Alignment.bottomLeft,
                          child: Typing(chatId: _chat.id),
                        ),
                        Align(
                          alignment: AlignmentGeometry.bottomRight,
                          child: ButtonDown(
                            scrollController: _scrollController,
                          ),
                        ),
                      ],
                    ),
                  ),
                  InputMesssage(
                    messageController: _messageController,
                    messageFocusNode: _messageFocusNode,
                    chat: _chat,
                  ),
                ],
              ),
            ),
            error: (state) => Scaffold(
              appBar: AppBar(
                title: Text(_chat.interlocutor.displayName ?? ''),
                centerTitle: false,
                leading: BackButton(onPressed: () => context.router.pop()),
              ),
              body: Center(child: Text(state.error)),
            ),
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
