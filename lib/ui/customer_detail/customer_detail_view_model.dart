import 'package:flutter/material.dart';
import 'package:garage/core/base/base_view_model.dart';
import 'package:mobx/mobx.dart';
import 'package:garage/data/managers/db_manager.dart';
import '../../data/model/customer/customer.dart';
import '../../data/model/vehicle/vehicle.dart';

part 'customer_detail_view_model.g.dart';

class CustomerDetailViewModel extends _CustomerDetailViewModel with _$CustomerDetailViewModel {
  CustomerDetailViewModel(Customer customer) : super(customer);
}

abstract class _CustomerDetailViewModel extends BaseViewModel with Store {
  final Customer customer;

  _CustomerDetailViewModel(this.customer) {
    init();
  }

  @observable
  List<Vehicle> vehicles = [];

  @observable
  bool isLoadingVehicles = false;

  @action
  Future<void> fetchVehicles() async {
    isLoadingVehicles = true;
    try {
      vehicles = await dbManager.fetchCustomerVehicles(customer.ownerId);
    } catch (e) {
      print("Error fetching vehicles: $e");
      vehicles = [];
    } finally {
      isLoadingVehicles = false;
    }
  }

  @action
  Future<bool> deleteVehicleAndWorkOrders(String vin) async {
    isLoadingVehicles = true;
    try {
      await dbManager.deleteVehicle(vin);
      await fetchVehicles();
      return true;
    } catch (e) {
      print('Error in CDViewModel deleting vehicle $vin: $e');
      return false;
    } finally {
      isLoadingVehicles = false;
    }
  }

  @action
  void updateVehicleInList(Vehicle updatedVehicle) {
    final index = vehicles.indexWhere((v) => v.vin == updatedVehicle.vin);
    if (index != -1) {
      final List<Vehicle> tempList = List.from(vehicles);
      tempList[index] = updatedVehicle;
      tempList.sort((a, b) {
        int manufacturerCompare = a.manufacturer.compareTo(b.manufacturer);
        if (manufacturerCompare != 0) return manufacturerCompare;
        return a.model.compareTo(b.model);
      });
      vehicles = tempList;
    }
  }

  @action
  void removeVehicleFromListByVin(String vin) {
    vehicles.removeWhere((v) => v.vin == vin);
    vehicles = List.from(vehicles);
  }

  @action
  Future<void> updateCustomer(Customer updatedCustomer) async {
    final customerToUpdate = Customer(
      ownerId: customer.ownerId,
      fullName: updatedCustomer.fullName,
      companyName: updatedCustomer.companyName,
      email: updatedCustomer.email,
      phoneNumber: updatedCustomer.phoneNumber,
      nationalId: updatedCustomer.nationalId,
      taxId: updatedCustomer.taxId,
      address: updatedCustomer.address,
      createdAt: customer.createdAt,
      updatedAt: DateTime.now().millisecondsSinceEpoch,
      ownerType: customer.ownerType,
      profilePhotoUrl: customer.profilePhotoUrl,
      vehicles: customer.vehicles,
    );
    
    await dbManager.updateCustomer(customer.ownerId, customerToUpdate);
  }

  @action
  Future<bool> deleteCustomerAndData() async {
    isLoading = true;
    try {
      await dbManager.deleteCustomer(customer.ownerId);
      return true;
    } catch (e) {
      print('Error in ViewModel while deleting customer ${customer.ownerId}: $e');
      return false;
    } finally {
      isLoading = false;
    }
  }

  @override
  void init() {
    fetchVehicles();
  }

  @override
  void dispose() {
    // TODO: implement dispose
  }
}
