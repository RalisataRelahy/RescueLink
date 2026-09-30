import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:rescuelink/core/constants/enums.dart';
import 'package:rescuelink/core/utils/image_helper.dart';
import 'package:rescuelink/core/utils/location_helper.dart';
import 'package:rescuelink/features/auth/presentation/providers/auth_provider.dart';
import 'package:rescuelink/features/incidents/domain/incident_model.dart';
import 'package:rescuelink/features/incidents/domain/priority_calculator.dart';
import 'package:rescuelink/features/incidents/presentation/providers/dashboard_provider.dart';
import 'package:rescuelink/features/incidents/presentation/providers/incident_providers.dart';
import 'package:rescuelink/generated/l10n/app_localizations.dart';

class CreateIncidentScreen extends ConsumerStatefulWidget {
  const CreateIncidentScreen({super.key});

  @override
  ConsumerState<CreateIncidentScreen> createState() =>
      _CreateIncidentScreenState();
}

class _CreateIncidentScreenState extends ConsumerState<CreateIncidentScreen> {
  final _formKey = GlobalKey<FormState>();
  final _descriptionController = TextEditingController();

  IncidentCategory? _selectedCategory;
  File? _imageFile;
  double? _latitude;
  double? _longitude;
  int _peopleAffected = 0;
  bool _roadBlocked = false;
  bool _isLoadingLocation = false;
  bool _isSubmitting = false;

  @override
  void dispose() {
    _descriptionController.dispose();
    super.dispose();
  }

  Future<void> _getLocation() async {
    setState(() => _isLoadingLocation = true);
    try {
      final pos = await LocationHelper.getCurrentPosition();
      setState(() {
        _latitude = pos.latitude;
        _longitude = pos.longitude;
      });
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(e.toString())),
        );
      }
    } finally {
      if (mounted) setState(() => _isLoadingLocation = false);
    }
  }

  Future<void> _pickImage(ImageSource source) async {
    final picked = await ImageHelper.pickImage(source);
    if (picked != null) {
      final compressed = await ImageHelper.compressImage(File(picked.path));
      setState(() => _imageFile = compressed);
    }
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;

    if (_selectedCategory == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(AppLocalizations.of(context).incidentValidationCategory),
        ),
      );
      return;
    }

    if (_latitude == null || _longitude == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(AppLocalizations.of(context).incidentValidationLocation),
        ),
      );
      return;
    }

    setState(() => _isSubmitting = true);

    try {
      final userId = ref.read(currentUserProvider)?.id ?? 'anonymous';

      // Compute priority deterministically
      final calculatedPriority = PriorityCalculator.calculatePriority(
        category: _selectedCategory!,
        roadBlocked: _roadBlocked,
        peopleAffected: _peopleAffected,
        isCriticalZone: false,
      );

      final incident = IncidentModel(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        userId: userId,
        category: _selectedCategory!,
        description: _descriptionController.text.trim(),
        latitude: _latitude!,
        longitude: _longitude!,
        priority: calculatedPriority,
        status: IncidentStatus.reported,
        createdAt: DateTime.now(),
        localPhotoPath: _imageFile?.path,
        peopleAffected: _peopleAffected,
        roadBlocked: _roadBlocked,
      );

      await ref.read(incidentRepositoryProvider).createIncident(incident);

      ref.invalidate(dashboardStatsProvider);
      ref.invalidate(incidentListProvider);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(AppLocalizations.of(context).incidentSubmitSuccess),
          ),
        );
        context.pop();
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(AppLocalizations.of(context).incidentSubmitError),
          ),
        );
      }
    } finally {
      if (mounted) setState(() => _isSubmitting = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return Scaffold(
      appBar: AppBar(title: Text(l10n.incidentCreate)),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Category dropdown
              DropdownButtonFormField<IncidentCategory>(
                initialValue: _selectedCategory,
                decoration: InputDecoration(
                  labelText: l10n.incidentCategory,
                  prefixIcon: const Icon(Icons.category_outlined),
                ),
                items: IncidentCategory.values.map((cat) {
                  return DropdownMenuItem(
                    value: cat,
                    child: Text(cat.name.toUpperCase()),
                  );
                }).toList(),
                onChanged: (val) => setState(() => _selectedCategory = val),
              ),
              const SizedBox(height: 16),

              // Description
              TextFormField(
                controller: _descriptionController,
                maxLines: 3,
                decoration: InputDecoration(
                  labelText: l10n.incidentDescription,
                  hintText: l10n.incidentDescriptionHint,
                ),
                validator: (v) =>
                    v == null || v.trim().isEmpty ? l10n.incidentValidationDescription : null,
              ),
              const SizedBox(height: 16),

              // Location Section
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(12),
                  child: Row(
                    children: [
                      const Icon(Icons.location_on_outlined, color: Colors.blue),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          _latitude != null
                              ? 'GPS: ${_latitude!.toStringAsFixed(4)}, ${_longitude!.toStringAsFixed(4)}'
                              : l10n.incidentValidationLocation,
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                      ),
                      TextButton.icon(
                        onPressed: _isLoadingLocation ? null : _getLocation,
                        icon: _isLoadingLocation
                            ? const SizedBox(
                                width: 16,
                                height: 16,
                                child: CircularProgressIndicator(strokeWidth: 2),
                              )
                            : const Icon(Icons.my_location),
                        label: Text(l10n.incidentGetLocation),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),

              // Impact options: Road blocked & People affected
              SwitchListTile(
                title: const Text('Road blocked'),
                value: _roadBlocked,
                onChanged: (v) => setState(() => _roadBlocked = v),
              ),
              Row(
                children: [
                  const Text('People affected: '),
                  const Spacer(),
                  IconButton(
                    icon: const Icon(Icons.remove_circle_outline),
                    onPressed: _peopleAffected > 0
                        ? () => setState(() => _peopleAffected--)
                        : null,
                  ),
                  Text('$_peopleAffected',
                      style: const TextStyle(fontWeight: FontWeight.bold)),
                  IconButton(
                    icon: const Icon(Icons.add_circle_outline),
                    onPressed: () => setState(() => _peopleAffected++),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              // Image section
              if (_imageFile != null)
                Stack(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: Image.file(_imageFile!, height: 160, width: double.infinity, fit: BoxFit.cover),
                    ),
                    Positioned(
                      top: 8,
                      right: 8,
                      child: CircleAvatar(
                        backgroundColor: Colors.black54,
                        child: IconButton(
                          icon: const Icon(Icons.close, color: Colors.white),
                          onPressed: () => setState(() => _imageFile = null),
                        ),
                      ),
                    ),
                  ],
                )
              else
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton.icon(
                        onPressed: () => _pickImage(ImageSource.camera),
                        icon: const Icon(Icons.camera_alt_outlined),
                        label: const Text('Camera'),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: OutlinedButton.icon(
                        onPressed: () => _pickImage(ImageSource.gallery),
                        icon: const Icon(Icons.photo_library_outlined),
                        label: const Text('Gallery'),
                      ),
                    ),
                  ],
                ),
              const SizedBox(height: 24),

              // Submit button
              FilledButton(
                onPressed: _isSubmitting ? null : _submit,
                child: _isSubmitting
                    ? const SizedBox(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : Text(l10n.actionSubmit),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
