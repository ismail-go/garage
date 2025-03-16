import 'package:mobx/mobx.dart';

part 'base_view_model.g.dart'; // Generated file

// Base ViewModel class
abstract class BaseViewModel = _BaseViewModelBase with _$BaseViewModel;

abstract class _BaseViewModelBase with Store {
  // Add common observables, for example, loading state
  @observable
  bool isLoading = false;

  // Common action to set loading state
  @action
  void setLoading(bool value) {
    isLoading = value;
  }

  void init();

  void dispose();
}
