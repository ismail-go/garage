import 'package:flutter/material.dart';
import 'package:garage/core/base/base_state.dart';
import 'package:garage/ui/home/home_view_model.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => HomeScreenState(HomeViewModel());
}

class HomeScreenState extends BaseState<HomeViewModel, HomeScreen> {
  HomeScreenState(super.viewModel);

  @override
  Widget build(BuildContext context) {
    return Center(child: Text("Ana sayfa"));
  }
}
