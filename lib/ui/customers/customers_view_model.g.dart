// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'customers_view_model.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic, no_leading_underscores_for_local_identifiers

mixin _$CustomersViewModel on _CustomersViewModel, Store {
  late final _$searchValueAtom =
      Atom(name: '_CustomersViewModel.searchValue', context: context);

  @override
  String get searchValue {
    _$searchValueAtom.reportRead();
    return super.searchValue;
  }

  @override
  set searchValue(String value) {
    _$searchValueAtom.reportWrite(value, super.searchValue, () {
      super.searchValue = value;
    });
  }

  late final _$isPerformingActionAtom =
      Atom(name: '_CustomersViewModel.isPerformingAction', context: context);

  @override
  bool get isPerformingAction {
    _$isPerformingActionAtom.reportRead();
    return super.isPerformingAction;
  }

  @override
  set isPerformingAction(bool value) {
    _$isPerformingActionAtom.reportWrite(value, super.isPerformingAction, () {
      super.isPerformingAction = value;
    });
  }

  late final _$addCustomerAsyncAction =
      AsyncAction('_CustomersViewModel.addCustomer', context: context);

  @override
  Future<void> addCustomer(Customer customer) {
    return _$addCustomerAsyncAction.run(() => super.addCustomer(customer));
  }

  late final _$deleteCustomerAsyncAction =
      AsyncAction('_CustomersViewModel.deleteCustomer', context: context);

  @override
  Future<void> deleteCustomer(String ownerId) {
    return _$deleteCustomerAsyncAction.run(() => super.deleteCustomer(ownerId));
  }

  @override
  String toString() {
    return '''
searchValue: ${searchValue},
isPerformingAction: ${isPerformingAction}
    ''';
  }
}
