import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:garage/core/base/base_state.dart';
import 'package:garage/data/managers/db_manager.dart';
import 'package:garage/data/model/customer/customer.dart';
import 'package:garage/ui/customer_detail/customer_detail_screen.dart';
import 'package:garage/ui/customers/customers_view_model.dart';
import 'package:garage/ui/widgets/bottom_sheets/add_customer/add_customer_sheet.dart';

import '../customer_detail/customer_detail_view_model.dart';

class CustomersScreen extends StatefulWidget {
  final CustomersViewModel viewModel;
  
  const CustomersScreen({
    super.key,
    required this.viewModel,
  });

  @override
  State<CustomersScreen> createState() => _CustomersScreenState(viewModel);
}

class _CustomersScreenState extends BaseState<CustomersViewModel, CustomersScreen> {
  _CustomersScreenState(super.viewModel);

  @override
  Widget build(BuildContext context) {
    return Observer(builder: (context) {
      if (viewModel.isLoading) {
        return Center(child: CircularProgressIndicator());
      }
      
      return Stack(
        children: [
          ListView.builder(
            padding: EdgeInsets.all(16).add(EdgeInsets.only(bottom: MediaQuery.of(context).padding.bottom, top: MediaQuery.of(context).padding.top)),
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
          ),
          if (viewModel.customers.isEmpty)
            Center(
              child: Text('No customers found'),
            ),
        ],
      );
    });
  }

  Widget _customerItem(Customer customer) {
    return Dismissible(
      key: Key(customer.ownerId),
      background: Container(
        color: Colors.red,
        alignment: Alignment.centerRight,
        padding: EdgeInsets.only(right: 16),
        child: Icon(Icons.delete, color: Colors.white),
      ),
      direction: DismissDirection.endToStart,
      onDismissed: (direction) async {
        await viewModel.deleteCustomer(customer.ownerId);
      },
      child: Card(
        margin: EdgeInsets.symmetric(vertical: 4),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(12))),
        color: Colors.grey.shade200,
        shadowColor: Colors.transparent,
        child: ListTile(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => CustomerDetailScreen(
                  viewModel: CustomerDetailViewModel(customer),
                  customersViewModel: viewModel,
                ),
              ),
            );
          },
          leading: CircleAvatar(
            backgroundColor: Colors.grey.shade300,
            backgroundImage: customer.profilePhotoUrl.isNotEmpty
                ? NetworkImage(customer.profilePhotoUrl)
                : null,
            child: customer.profilePhotoUrl.isEmpty
                ? Icon(Icons.person, color: Colors.black38)
                : null,
          ),
          title: Text(customer.fullName),
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (customer.companyName.isNotEmpty)
                Text(customer.companyName),
              Text(customer.phoneNumber),
            ],
          ),
          trailing: Icon(Icons.chevron_right),
        ),
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
    final searchLower = viewModel.searchValue.toLowerCase();
    return customer.fullName.toLowerCase().contains(searchLower) ||
        customer.companyName.toLowerCase().contains(searchLower) ||
        customer.phoneNumber.toLowerCase().contains(searchLower) ||
        customer.email.toLowerCase().contains(searchLower);
  }

  @override
  Widget buildFloatingActionButton(BuildContext context) {
    return FloatingActionButton(
      onPressed: () {
        showModalBottomSheet(
          context: context,
          isScrollControlled: true,
          useSafeArea: true,
          builder: (context) => AddCustomerBottomSheet(onAddCustomer: viewModel.addCustomer),
        );
      },
      child: const Icon(Icons.add),
    );
  }
}
