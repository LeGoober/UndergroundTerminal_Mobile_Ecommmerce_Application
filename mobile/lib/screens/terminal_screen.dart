import 'package:flutter/material.dart';

import '../models/user.dart';
import '../services/auth_service.dart';
import '../theme/app_theme.dart';
import 'insights_view.dart';
import 'logistics_view.dart';
import 'messages_view.dart';

/// Operations hub: the business-facing side of the app.
/// Three tabs — Logistics (consignment tracking), Messages
/// (client/business chat), and Insights (analytics dashboard).
class TerminalScreen extends StatefulWidget {
  const TerminalScreen({super.key});

  @override
  State<TerminalScreen> createState() => _TerminalScreenState();
}

class _TerminalScreenState extends State<TerminalScreen> {
  final AuthService _authService = AuthService();
  User? _currentUser;
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _loadUser();
  }

  Future<void> _loadUser() async {
    final user = await _authService.getCurrentUser();
    if (mounted) {
      setState(() {
        _currentUser = user;
        _loading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_loading) {
      return const Scaffold(
        backgroundColor: AppColors.background,
        body: Center(child: CircularProgressIndicator()),
      );
    }

    final user = _currentUser;
    if (user == null) {
      return Scaffold(
        backgroundColor: AppColors.background,
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(32),
            child: Text(
              'Sign in to access the Terminal — logistics, messaging and insights.',
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    color: AppColors.textSecondary,
                  ),
            ),
          ),
        ),
      );
    }

    return DefaultTabController(
      length: 3,
      child: Scaffold(
        backgroundColor: AppColors.background,
        appBar: AppBar(
          backgroundColor: AppColors.background,
          elevation: 0,
          title: Text(
            'Terminal',
            style: Theme.of(context).textTheme.headlineMedium?.copyWith(fontSize: 20),
          ),
          bottom: const TabBar(
            indicatorColor: AppColors.primary,
            labelColor: AppColors.primary,
            unselectedLabelColor: AppColors.textSecondary,
            tabs: [
              Tab(icon: Icon(Icons.local_shipping_outlined), text: 'Logistics'),
              Tab(icon: Icon(Icons.forum_outlined), text: 'Messages'),
              Tab(icon: Icon(Icons.insights_outlined), text: 'Insights'),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            LogisticsView(currentUser: user),
            MessagesView(currentUser: user),
            const InsightsView(),
          ],
        ),
      ),
    );
  }
}
