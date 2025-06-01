import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:garage/core/base/base_state.dart';
import 'package:garage/data/model/vehicle/vehicle.dart';
import 'package:garage/ui/vehicle_detail/vehicle_detail_view_model.dart';
import 'package:garage/ui/widgets/bottom_sheets/add_vehicle/add_vehicle_sheet.dart'; // Import AddVehicleBottomSheet
import 'package:intl/intl.dart'; // For date formatting

class VehicleDetailScreen extends StatefulWidget {
  final VehicleDetailViewModel viewModel;

  const VehicleDetailScreen({super.key, required this.viewModel});

  @override
  State<VehicleDetailScreen> createState() => _VehicleDetailScreenState(viewModel);
}

class _VehicleDetailScreenState extends BaseState<VehicleDetailViewModel, VehicleDetailScreen> {
  _VehicleDetailScreenState(super.viewModel);

  String _formatTimestamp(int timestamp) {
    if (timestamp == 0) return 'N/A';
    return DateFormat('dd/MM/yyyy').format(DateTime.fromMillisecondsSinceEpoch(timestamp));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Vehicle Details'),
        actions: [
          IconButton(
            icon: Icon(Icons.edit),
            onPressed: () {
              showModalBottomSheet(
                context: context,
                isScrollControlled: true,
                useSafeArea: true,
                builder: (context) => AddVehicleBottomSheet(
                  ownerId: viewModel.vehicle.ownerId, // Pass current ownerId
                  vehicle: viewModel.vehicle, // Pass current vehicle for editing
                  onAddVehicle: (vehicleFromSheet) async {
                    // vehicleFromSheet is the vehicle object potentially modified by AddVehicleViewModel's save logic
                    await viewModel.updateVehicle(vehicleFromSheet); 
                    // After updateVehicle, viewModel.vehicle in VehicleDetailViewModel is updated.
                    // Pop VehicleDetailScreen, returning the updated vehicle object.
                    if (mounted) { 
                       Navigator.pop(context, viewModel.vehicle); // Return the updated vehicle
                    }
                  },
                ),
              );
            },
          ),
        ],
      ),
      body: Observer(
        builder: (_) {
          final vehicle = viewModel.vehicle;
          return ListView(
            padding: const EdgeInsets.all(16.0),
            children: <Widget>[
              // Basic vehicle info header (e.g., Manufacturer, Model, Year)
              Center(
                child: Column(
                  children: [
                    // Placeholder for vehicle image if available
                    if (vehicle.imageUrl.isNotEmpty)
                      ClipRRect(
                        borderRadius: BorderRadius.circular(8.0),
                        child: Image.network(
                          vehicle.imageUrl,
                          height: 150,
                          width: double.infinity,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) => 
                            Container(height: 150, color: Colors.grey[300], child: Icon(Icons.directions_car, size: 50, color: Colors.grey[600])),
                        ),
                      )
                    else 
                      Container(
                        height: 150, 
                        width: double.infinity,
                        decoration: BoxDecoration(
                          color: Colors.grey[300],
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                        child: Icon(Icons.directions_car, size: 80, color: Colors.grey[700]),
                      ),
                    SizedBox(height: 16),
                    Text(
                      '${vehicle.manufacturer} ${vehicle.model}',
                      style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
                      textAlign: TextAlign.center,
                    ),
                    Text(
                      'Year: ${vehicle.year}',
                      style: Theme.of(context).textTheme.titleMedium,
                      textAlign: TextAlign.center,
                    ),
                     Text(
                      'Plate: ${vehicle.plateNo}',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(fontStyle: FontStyle.italic),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: 24),
                  ],
                ),
              ),
              Card(
                elevation: 2,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildDetailRow(context, 'Kilometers', '${vehicle.kilometer} km'),
                      _buildDetailRow(context, 'Fuel Type', vehicle.fuelType),
                      _buildDetailRow(context, 'Last Service', _formatTimestamp(vehicle.lastServiceDate)),
                      _buildDetailRow(context, 'Next Service Due', _formatTimestamp(vehicle.nextServiceDue)),
                      _buildDetailRow(context, 'Created At', _formatTimestamp(vehicle.createdAt)),
                      _buildDetailRow(context, 'Updated At', _formatTimestamp(vehicle.updatedAt)),
                      // Add more fields as necessary, e.g., driverId if relevant to display
                      // _buildDetailRow(context, 'Driver ID', vehicle.driverId),
                    ],
                  ),
                ),
              ),
              // Placeholder for related information, e.g., Work Orders for this vehicle
              // SizedBox(height: 20),
              // Text('Related Work Orders', style: Theme.of(context).textTheme.titleLarge),
              // FutureBuilder, ListView, etc. to display work orders
            ],
          );
        },
      ),
    );
  }

  Widget _buildDetailRow(BuildContext context, String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Text(label, style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
          Flexible(child: Text(value, style: Theme.of(context).textTheme.titleMedium, textAlign: TextAlign.end)),
        ],
      ),
    );
  }
} 