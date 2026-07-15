import 'dart:async';

import 'package:flutter/material.dart';

import '../models/message.dart';
import '../models/user.dart';
import '../services/api_service.dart';
import '../services/chat_service.dart';
import '../theme/app_theme.dart';

/// One-to-one conversation. Live via WebSocket when available,
/// with a polling fallback so messaging still works behind proxies
/// that strip WebSocket upgrades.
class ChatScreen extends StatefulWidget {
  final User currentUser;
  final int partnerId;
  final String partnerName;

  const ChatScreen({
    super.key,
    required this.currentUser,
    required this.partnerId,
    required this.partnerName,
  });

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final ApiService _apiService = ApiService();
  final ChatService _chatService = ChatService();
  final TextEditingController _inputController = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  List<Message> _messages = [];
  bool _loading = true;
  bool _live = false;
  StreamSubscription<Message>? _subscription;
  Timer? _pollTimer;

  @override
  void initState() {
    super.initState();
    _init();
  }

  Future<void> _init() async {
    await _loadHistory();
    _live = await _chatService.connect();
    if (_live) {
      _subscription = _chatService.messages.listen((message) {
        final relevant = message.senderId == widget.partnerId ||
            (message.senderId == widget.currentUser.id &&
                message.recipientId == widget.partnerId);
        if (relevant && mounted) {
          setState(() => _messages.add(message));
          _scrollToBottom();
        }
      });
    } else {
      // REST fallback: refresh the thread periodically
      _pollTimer = Timer.periodic(const Duration(seconds: 5), (_) => _loadHistory());
    }
    if (mounted) setState(() {});
  }

  Future<void> _loadHistory() async {
    try {
      final messages = await _apiService.getConversation(widget.partnerId);
      if (mounted) {
        final grew = messages.length != _messages.length;
        setState(() {
          _messages = messages;
          _loading = false;
        });
        if (grew) _scrollToBottom();
      }
    } catch (_) {
      if (mounted) setState(() => _loading = false);
    }
  }

  Future<void> _send() async {
    final content = _inputController.text.trim();
    if (content.isEmpty) return;
    _inputController.clear();

    // Prefer the socket; fall back to REST (echo comes back on the socket,
    // so only append locally on the REST path).
    if (!_chatService.send(widget.partnerId, content)) {
      try {
        final sent = await _apiService.sendMessage(widget.partnerId, content);
        if (mounted) {
          setState(() => _messages.add(sent));
          _scrollToBottom();
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('$e'), behavior: SnackBarBehavior.floating),
          );
        }
      }
    }
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 200),
          curve: Curves.easeOut,
        );
      }
    });
  }

  @override
  void dispose() {
    _subscription?.cancel();
    _pollTimer?.cancel();
    _chatService.dispose();
    _inputController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        elevation: 0,
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(widget.partnerName, style: const TextStyle(fontSize: 17)),
            Text(
              _live ? 'Live' : 'Syncing every 5s',
              style: TextStyle(
                fontSize: 11,
                color: _live ? const Color(0xFF58B87E) : AppColors.textSecondary,
              ),
            ),
          ],
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: _loading
                ? const Center(child: CircularProgressIndicator())
                : ListView.builder(
                    controller: _scrollController,
                    padding: const EdgeInsets.all(16),
                    itemCount: _messages.length,
                    itemBuilder: (context, index) => _bubble(_messages[index]),
                  ),
          ),
          _inputBar(),
        ],
      ),
    );
  }

  Widget _bubble(Message message) {
    final isMine = message.senderId == widget.currentUser.id;
    return Align(
      alignment: isMine ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.only(bottom: 10),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
        constraints: BoxConstraints(
          maxWidth: MediaQuery.of(context).size.width * 0.74,
        ),
        decoration: BoxDecoration(
          color: isMine
              ? AppColors.primary.withValues(alpha: 0.16)
              : AppColors.surface,
          borderRadius: BorderRadius.only(
            topLeft: const Radius.circular(14),
            topRight: const Radius.circular(14),
            bottomLeft: Radius.circular(isMine ? 14 : 4),
            bottomRight: Radius.circular(isMine ? 4 : 14),
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(message.content, style: Theme.of(context).textTheme.bodyMedium),
            const SizedBox(height: 4),
            Text(
              '${message.sentAt.hour.toString().padLeft(2, '0')}:${message.sentAt.minute.toString().padLeft(2, '0')}',
              style: TextStyle(
                fontSize: 10,
                color: AppColors.textSecondary.withValues(alpha: 0.8),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _inputBar() {
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 8, 8, 8),
      decoration: BoxDecoration(
        color: AppColors.surface,
        border: Border(top: BorderSide(color: Colors.white.withValues(alpha: 0.08))),
      ),
      child: SafeArea(
        top: false,
        child: Row(
          children: [
            Expanded(
              child: TextField(
                controller: _inputController,
                textInputAction: TextInputAction.send,
                onSubmitted: (_) => _send(),
                decoration: const InputDecoration(
                  hintText: 'Write a message…',
                  border: InputBorder.none,
                ),
              ),
            ),
            IconButton(
              icon: const Icon(Icons.send, color: AppColors.primary),
              onPressed: _send,
            ),
          ],
        ),
      ),
    );
  }
}
