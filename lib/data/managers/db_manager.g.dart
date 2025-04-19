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

  late final _$_DbManagerActionController =
      ActionController(name: '_DbManager', context: context);

  @override
  void initCustomers() {
    final _$actionInfo = _$_DbManagerActionController.startAction(
        name: '_DbManager.initCustomers');
    try {
      return super.initCustomers();
    } finally {
      _$_DbManagerActionController.endAction(_$actionInfo);
    }
  }

  @override
  void initWorkOrders() {
    final _$actionInfo = _$_DbManagerActionController.startAction(
        name: '_DbManager.initWorkOrders');
    try {
      return super.initWorkOrders();
    } finally {
      _$_DbManagerActionController.endAction(_$actionInfo);
    }
  }

  @override
  void addCustomer(Customer customer) {
    final _$actionInfo = _$_DbManagerActionController.startAction(
        name: '_DbManager.addCustomer');
    try {
      return super.addCustomer(customer);
    } finally {
      _$_DbManagerActionController.endAction(_$actionInfo);
    }
  }

  @override
  String toString() {
    return '''
customers: ${customers},
workOrders: ${workOrders}
    ''';
  }
}
