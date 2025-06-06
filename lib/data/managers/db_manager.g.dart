// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'db_manager.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic, no_leading_underscores_for_local_identifiers

mixin _$DbManager on _DbManager, Store {
  late final _$customersAtom =
      Atom(name: '_DbManager.customers', context: context);

  @override
  List<Customer> get customers {
    _$customersAtom.reportRead();
    return super.customers;
  }

  @override
  set customers(List<Customer> value) {
    _$customersAtom.reportWrite(value, super.customers, () {
      super.customers = value;
    });
  }

  late final _$vehiclesAtom =
      Atom(name: '_DbManager.vehicles', context: context);

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

  late final _$workOrdersAtom =
      Atom(name: '_DbManager.workOrders', context: context);

  @override
  List<WorkOrder> get workOrders {
    _$workOrdersAtom.reportRead();
    return super.workOrders;
  }

  @override
  set workOrders(List<WorkOrder> value) {
    _$workOrdersAtom.reportWrite(value, super.workOrders, () {
      super.workOrders = value;
    });
  }

  late final _$fetchCustomersAsyncAction =
      AsyncAction('_DbManager.fetchCustomers', context: context);

  @override
  Future<void> fetchCustomers() {
    return _$fetchCustomersAsyncAction.run(() => super.fetchCustomers());
  }

  late final _$initWorkOrdersAsyncAction =
      AsyncAction('_DbManager.initWorkOrders', context: context);

  @override
  Future<void> initWorkOrders() {
    return _$initWorkOrdersAsyncAction.run(() => super.initWorkOrders());
  }

  late final _$addCustomerAsyncAction =
      AsyncAction('_DbManager.addCustomer', context: context);

  @override
  Future<void> addCustomer(Customer customer) {
    return _$addCustomerAsyncAction.run(() => super.addCustomer(customer));
  }

  late final _$addWorkOrderAsyncAction =
      AsyncAction('_DbManager.addWorkOrder', context: context);

  @override
  Future<void> addWorkOrder(WorkOrder workOrder) {
    return _$addWorkOrderAsyncAction.run(() => super.addWorkOrder(workOrder));
  }

  late final _$updateCustomerAsyncAction =
      AsyncAction('_DbManager.updateCustomer', context: context);

  @override
  Future<void> updateCustomer(String ownerId, Customer customer) {
    return _$updateCustomerAsyncAction
        .run(() => super.updateCustomer(ownerId, customer));
  }

  late final _$updateWorkOrderAsyncAction =
      AsyncAction('_DbManager.updateWorkOrder', context: context);

  @override
  Future<void> updateWorkOrder(String vehicleId, WorkOrder workOrder) {
    return _$updateWorkOrderAsyncAction
        .run(() => super.updateWorkOrder(vehicleId, workOrder));
  }

  late final _$deleteCustomerAsyncAction =
      AsyncAction('_DbManager.deleteCustomer', context: context);

  @override
  Future<void> deleteCustomer(String ownerId) {
    return _$deleteCustomerAsyncAction.run(() => super.deleteCustomer(ownerId));
  }

  late final _$deleteWorkOrderAsyncAction =
      AsyncAction('_DbManager.deleteWorkOrder', context: context);

  @override
  Future<void> deleteWorkOrder(String vehicleId) {
    return _$deleteWorkOrderAsyncAction
        .run(() => super.deleteWorkOrder(vehicleId));
  }

  late final _$fetchCustomerVehiclesAsyncAction =
      AsyncAction('_DbManager.fetchCustomerVehicles', context: context);

  @override
  Future<List<Vehicle>> fetchCustomerVehicles(String ownerId) {
    return _$fetchCustomerVehiclesAsyncAction
        .run(() => super.fetchCustomerVehicles(ownerId));
  }

  late final _$addVehicleAsyncAction =
      AsyncAction('_DbManager.addVehicle', context: context);

  @override
  Future<void> addVehicle(Vehicle vehicle) {
    return _$addVehicleAsyncAction.run(() => super.addVehicle(vehicle));
  }

  late final _$updateVehicleAsyncAction =
      AsyncAction('_DbManager.updateVehicle', context: context);

  @override
  Future<void> updateVehicle(String vin, Vehicle vehicle) {
    return _$updateVehicleAsyncAction
        .run(() => super.updateVehicle(vin, vehicle));
  }

  late final _$deleteVehicleAsyncAction =
      AsyncAction('_DbManager.deleteVehicle', context: context);

  @override
  Future<void> deleteVehicle(String vin) {
    return _$deleteVehicleAsyncAction.run(() => super.deleteVehicle(vin));
  }

  @override
  String toString() {
    return '''
customers: ${customers},
vehicles: ${vehicles},
workOrders: ${workOrders}
    ''';
  }
}
