import 'package:garage/core/base/base_view_model.dart';
import 'package:garage/data/managers/db_manager.dart';
import 'package:garage/data/model/customer/customer.dart';
import 'package:mobx/mobx.dart';

part 'customers_view_model.g.dart';

class CustomersViewModel = _CustomersViewModel with _$CustomersViewModel;

abstract class _CustomersViewModel extends BaseViewModel with Store {
  @observable
  ObservableList<Customer> customers = ObservableList<Customer>();

  @observable
  String searchValue = "";

  @observable
  bool isLoading = true;

  @action
  Future<void> loadCustomers() async {
    isLoading = true;
    await dbManager.initCustomers();
    customers = ObservableList.of(dbManager.customers);
    isLoading = false;
  }

  @action
  Future<void> deleteCustomer(String nationalId) async {
    await dbManager.deleteCustomer(nationalId);
    await loadCustomers(); // Reload the list after deletion
  }

  @override
  void init() {
    loadCustomers();
  }

  @override
  void dispose() {
    // TODO: implement dispose
  }
}
