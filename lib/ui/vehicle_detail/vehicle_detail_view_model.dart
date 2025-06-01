import 'package:garage/core/base/base_view_model.dart';
import 'package:garage/data/model/vehicle/vehicle.dart';
import 'package:garage/data/managers/db_manager.dart';
import 'package:mobx/mobx.dart';

part 'vehicle_detail_view_model.g.dart';

class VehicleDetailViewModel extends _VehicleDetailViewModel with _$VehicleDetailViewModel {
  VehicleDetailViewModel(Vehicle vehicle) : super(vehicle);
}

abstract class _VehicleDetailViewModel extends BaseViewModel with Store {
  @observable
  Vehicle vehicle;

  _VehicleDetailViewModel(this.vehicle);

  @action
  Future<void> updateVehicle(Vehicle updatedVehicle) async {
    try {
      final vehicleToSave = updatedVehicle.copyWith(
        ownerId: vehicle.ownerId,
        createdAt: vehicle.createdAt 
      );

      await dbManager.updateVehicle(vehicleToSave.vin, vehicleToSave);
      this.vehicle = vehicleToSave; 
    } catch (e) {
      print('Error updating vehicle: $e');
    }
  }

  // If we need to update the vehicle displayed or fetch more data related to it,
  // methods would go here. For now, it primarily holds the vehicle.

  @override
  void init() {
    // Initialization logic if needed in the future
  }

  @override
  void dispose() {
    // Disposal logic if needed
  }
} 