import 'dart:convert';
import 'package:garage/data/fake_data.dart';
import 'package:garage/data/model/customer/customer.dart';
import 'package:garage/data/model/customer/customer_data.dart';
import 'package:garage/data/model/work_order/work_order.dart';
import 'package:garage/data/model/work_order/work_order_data.dart';
import 'package:mobx/mobx.dart';

part 'db_manager.g.dart';

final DbManager dbManager = DbManager._internal();

class DbManager = _DbManager with _$DbManager;

abstract class _DbManager with Store {
  // Private named constructor
  _DbManager._internal();

  // Store for holding the list of customers
  @observable
  List<Customer> customers = [];

  // Store for holding the list of customers
  @observable
  List<WorkOrder> workOrders = [];

  // Example method to initialize customers
  @action
  void initCustomers() {
    // Converting the JSON to a CustomerList object
    Map<String, dynamic> jsonMap = jsonDecode(FakeData.customerData);
    CustomerData data = CustomerData.fromJson(jsonMap);
    customers = data.customers;
  }

  // Example method to initialize customers
  @action
  void initWorkOrders() {
    // Converting the JSON to a CustomerList object
    Map<String, dynamic> jsonMap = jsonDecode(FakeData.workOrdersData);
    WorkOrderData data = WorkOrderData.fromJson(jsonMap);
    data.workOrders.sort((a, b) => b.workState.time.millisecondsSinceEpoch.compareTo(a.workState.time.millisecondsSinceEpoch));
    workOrders = data.workOrders;
  }

  // Example method to add a customer
  @action
  void addCustomer(Customer customer) {
    customers = [customer, ...customers];
  }
}
