import 'package:flutter/material.dart';
import 'package:garage/core/base/base_view_model.dart';
import 'package:garage/data/managers/db_manager.dart';
import 'package:garage/data/model/vehicle/vehicle.dart';
import 'package:mobx/mobx.dart';
import 'package:uuid/uuid.dart';

part 'add_vehicle_view_model.g.dart';

class AddVehicleViewModel extends _AddVehicleViewModel with _$AddVehicleViewModel {
  AddVehicleViewModel(
    String ownerId,
    Future<void> Function(Vehicle vehicle) onAddVehicle,
    Vehicle? vehicle, // This is the originalVehicle for editing
  ) : super(ownerId, onAddVehicle, vehicle);
}

abstract class _AddVehicleViewModel extends BaseViewModel with Store {
  final String ownerId;
  final Future<void> Function(Vehicle vehicle) onAddVehicleCallback;
  final Vehicle? originalVehicle; // This is for editing

  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  // Individual fields to hold form data. Not @observable unless UI needs to react to their changes mid-form.
  String manufacturer = '';
  String model = '';
  String year = '';
  String plateNo = '';
  String vin = ''; // This will hold form input if user types; ignored for new, used for display if editing
  String kilometer = '';
  String fuelType = '';
  String imageUrl = ''; 
  int? lastServiceDate;
  int? nextServiceDate;

  _AddVehicleViewModel(this.ownerId, this.onAddVehicleCallback, this.originalVehicle) {
    if (originalVehicle != null) {
      // If editing, populate fields from originalVehicle
      manufacturer = originalVehicle!.manufacturer;
      model = originalVehicle!.model;
      year = originalVehicle!.year;
      plateNo = originalVehicle!.plateNo;
      vin = originalVehicle!.vin; // Display existing VIN
      kilometer = originalVehicle!.kilometer;
      fuelType = originalVehicle!.fuelType;
      imageUrl = originalVehicle!.imageUrl;
      lastServiceDate = originalVehicle!.lastServiceDate;
      nextServiceDate = originalVehicle!.nextServiceDue;
    } else {
      // Defaults for a new vehicle are already empty strings / null for int?
    }
  }

  Future<void> onTapSave(BuildContext context) async {
    if (formKey.currentState!.validate()) {
      formKey.currentState!.save(); // Calls onSave for each TextFormField, updating the fields above

      final vehicleToSave = Vehicle(
        vin: originalVehicle?.vin ?? Uuid().v4(), // Use existing VIN or generate new for new vehicle
        ownerId: ownerId, 
        manufacturer: manufacturer,
        model: model,
        year: year,
        plateNo: plateNo,
        kilometer: kilometer,
        fuelType: fuelType,
        createdAt: originalVehicle?.createdAt ?? DateTime.now().millisecondsSinceEpoch,
        updatedAt: DateTime.now().millisecondsSinceEpoch,
        driverId: originalVehicle?.driverId ?? '', // Preserve or default
        imageUrl: imageUrl, 
        lastServiceDate: lastServiceDate ?? originalVehicle?.lastServiceDate ?? 0,
        nextServiceDue: nextServiceDate ?? originalVehicle?.nextServiceDue ?? 0,
      );

      await onAddVehicleCallback(vehicleToSave);
      Navigator.pop(context); // Close bottom sheet
    }
  }

  @override
  void init() {}

  @override
  void dispose() {}
} 