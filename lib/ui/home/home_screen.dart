import 'package:flutter/material.dart';
import 'package:garage/core/base/base_state.dart';
import 'package:garage/ui/customers/customers_screen.dart';
import 'package:garage/ui/home/home_view_model.dart';
import 'package:flutter_mobx/flutter_mobx.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => HomeScreenState(HomeViewModel());
}

class HomeScreenState extends BaseState<HomeViewModel, HomeScreen> {
  HomeScreenState(super.viewModel);

  final PageController _pageController = PageController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Gozen Otomotiv"),
      ),
      bottomNavigationBar: Observer(builder: (context) {
        return BottomNavigationBar(
          items: [BottomNavigationBarItem(icon: Icon(Icons.home), label: ""), BottomNavigationBarItem(icon: Icon(Icons.group), label: "")],
          onTap: (value) {
            viewModel.currentIndex = value;
            _pageController.animateToPage(value, duration: Duration(microseconds: 200), curve: Curves.linear);
          },
          selectedFontSize: 0,
          currentIndex: viewModel.currentIndex,
        );
      }),
      body: PageView(
        controller: _pageController,
        onPageChanged: (value) {},
        children: [
          Center(child: Text("Ana sayfa")),
          CustomersScreen(),
        ],
      ),
    );
  }
}
