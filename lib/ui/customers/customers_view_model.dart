import 'dart:convert';

import 'package:garage/core/base/base_view_model.dart';
import 'package:garage/data/fake_data.dart';
import 'package:garage/data/model/customer.dart';
import 'package:mobx/mobx.dart';

import '../../data/model/customer_data.dart';

part 'customers_view_model.g.dart';

class CustomersViewModel = _CustomersViewModel with _$CustomersViewModel;

abstract class _CustomersViewModel extends BaseViewModel with Store {
  List<Customer> customers = [];

  @observable
  String searchValue = "";

  @override
  void init() {
    // Converting the JSON to a CustomerList object
    Map<String, dynamic> jsonMap = jsonDecode(FakeData.customerData);
    CustomerData data = CustomerData.fromJson(jsonMap);
    customers = data.customers;
    print('Number of customers: ${data.customers.length}');
  }

  @override
  void dispose() {
    // TODO: implement dispose
  }
}
