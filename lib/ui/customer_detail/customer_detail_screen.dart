import 'package:flutter/material.dart';
import 'package:garage/core/base/base_state.dart';
import 'package:garage/data/managers/db_manager.dart';
import 'package:garage/ui/customer_detail/customer_detail_view_model.dart';
import 'package:garage/ui/widgets/bottom_sheets/add_customer/add_customer_sheet.dart';
import 'package:garage/ui/customers/customers_view_model.dart';

class CustomerDetailScreen extends StatefulWidget {
  final CustomerDetailViewModel viewModel;
  final CustomersViewModel? customersViewModel;

  const CustomerDetailScreen({
    super.key,
    required this.viewModel,
    this.customersViewModel,
  });

  @override
  State<CustomerDetailScreen> createState() => _CustomerDetailScreenState(viewModel);
}

class _CustomerDetailScreenState extends BaseState<CustomerDetailViewModel, CustomerDetailScreen> {
  _CustomerDetailScreenState(super.viewModel);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
            icon: Icon(Icons.edit),
            onPressed: () {
              showModalBottomSheet(
                context: context,
                isScrollControlled: true,
                useSafeArea: true,
                builder: (context) => AddCustomerBottomSheet(
                  customer: viewModel.customer,
                  onAddCustomer: (updatedCustomer) async {
                    await viewModel.updateCustomer(updatedCustomer);
                    if (widget.customersViewModel != null) {
                      await widget.customersViewModel!.refreshCustomers();
                    }
                  },
                ),
              );
            },
          ),
        ],
        title: Text("Customer Details"),
      ),
      body: ListView(
        padding: EdgeInsets.symmetric(horizontal: 16),
        children: [
          Container(
            height: 120,
            width: 120,
            margin: EdgeInsets.only(top: 32, bottom: 20),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.grey.shade200,
              image: viewModel.customer.profilePhotoUrl.isNotEmpty
                  ? DecorationImage(
                      image: NetworkImage(viewModel.customer.profilePhotoUrl),
                      fit: BoxFit.cover,
                    )
                  : null,
            ),
            child: viewModel.customer.profilePhotoUrl.isEmpty
                ? Icon(Icons.person, size: 80, color: Colors.black38)
                : null,
          ),
          Text(
            viewModel.customer.fullName,
            style: Theme.of(context).textTheme.headlineMedium,
            textAlign: TextAlign.center,
          ),
          if (viewModel.customer.companyName.isNotEmpty)
            Padding(
              padding: const EdgeInsets.only(top: 8.0),
              child: Text(
                viewModel.customer.companyName,
                style: Theme.of(context).textTheme.titleLarge,
                textAlign: TextAlign.center,
              ),
            ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            child: Text(
              viewModel.customer.phoneNumber,
              style: Theme.of(context).textTheme.labelLarge,
              textAlign: TextAlign.center,
            ),
          ),
          _detailCard(context),
          if (viewModel.customer.vehicles.isNotEmpty)
            _vehiclesCard(context),
        ],
      ),
    );
  }

  Widget _detailCard(BuildContext context) {
    return Card(
      margin: EdgeInsets.symmetric(vertical: 16),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _detailItem(context, "Email", viewModel.customer.email),
            _detailItem(context, "National ID", viewModel.customer.nationalId),
            _detailItem(context, "Tax ID", viewModel.customer.taxId),
            _detailItem(context, "Owner Type", viewModel.customer.ownerType),
            _detailItem(context, "Address", viewModel.customer.address),
            _detailItem(context, "Created", _formatDate(viewModel.customer.createdAt)),
            _detailItem(context, "Last Updated", _formatDate(viewModel.customer.updatedAt)),
          ],
        ),
      ),
    );
  }

  Widget _vehiclesCard(BuildContext context) {
    return Card(
      margin: EdgeInsets.symmetric(vertical: 8),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Vehicles",
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            SizedBox(height: 8),
            ...viewModel.customer.vehicles.map((vehicle) => Padding(
                  padding: const EdgeInsets.symmetric(vertical: 4.0),
                  child: Text(vehicle),
                )),
          ],
        ),
      ),
    );
  }

  Widget _detailItem(BuildContext context, String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 100,
            child: Text(
              label,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          ),
        ],
      ),
    );
  }

  String _formatDate(int timestamp) {
    final date = DateTime.fromMillisecondsSinceEpoch(timestamp);
    return "${date.day}/${date.month}/${date.year} ${date.hour}:${date.minute}";
  }
}
