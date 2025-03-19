import 'package:flutter/material.dart';
import 'package:garage/core/base/base_state.dart';
import 'package:garage/ui/customer_detail/customer_detail_view_model.dart';

class CustomerDetailScreen extends StatefulWidget {
  final CustomerDetailViewModel viewModel;

  const CustomerDetailScreen({super.key, required this.viewModel});

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
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Icon(Icons.edit),
          )
        ],
        title: Text("Müşteri Bilgisi"),
      ),
      body: ListView(
        padding: EdgeInsets.symmetric(horizontal: 16),
        children: [
          Container(
            height: 120,
            width: 120,
            margin: EdgeInsets.only(top: 32, bottom: 20),
            decoration: BoxDecoration(shape: BoxShape.circle, color: Colors.grey.shade200),
            child: Icon(Icons.person, size: 80, color: Colors.black38),
          ),
          Text(
            "${viewModel.customer.name} ${viewModel.customer.surname}",
            style: Theme.of(context).textTheme.headlineMedium,
            textAlign: TextAlign.center,
          ),
          Text(
            viewModel.customer.telNo,
            style: Theme.of(context).textTheme.labelLarge,
            textAlign: TextAlign.center,
          ),
          _option(context, "Accounts", Icons.account_balance_wallet),
          _option(context, "Vehicles", Icons.car_repair),
          _option(context, "Credit", Icons.car_repair)
        ],
      ),
    );
  }

  Container _option(BuildContext context, String title, IconData icon) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      margin: EdgeInsets.only(top: 16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: Colors.grey.shade200,
      ),
      child: Row(
        children: [
          Icon(icon),
          SizedBox(width: 12),
          Text(title, style: Theme.of(context).textTheme.labelLarge),
          Spacer(),
          Icon(Icons.chevron_right),
        ],
      ),
    );
  }
}
