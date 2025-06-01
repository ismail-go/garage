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
  
  @observable
  bool isSaving = false;
  
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

  @action
  Future<void> onTapSave(BuildContext context) async {
    if (formKey.currentState?.validate() ?? false) {
      formKey.currentState!.save();
      isSaving = true;
      try {
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
        if (context.mounted) {
          Navigator.pop(context);
        }
      } catch (e) {
        print("Error saving customer: $e");
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(existingCustomer != null ? "Error updating customer" : "Error saving customer"))
          );
        }
      } finally {
        isSaving = false;
      }
    }
  }
}
