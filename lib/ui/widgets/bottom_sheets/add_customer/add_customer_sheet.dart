import 'package:flutter/material.dart';
import 'package:garage/core/base/base_state.dart';
import 'package:garage/data/model/customer/customer.dart';
import 'package:garage/ui/widgets/bottom_sheets/add_customer/add_customer_view_model.dart';
import 'package:garage/ui/widgets/bottom_sheets/base_bottom_sheet.dart';

class AddCustomerBottomSheet extends StatefulWidget {
  final Future<void> Function(Customer customer) onAddCustomer;
  final Customer? customer;
  
  const AddCustomerBottomSheet({
    super.key,
    required this.onAddCustomer,
    this.customer,
  });

  @override
  State<AddCustomerBottomSheet> createState() => _AddCustomerBottomSheetState(AddCustomerViewModel(onAddCustomer, customer));
}

class _AddCustomerBottomSheetState extends BaseState<AddCustomerViewModel, AddCustomerBottomSheet> {
  _AddCustomerBottomSheetState(super.viewModel);

  @override
  Widget build(BuildContext context) {
    return BaseBottomSheet(
      child: Form(
        key: viewModel.formKey,
        child: Expanded(
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  widget.customer != null ? 'Edit Customer' : 'Add Customer',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 20),
                _inputField(
                  label: 'Full Name',
                  initialValue: widget.customer?.fullName,
                  onSave: (value) {
                    viewModel.fullName = value ?? "";
                  },
                ),
                SizedBox(height: 10),
                _inputField(
                  label: 'Company Name',
                  initialValue: widget.customer?.companyName,
                  onSave: (value) {
                    viewModel.companyName = value ?? "";
                  },
                ),
                SizedBox(height: 10),
                _inputField(
                  label: 'Email',
                  initialValue: widget.customer?.email,
                  onSave: (value) {
                    viewModel.email = value ?? "";
                  },
                ),
                SizedBox(height: 10),
                _inputField(
                  label: 'Phone Number',
                  initialValue: widget.customer?.phoneNumber,
                  keyboardType: TextInputType.phone,
                  onSave: (value) {
                    viewModel.phoneNumber = value ?? "";
                  },
                ),
                SizedBox(height: 10),
                _inputField(
                  label: 'National ID',
                  initialValue: widget.customer?.nationalId,
                  keyboardType: TextInputType.number,
                  onSave: (value) {
                    viewModel.nationalId = value ?? "";
                  },
                ),
                SizedBox(height: 10),
                _inputField(
                  label: 'Tax ID',
                  initialValue: widget.customer?.taxId,
                  keyboardType: TextInputType.number,
                  onSave: (value) {
                    viewModel.taxId = value ?? "";
                  },
                ),
                SizedBox(height: 10),
                _inputField(
                  label: 'Address',
                  initialValue: widget.customer?.address,
                  maxLines: 3,
                  onSave: (value) {
                    viewModel.address = value ?? "";
                  },
                ),
                SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () => viewModel.onTapSave(context),
                  child: Text(widget.customer != null ? 'Update' : 'Save'),
                ),
                SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _inputField({
    required String label,
    required Function(String?) onSave,
    String? initialValue,
    TextInputType? keyboardType,
    int? maxLines,
  }) {
    return TextFormField(
      decoration: InputDecoration(
        labelText: label,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
      initialValue: initialValue,
      keyboardType: keyboardType,
      maxLines: maxLines ?? 1,
      onSaved: onSave,
    );
  }
}
