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

  @override
  String toString() {
    return '''
searchValue: ${searchValue}
    ''';
  }
}
