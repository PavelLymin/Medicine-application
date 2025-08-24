import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:medicine_application/src/feature/chat/data/repository/real_time_repository.dart';
import 'package:medicine_application/src/feature/chat/data/response_handler/precent_response.dart';
import '../../data/repository/precent_repository.dart';

typedef TypingStateMatch<R, S extends TypingState> = R Function(S state);

sealed class TypingState {
  const TypingState({required this.isTyping});

  const factory TypingState.initial({required bool isTyping}) = _TypingInitial;

  const factory TypingState.startTyping({
    required bool isTyping,
    required int chatId,
  }) = _StartTyping;

  const factory TypingState.stopTyping({
    required bool isTyping,
    required int chatId,
  }) = _StopTyping;

  const factory TypingState.error({
    required bool isTyping,
    required int chatId,
    required String error,
  }) = _TypingError;

  final bool isTyping;

  TypingState get state => this;

  R map<R>({
    // ignore: library_private_types_in_public_api
    required TypingStateMatch<R, _TypingInitial> initial,
    // ignore: library_private_types_in_public_api
    required TypingStateMatch<R, _StartTyping> startTyping,
    // ignore: library_private_types_in_public_api
    required TypingStateMatch<R, _StopTyping> stopTyping,
    // ignore: library_private_types_in_public_api
    required TypingStateMatch<R, _TypingError> error,
  }) {
    return switch (this) {
      _TypingInitial e => initial(e),
      _StartTyping e => startTyping(e),
      _StopTyping e => stopTyping(e),
      _TypingError e => error(e),
    };
  }

  R maybeMap<R>({
    required R Function() orElse,
    // ignore: library_private_types_in_public_api
    TypingStateMatch<R, _TypingInitial>? initial,
    // ignore: library_private_types_in_public_api
    TypingStateMatch<R, _StartTyping>? startTyping,
    // ignore: library_private_types_in_public_api
    TypingStateMatch<R, _StopTyping>? stopTyping,
    // ignore: library_private_types_in_public_api
    TypingStateMatch<R, _TypingError>? error,
  }) => map<R>(
    initial: initial ?? (_) => orElse(),
    startTyping: startTyping ?? (_) => orElse(),
    stopTyping: stopTyping ?? (_) => orElse(),
    error: error ?? (_) => orElse(),
  );
}

class _TypingInitial extends TypingState {
  const _TypingInitial({required super.isTyping});
}

class _StartTyping extends TypingState {
  const _StartTyping({required super.isTyping, required this.chatId});

  final int chatId;
}

class _StopTyping extends TypingState {
  const _StopTyping({required super.isTyping, required this.chatId});

  final int chatId;
}

class _TypingError extends TypingState {
  const _TypingError({
    required super.isTyping,
    required this.chatId,
    required this.error,
  });

  final int chatId;
  final String error;
}

class TypingController with ChangeNotifier {
  TypingController({
    required IRealTimeRepository realTimeRepository,
    required IPrecentRepository precentRepository,
  }) : _realTimeRepository = realTimeRepository,
       _precentRepository = precentRepository {
    _subscription = _realTimeRepository.stream.listen((message) {
      try {
        final json = jsonDecode(message) as Map<String, dynamic>;
        final response = PrecentResponse.fromJson(json);

        switch (response) {
          case StartTypingResponse response:
            _state = _StartTyping(isTyping: true, chatId: response.chatId);
            notifyListeners();
          case StopTypingResponse response:
            _state = _StopTyping(isTyping: false, chatId: response.chatId);
            notifyListeners();
          case PrecentError response:
            _state = _TypingError(
              isTyping: false,
              chatId: response.chatId,
              error: response.error,
            );
            notifyListeners();
        }
      } catch (e) {
        _state = const _TypingInitial(isTyping: false);
        notifyListeners();
        rethrow;
      }
    });
  }

  final IRealTimeRepository _realTimeRepository;

  final IPrecentRepository _precentRepository;

  StreamSubscription? _subscription;

  TypingState _state = const _TypingInitial(isTyping: false);

  TypingState get state => _state;

  Timer? _timer;

  Future<void> onTextChanged(String userId, int chatId, String text) async {
    if (text.isNotEmpty && !state.isTyping) {
      _state = _StartTyping(isTyping: true, chatId: chatId);
      await _precentRepository.startTypingMessage(
        userId: userId,
        chatId: chatId,
      );
    }

    if (text.isEmpty && state.isTyping) {
      await _precentRepository.stopTypingMessage(
        chatId: chatId,
        userId: userId,
      );
      _state = _StopTyping(isTyping: false, chatId: chatId);
    }

    _timer?.cancel();
    _timer = Timer(const Duration(seconds: 2), () async {
      if (!state.isTyping) return;
      _state = _StopTyping(isTyping: false, chatId: chatId);
      await _precentRepository.stopTypingMessage(
        chatId: chatId,
        userId: userId,
      );
    });
  }

  @override
  void dispose() {
    _subscription?.cancel();
    _subscription = null;
    super.dispose();
  }
}
