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
  late Logger logger;

  @override
  void initState() {
    super.initState();
    context.read<ChatBloc>().add(ChatEvent.loadChats());
    logger = DepenciesScope.of(context).logger;
    logger.i('Welcome to chat screen!');
  }

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      slivers: [
        SliverAppBar(title: const Text('Chats')),
        BlocBuilder<ChatBloc, ChatState>(
          builder: (context, state) {
            return state.maybeMap(
              orElse: () => SliverToBoxAdapter(child: Container()),
              loading: (_) => const SliverToBoxAdapter(
                child: Center(child: CircularProgressIndicator()),
              ),
              error: (state) {
                logger.e(state.message);
                return SliverToBoxAdapter(
                  child: Center(
                    child: const Text('Произoшла ошибка. Попробуйте позже'),
                  ),
                );
              },
              loaded: (state) => SliverList.builder(
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
        ),
      ],
    );
  }
}
