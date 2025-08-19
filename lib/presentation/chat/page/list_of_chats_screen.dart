import 'package:auto_route/auto_route.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:logger/web.dart';
import 'package:medicine_application/common/bloc/chat_bloc/chat_bloc.dart';
import 'package:medicine_application/common/extencions/build_context.dart';
import 'package:medicine_application/main.dart';
import 'package:medicine_application/model/chat_entity.dart';
import '../../../common/ui.dart';

class ListOfChatsScreen extends StatefulWidget {
  const ListOfChatsScreen({super.key});

  @override
  State<ListOfChatsScreen> createState() => _ListOfChatsScreenState();
}

class _ListOfChatsScreenState extends State<ListOfChatsScreen> {
  late Logger _logger;

  @override
  void initState() {
    super.initState();
    _logger = DepenciesScope.of(context).logger;
    _logger.i('Welcome to chat screen!');
  }

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
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
    );
  }
}

class ChatTile extends StatelessWidget {
  const ChatTile({super.key, required this.chat});

  final FullChatEntity chat;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => context.router.push(
        NamedRoute('ChatScreen', params: {'chatEntity': chat}),
      ),
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
                Text(
                  chat.lastMessage.content,
                  style: context.themeText.bodyMedium,
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
