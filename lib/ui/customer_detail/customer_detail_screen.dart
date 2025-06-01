import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:garage/core/base/base_state.dart';
import 'package:garage/data/managers/db_manager.dart';
import 'package:garage/data/model/vehicle/vehicle.dart';
import 'package:garage/ui/customer_detail/customer_detail_view_model.dart';
import 'package:garage/ui/widgets/bottom_sheets/add_customer/add_customer_sheet.dart';
import 'package:garage/ui/widgets/bottom_sheets/add_vehicle/add_vehicle_sheet.dart';
import 'package:garage/ui/customers/customers_view_model.dart';
import 'package:garage/ui/vehicle_detail/vehicle_detail_screen.dart';
import 'package:garage/ui/vehicle_detail/vehicle_detail_view_model.dart';

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
      body: Observer(
        builder: (_) => ListView(
          padding: EdgeInsets.fromLTRB(16, 0, 16, MediaQuery.of(context).padding.bottom + 16),
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
            _vehiclesCard(context),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showModalBottomSheet(
            context: context,
            isScrollControlled: true,
            useSafeArea: true,
            builder: (context) => AddVehicleBottomSheet(
              ownerId: viewModel.customer.ownerId,
              onAddVehicle: (newVehicle) async {
                await dbManager.addVehicle(newVehicle);
                await viewModel.fetchVehicles();
              },
            ),
          );
        },
        child: Icon(Icons.add),
        tooltip: 'Add Vehicle',
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
    if (viewModel.isLoadingVehicles) {
      return Card(
        margin: EdgeInsets.symmetric(vertical: 8),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Center(child: CircularProgressIndicator()),
        ),
      );
    }

    if (viewModel.vehicles.isEmpty) {
      return Card(
        margin: EdgeInsets.symmetric(vertical: 8),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Center(child: Text("No vehicles found for this customer.")),
        ),
      );
    }

    return Card(
      margin: EdgeInsets.symmetric(vertical: 8),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(0, 16, 0, 8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Text(
                "Vehicles",
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
              ),
            ),
            SizedBox(height: 8),
            Column(
              children: viewModel.vehicles.map((vehicle) {
                final index = viewModel.vehicles.indexOf(vehicle);
                return Column(
                  children: [
                    _vehicleListItem(context, vehicle),
                    if (index < viewModel.vehicles.length - 1)
                      Divider(height: 1, indent: 16, endIndent: 16),
                  ],
                );
              }).toList(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _vehicleListItem(BuildContext context, Vehicle vehicle) {
    Widget leadingWidget;
    if (vehicle.imageUrl.isNotEmpty) {
      leadingWidget = SizedBox(
        width: 48,
        height: 48,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(4.0),
          child: Image.network(
            vehicle.imageUrl,
            fit: BoxFit.cover,
            errorBuilder: (context, error, stackTrace) {
              return Container(
                color: Colors.grey[200],
                child: Icon(Icons.directions_car, color: Theme.of(context).primaryColor, size: 30),
              );
            },
            loadingBuilder: (BuildContext context, Widget child, ImageChunkEvent? loadingProgress) {
              if (loadingProgress == null) return child;
              return Center(
                child: CircularProgressIndicator(
                  strokeWidth: 2.0,
                  value: loadingProgress.expectedTotalBytes != null
                      ? loadingProgress.cumulativeBytesLoaded / loadingProgress.expectedTotalBytes!
                      : null,
                ),
              );
            }, 
          ),
        ),
      );
    } else {
      leadingWidget = SizedBox(
        width: 48,
        height: 48,
        child: Icon(Icons.directions_car, color: Theme.of(context).primaryColor, size: 36),
      );
    }

    return InkWell(
      onTap: () async { 
        final result = await Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => VehicleDetailScreen(
              viewModel: VehicleDetailViewModel(vehicle), 
            ),
          ),
        );

        if (result is Vehicle) {
          viewModel.updateVehicleInList(result); 
        }
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0), 
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center, 
          children: [
            leadingWidget,
            SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min, 
                children: [
                  Text(
                    "${vehicle.manufacturer} ${vehicle.model}",
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600),
                    overflow: TextOverflow.ellipsis, 
                  ),
                  SizedBox(height: 4), 
                  Text(
                    "Plate: ${vehicle.plateNo}\nYear: ${vehicle.year}", 
                    style: Theme.of(context).textTheme.bodyMedium,
                    overflow: TextOverflow.ellipsis,
                    maxLines: 2,
                  ),
                ],
              ),
            ),
            SizedBox(width: 8), 
            Icon(Icons.chevron_right, color: Colors.grey[600]),
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
