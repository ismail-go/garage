import 'package:flutter/material.dart';
import 'package:garage/core/base/base_view_model.dart';

abstract class BaseState<T extends BaseViewModel, Y extends StatefulWidget> extends State<Y> {
  late final T viewModel;

  @override
  void initState() {
    viewModel.init();
    super.initState();
  }

  @override
  void dispose() {
    viewModel.dispose();
    super.dispose();
  }

  BaseState(this.viewModel);
}
