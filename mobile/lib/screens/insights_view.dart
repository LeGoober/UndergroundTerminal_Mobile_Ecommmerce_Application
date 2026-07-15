import 'package:flutter/material.dart';

import '../models/analytics_summary.dart';
import '../services/api_service.dart';
import '../theme/app_theme.dart';

/// Analytics dashboard: platform position at a glance.
/// Charts are painted with CustomPaint — no charting dependency.
class InsightsView extends StatefulWidget {
  const InsightsView({super.key});

  @override
  State<InsightsView> createState() => _InsightsViewState();
}

class _InsightsViewState extends State<InsightsView> {
  final ApiService _apiService = ApiService();
  AnalyticsSummary? _summary;
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
      final summary = await _apiService.getAnalyticsSummary();
      if (mounted) setState(() => _summary = summary);
    } catch (e) {
      if (mounted) setState(() => _error = e.toString());
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_loading) {
      return const Center(child: CircularProgressIndicator());
    }
    final summary = _summary;
    if (_error != null || summary == null) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(32),
          child: Text(
            'Could not load analytics.\nPull down to retry.',
            textAlign: TextAlign.center,
            style: Theme.of(context)
                .textTheme
                .bodyMedium
                ?.copyWith(color: AppColors.textSecondary),
          ),
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: _load,
      color: AppColors.primary,
      child: ListView(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: const EdgeInsets.all(16),
        children: [
          _statGrid(summary),
          const SizedBox(height: 20),
          _panel(
            title: 'Orders — last 7 days',
            child: SizedBox(
              height: 140,
              child: CustomPaint(
                size: Size.infinite,
                painter: _OrdersLinePainter(summary.ordersByDay),
              ),
            ),
          ),
          const SizedBox(height: 16),
          _panel(
            title: 'Stock on hand — top products',
            child: Column(
              children: summary.topStock.map((entry) {
                final maxStock = summary.topStock
                    .map((s) => s.stockLevel)
                    .fold(1, (a, b) => a > b ? a : b);
                return Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Text(
                              entry.name,
                              overflow: TextOverflow.ellipsis,
                              style: Theme.of(context)
                                  .textTheme
                                  .bodySmall
                                  ?.copyWith(color: AppColors.textSecondary),
                            ),
                          ),
                          Text(
                            '${entry.stockLevel}',
                            style: const TextStyle(
                              color: AppColors.primary,
                              fontWeight: FontWeight.w600,
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      ClipRRect(
                        borderRadius: BorderRadius.circular(4),
                        child: LinearProgressIndicator(
                          value: entry.stockLevel / maxStock,
                          minHeight: 8,
                          backgroundColor: AppColors.background,
                          valueColor:
                              const AlwaysStoppedAnimation(AppColors.primary),
                        ),
                      ),
                    ],
                  ),
                );
              }).toList(),
            ),
          ),
          const SizedBox(height: 24),
        ],
      ),
    );
  }

  Widget _statGrid(AnalyticsSummary summary) {
    final stats = [
      ('Revenue', '\$${summary.totalRevenue.toStringAsFixed(0)}'),
      ('Orders', '${summary.totalOrders}'),
      ('Active consignments', '${summary.activeConsignments}'),
      ('Products listed', '${summary.totalProducts}'),
      ('Units in stock', '${summary.totalStockUnits}'),
      ('Low stock alerts', '${summary.lowStockCount}'),
    ];
    return GridView.count(
      crossAxisCount: 2,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      childAspectRatio: 1.9,
      crossAxisSpacing: 12,
      mainAxisSpacing: 12,
      children: stats.map((stat) {
        return Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                stat.$2,
                style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                      color: AppColors.primary,
                      fontSize: 22,
                    ),
              ),
              const SizedBox(height: 2),
              Text(
                stat.$1,
                style: Theme.of(context)
                    .textTheme
                    .bodySmall
                    ?.copyWith(color: AppColors.textSecondary),
              ),
            ],
          ),
        );
      }).toList(),
    );
  }

  Widget _panel({required String title, required Widget child}) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: Theme.of(context)
                .textTheme
                .bodyLarge
                ?.copyWith(fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 16),
          child,
        ],
      ),
    );
  }
}

/// Single-series line chart of orders per day, brand gold on dark.
class _OrdersLinePainter extends CustomPainter {
  final List<DayOrders> data;

  _OrdersLinePainter(this.data);

  @override
  void paint(Canvas canvas, Size size) {
    if (data.isEmpty) return;

    const padLeft = 8.0, padRight = 8.0, padTop = 8.0, padBottom = 22.0;
    final chartWidth = size.width - padLeft - padRight;
    final chartHeight = size.height - padTop - padBottom;
    final maxOrders =
        data.map((d) => d.orders).fold(1, (a, b) => a > b ? a : b);

    final stepX = data.length > 1 ? chartWidth / (data.length - 1) : chartWidth;
    double xOf(int i) => padLeft + i * stepX;
    double yOf(int orders) =>
        padTop + chartHeight * (1 - orders / maxOrders);

    // Recessive gridline at zero
    final gridPaint = Paint()
      ..color = AppColors.textSecondary.withValues(alpha: 0.15)
      ..strokeWidth = 1;
    canvas.drawLine(
      Offset(padLeft, padTop + chartHeight),
      Offset(size.width - padRight, padTop + chartHeight),
      gridPaint,
    );

    // Series line
    final linePaint = Paint()
      ..color = AppColors.primary
      ..strokeWidth = 2
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;
    final path = Path();
    for (var i = 0; i < data.length; i++) {
      final point = Offset(xOf(i), yOf(data[i].orders));
      if (i == 0) {
        path.moveTo(point.dx, point.dy);
      } else {
        path.lineTo(point.dx, point.dy);
      }
    }
    canvas.drawPath(path, linePaint);

    // Day labels + value labels on first/peak/last points
    final peakIndex = data.indexWhere(
        (d) => d.orders == data.map((e) => e.orders).reduce((a, b) => a > b ? a : b));
    for (var i = 0; i < data.length; i++) {
      final dayLabel = data[i].date.length >= 10 ? data[i].date.substring(8) : data[i].date;
      _drawText(canvas, dayLabel, Offset(xOf(i), size.height - 12),
          color: AppColors.textSecondary, fontSize: 9, center: true);
      if (i == 0 || i == data.length - 1 || i == peakIndex) {
        canvas.drawCircle(Offset(xOf(i), yOf(data[i].orders)), 3.5,
            Paint()..color = AppColors.primary);
        _drawText(canvas, '${data[i].orders}',
            Offset(xOf(i), yOf(data[i].orders) - 14),
            color: AppColors.primary, fontSize: 10, center: true);
      }
    }
  }

  void _drawText(Canvas canvas, String text, Offset position,
      {required Color color, required double fontSize, bool center = false}) {
    final painter = TextPainter(
      text: TextSpan(
        text: text,
        style: TextStyle(color: color, fontSize: fontSize),
      ),
      textDirection: TextDirection.ltr,
    )..layout();
    painter.paint(
      canvas,
      center ? position - Offset(painter.width / 2, 0) : position,
    );
  }

  @override
  bool shouldRepaint(_OrdersLinePainter oldDelegate) =>
      oldDelegate.data != data;
}
