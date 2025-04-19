import 'package:flutter/material.dart';
import 'package:garage/core/base/base_view_model.dart';
import 'package:garage/data/managers/db_manager.dart';
import 'package:garage/data/model/customer/customer.dart';
import 'package:mobx/mobx.dart';

part 'add_customer_view_model.g.dart';

class AddCustomerViewModel = _AddCustomerViewModel with _$AddCustomerViewModel;

abstract class _AddCustomerViewModel extends BaseViewModel with Store {
  final formKey = GlobalKey<FormState>();
  late final Customer newCustomer;
  String name = "";
  String surname = "";
  String tcNo = "";
  String taxNo = "";
  String telNo = "";
  String address = "";

  @override
  void init() {}

  @override
  void dispose() {
    // TODO: implement dispose
  }

  void onTapSave(BuildContext context) {
    if (formKey.currentState!.validate()) {
      formKey.currentState!.save();
      newCustomer = Customer(name: name, surname: surname, tcNo: tcNo, taxNo: taxNo, telNo: telNo, address: address, debit: 0.0);
      dbManager.addCustomer(newCustomer);
    }
    Navigator.pop(context); // Close the bottom sheet
  }
}
