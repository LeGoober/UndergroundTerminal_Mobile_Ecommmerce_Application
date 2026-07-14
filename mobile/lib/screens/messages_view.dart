import 'package:flutter/material.dart';

import '../models/message.dart';
import '../models/user.dart';
import '../services/api_service.dart';
import '../theme/app_theme.dart';
import 'chat_screen.dart';

/// Conversation list plus a directory picker for starting new chats.
class MessagesView extends StatefulWidget {
  final User currentUser;

  const MessagesView({super.key, required this.currentUser});

  @override
  State<MessagesView> createState() => _MessagesViewState();
}

class _MessagesViewState extends State<MessagesView> {
  final ApiService _apiService = ApiService();
  List<Message> _conversations = [];
  bool _loading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    setState(() {
      _loading = true;
      _error = null;
    });
    try {
      final conversations = await _apiService.getConversations();
      if (mounted) setState(() => _conversations = conversations);
    } catch (e) {
      if (mounted) setState(() => _error = e.toString());
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  Future<void> _openChat(int partnerId, String partnerName) async {
    await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => ChatScreen(
          currentUser: widget.currentUser,
          partnerId: partnerId,
          partnerName: partnerName,
        ),
      ),
    );
    _load();
  }

  Future<void> _startNewChat() async {
    List<User> users;
    try {
      users = await _apiService.getUsers();
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Could not load directory: $e')),
        );
      }
      return;
    }
    if (!mounted) return;

    final contacts = users.where((u) => u.id != widget.currentUser.id).toList();
    showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.background,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(24, 24, 24, 8),
              child: Text('New message', style: Theme.of(context).textTheme.headlineMedium),
            ),
            Expanded(
              child: ListView.builder(
                itemCount: contacts.length,
                itemBuilder: (context, index) {
                  final contact = contacts[index];
                  return ListTile(
                    leading: CircleAvatar(
                      backgroundColor: AppColors.surface,
                      backgroundImage: contact.imageUrl != null
                          ? NetworkImage(contact.imageUrl!)
                          : null,
                      child: contact.imageUrl == null
                          ? Text(
                              contact.name.isNotEmpty ? contact.name[0] : '?',
                              style: const TextStyle(color: AppColors.primary),
                            )
                          : null,
                    ),
                    title: Text(contact.name),
                    subtitle: Text(
                      contact.role.name.toUpperCase(),
                      style: const TextStyle(
                        color: AppColors.textSecondary,
                        fontSize: 11,
                        letterSpacing: 1,
                      ),
                    ),
                    onTap: () {
                      Navigator.pop(context);
                      _openChat(contact.id, contact.name);
                    },
                  );
                },
              ),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      floatingActionButton: FloatingActionButton(
        onPressed: _startNewChat,
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.black,
        child: const Icon(Icons.edit_outlined),
      ),
      body: _buildBody(),
    );
  }

  Widget _buildBody() {
    if (_loading) {
      return const Center(child: CircularProgressIndicator());
    }
    if (_error != null) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(32),
          child: Text(
            'Could not load conversations.\nPull down to retry.',
            textAlign: TextAlign.center,
            style: Theme.of(context)
                .textTheme
                .bodyMedium
                ?.copyWith(color: AppColors.textSecondary),
          ),
        ),
      );
    }
    if (_conversations.isEmpty) {
      return Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.forum_outlined,
                size: 56, color: AppColors.textSecondary.withValues(alpha: 0.5)),
            const SizedBox(height: 16),
            Text('No conversations yet', style: Theme.of(context).textTheme.headlineMedium),
            const SizedBox(height: 8),
            Text(
              'Message a supplier, buyer or designer to start trading.',
              style: Theme.of(context)
                  .textTheme
                  .bodyMedium
                  ?.copyWith(color: AppColors.textSecondary),
            ),
          ],
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: _load,
      color: AppColors.primary,
      child: ListView.builder(
        physics: const AlwaysScrollableScrollPhysics(),
        itemCount: _conversations.length,
        itemBuilder: (context, index) {
          final message = _conversations[index];
          final partnerId = message.partnerId(widget.currentUser.id);
          final partnerName = message.partnerName(widget.currentUser.id);
          final isMine = message.senderId == widget.currentUser.id;
          return ListTile(
            leading: CircleAvatar(
              backgroundColor: AppColors.surface,
              child: Text(
                partnerName.isNotEmpty ? partnerName[0] : '?',
                style: const TextStyle(color: AppColors.primary),
              ),
            ),
            title: Text(partnerName),
            subtitle: Text(
              '${isMine ? 'You: ' : ''}${message.content}',
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(color: AppColors.textSecondary),
            ),
            trailing: Text(
              _timeLabel(message.sentAt),
              style: const TextStyle(color: AppColors.textSecondary, fontSize: 11),
            ),
            onTap: () => _openChat(partnerId, partnerName),
          );
        },
      ),
    );
  }

  static String _timeLabel(DateTime time) {
    final now = DateTime.now();
    final difference = now.difference(time);
    if (difference.inMinutes < 1) return 'now';
    if (difference.inHours < 1) return '${difference.inMinutes}m';
    if (difference.inDays < 1) return '${difference.inHours}h';
    return '${time.day}/${time.month}';
  }
}
