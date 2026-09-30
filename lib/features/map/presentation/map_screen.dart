import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:latlong2/latlong.dart';
import 'package:rescuelink/core/constants/app_constants.dart';
import 'package:rescuelink/core/constants/enums.dart';
import 'package:rescuelink/core/theme/app_theme.dart';
import 'package:rescuelink/core/utils/location_helper.dart';
import 'package:rescuelink/core/widgets/app_state_widgets.dart';
import 'package:rescuelink/features/incidents/presentation/providers/incident_providers.dart';
import 'package:rescuelink/generated/l10n/app_localizations.dart';

class MapScreen extends ConsumerStatefulWidget {
  const MapScreen({super.key});

  @override
  ConsumerState<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends ConsumerState<MapScreen> {
  final MapController _mapController = MapController();

  IncidentCategory? _selectedCategory;
  IncidentPriority? _selectedPriority;
  LatLng? _userLocation;
  bool _isLoadingUserLocation = false;

  @override
  void initState() {
    super.initState();
    _fetchUserLocation();
  }

  Future<void> _fetchUserLocation() async {
    setState(() => _isLoadingUserLocation = true);
    try {
      final pos = await LocationHelper.getCurrentPosition();
      final latLng = LatLng(pos.latitude, pos.longitude);
      setState(() => _userLocation = latLng);
      _mapController.move(latLng, AppConstants.defaultZoom);
    } catch (_) {
    } finally {
      if (mounted) setState(() => _isLoadingUserLocation = false);
    }
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

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final incidentsAsync = ref.watch(
      incidentListProvider((category: _selectedCategory, priority: _selectedPriority)),
    );

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.mapTitle),
        actions: [
          IconButton(
            icon: _isLoadingUserLocation
                ? const SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                : const Icon(Icons.my_location),
            onPressed: _fetchUserLocation,
          ),
        ],
      ),
      body: Stack(
        children: [
          incidentsAsync.when(
            loading: () => const AppLoadingIndicator(),
            error: (err, _) => AppErrorWidget(message: err.toString()),
            data: (incidents) {
              final initialCenter = _userLocation ??
                  (incidents.isNotEmpty
                      ? LatLng(incidents.first.latitude, incidents.first.longitude)
                      : const LatLng(48.8566, 2.3522)); // Default Paris

              final criticalIncidents = incidents
                  .where((i) => i.priority == IncidentPriority.critical)
                  .toList();

              return FlutterMap(
                mapController: _mapController,
                options: MapOptions(
                  initialCenter: initialCenter,
                  initialZoom: AppConstants.defaultZoom,
                ),
                children: [
                  TileLayer(
                    urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                    userAgentPackageName: 'com.rescuelink.app',
                  ),

                  // Risk Zones Heat Circle Layer (Critical areas)
                  CircleLayer(
                    circles: criticalIncidents.map((inc) {
                      return CircleMarker(
                        point: LatLng(inc.latitude, inc.longitude),
                        radius: 600,
                        useRadiusInMeter: true,
                        color: Colors.red.withValues(alpha: 0.25),
                        borderColor: Colors.red,
                        borderStrokeWidth: 1.5,
                      );
                    }).toList(),
                  ),

                  // Incident Markers Layer
                  MarkerLayer(
                    markers: [
                      // User position marker
                      if (_userLocation != null)
                        Marker(
                          point: _userLocation!,
                          width: 40,
                          height: 40,
                          child: const Icon(
                            Icons.my_location,
                            color: Colors.blue,
                            size: 30,
                          ),
                        ),

                      // Incident Markers
                      ...incidents.map((incident) {
                        final color = _getPriorityColor(incident.priority);
                        return Marker(
                          point: LatLng(incident.latitude, incident.longitude),
                          width: 44,
                          height: 44,
                          child: GestureDetector(
                            onTap: () => context.go('/incidents/${incident.id}'),
                            child: Tooltip(
                              message: incident.description,
                              child: CircleAvatar(
                                backgroundColor: color,
                                child: const Icon(
                                  Icons.warning_amber_rounded,
                                  color: Colors.white,
                                  size: 24,
                                ),
                              ),
                            ),
                          ),
                        );
                      }),
                    ],
                  ),
                ],
              );
            },
          ),

          // Top Filter Bar Overlay
          Positioned(
            top: 12,
            left: 12,
            right: 12,
            child: Card(
              elevation: 4,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                child: Row(
                  children: [
                    Expanded(
                      child: DropdownButton<IncidentCategory?>(
                        isExpanded: true,
                        underline: const SizedBox.shrink(),
                        hint: Text(l10n.mapFilterCategory),
                        value: _selectedCategory,
                        items: [
                          DropdownMenuItem(
                            value: null,
                            child: Text(l10n.mapAllCategories),
                          ),
                          ...IncidentCategory.values.map(
                            (c) => DropdownMenuItem(
                              value: c,
                              child: Text(c.name.toUpperCase()),
                            ),
                          ),
                        ],
                        onChanged: (v) => setState(() => _selectedCategory = v),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: DropdownButton<IncidentPriority?>(
                        isExpanded: true,
                        underline: const SizedBox.shrink(),
                        hint: Text(l10n.mapFilterPriority),
                        value: _selectedPriority,
                        items: [
                          DropdownMenuItem(
                            value: null,
                            child: Text(l10n.mapAllPriorities),
                          ),
                          ...IncidentPriority.values.map(
                            (p) => DropdownMenuItem(
                              value: p,
                              child: Text(p.name.toUpperCase()),
                            ),
                          ),
                        ],
                        onChanged: (v) => setState(() => _selectedPriority = v),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
