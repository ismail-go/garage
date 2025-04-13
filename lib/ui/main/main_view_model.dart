import 'package:flutter/material.dart';
import 'package:garage/core/base/base_view_model.dart';
import 'package:mobx/mobx.dart';

part 'main_view_model.g.dart';

class MainViewModel = _MainViewModel with _$MainViewModel;

abstract class _MainViewModel extends BaseViewModel with Store {
  final PageController pageController = PageController();

  @observable
  int currentIndex = 0;

  @override
  void init() {
    // TODO: implement init
  }

  @override
  void dispose() {
    // TODO: implement dispose
  }
}
