import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:logger/web.dart';
import 'package:medicine_application/common/bloc/chat_bloc/chat_bloc.dart';
import 'package:medicine_application/main.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  late Logger _logger;
  late ChatBloc _bloc;

  @override
  void initState() {
    super.initState();
    _logger = DepenciesScope.of(context).logger;
    _logger.i('Welcome to chat screen!');
    _bloc = DepenciesScope.of(context).chatBloc;
    _bloc.add(ChatEvent.loadChats());
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: _bloc,
      child: CustomScrollView(
        slivers: [
          const SliverAppBar(title: Text('Chats')),
          BlocBuilder<ChatBloc, ChatState>(
            builder: (context, state) {
              return state.maybeMap(
                orElse: () =>
                    const SliverToBoxAdapter(child: SizedBox.shrink()),
                loaded: (state) => SliverList(
                  delegate: SliverChildBuilderDelegate(
                    childCount: state.chats.length,
                    (context, index) {
                      final chat = state.chats[index];
                      return ListTile(title: Text(chat.lastMessage.toString()));
                    },
                  ),
                ),
                error: (_) => const SliverToBoxAdapter(
                  child: Text('Произошла ошибка. Попробуйте позже'),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}

class _ChatList extends StatefulWidget {
  const _ChatList();

  @override
  State<_ChatList> createState() => _ChatListState();
}

class _ChatListState extends State<_ChatList> {
  @override
  void initState() {
    super.initState();
    context.read<ChatBloc>().add(ChatEvent.loadChats());
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ChatBloc, ChatState>(
      builder: (context, state) {
        return state.maybeMap(
          orElse: () => Container(),
          loading: (_) => const Center(child: CircularProgressIndicator()),
          error: (state) =>
              const Center(child: Text('Произoшла ошибка. Попробуйте позже')),
          loaded: (state) => ListView.builder(
            scrollDirection: Axis.vertical,
            shrinkWrap: true,
            itemCount: state.chats.length,
            itemBuilder: (context, index) {
              final chat = state.chats[index];
              return ListTile(
                title: Text('Chat ${chat.lastMessage}'),
                onTap: () {},
              );
            },
          ),
        );
      },
    );
  }
}
