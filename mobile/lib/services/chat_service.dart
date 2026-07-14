import 'dart:async';
import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

import '../config/api_config.dart';
import '../models/message.dart';

/// Live chat over the backend's raw WebSocket endpoint (/ws/chat).
///
/// Emits incoming [Message]s on [messages]. If the socket cannot connect
/// (e.g. proxy strips WebSocket upgrades), callers should fall back to
/// polling the REST conversation endpoint — [isConnected] reports state.
class ChatService {
  WebSocketChannel? _channel;
  final StreamController<Message> _messages = StreamController.broadcast();
  bool _connected = false;

  Stream<Message> get messages => _messages.stream;

  bool get isConnected => _connected;

  /// Derives ws(s)://host/ws/chat from the configured API base URL.
  static String _wsUrl(String token) {
    var root = ApiConfig.baseUrl;
    if (root.endsWith('/api')) {
      root = root.substring(0, root.length - 4);
    }
    root = root.replaceFirst('https://', 'wss://').replaceFirst('http://', 'ws://');
    return '$root/ws/chat?token=$token';
  }

  Future<bool> connect() async {
    if (_connected) return true;
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('auth_token');
    if (token == null) return false;

    try {
      final channel = WebSocketChannel.connect(Uri.parse(_wsUrl(token)));
      await channel.ready;
      _channel = channel;
      _connected = true;
      channel.stream.listen(
        (frame) {
          try {
            final data = json.decode(frame as String);
            if (data is Map<String, dynamic> && data['error'] == null) {
              _messages.add(Message.fromJson(data));
            }
          } catch (_) {
            // Ignore malformed frames
          }
        },
        onError: (_) => _connected = false,
        onDone: () => _connected = false,
      );
      return true;
    } catch (_) {
      _connected = false;
      return false;
    }
  }

  /// Sends a message over the socket. Returns false if not connected
  /// (caller should use the REST fallback).
  bool send(int recipientId, String content) {
    final channel = _channel;
    if (!_connected || channel == null) return false;
    channel.sink.add(json.encode({'recipientId': recipientId, 'content': content}));
    return true;
  }

  void disconnect() {
    _channel?.sink.close();
    _channel = null;
    _connected = false;
  }

  void dispose() {
    disconnect();
    _messages.close();
  }
}
