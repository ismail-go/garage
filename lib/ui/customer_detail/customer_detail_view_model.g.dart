// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'customer_detail_view_model.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic, no_leading_underscores_for_local_identifiers

mixin _$CustomerDetailViewModel on _CustomerDetailViewModel, Store {
  late final _$vehiclesAtom =
      Atom(name: '_CustomerDetailViewModel.vehicles', context: context);

  @override
  List<Vehicle> get vehicles {
    _$vehiclesAtom.reportRead();
    return super.vehicles;
  }

  @override
  set vehicles(List<Vehicle> value) {
    _$vehiclesAtom.reportWrite(value, super.vehicles, () {
      super.vehicles = value;
    });
  }

  late final _$isLoadingVehiclesAtom = Atom(
      name: '_CustomerDetailViewModel.isLoadingVehicles', context: context);

  @override
  bool get isLoadingVehicles {
    _$isLoadingVehiclesAtom.reportRead();
    return super.isLoadingVehicles;
  }

  @override
  set isLoadingVehicles(bool value) {
    _$isLoadingVehiclesAtom.reportWrite(value, super.isLoadingVehicles, () {
      super.isLoadingVehicles = value;
    });
  }

  late final _$fetchVehiclesAsyncAction =
      AsyncAction('_CustomerDetailViewModel.fetchVehicles', context: context);

  @override
  Future<void> fetchVehicles() {
    return _$fetchVehiclesAsyncAction.run(() => super.fetchVehicles());
  }

  late final _$updateCustomerAsyncAction =
      AsyncAction('_CustomerDetailViewModel.updateCustomer', context: context);

  @override
  Future<void> updateCustomer(Customer updatedCustomer) {
    return _$updateCustomerAsyncAction
        .run(() => super.updateCustomer(updatedCustomer));
  }

  @override
  String toString() {
    return '''
vehicles: ${vehicles},
isLoadingVehicles: ${isLoadingVehicles}
    ''';
  }
}
