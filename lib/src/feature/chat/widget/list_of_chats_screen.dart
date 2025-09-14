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
    _chatBloc = ChatBloc(
      chatRepository: DependeciesScope.of(context).chatRepository,
      realTimeRepository: DependeciesScope.of(context).realTimeRepository,
    );

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
    _presenceBloc.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => _chatBloc),
        BlocProvider.value(value: _presenceBloc),
      ],
      child: CustomScrollView(
        slivers: [
          SliverPadding(
            padding: const EdgeInsetsGeometry.symmetric(horizontal: 16),
            sliver: BlocBuilder<ChatBloc, ChatState>(
              builder: (context, state) {
                return state.maybeMap(
                  orElse: () =>
                      const SliverToBoxAdapter(child: SizedBox.shrink()),
                  loaded: (state) => SliverList.builder(
                    itemCount: state.chats.length,
                    itemBuilder: (context, index) {
                      final chat = state.chats[index];
                      return ChatTile(chat: chat);
                    },
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
                  style: context.extentions.themeText.titleMedium,
                ),
                BlocBuilder<PresenceBloc, PresenceState>(
                  builder: (context, state) {
                    return state.maybeMap(
                      orElse: () => Text(
                        chat.lastMessage.content,
                        style: context.extentions.themeText.bodyMedium,
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
