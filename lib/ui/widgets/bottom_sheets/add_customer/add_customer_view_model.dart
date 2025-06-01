import 'package:flutter/material.dart';
import 'package:garage/core/base/base_view_model.dart';
import 'package:garage/data/model/customer/customer.dart';
import 'package:mobx/mobx.dart';

part 'add_customer_view_model.g.dart';

class AddCustomerViewModel = _AddCustomerViewModel with _$AddCustomerViewModel;

abstract class _AddCustomerViewModel extends BaseViewModel with Store {
  final Future<void> Function(Customer customer) onAddCustomer;
  final Customer? existingCustomer;
  final formKey = GlobalKey<FormState>();
  
  _AddCustomerViewModel(this.onAddCustomer, this.existingCustomer) {
    if (existingCustomer != null) {
      fullName = existingCustomer!.fullName;
      companyName = existingCustomer!.companyName;
      email = existingCustomer!.email;
      phoneNumber = existingCustomer!.phoneNumber;
      nationalId = existingCustomer!.nationalId;
      taxId = existingCustomer!.taxId;
      address = existingCustomer!.address;
    }
  }
  
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
    formKey.currentState?.save();
    final now = DateTime.now().millisecondsSinceEpoch;
    
    final customer = Customer(
      ownerId: existingCustomer?.ownerId ?? '',
      fullName: fullName,
      companyName: companyName,
      email: email,
      phoneNumber: phoneNumber,
      nationalId: existingCustomer?.nationalId ?? nationalId,
      taxId: taxId,
      address: address,
      createdAt: existingCustomer?.createdAt ?? now,
      updatedAt: now,
      ownerType: existingCustomer?.ownerType ?? 'individual',
      profilePhotoUrl: existingCustomer?.profilePhotoUrl ?? '',
      vehicles: existingCustomer?.vehicles ?? [],
    );

    await onAddCustomer(customer);
    Navigator.pop(context);
  }
}
