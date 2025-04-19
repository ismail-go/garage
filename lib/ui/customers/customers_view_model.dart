import 'package:garage/core/base/base_view_model.dart';
import 'package:garage/data/managers/db_manager.dart';
import 'package:garage/data/model/customer/customer.dart';
import 'package:mobx/mobx.dart';

part 'customers_view_model.g.dart';

class CustomersViewModel = _CustomersViewModel with _$CustomersViewModel;

abstract class _CustomersViewModel extends BaseViewModel with Store {
  List<Customer> get customers => dbManager.customers;

  @observable
  String searchValue = "";

  @override
  void init() {
    dbManager.initCustomers();
  }

  @override
  void dispose() {
    // TODO: implement dispose
  }
}
