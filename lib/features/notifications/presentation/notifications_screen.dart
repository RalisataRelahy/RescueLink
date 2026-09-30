import 'package:flutter/material.dart';
import 'package:rescuelink/core/widgets/app_state_widgets.dart';
import 'package:rescuelink/generated/l10n/app_localizations.dart';

class NotificationItem {
  const NotificationItem({
    required this.id,
    required this.title,
    required this.body,
    required this.timestamp,
  });

  final String id;
  final String title;
  final String body;
  final DateTime timestamp;
}

class NotificationsScreen extends StatelessWidget {
  const NotificationsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    // Mock initial notification list (ready for Supabase notifications query)
    final notifications = <NotificationItem>[
      NotificationItem(
        id: '1',
        title: l10n.notifIncidentReceived,
        body: l10n.stateSyncPending,
        timestamp: DateTime.now().subtract(const Duration(minutes: 5)),
      ),
      NotificationItem(
        id: '2',
        title: l10n.notifSyncComplete,
        body: l10n.stateSynced,
        timestamp: DateTime.now().subtract(const Duration(hours: 1)),
      ),
    ];

    return Scaffold(
      appBar: AppBar(title: Text(l10n.notifTitle)),
      body: notifications.isEmpty
          ? AppEmptyWidget(message: l10n.stateEmpty)
          : ListView.separated(
              itemCount: notifications.length,
              separatorBuilder: (context, index) => const Divider(height: 1),
              itemBuilder: (context, index) {
                final item = notifications[index];
                return ListTile(
                  leading: const CircleAvatar(
                    child: Icon(Icons.notifications_active_outlined),
                  ),
                  title: Text(item.title, style: const TextStyle(fontWeight: FontWeight.bold)),
                  subtitle: Text(item.body),
                  trailing: Text(
                    '${item.timestamp.hour}:${item.timestamp.minute.toString().padLeft(2, '0')}',
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                );
              },
            ),
    );
  }
}
