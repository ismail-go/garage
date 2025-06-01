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
    return StreamBuilder<List<Customer>>(
      stream: viewModel.customerStream,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          if (!snapshot.hasData) {
             return Center(child: CircularProgressIndicator());
          }
        }

        if (snapshot.hasError) {
          print("Error in customer stream: ${snapshot.error}");
          return Center(child: Text("Error loading customers. Please try again."));
        }

        if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return Stack(
            children: [
              _searchBar(),
              Center(child: Text('No customers found')),
            ],
          );
        }

        final allCustomers = snapshot.data!;
        final filteredCustomers = allCustomers.where((customer) => searchCondition(customer)).toList();

        return Stack(
          children: [
            ListView.builder(
              padding: EdgeInsets.all(16).add(EdgeInsets.only(bottom: MediaQuery.of(context).padding.bottom, top: MediaQuery.of(context).padding.top)),
              itemCount: filteredCustomers.length + 1,
              itemBuilder: (context, index) {
                if (index == 0) {
                  return _searchBar();
                }
                final customer = filteredCustomers[index - 1];
                return _customerItem(customer);
              },
            ),
            if (allCustomers.isNotEmpty && filteredCustomers.isEmpty && viewModel.searchValue.isNotEmpty) 
              Center(
                 child: Text('No customers match your search.')
              ),
          ],
        );
      },
    );
  }

  Widget _customerItem(Customer customer) {
    return Card(
      margin: EdgeInsets.symmetric(vertical: 4),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(12))),
      color: Colors.grey.shade200,
      shadowColor: Colors.transparent,
      child: ListTile(
        onTap: () async {
          final customerDetailViewModel = CustomerDetailViewModel(
            customer.ownerId,
          );

          Navigator.push(
            context,
            CupertinoPageRoute(
                builder: (context) => CustomerDetailScreen(
                  viewModel: customerDetailViewModel,
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
    );
  }

  Widget _searchBar() {
    return Observer(builder: (_) {
      return Padding(
        padding: const EdgeInsets.only(bottom: 8.0),
        child: CupertinoSearchTextField(
          controller: TextEditingController(text: viewModel.searchValue),
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
    });
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
      child: const Icon(Icons.person_add_outlined),
    );
  }
}
