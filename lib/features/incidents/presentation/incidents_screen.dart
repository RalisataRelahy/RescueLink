import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rescuelink/core/constants/enums.dart';
import 'package:rescuelink/core/widgets/app_state_widgets.dart';
import 'package:rescuelink/features/incidents/presentation/providers/incident_providers.dart';
import 'package:rescuelink/features/incidents/presentation/widgets/incident_card.dart';
import 'package:rescuelink/generated/l10n/app_localizations.dart';

class IncidentsScreen extends ConsumerStatefulWidget {
  const IncidentsScreen({super.key});

  @override
  ConsumerState<IncidentsScreen> createState() => _IncidentsScreenState();
}

class _IncidentsScreenState extends ConsumerState<IncidentsScreen> {
  final _searchController = TextEditingController();
  Timer? _debounceTimer;

  IncidentCategory? _selectedCategory;
  IncidentPriority? _selectedPriority;
  String _searchQuery = '';

  @override
  void dispose() {
    _searchController.dispose();
    _debounceTimer?.cancel();
    super.dispose();
  }

  void _onSearchChanged(String query) {
    _debounceTimer?.cancel();
    _debounceTimer = Timer(const Duration(milliseconds: 300), () {
      setState(() => _searchQuery = query.toLowerCase().trim());
    });
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final incidentsAsync = ref.watch(
      incidentListProvider((category: _selectedCategory, priority: _selectedPriority)),
    );

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.incidentTitle),
      ),
      body: Column(
        children: [
          // Search & Filter Bar
          Padding(
            padding: const EdgeInsets.all(12),
            child: TextField(
              controller: _searchController,
              onChanged: _onSearchChanged,
              decoration: InputDecoration(
                hintText: l10n.actionSearch,
                prefixIcon: const Icon(Icons.search),
                suffixIcon: _searchController.text.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.clear),
                        onPressed: () {
                          _searchController.clear();
                          _onSearchChanged('');
                        },
                      )
                    : null,
                contentPadding: const EdgeInsets.symmetric(horizontal: 16),
              ),
            ),
          ),

          // Filters Row
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: Row(
              children: [
                // Category Filter Chip
                DropdownButton<IncidentCategory?>(
                  hint: Text(l10n.mapFilterCategory),
                  value: _selectedCategory,
                  items: [
                    DropdownMenuItem(value: null, child: Text(l10n.mapAllCategories)),
                    ...IncidentCategory.values.map(
                      (cat) => DropdownMenuItem(value: cat, child: Text(cat.name.toUpperCase())),
                    ),
                  ],
                  onChanged: (val) => setState(() => _selectedCategory = val),
                ),
                const SizedBox(width: 12),

                // Priority Filter Chip
                DropdownButton<IncidentPriority?>(
                  hint: Text(l10n.mapFilterPriority),
                  value: _selectedPriority,
                  items: [
                    DropdownMenuItem(value: null, child: Text(l10n.mapAllPriorities)),
                    ...IncidentPriority.values.map(
                      (pri) => DropdownMenuItem(value: pri, child: Text(pri.name.toUpperCase())),
                    ),
                  ],
                  onChanged: (val) => setState(() => _selectedPriority = val),
                ),
              ],
            ),
          ),
          const Divider(),

          // Incidents List
          Expanded(
            child: incidentsAsync.when(
              loading: () => const AppLoadingIndicator(),
              error: (err, stack) => AppErrorWidget(
                message: err.toString(),
                onRetry: () => ref.invalidate(
                  incidentListProvider((category: _selectedCategory, priority: _selectedPriority)),
                ),
              ),
              data: (incidents) {
                final filtered = _searchQuery.isEmpty
                    ? incidents
                    : incidents.where((inc) => inc.description.toLowerCase().contains(_searchQuery)).toList();

                if (filtered.isEmpty) {
                  return AppEmptyWidget(message: l10n.stateEmpty);
                }

                return RefreshIndicator(
                  onRefresh: () async => ref.invalidate(
                    incidentListProvider((category: _selectedCategory, priority: _selectedPriority)),
                  ),
                  child: ListView.builder(
                    itemCount: filtered.length,
                    itemBuilder: (context, index) {
                      final incident = filtered[index];
                      return IncidentCard(incident: incident);
                    },
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
