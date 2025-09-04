import 'package:auto_route/auto_route.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../common/extensions/build_context.dart';
import '../../../common/scopes/dependencies_scope.dart';
import '../../../../ui/ui.dart';
import '../model/chat_entity.dart';
import '../state_management/chat_bloc/chat_bloc.dart';
import '../state_management/presence_bloc/presence_bloc.dart';

class ListOfChatsScreen extends StatefulWidget {
  const ListOfChatsScreen({super.key});

  @override
  State<ListOfChatsScreen> createState() => _ListOfChatsScreenState();
}

class _ListOfChatsScreenState extends State<ListOfChatsScreen> {
  late ChatBloc _chatBloc;
  late PresenceBloc _presenceBloc;

  @override
  void initState() {
    super.initState();
    _chatBloc = DependeciesScope.of(context).chatBloc;

    _presenceBloc = DependeciesScope.of(context).presenceBloc;

    DependeciesScope.of(context).authenticationBloc.state.currentUser.map(
      notAuthenticatedUser: (_) {},
      authenticatedUser: (user) {
        _chatBloc.add(ChatEvent.loadChats(userId: user.uid));
      },
    );
  }

  @override
  void dispose() {
    _chatBloc.close();
    _presenceBloc.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider.value(value: _chatBloc),
        BlocProvider.value(value: _presenceBloc),
      ],
      child: CustomScrollView(
        slivers: [
          const SliverAppBar(title: Text('Chats'), stretch: true, pinned: true),
          SliverPadding(
            padding: const EdgeInsetsGeometry.symmetric(horizontal: 16),
            sliver: BlocBuilder<ChatBloc, ChatState>(
              builder: (context, state) {
                return state.maybeMap(
                  orElse: () =>
                      const SliverToBoxAdapter(child: SizedBox.shrink()),
                  loaded: (state) => SliverList(
                    delegate: SliverChildBuilderDelegate(
                      childCount: state.chats.length,
                      (context, index) {
                        final chat = state.chats[index];
                        return ChatTile(chat: chat);
                      },
                    ),
                  ),
                  error: (e) =>
                      SliverToBoxAdapter(child: Center(child: Text(e.message))),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class ChatTile extends StatelessWidget {
  const ChatTile({super.key, required this.chat});

  final FullChatEntity chat;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        context.router.push(
          NamedRoute('ChatScreen', params: {'chatEntity': chat}),
        );
      },
      child: Row(
        children: [
          UserAvatar(user: chat.interlocutor, radius: 32),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  chat.interlocutor.displayName ?? '',
                  style: context.themeText.titleMedium,
                ),
                BlocBuilder<PresenceBloc, PresenceState>(
                  builder: (context, state) {
                    return state.maybeMap(
                      orElse: () => Text(
                        chat.lastMessage.content,
                        style: context.themeText.bodyMedium,
                      ),
                      startTyping: (state) {
                        if (state.chatId == chat.id) {
                          return const Text('Typing...');
                        }
                        return Text(chat.lastMessage.content);
                      },
                    );
                  },
                ),
                const Divider(thickness: 1),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
