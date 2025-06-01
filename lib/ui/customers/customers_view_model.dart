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
    // Only fetch from DB if we haven't done initial load
    if (!dbManager.hasInitialLoad) {
      await dbManager.fetchCustomers();
    }
    final sortedCustomers = List<Customer>.from(dbManager.customers)
      ..sort((a, b) => a.fullName.toLowerCase().compareTo(b.fullName.toLowerCase()));
    customers = ObservableList.of(sortedCustomers);
    isLoading = false;
  }

  @action
  Future<void> refreshCustomers() async {
    await dbManager.fetchCustomers();
    final sortedCustomers = List<Customer>.from(dbManager.customers)
      ..sort((a, b) => a.fullName.toLowerCase().compareTo(b.fullName.toLowerCase()));
    customers = ObservableList.of(sortedCustomers);
  }

  @action
  Future<void> addCustomer(Customer customer) async {
    isLoading = true;
    await dbManager.addCustomer(customer);
    await refreshCustomers();
    isLoading = false;
  }

  @action
  Future<void> updateCustomer(String ownerId, Customer customer) async {
    isLoading = true;
    await dbManager.updateCustomer(ownerId, customer);
    await refreshCustomers();
    isLoading = false;
  }

  @action
  Future<void> deleteCustomer(String ownerId) async {
    await dbManager.deleteCustomer(ownerId);
    await refreshCustomers();
  }

  @override
  void init() {
    loadCustomers();
  }

  @override
  void dispose() {
    // No need for cleanup
  }
}
