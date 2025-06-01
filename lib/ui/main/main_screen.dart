import 'package:flutter/material.dart';
import 'package:garage/core/base/base_state.dart';
import 'package:garage/data/model/customer/customer.dart';
import 'package:garage/ui/customers/customers_screen.dart';
import 'package:garage/ui/customers/customers_view_model.dart';
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
  final CustomersViewModel _customersViewModel = CustomersViewModel();
  _MainScreenState(super.viewModel);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      resizeToAvoidBottomInset: true,
      extendBody: true,
      appBar: AppBar(
        titleSpacing: 0,
        title: Observer(builder: (context) {
          return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Text(viewModel.currentIndex == 0 ? "Gözen Otomotiv" : "Müşteriler"),
          );
        }),
      ),
      floatingActionButton: Observer(builder: (context) {
        // Only show FAB on the Customers screen (index 1)
        if (viewModel.currentIndex == 1) {
          return FloatingActionButton(
            onPressed: () {
              showModalBottomSheet(
                context: context,
                isScrollControlled: true,
                useSafeArea: true,
                builder: (context) => AddCustomerBottomSheet(
                  onAddCustomer: (customer) async {
                    await _customersViewModel.addCustomer(customer);
                  },
                ),
              );
            },
            child: const Icon(Icons.add),
          );
        }
        return const SizedBox.shrink(); // Return an empty widget instead of null
      }),
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
        onPageChanged: (value) {
          viewModel.currentIndex = value;
        },
        children: [
          HomeScreen(),
          CustomersScreen(viewModel: _customersViewModel),
        ],
      ),
    );
  }
}
