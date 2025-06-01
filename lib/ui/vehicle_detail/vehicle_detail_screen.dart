import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:garage/core/base/base_state.dart';
import 'package:garage/data/model/vehicle/vehicle.dart';
import 'package:garage/ui/vehicle_detail/vehicle_detail_view_model.dart';
import 'package:garage/ui/widgets/bottom_sheets/add_vehicle/add_vehicle_sheet.dart'; // Import AddVehicleBottomSheet
import 'package:garage/ui/widgets/custom_bars/blurred_app_bar.dart'; // Added import
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
    // final appBarIconColor = Theme.of(context).appBarTheme.actionsIconTheme?.color ?? 
    //                         (Theme.of(context).brightness == Brightness.dark ? Colors.white : Colors.white);

    return Scaffold(
      extendBodyBehindAppBar: true, // Added for blur effect
      appBar: BlurredAppBar( // Replaced AppBar
        leading: BackButton(color: Colors.white),
        title: Text('Vehicle Details'),
        actions: <Widget>[
          Observer(
            builder: (_) {
              if (viewModel.isDeleting) {
                return SizedBox.shrink();
              }
              return IconButton(
                icon: Icon(Icons.edit, color: Colors.white),
                onPressed: () {
                  showModalBottomSheet(
                    context: context,
                    isScrollControlled: true,
                    useSafeArea: true,
                    builder: (context) => AddVehicleBottomSheet(
                      ownerId: viewModel.vehicle.ownerId,
                      vehicle: viewModel.vehicle,
                      onAddVehicle: (vehicleFromSheet) async {
                        await viewModel.updateVehicle(vehicleFromSheet);
                        if (mounted) {
                          Navigator.pop(context, viewModel.vehicle);
                        }
                      },
                    ),
                  );
                },
              );
            },
          ),
        ],
      ),
      body: Observer(
        builder: (_) {
          if (viewModel.isDeleting) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProgressIndicator(),
                  SizedBox(height: 16),
                  Text("Deleting Vehicle..."),
                ],
              )
            );
          }
          final vehicle = viewModel.vehicle;
          return ListView(
            padding: const EdgeInsets.all(16.0)
                .copyWith(
                  top: (const EdgeInsets.all(16.0).top) + kToolbarHeight + MediaQuery.of(context).padding.top, // Adjusted top padding
                  bottom: (const EdgeInsets.all(16.0).bottom) + MediaQuery.of(context).padding.bottom + 16 + 70 // Keep existing logic for bottom
                ),
            children: <Widget>[
              Center(
                child: Column(
                  children: [
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
                    SelectableText(
                      '${vehicle.manufacturer} ${vehicle.model}',
                      style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
                      textAlign: TextAlign.center,
                    ),
                    SelectableText(
                      'Year: ${vehicle.year}',
                      style: Theme.of(context).textTheme.titleMedium,
                      textAlign: TextAlign.center,
                    ),
                    SelectableText(
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
                    ],
                  ),
                ),
              ),
              SizedBox(height: 24),
              _buildDeleteVehicleButton(context, vehicle),
            ],
          );
        },
      ),
    );
  }

  Widget _buildDeleteVehicleButton(BuildContext context, Vehicle vehicle) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: SizedBox(
        width: double.infinity,
        child: ElevatedButton.icon(
          icon: Icon(Icons.delete_forever, color: Colors.white),
          label: Text('Delete Vehicle', style: TextStyle(color: Colors.white)),
          onPressed: () => _showDeleteVehicleConfirmationDialog(context, vehicle),
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

  void _showDeleteVehicleConfirmationDialog(BuildContext context, Vehicle vehicle) {
    showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          title: Text('Confirm Deletion'),
          content: Text('Are you sure you want to delete this vehicle (${vehicle.manufacturer} ${vehicle.model}) and all its associated work orders? This action cannot be undone.'),
          actions: <Widget>[
            TextButton(
              child: Text('Cancel'),
              onPressed: () {
                Navigator.of(dialogContext).pop(); // Dismiss dialog
              },
            ),
            TextButton(
              child: Text('Delete', style: TextStyle(color: Colors.red)),
              onPressed: () async {
                Navigator.of(dialogContext).pop(); // Dismiss dialog first
                
                bool success = await viewModel.deleteThisVehicle();
                if (success && mounted) {
                  Navigator.of(context).pop(vehicle.vin); // Pop VehicleDetailScreen
                }
                if (!success && mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Error deleting vehicle. Please try again.')),
                  );
                }
              },
            ),
          ],
        );
      },
    );
  }

  Widget _buildDetailRow(BuildContext context, String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Text(label, style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
          Flexible(child: SelectableText(value, style: Theme.of(context).textTheme.titleMedium, textAlign: TextAlign.end)),
        ],
      ),
    );
  }
} 