import 'package:flutter/material.dart';

import '../models/consignment.dart';
import '../models/user.dart';
import '../services/api_service.dart';
import '../theme/app_theme.dart';

/// Consignment tracking: buyers/designers follow incoming stock,
/// suppliers advance shipment status.
class LogisticsView extends StatefulWidget {
  final User currentUser;

  const LogisticsView({super.key, required this.currentUser});

  @override
  State<LogisticsView> createState() => _LogisticsViewState();
}

class _LogisticsViewState extends State<LogisticsView> {
  final ApiService _apiService = ApiService();
  List<Consignment> _consignments = [];
  bool _loading = true;
  String? _error;

  static const Map<String, Color> _statusColors = {
    'PREPARING': AppColors.textSecondary,
    'IN_TRANSIT': Color(0xFF5B9BD5),
    'CUSTOMS': Color(0xFFE2953F),
    'DELIVERED': Color(0xFF58B87E),
    'DELAYED': AppColors.error,
  };

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
      final consignments = await _apiService.getMyConsignments();
      if (mounted) setState(() => _consignments = consignments);
    } catch (e) {
      if (mounted) setState(() => _error = e.toString());
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  Future<void> _advance(Consignment consignment) async {
    final next = consignment.nextStatus;
    if (next == null) return;
    try {
      await _apiService.advanceConsignmentStatus(
        consignment.id,
        next,
        note: 'Status advanced by ${widget.currentUser.name}',
      );
      await _load();
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('${consignment.reference} moved to ${_label(next)}'),
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('$e'), behavior: SnackBarBehavior.floating),
        );
      }
    }
  }

  static String _label(String status) => status.replaceAll('_', ' ');

  @override
  Widget build(BuildContext context) {
    if (_loading) {
      return const Center(child: CircularProgressIndicator());
    }
    if (_error != null) {
      return _MessageState(
        icon: Icons.cloud_off,
        title: 'Could not load consignments',
        subtitle: 'Check your connection and pull to retry.',
        onRefresh: _load,
      );
    }
    if (_consignments.isEmpty) {
      return _MessageState(
        icon: Icons.local_shipping_outlined,
        title: 'No consignments yet',
        subtitle: widget.currentUser.isSupplier
            ? 'Consignments open automatically when buyers order your products.'
            : 'Place an order and its consignment will appear here for tracking.',
        onRefresh: _load,
      );
    }

    return RefreshIndicator(
      onRefresh: _load,
      color: AppColors.primary,
      child: ListView.builder(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: const EdgeInsets.all(16),
        itemCount: _consignments.length,
        itemBuilder: (context, index) => _consignmentCard(_consignments[index]),
      ),
    );
  }

  Widget _consignmentCard(Consignment consignment) {
    final statusColor = _statusColors[consignment.status] ?? AppColors.textSecondary;
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: () => _showTimeline(consignment),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Text(
                    consignment.reference,
                    style: const TextStyle(
                      color: AppColors.primary,
                      fontWeight: FontWeight.w600,
                      letterSpacing: 1.2,
                    ),
                  ),
                  const Spacer(),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: statusColor.withValues(alpha: 0.12),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.circle, size: 8, color: statusColor),
                        const SizedBox(width: 6),
                        Text(
                          _label(consignment.status),
                          style: TextStyle(
                            color: statusColor,
                            fontSize: 11,
                            fontWeight: FontWeight.w600,
                            letterSpacing: 0.6,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  const Icon(Icons.route_outlined, size: 16, color: AppColors.textSecondary),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      '${consignment.origin}  →  ${consignment.destination}',
                      style: Theme.of(context).textTheme.bodyMedium,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
              if (consignment.eta != null) ...[
                const SizedBox(height: 6),
                Row(
                  children: [
                    const Icon(Icons.schedule, size: 16, color: AppColors.textSecondary),
                    const SizedBox(width: 8),
                    Text(
                      'ETA ${_formatDate(consignment.eta!)}',
                      style: Theme.of(context)
                          .textTheme
                          .bodySmall
                          ?.copyWith(color: AppColors.textSecondary),
                    ),
                  ],
                ),
              ],
              if (widget.currentUser.isSupplier && consignment.nextStatus != null) ...[
                const SizedBox(height: 12),
                Align(
                  alignment: Alignment.centerRight,
                  child: OutlinedButton.icon(
                    onPressed: () => _advance(consignment),
                    icon: const Icon(Icons.arrow_forward, size: 16),
                    label: Text('Advance to ${_label(consignment.nextStatus!)}'),
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  void _showTimeline(Consignment consignment) {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.background,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                consignment.reference,
                style: Theme.of(context)
                    .textTheme
                    .headlineMedium
                    ?.copyWith(color: AppColors.primary),
              ),
              const SizedBox(height: 4),
              Text(
                '${consignment.origin} → ${consignment.destination} · Order #${consignment.orderId}',
                style: Theme.of(context)
                    .textTheme
                    .bodySmall
                    ?.copyWith(color: AppColors.textSecondary),
              ),
              const SizedBox(height: 20),
              Flexible(
                child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: consignment.events.length,
                  itemBuilder: (context, index) {
                    final event = consignment.events[index];
                    final isLast = index == consignment.events.length - 1;
                    final color = _statusColors[event.status] ?? AppColors.textSecondary;
                    return IntrinsicHeight(
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Column(
                            children: [
                              Icon(Icons.circle, size: 10, color: color),
                              if (!isLast)
                                Expanded(
                                  child: Container(
                                    width: 2,
                                    color: AppColors.surface,
                                  ),
                                ),
                            ],
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Padding(
                              padding: const EdgeInsets.only(bottom: 16),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    _label(event.status),
                                    style: TextStyle(
                                      color: color,
                                      fontWeight: FontWeight.w600,
                                      fontSize: 13,
                                    ),
                                  ),
                                  if (event.note != null && event.note!.isNotEmpty)
                                    Text(
                                      event.note!,
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodySmall
                                          ?.copyWith(color: AppColors.textSecondary),
                                    ),
                                  Text(
                                    _formatDate(event.timestamp),
                                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                          color: AppColors.textSecondary
                                              .withValues(alpha: 0.7),
                                          fontSize: 11,
                                        ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  static String _formatDate(DateTime date) {
    return '${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}/${date.year} '
        '${date.hour.toString().padLeft(2, '0')}:${date.minute.toString().padLeft(2, '0')}';
  }
}

class _MessageState extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final Future<void> Function() onRefresh;

  const _MessageState({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onRefresh,
  });

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: onRefresh,
      color: AppColors.primary,
      child: ListView(
        physics: const AlwaysScrollableScrollPhysics(),
        children: [
          SizedBox(height: MediaQuery.of(context).size.height * 0.22),
          Icon(icon, size: 56, color: AppColors.textSecondary.withValues(alpha: 0.5)),
          const SizedBox(height: 16),
          Text(title, textAlign: TextAlign.center, style: Theme.of(context).textTheme.headlineMedium),
          const SizedBox(height: 8),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 40),
            child: Text(
              subtitle,
              textAlign: TextAlign.center,
              style: Theme.of(context)
                  .textTheme
                  .bodyMedium
                  ?.copyWith(color: AppColors.textSecondary),
            ),
          ),
        ],
      ),
    );
  }
}
