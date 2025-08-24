import 'dart:async';
import 'package:web_socket_channel/io.dart';
import 'package:web_socket_channel/web_socket_channel.dart';
import '../../../../common/constant/config.dart';

enum RequestType {
  message('message'),
  chat('chat'),
  typing('typing');

  const RequestType(this.value);
  final String value;
}

abstract interface class IRealTimeRepository {
  WebSocketChannel get channel;

  Stream<dynamic> get stream;

  Future<void> connect({required String userId});

  Future<void> dispose();
}

class RealTimeRepository implements IRealTimeRepository {
  static final RealTimeRepository _instance = RealTimeRepository._internal();
  factory RealTimeRepository() => _instance;
  RealTimeRepository._internal();

  WebSocketChannel? _channel;

  @override
  WebSocketChannel get channel {
    if (_channel == null) throw Exception('Not connected');
    return _channel!;
  }

  final StreamController<dynamic> _controller =
      StreamController<dynamic>.broadcast();

  @override
  Stream<dynamic> get stream => _controller.stream;

  StreamSubscription? _subscription;

  @override
  Future<void> connect({required String userId}) async {
    if (_channel != null) return;

    final uri = Uri.parse('${Config.wsBaseUrl}/connection');
    try {
      _channel = IOWebSocketChannel.connect(uri, headers: {'user_id': userId});

      _subscription = _channel?.stream.listen(
        (data) => _controller.add(data),
        onError: (error) => _controller.addError(error),
        onDone: () => _controller.close(),
      );
    } catch (_) {
      _channel = null;
      _subscription?.cancel();
      _subscription = null;
      rethrow;
    }
  }

  @override
  Future<void> dispose() async {
    await _channel?.sink.close();
    _channel = null;
    _subscription?.cancel();
    _subscription = null;
  }
}
