// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'vehicle_detail_view_model.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic, no_leading_underscores_for_local_identifiers

mixin _$VehicleDetailViewModel on _VehicleDetailViewModel, Store {
  late final _$vehicleAtom =
      Atom(name: '_VehicleDetailViewModel.vehicle', context: context);

  @override
  Vehicle get vehicle {
    _$vehicleAtom.reportRead();
    return super.vehicle;
  }

  @override
  set vehicle(Vehicle value) {
    _$vehicleAtom.reportWrite(value, super.vehicle, () {
      super.vehicle = value;
    });
  }

  late final _$isDeletingAtom =
      Atom(name: '_VehicleDetailViewModel.isDeleting', context: context);

  @override
  bool get isDeleting {
    _$isDeletingAtom.reportRead();
    return super.isDeleting;
  }

  @override
  set isDeleting(bool value) {
    _$isDeletingAtom.reportWrite(value, super.isDeleting, () {
      super.isDeleting = value;
    });
  }

  late final _$updateVehicleAsyncAction =
      AsyncAction('_VehicleDetailViewModel.updateVehicle', context: context);

  @override
  Future<void> updateVehicle(Vehicle updatedVehicle) {
    return _$updateVehicleAsyncAction
        .run(() => super.updateVehicle(updatedVehicle));
  }

  late final _$deleteThisVehicleAsyncAction = AsyncAction(
      '_VehicleDetailViewModel.deleteThisVehicle',
      context: context);

  @override
  Future<bool> deleteThisVehicle() {
    return _$deleteThisVehicleAsyncAction.run(() => super.deleteThisVehicle());
  }

  @override
  String toString() {
    return '''
vehicle: ${vehicle},
isDeleting: ${isDeleting}
    ''';
  }
}
