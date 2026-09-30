import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:rescuelink/core/widgets/app_state_widgets.dart';
import 'package:rescuelink/features/incidents/presentation/providers/dashboard_provider.dart';
import 'package:rescuelink/features/incidents/presentation/widgets/incident_card.dart';
import 'package:rescuelink/generated/l10n/app_localizations.dart';

class DashboardScreen extends ConsumerWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final statsAsync = ref.watch(dashboardStatsProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.dashboardTitle),
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications_outlined),
            onPressed: () => context.push('/notifications'),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => context.push('/incidents/create'),
        icon: const Icon(Icons.add_alert),
        label: Text(l10n.incidentCreate),
      ),
      body: statsAsync.when(
        loading: () => const AppLoadingIndicator(),
        error: (err, stack) => AppErrorWidget(
          message: err.toString(),
          onRetry: () => ref.invalidate(dashboardStatsProvider),
        ),
        data: (stats) {
          return RefreshIndicator(
            onRefresh: () async => ref.invalidate(dashboardStatsProvider),
            child: ListView(
              padding: const EdgeInsets.symmetric(vertical: 16),
              children: [
                // Risk Score Banner
                _RiskScoreCard(score: stats.riskScore),
                const SizedBox(height: 16),

                // Metrics Grid
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: GridView.count(
                    crossAxisCount: 2,
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    mainAxisSpacing: 12,
                    crossAxisSpacing: 12,
                    childAspectRatio: 1.5,
                    children: [
                      _StatCard(
                        title: l10n.dashboardTotal,
                        value: stats.total.toString(),
                        icon: Icons.list_alt,
                        color: Colors.blue,
                      ),
                      _StatCard(
                        title: l10n.dashboardActive,
                        value: stats.active.toString(),
                        icon: Icons.pending_actions,
                        color: Colors.orange,
                      ),
                      _StatCard(
                        title: l10n.dashboardResolved,
                        value: stats.resolved.toString(),
                        icon: Icons.check_circle_outline,
                        color: Colors.green,
                      ),
                      _StatCard(
                        title: l10n.dashboardCritical,
                        value: stats.critical.toString(),
                        icon: Icons.warning_amber,
                        color: Colors.red,
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),

                // Recent Incidents Header
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        l10n.dashboardRecentIncidents,
                        style: Theme.of(context).textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                      ),
                      TextButton(
                        onPressed: () => context.go('/incidents'),
                        child: const Icon(Icons.arrow_forward),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 8),

                // Recent Incidents List
                if (stats.recentIncidents.isEmpty)
                  AppEmptyWidget(message: l10n.dashboardNoRecent)
                else
                  ...stats.recentIncidents
                      .map((inc) => IncidentCard(incident: inc)),
              ],
            ),
          );
        },
      ),
    );
  }
}

class _RiskScoreCard extends StatelessWidget {
  const _RiskScoreCard({required this.score});

  final int score;

  Color _getRiskColor() {
    if (score >= 80) return Colors.red;
    if (score >= 60) return Colors.orange;
    if (score >= 30) return Colors.amber.shade700;
    return Colors.green;
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final color = _getRiskColor();

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      color: color.withValues(alpha: 0.12),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: color,
                shape: BoxShape.circle,
              ),
              child: Text(
                '$score',
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                ),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    l10n.dashboardRiskScore,
                    style: Theme.of(context).textTheme.titleSmall?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                  const SizedBox(height: 4),
                  LinearProgressIndicator(
                    value: score / 100,
                    backgroundColor: color.withValues(alpha: 0.2),
                    color: color,
                    minHeight: 6,
                    borderRadius: BorderRadius.circular(3),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _StatCard extends StatelessWidget {
  const _StatCard({
    required this.title,
    required this.value,
    required this.icon,
    required this.color,
  });

  final String title;
  final String value;
  final IconData icon;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(icon, color: color, size: 20),
                const Spacer(),
                Text(
                  value,
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: color,
                      ),
                ),
              ],
            ),
            const Spacer(),
            Text(
              title,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: Theme.of(context).textTheme.bodySmall,
            ),
          ],
        ),
      ),
    );
  }
}
