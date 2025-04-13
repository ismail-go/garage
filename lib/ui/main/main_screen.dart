import 'package:flutter/material.dart';
import 'package:garage/core/base/base_state.dart';
import 'package:garage/ui/customers/customers_screen.dart';
import 'package:garage/ui/home/home_screen.dart';
import 'package:garage/ui/main/main_view_model.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:garage/ui/widgets/bottom_sheets/add_customer/add_customer_sheet.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState(MainViewModel());
}

class _MainScreenState extends BaseState<MainViewModel, MainScreen> {
  _MainScreenState(super.viewModel);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      resizeToAvoidBottomInset: true,
      extendBody: true,
      appBar: AppBar(
        title: Observer(builder: (context) {
          return Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [Text(viewModel.currentIndex == 0 ? "Gozen Otomotiv" : "Müşteriler"), appbarButton()],
          );
        }),
      ),
      bottomNavigationBar: Observer(builder: (context) {
        return BottomNavigationBar(
          items: [BottomNavigationBarItem(icon: Icon(Icons.home), label: ""), BottomNavigationBarItem(icon: Icon(Icons.group), label: "")],
          onTap: (value) {
            viewModel.currentIndex = value;
            viewModel.pageController.animateToPage(value, duration: Duration(microseconds: 200), curve: Curves.linear);
          },
          selectedFontSize: 0,
          currentIndex: viewModel.currentIndex,
        );
      }),
      body: PageView(
        controller: viewModel.pageController,
        onPageChanged: (value) {},
        children: [
          HomeScreen(),
          CustomersScreen(),
        ],
      ),
    );
  }

  GestureDetector appbarButton() {
    return GestureDetector(
      onTap: () {
        showModalBottomSheet(
          context: context,
          scrollControlDisabledMaxHeightRatio: 0.9,
          builder: (context) {
            return AddCustomerBottomSheet();
          },
        );
      },
      child: Icon(viewModel.currentIndex == 0 ? Icons.settings : Icons.add_circle_outline),
    );
  }
}
