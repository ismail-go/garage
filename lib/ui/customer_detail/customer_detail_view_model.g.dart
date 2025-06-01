// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'customer_detail_view_model.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic, no_leading_underscores_for_local_identifiers

mixin _$CustomerDetailViewModel on _CustomerDetailViewModel, Store {
  Computed<bool>? _$isProcessingCustomerDeletionComputed;

  @override
  bool get isProcessingCustomerDeletion =>
      (_$isProcessingCustomerDeletionComputed ??= Computed<bool>(
              () => super.isProcessingCustomerDeletion,
              name: '_CustomerDetailViewModel.isProcessingCustomerDeletion'))
          .value;

  late final _$customerAtom =
      Atom(name: '_CustomerDetailViewModel.customer', context: context);

  @override
  Customer? get customer {
    _$customerAtom.reportRead();
    return super.customer;
  }

  @override
  set customer(Customer? value) {
    _$customerAtom.reportWrite(value, super.customer, () {
      super.customer = value;
    });
  }

  late final _$isCustomerLoadingAtom = Atom(
      name: '_CustomerDetailViewModel.isCustomerLoading', context: context);

  @override
  bool get isCustomerLoading {
    _$isCustomerLoadingAtom.reportRead();
    return super.isCustomerLoading;
  }

  @override
  set isCustomerLoading(bool value) {
    _$isCustomerLoadingAtom.reportWrite(value, super.isCustomerLoading, () {
      super.isCustomerLoading = value;
    });
  }

  late final _$customerLoadingErrorAtom = Atom(
      name: '_CustomerDetailViewModel.customerLoadingError', context: context);

  @override
  String? get customerLoadingError {
    _$customerLoadingErrorAtom.reportRead();
    return super.customerLoadingError;
  }

  @override
  set customerLoadingError(String? value) {
    _$customerLoadingErrorAtom.reportWrite(value, super.customerLoadingError,
        () {
      super.customerLoadingError = value;
    });
  }

  late final _$isLoadingAtom =
      Atom(name: '_CustomerDetailViewModel.isLoading', context: context);

  @override
  bool get isLoading {
    _$isLoadingAtom.reportRead();
    return super.isLoading;
  }

  @override
  set isLoading(bool value) {
    _$isLoadingAtom.reportWrite(value, super.isLoading, () {
      super.isLoading = value;
    });
  }

  late final _$_isDeletingCustomerAtom = Atom(
      name: '_CustomerDetailViewModel._isDeletingCustomer', context: context);

  @override
  bool get _isDeletingCustomer {
    _$_isDeletingCustomerAtom.reportRead();
    return super._isDeletingCustomer;
  }

  @override
  set _isDeletingCustomer(bool value) {
    _$_isDeletingCustomerAtom.reportWrite(value, super._isDeletingCustomer, () {
      super._isDeletingCustomer = value;
    });
  }

  late final _$updateCustomerAsyncAction =
      AsyncAction('_CustomerDetailViewModel.updateCustomer', context: context);

  @override
  Future<void> updateCustomer(Customer customerToUpdate) {
    return _$updateCustomerAsyncAction
        .run(() => super.updateCustomer(customerToUpdate));
  }

  late final _$deleteCustomerAndDataAsyncAction = AsyncAction(
      '_CustomerDetailViewModel.deleteCustomerAndData',
      context: context);

  @override
  Future<bool> deleteCustomerAndData() {
    return _$deleteCustomerAndDataAsyncAction
        .run(() => super.deleteCustomerAndData());
  }

  @override
  String toString() {
    return '''
customer: ${customer},
isCustomerLoading: ${isCustomerLoading},
customerLoadingError: ${customerLoadingError},
isLoading: ${isLoading},
isProcessingCustomerDeletion: ${isProcessingCustomerDeletion}
    ''';
  }
}
