import 'dart:async';
import 'dart:convert';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../data/repository/precent_repository.dart';
import '../../data/repository/real_time_repository.dart';
import '../../data/response_handler/precent_response.dart';

part 'presence_event.dart';
part 'presence_state.dart';

class PresenceBloc extends Bloc<PresenceEvent, PresenceState>
    with _SetStateMixin {
  PresenceBloc({
    required IRealTimeRepository realTimeRepository,
    required IPresenceRepository presenceRepository,
  }) : _realTimeRepository = realTimeRepository,
       _presenceRepository = presenceRepository,
       super(const _TypingInitial()) {
    _subscription = _realTimeRepository.stream.listen((message) {
      try {
        final json = jsonDecode(message) as Map<String, dynamic>;
        if (json['request_type'] != RequestType.typing.value) return;

        final response = PresenceResponse.fromJson(json);

        switch (response) {
          case StartTypingResponse response:
            setState(_StartTyping(chatId: response.chatId));
          case StopTypingResponse response:
            setState(_StopTyping(chatId: response.chatId));
          case SetChatId response:
            setState(_StopTyping(chatId: response.chatId));
          case PpesenceError response:
            if (state.chatId != null) {
              setState(
                PresenceState.error(
                  error: response.error,
                  chatId: state.chatId!,
                ),
              );
            }
        }
      } catch (e) {
        rethrow;
      }
    }, onError: (e) {});
    on<PresenceEvent>((event, emit) async {
      await event.map(
        startTypingEvent: (e) => _startTypingEvent(emit, e),
        stopTypingEvent: (e) => _stopTypingEvent(emit, e),
        onTextChangedEvent: (e) => _onTextChangedEvent(emit, e),
      );
    });
  }

  final IRealTimeRepository _realTimeRepository;
  final IPresenceRepository _presenceRepository;

  StreamSubscription? _subscription;
  Timer? _timer;

  Future<void> _stopTypingEvent(
    Emitter<PresenceState> emit,
    _StopTypingEvent e,
  ) async {
    try {
      await _presenceRepository.stopTypingMessage(
        chatId: e.chatId,
        userId: e.userId,
      );

      emit(_TypingInitial(chatId: e.chatId, isTyping: false));
    } catch (error) {
      emit(PresenceState.error(error: error.toString(), chatId: e.chatId));
    }
  }

  Future<void> _startTypingEvent(
    Emitter<PresenceState> emit,
    _StartTypingEvent e,
  ) async {
    try {
      await _presenceRepository.startTypingMessage(
        userId: e.userId,
        chatId: e.chatId,
      );

      emit(_TypingInitial(chatId: e.chatId, isTyping: true));
    } catch (error) {
      emit(PresenceState.error(error: error.toString(), chatId: e.chatId));
    }
  }

  Future<void> _onTextChangedEvent(
    Emitter<PresenceState> emit,
    _OnTextChangedEvent e,
  ) async {
    if (e.text.isNotEmpty && !state.isTyping) {
      add(PresenceEvent.startTypingEvent(chatId: e.chatId, userId: e.userId));
    }

    if (e.text.isEmpty && state.isTyping) {
      add(PresenceEvent.stopTypingEvent(chatId: e.chatId, userId: e.userId));
    }

    disposeTimer();
    _timer = Timer(const Duration(seconds: 2), () async {
      if (!state.isTyping) return;
      add(PresenceEvent.stopTypingEvent(chatId: e.chatId, userId: e.userId));
    });
  }

  void disposeSub() {
    _subscription?.cancel();
    _subscription = null;
  }

  void disposeTimer() {
    _timer?.cancel();
    _timer = null;
  }

  @override
  Future<void> close() {
    disposeSub();
    return super.close();
  }
}

mixin _SetStateMixin<State extends PresenceState> implements Emittable<State> {
  void setState(State state) {
    emit(state);
  }
}
