import 'package:flutter/material.dart';
import 'package:garage/core/base/base_view_model.dart';
import 'package:garage/data/model/customer/customer.dart';
import 'package:mobx/mobx.dart';

part 'add_customer_view_model.g.dart';

class AddCustomerViewModel = _AddCustomerViewModel with _$AddCustomerViewModel;

abstract class _AddCustomerViewModel extends BaseViewModel with Store {
  final formKey = GlobalKey<FormState>();
  late final Customer newCustomer;
  final Future<void> Function(Customer customer) onAddCustomer;
  
  _AddCustomerViewModel(this.onAddCustomer);
  
  String address = "";
  String companyName = "";
  String email = "";
  String fullName = "";
  String nationalId = "";
  String ownerId = "";
  String ownerType = "";
  String phoneNumber = "";
  String profilePhotoUrl = "";
  String taxId = "";
  List<String> vehicles = [];

  @override
  void init() {}

  @override
  void dispose() {
    // TODO: implement dispose
  }

  Future<void> onTapSave(BuildContext context) async {
    if (formKey.currentState!.validate()) {
      formKey.currentState!.save();
      final now = DateTime.now().millisecondsSinceEpoch;
      newCustomer = Customer(
        address: address,
        companyName: companyName,
        createdAt: now,
        email: email,
        fullName: fullName,
        nationalId: nationalId,
        ownerId: ownerId,
        ownerType: ownerType,
        phoneNumber: phoneNumber,
        profilePhotoUrl: profilePhotoUrl,
        taxId: taxId,
        updatedAt: now,
        vehicles: vehicles,
      );
      await onAddCustomer(newCustomer);
      Navigator.pop(context); // Close the bottom sheet
    }
  }
}
