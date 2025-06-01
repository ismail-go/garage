import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:garage/core/base/base_state.dart';
import 'package:garage/data/managers/db_manager.dart';
import 'package:garage/data/model/customer/customer.dart';
import 'package:garage/data/model/vehicle/vehicle.dart';
import 'package:garage/ui/customer_detail/customer_detail_view_model.dart';
import 'package:garage/ui/widgets/bottom_sheets/add_customer/add_customer_sheet.dart';
import 'package:garage/ui/widgets/bottom_sheets/add_vehicle/add_vehicle_sheet.dart';
import 'package:garage/ui/vehicle_detail/vehicle_detail_screen.dart';
import 'package:garage/ui/vehicle_detail/vehicle_detail_view_model.dart';
import 'package:garage/ui/widgets/custom_bars/blurred_app_bar.dart';
import 'package:intl/intl.dart';
import 'package:flutter/cupertino.dart';

class CustomerDetailScreen extends StatefulWidget {
  final CustomerDetailViewModel viewModel;

  const CustomerDetailScreen({
    super.key,
    required this.viewModel,
  });

  @override
  State<CustomerDetailScreen> createState() => _CustomerDetailScreenState(viewModel);
}

class _CustomerDetailScreenState extends BaseState<CustomerDetailViewModel, CustomerDetailScreen> {
  _CustomerDetailScreenState(super.viewModel);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: BlurredAppBar(
        leading: BackButton(color: Colors.white),
        actions: <Widget>[
          Observer(
            builder: (_) {
              if (viewModel.isCustomerLoading) {
                return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Center(child: SizedBox(width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2))),
                  );
              }
              if (viewModel.customer == null) {
                return IconButton(icon: Icon(Icons.edit_off, color: Colors.white), onPressed: null);
              }
              if (viewModel.isLoading && !viewModel.isProcessingCustomerDeletion) { 
                 return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Center(child: SizedBox(width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2))),
                  );
              }
              return IconButton(
                icon: Icon(Icons.edit, color: Colors.white),
                onPressed: () {
                  if (viewModel.customer != null) {
                    showModalBottomSheet(
                      context: context,
                      isScrollControlled: true,
                      useSafeArea: true,
                      builder: (context) => AddCustomerBottomSheet(
                        customer: viewModel.customer!,
                        onAddCustomer: (updatedCustomer) async {
                          await viewModel.updateCustomer(updatedCustomer);
                        },
                      ),
                    );
                  }
                },
              );
            }
          )
        ],
        title: Observer(
          builder: (_) {
            if (viewModel.customer != null && viewModel.customer!.fullName.isNotEmpty) {
              return Text(viewModel.customer!.fullName);
            }
            return Text("Customer Details");
          }
        ),
      ),
      body: Observer(
        builder: (_) {
          if (viewModel.isCustomerLoading) {
            return Center(child: CircularProgressIndicator());
          }
          if (viewModel.customerLoadingError != null) {
            return Center(child: Text("Error: ${viewModel.customerLoadingError}"));
          }
          if (viewModel.customer == null) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text("Customer not found or has been deleted."),
                  SizedBox(height: 10),
                  ElevatedButton(
                    onPressed: () => Navigator.of(context).pop(), 
                    child: Text("Go Back")
                  )
                ],
              )
            );
          }

          if (viewModel.isProcessingCustomerDeletion) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProgressIndicator(),
                  SizedBox(height: 16),
                  Text("Deleting Customer..."),
                ],
              )
            );
          }
          
          return ListView(
            padding: EdgeInsets.fromLTRB(
                16, 
                kToolbarHeight + MediaQuery.of(context).padding.top,
                16, 
                MediaQuery.of(context).padding.bottom + 16 + 70
            ),
            children: [
              Observer(builder: (_) {
                final customer = viewModel.customer!;
                return Column(
                  children: [
                    Container(
                      height: 120,
                      width: 120,
                      margin: EdgeInsets.only(top: 32, bottom: 20),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.grey.shade200,
                        image: customer.profilePhotoUrl.isNotEmpty
                            ? DecorationImage(
                                image: NetworkImage(customer.profilePhotoUrl),
                                fit: BoxFit.cover,
                              )
                            : null,
                      ),
                      child: customer.profilePhotoUrl.isEmpty
                          ? Icon(Icons.person, size: 80, color: Colors.black38)
                          : null,
                    ),
                    Text(
                      customer.fullName,
                      style: Theme.of(context).textTheme.headlineMedium,
                      textAlign: TextAlign.center,
                    ),
                    if (customer.companyName.isNotEmpty)
                      Padding(
                        padding: const EdgeInsets.only(top: 8.0),
                        child: Text(
                          customer.companyName,
                          style: Theme.of(context).textTheme.titleLarge,
                          textAlign: TextAlign.center,
                        ),
                      ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8.0),
                      child: Text(
                        customer.phoneNumber,
                        style: Theme.of(context).textTheme.labelLarge,
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ],
                );
              }),
              
              Observer(builder: (_) {
                return _detailCard(context, viewModel.customer!); 
              }),
              
              _vehiclesCard(context), 
              
              SizedBox(height: 24),
              
              _buildDeleteCustomerButton(context, viewModel.customer!), 
            ],
          );
        }
      ),
      floatingActionButton: Observer(builder: (_) {
        if (viewModel.isCustomerLoading || viewModel.customer == null || viewModel.isLoading) {
          return SizedBox.shrink();
        }
        return FloatingActionButton(
          onPressed: () {
            showModalBottomSheet(
              context: context,
              isScrollControlled: true,
              useSafeArea: true,
              builder: (context) => AddVehicleBottomSheet(
                ownerId: viewModel.ownerId,
                onAddVehicle: (newVehicle) async {
                  await dbManager.addVehicle(newVehicle);
                },
              ),
            );
          },
          child: Icon(Icons.directions_car_outlined),
          tooltip: 'Add Vehicle',
        );
      }),
    );
  }

  Widget _detailCard(BuildContext context, Customer customer) {
    return Card(
      margin: EdgeInsets.symmetric(vertical: 16),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _detailItem(context, "Email", customer.email),
            _detailItem(context, "National ID", customer.nationalId),
            _detailItem(context, "Tax ID", customer.taxId),
            _detailItem(context, "Owner Type", customer.ownerType),
            _detailItem(context, "Address", customer.address),
            _detailItem(context, "Created", _formatDate(customer.createdAt)),
            _detailItem(context, "Last Updated", _formatDate(customer.updatedAt)),
          ],
        ),
      ),
    );
  }

  Widget _vehiclesCard(BuildContext context) {
    return StreamBuilder<List<Vehicle>>(
      stream: viewModel.vehicleStream,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Card(
            margin: EdgeInsets.symmetric(vertical: 8),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Center(child: CircularProgressIndicator()),
            ),
          );
        }
        if (snapshot.hasError) {
          print("Error in vehicle stream: ${snapshot.error}");
          return Card(
            margin: EdgeInsets.symmetric(vertical: 8),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Center(child: Text("Error loading vehicles.")),
            ),
          );
        }
        if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return Card(
            margin: EdgeInsets.symmetric(vertical: 8),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Center(child: Text("No vehicles found for this customer.")),
            ),
          );
        }

        final vehicles = snapshot.data!;
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
                  children: vehicles.map((vehicle) {
                    final index = vehicles.indexOf(vehicle);
                    return Column(
                      children: [
                        _vehicleListItem(context, vehicle),
                        if (index < vehicles.length - 1)
                          Divider(height: 1, indent: 16, endIndent: 16),
                      ],
                    );
                  }).toList(),
                ),
              ],
            ),
          ),
        );
      },
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
        await Navigator.push<dynamic>(
          context,
          CupertinoPageRoute(
            builder: (context) => VehicleDetailScreen(
              viewModel: VehicleDetailViewModel(vehicle),
            ),
          ),
        );
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
        child: Row(
          children: [
            leadingWidget,
            SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '${vehicle.manufacturer} ${vehicle.model}',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  SizedBox(height: 2),
                  Text(
                    'Plate: ${vehicle.plateNo} • Year: ${vehicle.year}',
                    style: Theme.of(context).textTheme.bodyMedium,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
            Icon(Icons.chevron_right, color: Colors.grey[600]),
          ],
        ),
      ),
    );
  }

  Widget _detailItem(BuildContext context, String title, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title + ":", style: Theme.of(context).textTheme.labelLarge),
          SizedBox(width: 16),
          Expanded(
            child: Text(
              value.isNotEmpty ? value : "N/A",
              style: Theme.of(context).textTheme.titleSmall,
              textAlign: TextAlign.end,
            ),
          ),
        ],
      ),
    );
  }

  String _formatDate(int? timestamp) {
    if (timestamp == null || timestamp == 0) return "N/A";
    return DateFormat('dd MMMM yyyy, HH:mm').format(DateTime.fromMillisecondsSinceEpoch(timestamp));
  }

  Widget _buildDeleteCustomerButton(BuildContext context, Customer customer) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 0.0, vertical: 8.0),
      child: SizedBox(
        width: double.infinity,
        child: ElevatedButton.icon(
          icon: Icon(Icons.delete_forever, color: Colors.white),
          label: Text('Delete Customer and All Data', style: TextStyle(color: Colors.white)),
          onPressed: () => _showDeleteConfirmationDialog(context, customer),
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.red[700],
            padding: EdgeInsets.symmetric(vertical: 12),
            textStyle: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          ),
        ),
      ),
    );
  }

  void _showDeleteConfirmationDialog(BuildContext context, Customer customer) {
    showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          title: Text('Confirm Deletion'),
          content: Text(
              'Are you sure you want to delete this customer (${customer.fullName}) and all associated data (vehicles, work orders)? This action cannot be undone.'),
          actions: <Widget>[
            TextButton(
              child: Text('Cancel'),
              onPressed: () {
                Navigator.of(dialogContext).pop();
              },
            ),
            TextButton(
              child: Text('Delete', style: TextStyle(color: Colors.red)),
              onPressed: () async {
                Navigator.of(dialogContext).pop(); 

                bool success = await viewModel.deleteCustomerAndData();
                if (success && mounted) {
                  if (viewModel.customer == null && Navigator.canPop(context)) {
                    Navigator.of(context).pop(true);
                  }
                } else if (!success && mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Error deleting customer. Please try again.')),
                  );
                }
              },
            ),
          ],
        );
      },
    );
  }
}
