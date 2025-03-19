import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:garage/core/base/base_state.dart';
import 'package:garage/data/model/customer.dart';
import 'package:garage/ui/customer_detail/customer_detail_screen.dart';
import 'package:garage/ui/customers/customers_view_model.dart';

import '../customer_detail/customer_detail_view_model.dart';

class CustomersScreen extends StatefulWidget {
  const CustomersScreen({super.key});

  @override
  State<CustomersScreen> createState() => _CustomersScreenState(CustomersViewModel());
}

class _CustomersScreenState extends BaseState<CustomersViewModel, CustomersScreen> {
  _CustomersScreenState(super.viewModel);

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 148),
      itemCount: viewModel.customers.length + 1,
      itemBuilder: (context, index) {
        if (index == 0) {
          return _searchBar();
        }
        final customer = viewModel.customers[index - 1];
        return Observer(builder: (context) {
          return searchCondition(customer) ? _customerItem(customer) : SizedBox.shrink();
        });
      },
    );
  }

  Card _customerItem(Customer customer) {
    return Card(
      margin: EdgeInsets.symmetric(vertical: 4),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(12))),
      color: Colors.grey.shade200,
      shadowColor: Colors.transparent,
      child: ListTile(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => CustomerDetailScreen(viewModel: CustomerDetailViewModel(customer)),
            ),
          );
        },
        title: Text("${customer.name} ${customer.surname.toUpperCase()}"),
        subtitle: Padding(padding: const EdgeInsets.only(top: 8.0), child: Text("${customer.telNo} ")),
        trailing: Icon(Icons.chevron_right),
      ),
    );
  }

  Padding _searchBar() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: CupertinoSearchTextField(
        borderRadius: BorderRadius.circular(12),
        padding: EdgeInsets.symmetric(horizontal: 8, vertical: 12),
        prefixInsets: EdgeInsets.only(left: 12),
        suffixInsets: EdgeInsets.only(right: 12),
        backgroundColor: Colors.grey.shade200,
        smartDashesType: SmartDashesType.disabled,
        smartQuotesType: SmartQuotesType.disabled,
        onChanged: (value) {
          viewModel.searchValue = value;
        },
      ),
    );
  }

  bool searchCondition(Customer customer) {
    return customer.name.toLowerCase().contains(viewModel.searchValue.toLowerCase()) ||
        customer.surname.toLowerCase().contains(viewModel.searchValue.toLowerCase()) ||
        customer.telNo.toLowerCase().contains(viewModel.searchValue.toLowerCase());
  }
}
