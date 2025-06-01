import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:garage/core/base/base_state.dart';
import 'package:garage/data/model/customer/customer.dart';
import 'package:garage/ui/widgets/bottom_sheets/add_customer/add_customer_view_model.dart';
import 'package:garage/ui/widgets/bottom_sheets/base_bottom_sheet.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

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

  // Focus nodes for auto focus navigation
  final _fullNameFocus = FocusNode();
  final _companyFocus = FocusNode();
  final _emailFocus = FocusNode();
  final _phoneFocus = FocusNode();
  final _nationalIdFocus = FocusNode();
  final _taxIdFocus = FocusNode();
  final _addressFocus = FocusNode();

  @override
  void dispose() {
    _fullNameFocus.dispose();
    _companyFocus.dispose();
    _emailFocus.dispose();
    _phoneFocus.dispose();
    _nationalIdFocus.dispose();
    _taxIdFocus.dispose();
    _addressFocus.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isEditing = widget.customer != null;
    return Padding(
      padding: MediaQuery.of(context).viewInsets, // Keyboard-aware
      child: DraggableScrollableSheet(
        initialChildSize: 0.7,
        minChildSize: 0.5,
        maxChildSize: 0.95,
        expand: false,
        builder: (context, scrollController) => Container(
          decoration: BoxDecoration(
            color: Theme.of(context).canvasColor,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
          ),
          child: Form(
            key: viewModel.formKey,
            child: SingleChildScrollView(
              controller: scrollController,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      width: 40,
                      height: 4,
                      margin: const EdgeInsets.only(bottom: 16),
                      decoration: BoxDecoration(
                        color: Colors.grey[300],
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            isEditing ? AppLocalizations.of(context)!.editCustomer : AppLocalizations.of(context)!.addCustomer,
                            style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
                          ),
                        ),
                        IconButton(
                          icon: const Icon(Icons.close),
                          onPressed: () => Navigator.of(context).pop(),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    _inputField(
                      label: AppLocalizations.of(context)!.fullName,
                      initialValue: widget.customer?.fullName,
                      onSave: (value) {
                        viewModel.fullName = value ?? "";
                      },
                      validator: (value) => (value == null || value.isEmpty) ? AppLocalizations.of(context)!.fullName + ' ' + AppLocalizations.of(context)!.save.toLowerCase() + ' ' + AppLocalizations.of(context)!.cancel.toLowerCase() : null,
                      focusNode: _fullNameFocus,
                      textInputAction: TextInputAction.next,
                      onFieldSubmitted: (_) => FocusScope.of(context).requestFocus(_companyFocus),
                    ),
                    const SizedBox(height: 12),
                    _inputField(
                      label: AppLocalizations.of(context)!.companyName,
                      initialValue: widget.customer?.companyName,
                      onSave: (value) {
                        viewModel.companyName = value ?? "";
                      },
                      focusNode: _companyFocus,
                      textInputAction: TextInputAction.next,
                      onFieldSubmitted: (_) => FocusScope.of(context).requestFocus(_emailFocus),
                    ),
                    const SizedBox(height: 12),
                    _inputField(
                      label: AppLocalizations.of(context)!.email,
                      initialValue: widget.customer?.email,
                      onSave: (value) {
                        viewModel.email = value ?? "";
                      },
                      validator: (value) {
                        if (value == null || value.isEmpty) return 'Email is required';
                        final emailRegex = RegExp(r"^[a-zA-Z0-9.!#\$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?(?:\\.[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?)*");
                        if (!emailRegex.hasMatch(value)) {
                          return 'Enter a valid email';
                        }
                        return null;
                      },
                      focusNode: _emailFocus,
                      textInputAction: TextInputAction.next,
                      onFieldSubmitted: (_) => FocusScope.of(context).requestFocus(_phoneFocus),
                    ),
                    const SizedBox(height: 12),
                    _inputField(
                      label: AppLocalizations.of(context)!.phoneNumber,
                      initialValue: widget.customer?.phoneNumber,
                      keyboardType: TextInputType.phone,
                      onSave: (value) {
                        viewModel.phoneNumber = value ?? "";
                      },
                      validator: (value) => (value == null || value.isEmpty) ? AppLocalizations.of(context)!.phoneNumber + ' ' + AppLocalizations.of(context)!.save.toLowerCase() + ' ' + AppLocalizations.of(context)!.cancel.toLowerCase() : null,
                      focusNode: _phoneFocus,
                      textInputAction: TextInputAction.next,
                      onFieldSubmitted: (_) => FocusScope.of(context).requestFocus(_nationalIdFocus),
                    ),
                    const SizedBox(height: 12),
                    _inputField(
                      label: 'National ID',
                      initialValue: widget.customer?.nationalId,
                      keyboardType: TextInputType.number,
                      onSave: (value) {
                        viewModel.nationalId = value ?? "";
                      },
                      focusNode: _nationalIdFocus,
                      textInputAction: TextInputAction.next,
                      onFieldSubmitted: (_) => FocusScope.of(context).requestFocus(_taxIdFocus),
                    ),
                    const SizedBox(height: 12),
                    _inputField(
                      label: 'Tax ID',
                      initialValue: widget.customer?.taxId,
                      keyboardType: TextInputType.number,
                      onSave: (value) {
                        viewModel.taxId = value ?? "";
                      },
                      focusNode: _taxIdFocus,
                      textInputAction: TextInputAction.next,
                      onFieldSubmitted: (_) => FocusScope.of(context).requestFocus(_addressFocus),
                    ),
                    const SizedBox(height: 12),
                    _inputField(
                      label: 'Address',
                      initialValue: widget.customer?.address,
                      maxLines: 3,
                      onSave: (value) {
                        viewModel.address = value ?? "";
                      },
                      focusNode: _addressFocus,
                      textInputAction: TextInputAction.done,
                      onFieldSubmitted: (_) => FocusScope.of(context).unfocus(),
                    ),
                    const SizedBox(height: 24),
                    Observer(
                      builder: (_) {
                        return SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed: viewModel.isSaving ? null : () => viewModel.onTapSave(context),
                            style: ElevatedButton.styleFrom(
                              padding: const EdgeInsets.symmetric(vertical: 16),
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                            ),
                            child: viewModel.isSaving
                                ? const SizedBox(
                                    height: 20,
                                    width: 20,
                                    child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                                  )
                                : Text(isEditing ? AppLocalizations.of(context)!.update : AppLocalizations.of(context)!.save),
                          ),
                        );
                      },
                    ),
                    const SizedBox(height: 12),
                  ],
                ),
              ),
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
    String? Function(String?)? validator,
    FocusNode? focusNode,
    TextInputAction? textInputAction,
    void Function(String)? onFieldSubmitted,
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
      validator: validator,
      focusNode: focusNode,
      textInputAction: textInputAction,
      onFieldSubmitted: onFieldSubmitted,
    );
  }
}
