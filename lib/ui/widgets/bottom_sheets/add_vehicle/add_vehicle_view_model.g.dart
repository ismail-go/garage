// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'add_vehicle_view_model.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic, no_leading_underscores_for_local_identifiers

mixin _$AddVehicleViewModel on _AddVehicleViewModel, Store {
  late final _$isSavingAtom =
      Atom(name: '_AddVehicleViewModel.isSaving', context: context);

  @override
  bool get isSaving {
    _$isSavingAtom.reportRead();
    return super.isSaving;
  }

  @override
  set isSaving(bool value) {
    _$isSavingAtom.reportWrite(value, super.isSaving, () {
      super.isSaving = value;
    });
  }

  late final _$onTapSaveAsyncAction =
      AsyncAction('_AddVehicleViewModel.onTapSave', context: context);

  @override
  Future<void> onTapSave(BuildContext context) {
    return _$onTapSaveAsyncAction.run(() => super.onTapSave(context));
  }

  @override
  String toString() {
    return '''
isSaving: ${isSaving}
    ''';
  }
}
