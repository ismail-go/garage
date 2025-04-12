import 'package:flutter/material.dart';
import 'package:garage/core/base/base_state.dart';
import 'package:garage/ui/widgets/bottom_sheets/add_customer/add_customer_view_model.dart';
import 'package:garage/ui/widgets/bottom_sheets/base_bottom_sheet.dart';

class AddCustomerBottomSheet extends StatefulWidget {
  const AddCustomerBottomSheet({super.key});

  @override
  State<AddCustomerBottomSheet> createState() => _AddCustomerBottomSheetState(AddCustomerViewModel());
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
                  'Müşteri Ekle',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 20),
                _inputField(
                  label: 'Ad',
                  onSave: (value) {
                    viewModel.name = value ?? "";
                  },
                ),
                SizedBox(height: 10),
                _inputField(
                  label: 'Soyad',
                  onSave: (value) {
                    viewModel.surname = value ?? "";
                  },
                ),
                SizedBox(height: 10),
                _inputField(
                  label: 'Email',
                  onSave: (value) {},
                ),
                SizedBox(height: 10),
                _inputField(
                  label: 'Telefon',
                  keyboardType: const TextInputType.numberWithOptions(signed: true),
                  onSave: (value) {
                    viewModel.telNo = value ?? "";
                  },
                ),
                SizedBox(height: 10),
                _inputField(
                  label: 'Tc No',
                  keyboardType: const TextInputType.numberWithOptions(signed: true),
                  onSave: (value) {
                    viewModel.tcNo = value ?? "";
                  },
                ),
                SizedBox(height: 10),
                _inputField(
                  label: 'Vergi No',
                  keyboardType: const TextInputType.numberWithOptions(signed: true),
                  onSave: (value) {
                    viewModel.taxNo = value ?? "";
                  },
                ),
                SizedBox(height: 10),
                _inputField(
                  label: 'Adres',
                  onSave: (value) {
                    viewModel.address = value ?? "";
                  },
                ),
                SizedBox(height: 20),
                ElevatedButton(onPressed: () => viewModel.onTapSave(context), child: Text('Kaydet')),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _inputField({required String label, TextInputType? keyboardType, required Function(String?) onSave}) {
    return TextFormField(
      onSaved: onSave,
      decoration: InputDecoration(
        labelText: label,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(12)),
        ),
      ),
      textInputAction: TextInputAction.next,
      keyboardType: keyboardType,
    );
  }
}
