import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:rescuelink/core/constants/enums.dart';
import 'package:rescuelink/core/theme/app_theme.dart';
import 'package:rescuelink/features/incidents/domain/incident_model.dart';
import 'package:rescuelink/generated/l10n/app_localizations.dart';

class IncidentCard extends StatelessWidget {
  const IncidentCard({super.key, required this.incident});

  final IncidentModel incident;

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

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final dateStr = DateFormat.yMMMd().add_Hm().format(incident.createdAt);
    final priorityColor = _getPriorityColor(incident.priority);

    return Semantics(
      label: l10n.semanticIncidentCard(
        incident.category.name,
        incident.priority.name,
        incident.status.name,
      ),
      button: true,
      child: Card(
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
        child: ListTile(
          onTap: () => context.go('/incidents/${incident.id}'),
          leading: CircleAvatar(
            backgroundColor: priorityColor.withValues(alpha: 0.15),
            child: Icon(
              Icons.warning_amber_rounded,
              color: priorityColor,
            ),
          ),
          title: Text(
            incident.description,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          subtitle: Text(
            '${incident.category.name.toUpperCase()} • $dateStr',
            style: Theme.of(context).textTheme.bodySmall,
          ),
          trailing: Chip(
            padding: EdgeInsets.zero,
            label: Text(
              incident.status.name,
              style: TextStyle(
                fontSize: 11,
                color: priorityColor,
                fontWeight: FontWeight.bold,
              ),
            ),
            backgroundColor: priorityColor.withValues(alpha: 0.1),
            side: BorderSide.none,
          ),
        ),
      ),
    );
  }
}
