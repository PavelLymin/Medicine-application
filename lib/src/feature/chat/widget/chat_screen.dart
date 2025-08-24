import 'package:auto_route/auto_route.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:medicine_application/src/feature/chat/state_management/message_bloc/message_bloc.dart';
import 'package:medicine_application/src/feature/chat/model/chat_entity.dart';
import 'package:medicine_application/src/feature/chat/state_management/precent_notify.dart/typing_notify.dart';
import 'package:medicine_application/src/feature/chat/widget/typing.dart';
import '../../../common/scopes/dependencies_scope.dart';
import '../../../../ui/ui.dart';
import 'input_messsage.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key, required this.chatEntity});

  final FullChatEntity chatEntity;

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final _messageController = TextEditingController();
  final _messageFocusNode = FocusNode();
  late FullChatEntity _chat;
  late MessageBloc _bloc;
  late TypingController _typingController;

  @override
  void initState() {
    super.initState();
    _chat = widget.chatEntity;
    _bloc = DepenciesScope.of(context).messageBloc;

    _typingController = TypingController(
      realTimeRepository: DepenciesScope.of(context).realTimeRepository,
      precentRepository: DepenciesScope.of(context).precentRepository,
    );

    DepenciesScope.of(context).authenticationBloc.state.currentUser.map(
      notAuthenticatedUser: (_) {},
      authenticatedUser: (user) {
        _bloc.add(MessageEvent.load(chatId: _chat.id, userId: user.uid));

        _messageController.addListener(
          () async => await _typingController.onTextChanged(
            user.uid,
            _chat.id,
            _messageController.text,
          ),
        );
      },
    );
  }

  @override
  void dispose() {
    _messageController.dispose();
    _messageFocusNode.dispose();
    _typingController.dispose();
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
                title: Text(_chat.interlocutor.displayName ?? ''),
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
                  Typing(typingController: _typingController, chatId: _chat.id),
                  SafeArea(
                    child: InputMesssage(
                      messageController: _messageController,
                      messageFocusNode: _messageFocusNode,
                      chat: _chat,
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
