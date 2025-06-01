import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
// flutter_mobx import is removed as Observer is not used.
import 'package:garage/core/base/base_state.dart';
import 'package:garage/data/model/vehicle/vehicle.dart';
import 'package:garage/ui/widgets/bottom_sheets/add_vehicle/add_vehicle_view_model.dart';
import 'package:garage/ui/widgets/bottom_sheets/base_bottom_sheet.dart';

class AddVehicleBottomSheet extends StatefulWidget {
  final String ownerId;
  final Future<void> Function(Vehicle vehicle) onAddVehicle;
  final Vehicle? vehicle; // For editing existing vehicle (passed to ViewModel as originalVehicle)

  const AddVehicleBottomSheet({
    super.key,
    required this.ownerId,
    required this.onAddVehicle,
    this.vehicle,
  });

  @override
  State<AddVehicleBottomSheet> createState() =>
      _AddVehicleBottomSheetState(AddVehicleViewModel(ownerId, onAddVehicle, vehicle));
}

class _AddVehicleBottomSheetState extends BaseState<AddVehicleViewModel, AddVehicleBottomSheet> {
  _AddVehicleBottomSheetState(super.viewModel);

  // Focus nodes for auto focus navigation
  final _manufacturerFocus = FocusNode();
  final _modelFocus = FocusNode();
  final _yearFocus = FocusNode();
  final _plateFocus = FocusNode();
  final _vinFocus = FocusNode();
  final _kmFocus = FocusNode();
  final _fuelFocus = FocusNode();

  @override
  void dispose() {
    _manufacturerFocus.dispose();
    _modelFocus.dispose();
    _yearFocus.dispose();
    _plateFocus.dispose();
    _vinFocus.dispose();
    _kmFocus.dispose();
    _fuelFocus.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isEditing = widget.vehicle != null;
    return Padding(
      padding: MediaQuery.of(context).viewInsets, // Keyboard-aware
      child: DraggableScrollableSheet(
        initialChildSize: 0.7,
        minChildSize: 0.5,
        maxChildSize: 0.95,
        expand: false,
        builder: (context, scrollController) => Container(
          decoration: BoxDecoration(
            color: Theme.of(context).canvasColor,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
          ),
          child: Form(
            key: viewModel.formKey,
            child: SingleChildScrollView(
              controller: scrollController,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      width: 40,
                      height: 4,
                      margin: const EdgeInsets.only(bottom: 16),
                      decoration: BoxDecoration(
                        color: Colors.grey[300],
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            isEditing ? 'Edit Vehicle' : 'Add New Vehicle',
                            style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
                          ),
                        ),
                        IconButton(
                          icon: const Icon(Icons.close),
                          onPressed: () => Navigator.of(context).pop(),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    _inputField(
                      label: 'Manufacturer',
                      initialValue: viewModel.manufacturer,
                      onSave: (value) => viewModel.manufacturer = value ?? '',
                      validator: (value) => (value == null || value.isEmpty) ? 'Manufacturer is required' : null,
                      focusNode: _manufacturerFocus,
                      textInputAction: TextInputAction.next,
                      onFieldSubmitted: (_) => FocusScope.of(context).requestFocus(_modelFocus),
                    ),
                    const SizedBox(height: 12),
                    _inputField(
                      label: 'Model',
                      initialValue: viewModel.model,
                      onSave: (value) => viewModel.model = value ?? '',
                      validator: (value) => (value == null || value.isEmpty) ? 'Model is required' : null,
                      focusNode: _modelFocus,
                      textInputAction: TextInputAction.next,
                      onFieldSubmitted: (_) => FocusScope.of(context).requestFocus(_yearFocus),
                    ),
                    const SizedBox(height: 12),
                    _inputField(
                      label: 'Year',
                      initialValue: viewModel.year,
                      keyboardType: TextInputType.number,
                      onSave: (value) => viewModel.year = value ?? '',
                      validator: (value) => (value == null || value.isEmpty) ? 'Year is required' : null,
                      focusNode: _yearFocus,
                      textInputAction: TextInputAction.next,
                      onFieldSubmitted: (_) => FocusScope.of(context).requestFocus(_plateFocus),
                    ),
                    const SizedBox(height: 12),
                    _inputField(
                      label: 'Plate Number',
                      initialValue: viewModel.plateNo,
                      onSave: (value) => viewModel.plateNo = value ?? '',
                      validator: (value) => (value == null || value.isEmpty) ? 'Plate number is required' : null,
                      focusNode: _plateFocus,
                      textInputAction: isEditing ? TextInputAction.next : TextInputAction.next,
                      onFieldSubmitted: (_) {
                        if (isEditing) {
                          FocusScope.of(context).requestFocus(_vinFocus);
                        } else {
                          FocusScope.of(context).requestFocus(_kmFocus);
                        }
                      },
                    ),
                    if (viewModel.originalVehicle != null) ...[
                      const SizedBox(height: 12),
                      _inputField(
                        label: 'VIN (Vehicle Identification Number)',
                        initialValue: viewModel.vin,
                        readOnly: true,
                        onSave: (value) {},
                        focusNode: _vinFocus,
                        textInputAction: TextInputAction.next,
                        onFieldSubmitted: (_) => FocusScope.of(context).requestFocus(_kmFocus),
                      ),
                    ],
                    const SizedBox(height: 12),
                    _inputField(
                      label: 'Kilometer',
                      initialValue: viewModel.kilometer,
                      keyboardType: TextInputType.number,
                      onSave: (value) => viewModel.kilometer = value ?? '',
                      focusNode: _kmFocus,
                      textInputAction: TextInputAction.next,
                      onFieldSubmitted: (_) => FocusScope.of(context).requestFocus(_fuelFocus),
                    ),
                    const SizedBox(height: 12),
                    _inputField(
                      label: 'Fuel Type',
                      initialValue: viewModel.fuelType,
                      onSave: (value) => viewModel.fuelType = value ?? '',
                      focusNode: _fuelFocus,
                      textInputAction: TextInputAction.done,
                      onFieldSubmitted: (_) => FocusScope.of(context).unfocus(),
                    ),
                    const SizedBox(height: 24),
                    Observer(
                      builder: (_) {
                        return SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed: viewModel.isSaving ? null : () => viewModel.onTapSave(context),
                            style: ElevatedButton.styleFrom(
                              padding: const EdgeInsets.symmetric(vertical: 16),
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                            ),
                            child: viewModel.isSaving 
                                ? const SizedBox(
                                    height: 20, 
                                    width: 20, 
                                    child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white)
                                  )
                                : Text(widget.vehicle != null ? 'Update Vehicle' : 'Save Vehicle'),
                          ),
                        );
                      },
                    ),
                    const SizedBox(height: 12),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _inputField({
    required String label,
    required Function(String?) onSave,
    String? initialValue,
    TextInputType? keyboardType,
    int? maxLines,
    String? Function(String?)? validator,
    bool readOnly = false,
    FocusNode? focusNode,
    TextInputAction? textInputAction,
    void Function(String)? onFieldSubmitted,
  }) {
    return TextFormField(
      decoration: InputDecoration(
        labelText: label,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
      initialValue: initialValue,
      keyboardType: keyboardType,
      maxLines: maxLines ?? 1,
      onSaved: onSave,
      validator: validator,
      readOnly: readOnly,
      focusNode: focusNode,
      textInputAction: textInputAction,
      onFieldSubmitted: onFieldSubmitted,
    );
  }
} 