import 'package:garage/core/base/base_view_model.dart';
import 'package:garage/data/managers/db_manager.dart';
import 'package:garage/data/model/customer/customer.dart';
import 'package:mobx/mobx.dart';

part 'customers_view_model.g.dart';

class CustomersViewModel = _CustomersViewModel with _$CustomersViewModel;

abstract class _CustomersViewModel extends BaseViewModel with Store {
  @observable
  String searchValue = "";

  // Expose the customer stream from DbManager
  Stream<List<Customer>> get customerStream => dbManager.streamCustomers();

  // isLoading can be kept if it's used for other operations like add/update/delete indications,
  // but for the list display, StreamBuilder handles its own connection state.
  // For now, let's remove it if its primary use was for fetchCustomers.
  // If add/delete need their own loading indicators, they can have specific @observable booleans.
  @observable
  bool isPerformingAction = false; // Example: for add/delete operations if needed

  @action
  Future<void> addCustomer(Customer customer) async {
    isPerformingAction = true;
    try {
      await dbManager.addCustomer(customer);
      // No need to call refreshCustomers or update local list, stream handles it.
    } catch (e) {
      print("Error adding customer in ViewModel: $e");
      // Handle error appropriately, maybe set an error state
    } finally {
      isPerformingAction = false;
    }
  }

  // updateCustomer is not directly used by CustomersScreen typically, but by detail screen.
  // If it were, it would also just call dbManager and let the stream update.
  Future<void> updateCustomer(String ownerId, Customer customer) async {
    isPerformingAction = true;
    try {
      await dbManager.updateCustomer(ownerId, customer);
    } catch (e) {
      print("Error updating customer in ViewModel: $e");
    } finally {
      isPerformingAction = false;
    }
  }

  @action
  Future<void> deleteCustomer(String ownerId) async {
    // This might be called if CustomersScreen had a direct delete (e.g., swipe, which was removed).
    // If deletion only happens via CustomerDetailScreen, this method might not be directly invoked from CustomersScreen.
    isPerformingAction = true;
    try {
      await dbManager.deleteCustomer(ownerId);
      // No need to call refreshCustomers or update local list, stream handles it.
    } catch (e) {
      print("Error deleting customer in ViewModel: $e");
    } finally {
      isPerformingAction = false;
    }
  }

  @override
  void init() {
    // No initial data loading here, StreamBuilder will handle it.
  }

  @override
  void dispose() {
    // No specific cleanup needed for this ViewModel unless you add manual stream subscriptions.
  }
}
