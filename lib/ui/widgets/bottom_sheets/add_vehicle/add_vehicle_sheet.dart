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

  @override
  Widget build(BuildContext context) {
    // No Observer needed
    return BaseBottomSheet(
      child: Form(
        key: viewModel.formKey,
        child: Expanded(
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  widget.vehicle != null ? 'Edit Vehicle' : 'Add New Vehicle',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 20),
                _inputField(
                  label: 'Manufacturer',
                  initialValue: viewModel.manufacturer, // Bind to ViewModel's field
                  onSave: (value) => viewModel.manufacturer = value ?? '', // Update ViewModel's field
                  validator: (value) => (value == null || value.isEmpty) ? 'Manufacturer is required' : null,
                ),
                SizedBox(height: 10),
                _inputField(
                  label: 'Model',
                  initialValue: viewModel.model,
                  onSave: (value) => viewModel.model = value ?? '',
                  validator: (value) => (value == null || value.isEmpty) ? 'Model is required' : null,
                ),
                SizedBox(height: 10),
                _inputField(
                  label: 'Year',
                  initialValue: viewModel.year,
                  keyboardType: TextInputType.number,
                  onSave: (value) => viewModel.year = value ?? '',
                  validator: (value) => (value == null || value.isEmpty) ? 'Year is required' : null,
                ),
                SizedBox(height: 10),
                _inputField(
                  label: 'Plate Number',
                  initialValue: viewModel.plateNo,
                  onSave: (value) => viewModel.plateNo = value ?? '',
                  validator: (value) => (value == null || value.isEmpty) ? 'Plate number is required' : null,
                ),
                SizedBox(height: 10),
                // VIN field: Displayed if editing (viewModel.originalVehicle exists), read-only.
                // Not shown if adding new (viewModel.originalVehicle is null) as it's auto-generated.
                if (viewModel.originalVehicle != null) 
                  _inputField(
                    label: 'VIN (Vehicle Identification Number)',
                    initialValue: viewModel.vin, // Display existing VIN from ViewModel
                    readOnly: true, // VIN is not directly editable
                    onSave: (value) { /* viewModel.vin is mostly for display here if editing */ }, 
                  ),
                SizedBox(height: 10),
                _inputField(
                  label: 'Kilometer',
                  initialValue: viewModel.kilometer,
                  keyboardType: TextInputType.number,
                  onSave: (value) => viewModel.kilometer = value ?? '',
                ),
                SizedBox(height: 10),
                _inputField(
                  label: 'Fuel Type',
                  initialValue: viewModel.fuelType,
                  onSave: (value) => viewModel.fuelType = value ?? '',
                ),
                SizedBox(height: 20),
                Observer(
                  builder: (_) {
                    return ElevatedButton(
                      onPressed: viewModel.isSaving ? null : () => viewModel.onTapSave(context),
                      child: viewModel.isSaving 
                          ? SizedBox(
                              height: 20, 
                              width: 20, 
                              child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white)
                            )
                          : Text(widget.vehicle != null ? 'Update Vehicle' : 'Save Vehicle'),
                    );
                  },
                ),
                SizedBox(height: 20),
              ],
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
    );
  }
} 