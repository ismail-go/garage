import 'package:flutter/material.dart';
import 'package:garage/core/base/base_view_model.dart';
import 'package:mobx/mobx.dart';
import 'package:garage/data/managers/db_manager.dart';
import '../../data/model/customer/customer.dart';

part 'customer_detail_view_model.g.dart';

class CustomerDetailViewModel extends _CustomerDetailViewModel with _$CustomerDetailViewModel {
  CustomerDetailViewModel(Customer customer) : super(customer);
}

abstract class _CustomerDetailViewModel extends BaseViewModel with Store {
  final Customer customer;

  _CustomerDetailViewModel(this.customer);

  @action
  Future<void> updateCustomer(Customer updatedCustomer) async {
    // Make sure we preserve the original customer's ID and other important fields
    final customerToUpdate = Customer(
      ownerId: customer.ownerId,  // Keep the original ownerId
      fullName: updatedCustomer.fullName,
      companyName: updatedCustomer.companyName,
      email: updatedCustomer.email,
      phoneNumber: updatedCustomer.phoneNumber,
      nationalId: updatedCustomer.nationalId,  // Allow nationalId to be updated
      taxId: updatedCustomer.taxId,
      address: updatedCustomer.address,
      createdAt: customer.createdAt,  // Keep the original creation date
      updatedAt: DateTime.now().millisecondsSinceEpoch,
      ownerType: customer.ownerType,
      profilePhotoUrl: customer.profilePhotoUrl,
      vehicles: customer.vehicles,
    );
    
    await dbManager.updateCustomer(customer.ownerId, customerToUpdate);
  }

  @override
  void init() {}

  @override
  void dispose() {
    // TODO: implement dispose
  }
}
