import 'dart:convert';
import 'package:garage/data/fake_data.dart';
import 'package:garage/data/model/customer.dart';
import 'package:garage/data/model/customer_data.dart';
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

  // Example method to initialize customers
  @action
  void initCustomers() {
    // Converting the JSON to a CustomerList object
    Map<String, dynamic> jsonMap = jsonDecode(FakeData.customerData);
    CustomerData data = CustomerData.fromJson(jsonMap);
    customers = data.customers;
  }

  // Example method to add a customer
  @action
  void addCustomer(Customer customer) {
    customers = [customer, ...customers];
  }
}
