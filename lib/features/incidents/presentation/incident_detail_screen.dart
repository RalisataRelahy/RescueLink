import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:rescuelink/core/constants/enums.dart';
import 'package:rescuelink/core/theme/app_theme.dart';
import 'package:rescuelink/core/widgets/app_state_widgets.dart';
import 'package:rescuelink/features/incidents/domain/incident_model.dart';
import 'package:rescuelink/features/incidents/presentation/providers/incident_providers.dart';
import 'package:rescuelink/generated/l10n/app_localizations.dart';

class IncidentDetailScreen extends ConsumerWidget {
  const IncidentDetailScreen({super.key, required this.id});

  final String id;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final incidentsAsync = ref.watch(incidentListProvider((category: null, priority: null)));

    return Scaffold(
      appBar: AppBar(title: Text(l10n.incidentTitle)),
      body: incidentsAsync.when(
        loading: () => const AppLoadingIndicator(),
        error: (err, s) => AppErrorWidget(message: err.toString()),
        data: (incidents) {
          final incident = incidents.firstWhere(
            (inc) => inc.id == id,
            orElse: () => IncidentModel(
              id: id,
              userId: 'unknown',
              category: IncidentCategory.other,
              description: 'Incident details unavailable',
              latitude: 0,
              longitude: 0,
              priority: IncidentPriority.low,
              status: IncidentStatus.reported,
              createdAt: DateTime.now(),
            ),
          );

          final historyAsync = ref.watch(incidentHistoryProvider(id));

          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header card
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Chip(
                              label: Text(
                                incident.category.name.toUpperCase(),
                                style: const TextStyle(fontWeight: FontWeight.bold),
                              ),
                              backgroundColor: AppColors.primary.withValues(alpha: 0.15),
                            ),
                            const Spacer(),
                            Chip(
                              label: Text(
                                incident.priority.name.toUpperCase(),
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              backgroundColor: _getPriorityColor(incident.priority),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        Text(
                          incident.description,
                          style: Theme.of(context).textTheme.titleLarge,
                        ),
                        const SizedBox(height: 12),
                        Text(
                          '${l10n.incidentDate}: ${DateFormat.yMMMd().add_Hm().format(incident.createdAt)}',
                          style: Theme.of(context).textTheme.bodySmall,
                        ),
                        const SizedBox(height: 4),
                        Text(
                          '${l10n.incidentLocation}: ${incident.latitude.toStringAsFixed(4)}, ${incident.longitude.toStringAsFixed(4)}',
                          style: Theme.of(context).textTheme.bodySmall,
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 16),

                // Photo section
                if (incident.photoUrl != null) ...[
                  ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: Image.network(
                      incident.photoUrl!,
                      height: 200,
                      width: double.infinity,
                      fit: BoxFit.cover,
                      errorBuilder: (ctx, err, stack) => const Icon(Icons.broken_image, size: 64),
                    ),
                  ),
                  const SizedBox(height: 16),
                ],

                // Timeline Section
                Text(
                  l10n.incidentHistory,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                ),
                const SizedBox(height: 8),

                historyAsync.when(
                  loading: () => const AppLoadingIndicator(),
                  error: (err, stack) => const SizedBox.shrink(),
                  data: (historyList) {
                    if (historyList.isEmpty) {
                      return _TimelineTile(
                        status: incident.status,
                        date: incident.createdAt,
                        isFirst: true,
                        isLast: true,
                      );
                    }

                    return Column(
                      children: List.generate(historyList.length, (index) {
                        final item = historyList[index];
                        return _TimelineTile(
                          status: item.status,
                          date: item.updatedAt,
                          comment: item.comment,
                          isFirst: index == 0,
                          isLast: index == historyList.length - 1,
                        );
                      }),
                    );
                  },
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Color _getPriorityColor(IncidentPriority priority) {
    switch (priority) {
      case IncidentPriority.critical:
        return AppColors.critical;
      case IncidentPriority.high:
        return AppColors.high;
      case IncidentPriority.medium:
        return AppColors.medium;
      case IncidentPriority.low:
        return AppColors.low;
    }
  }
}

class _TimelineTile extends StatelessWidget {
  const _TimelineTile({
    required this.status,
    required this.date,
    this.comment,
    this.isFirst = false,
    this.isLast = false,
  });

  final IncidentStatus status;
  final DateTime date;
  final String? comment;
  final bool isFirst;
  final bool isLast;

  @override
  Widget build(BuildContext context) {
    final dateStr = DateFormat.yMMMd().add_Hm().format(date);

    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Indicator column
          Column(
            children: [
              Container(
                width: 16,
                height: 16,
                decoration: const BoxDecoration(
                  color: AppColors.primary,
                  shape: BoxShape.circle,
                ),
              ),
              if (!isLast)
                Expanded(
                  child: Container(
                    width: 2,
                    color: AppColors.primary.withValues(alpha: 0.3),
                  ),
                ),
            ],
          ),
          const SizedBox(width: 16),

          // Content column
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(bottom: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    status.name.toUpperCase(),
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  Text(dateStr, style: Theme.of(context).textTheme.bodySmall),
                  if (comment != null) ...[
                    const SizedBox(height: 4),
                    Text(comment!),
                  ],
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
