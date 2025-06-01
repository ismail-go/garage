import 'dart:async'; // For StreamSubscription
import 'package:flutter/material.dart';
import 'package:garage/core/base/base_view_model.dart';
import 'package:mobx/mobx.dart';
import 'package:garage/data/managers/db_manager.dart';
import '../../data/model/customer/customer.dart';
import '../../data/model/vehicle/vehicle.dart';

part 'customer_detail_view_model.g.dart';

class CustomerDetailViewModel = _CustomerDetailViewModel with _$CustomerDetailViewModel;

abstract class _CustomerDetailViewModel extends BaseViewModel with Store {
  final String ownerId;

  @observable
  Customer? customer;

  @observable
  bool isCustomerLoading = true;

  @observable
  String? customerLoadingError;

  @observable
  bool isLoading = false; // For general actions like update/delete

  late final Stream<List<Vehicle>> vehicleStream;
  StreamSubscription? _customerSubscription;

  _CustomerDetailViewModel(this.ownerId) {
    vehicleStream = dbManager.streamCustomerVehicles(ownerId);
    _listenToCustomer();
    init(); // Call existing init if it has other logic
  }

  void _listenToCustomer() {
    isCustomerLoading = true;
    customerLoadingError = null;
    _customerSubscription = dbManager.streamCustomer(ownerId).listen(
      (customerData) {
        this.customer = customerData;
        isCustomerLoading = false;
      },
      onError: (error) {
        print("Error listening to customer $ownerId: $error");
        customerLoadingError = error.toString();
        isCustomerLoading = false;
      },
      onDone: () {
        isCustomerLoading = false;
        // If stream closes and customer is null, it means not found or deleted.
        if (this.customer == null) {
          print("Customer stream for $ownerId done, customer not found.");
        }
      }
    );
  }

  @observable
  bool _isDeletingCustomer = false;

  // Getter for UI to observe deletion state, e.g. for showing a loading indicator
  // This combines the general isLoading with the specific customer deletion flag
  @computed
  bool get isProcessingCustomerDeletion => isLoading && _isDeletingCustomer;

  @action
  Future<void> updateCustomer(Customer customerToUpdate) async {
    isLoading = true;
    try {
      final updatedCustomerData = customerToUpdate.copyWith(
        ownerId: this.ownerId,
        updatedAt: DateTime.now().millisecondsSinceEpoch,
      );
      await dbManager.updateCustomer(this.ownerId, updatedCustomerData);
      // The stream listener will automatically update `this.customer`
    } catch (e) {
      print("Error updating customer in ViewModel: $e");
      // Potentially set a user-facing error message
    } finally {
      isLoading = false;
    }
  }

  @action
  Future<bool> deleteCustomerAndData() async {
    isLoading = true;
    _isDeletingCustomer = true;
    try {
      await dbManager.deleteCustomer(ownerId);
      // `this.customer` will become null via the stream listener if successful
      return true;
    } catch (e) {
      print("Error deleting customer and data for $ownerId: $e");
      return false;
    } finally {
      isLoading = false;
      _isDeletingCustomer = false;
    }
  }

  @override
  void init() {
    // BaseViewModel init logic can go here if any
  }

  @override
  void dispose() {
    _customerSubscription?.cancel();
    // super.dispose(); // Removed as dispose might be abstract in BaseViewModel
  }
}
