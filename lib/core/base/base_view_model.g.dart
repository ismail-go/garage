// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'base_view_model.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic, no_leading_underscores_for_local_identifiers

mixin _$BaseViewModel on _BaseViewModelBase, Store {
  late final _$isLoadingAtom =
      Atom(name: '_BaseViewModelBase.isLoading', context: context);

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

  late final _$_BaseViewModelBaseActionController =
      ActionController(name: '_BaseViewModelBase', context: context);

  @override
  void setLoading(bool value) {
    final _$actionInfo = _$_BaseViewModelBaseActionController.startAction(
        name: '_BaseViewModelBase.setLoading');
    try {
      return super.setLoading(value);
    } finally {
      _$_BaseViewModelBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  String toString() {
    return '''
isLoading: ${isLoading}
    ''';
  }
}
