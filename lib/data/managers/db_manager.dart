import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:garage/data/model/customer/customer.dart';
import 'package:garage/data/model/vehicle/vehicle.dart';
import 'package:garage/data/model/work_order/work_order.dart';
import 'package:mobx/mobx.dart';
import 'dart:convert';
import 'package:garage/data/fake_data.dart';
import 'package:uuid/uuid.dart';

part 'db_manager.g.dart';

final DbManager dbManager = DbManager._internal();

class DbManager = _DbManager with _$DbManager;

abstract class _DbManager with Store {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  bool _hasInitialLoad = false;

  _DbManager._internal();

  @observable
  List<Customer> customers = [];

  @observable
  List<Vehicle> vehicles = [];

  @observable
  List<WorkOrder> workOrders = [];

  // Fetch customers from Firestore owners collection
  @action
  Future<void> fetchCustomers() async {
    try {
      final QuerySnapshot snapshot = await _firestore.collection('owners').get();
      customers = snapshot.docs.map((doc) {
        final data = doc.data() as Map<String, dynamic>;
        // No need to add doc.id, it should already be in the data
        return Customer.fromJson(data);
      }).toList();
      customers.sort((a, b) => a.fullName.toLowerCase().compareTo(b.fullName.toLowerCase()));
      _hasInitialLoad = true;
    } catch (e) {
      print('Error fetching owners: $e');
      customers = [];
    }
  }

  // Initialize work orders from Firestore
  @action
  Future<void> initWorkOrders() async {
    try {
      final QuerySnapshot snapshot = await _firestore.collection('workOrders').get();
      final List<WorkOrder> orders = snapshot.docs.map((doc) {
        final data = doc.data() as Map<String, dynamic>;
        return WorkOrder.fromJson(data);
      }).toList();
      
      // Sort work orders by time (newest first)
      orders.sort((a, b) => b.workState.time.millisecondsSinceEpoch
          .compareTo(a.workState.time.millisecondsSinceEpoch));
      
      workOrders = orders;
    } catch (e) {
      print('Error fetching work orders: $e');
      workOrders = [];
    }
  }

  // Add a customer to Firestore
  @action
  Future<void> addCustomer(Customer customer) async {
    try {
      // Generate our own unique ID
      final String uniqueId = const Uuid().v4();
      
      // Update the customer's ownerId
      customer.ownerId = uniqueId;
      
      // Use our ID for the Firestore document
      await _firestore.collection('owners').doc(uniqueId).set(customer.toJson());
      
      final newList = [...customers, customer];
      newList.sort((a, b) => a.fullName.toLowerCase().compareTo(b.fullName.toLowerCase()));
      customers = newList;
    } catch (e) {
      print('Error adding customer: $e');
    }
  }

  // Add a work order to Firestore
  @action
  Future<void> addWorkOrder(WorkOrder workOrder) async {
    try {
      await _firestore.collection('workOrders').add(workOrder.toJson());
      workOrders = [workOrder, ...workOrders];
    } catch (e) {
      print('Error adding work order: $e');
    }
  }

  // Update a customer in Firestore
  @action
  Future<void> updateCustomer(String ownerId, Customer customer) async {
    try {
      final docRef = _firestore.collection('owners').doc(ownerId);
      await docRef.update(customer.toJson());
      
      final index = customers.indexWhere((c) => c.ownerId == ownerId);
      if (index != -1) {
        final List<Customer> updatedList = List.from(customers);
        updatedList[index] = customer;
        updatedList.sort((a, b) => a.fullName.toLowerCase().compareTo(b.fullName.toLowerCase()));
        customers = updatedList;
      }
    } catch (e) {
      print('Error updating customer: $e');
    }
  }

  // Update a work order in Firestore
  @action
  Future<void> updateWorkOrder(String vehicleId, WorkOrder workOrder) async {
    try {
      final QuerySnapshot snapshot = await _firestore
          .collection('workOrders')
          .where('vehicle_id', isEqualTo: vehicleId)
          .get();
      
      if (snapshot.docs.isNotEmpty) {
        await snapshot.docs.first.reference.update(workOrder.toJson());
        final index = workOrders.indexWhere((w) => w.vehicleId == vehicleId);
        if (index != -1) {
          final List<WorkOrder> updatedList = List.from(workOrders);
          updatedList[index] = workOrder;
          workOrders = updatedList;
        }
      }
    } catch (e) {
      print('Error updating work order: $e');
    }
  }

  // Delete a customer from Firestore
  @action
  Future<void> deleteCustomer(String ownerId) async {
    try {
      // 1. Fetch all vehicles for this customer
      final List<Vehicle> customerVehicles = await fetchCustomerVehicles(ownerId);

      // 2. For each vehicle, delete it (which will also delete its work orders)
      for (var vehicle in customerVehicles) {
        await deleteVehicle(vehicle.vin);
      }

      // 3. Finally, delete the customer (owner) document
      await _firestore.collection('owners').doc(ownerId).delete();
      
      // Update local list of customers
      customers = customers.where((c) => c.ownerId != ownerId).toList();
    } catch (e) {
      print('Error deleting customer $ownerId and their associated data: $e');
    }
  }

  // Delete a work order from Firestore
  @action
  Future<void> deleteWorkOrder(String vehicleId) async {
    try {
      final QuerySnapshot snapshot = await _firestore
          .collection('workOrders')
          .where('vehicle_id', isEqualTo: vehicleId)
          .get();
      
      // Delete all documents found by the query
      final WriteBatch batch = _firestore.batch();
      for (var doc in snapshot.docs) {
        batch.delete(doc.reference);
      }
      await batch.commit();

      // Update local list
      workOrders = workOrders.where((w) => w.vehicleId != vehicleId).toList();
    } catch (e) {
      print('Error deleting work order(s) for vehicle $vehicleId: $e');
    }
  }

  // Stream of customers for real-time updates
  Stream<List<Customer>> streamCustomers() {
    return _firestore.collection('owners').snapshots().map((snapshot) {
      final customerList = snapshot.docs.map((doc) {
        final data = doc.data();
        return Customer.fromJson(data);
      }).toList();
      // Sort customers by full name for consistent ordering
      customerList.sort((a, b) => a.fullName.toLowerCase().compareTo(b.fullName.toLowerCase()));
      return customerList;
    });
  }

  // Stream of a single customer for real-time updates
  Stream<Customer?> streamCustomer(String ownerId) {
    return _firestore.collection('owners').doc(ownerId).snapshots().map((snapshot) {
      if (snapshot.exists && snapshot.data() != null) {
        return Customer.fromJson(snapshot.data()!);
      } else {
        return null; // Customer document doesn't exist or has no data
      }
    });
  }

  // Stream of work orders for real-time updates
  Stream<List<WorkOrder>> streamWorkOrders() {
    return _firestore.collection('workOrders').snapshots().map((snapshot) {
      return snapshot.docs.map((doc) {
        final data = doc.data();
        return WorkOrder.fromJson(data);
      }).toList();
    });
  }

  // Add sample owners to Firestore
  Future<void> addSampleOwners() async {
    try {
      final Map<String, dynamic> sampleData = json.decode(FakeData.ownersData);
      final List<dynamic> sampleOwners = sampleData['owners'];
      
      // Delete existing owners first
      final QuerySnapshot existingOwners = await _firestore.collection('owners').get();
      for (var doc in existingOwners.docs) {
        await doc.reference.delete();
      }
      
      // Add new sample owners
      for (var ownerData in sampleOwners) {
        final customer = Customer.fromJson(ownerData as Map<String, dynamic>);
        await _firestore.collection('owners').doc(customer.ownerId).set(customer.toJson());
      }
      print('Sample owners added successfully');
    } catch (e) {
      print('Error adding sample owners: $e');
    }
  }

  // Fetch vehicles for a specific customer
  @action
  Future<List<Vehicle>> fetchCustomerVehicles(String ownerId) async {
    try {
      final QuerySnapshot snapshot = await _firestore
          .collection('vehicles')
          .where('owner_id', isEqualTo: ownerId)
          .get();

      final customerVehicles = snapshot.docs.map((doc) {
        final data = doc.data() as Map<String, dynamic>;
        return Vehicle.fromJson(data);
      }).toList();

      // Sort vehicles by manufacturer and model
      customerVehicles.sort((a, b) {
        int manufacturerCompare = a.manufacturer.compareTo(b.manufacturer);
        if (manufacturerCompare != 0) return manufacturerCompare;
        return a.model.compareTo(b.model);
      });

      return customerVehicles;
    } catch (e) {
      print('Error fetching customer vehicles: $e');
      return [];
    }
  }

  // Add a vehicle
  @action
  Future<void> addVehicle(Vehicle vehicle) async {
    try {
      // 1. Add the vehicle to the 'vehicles' collection
      await _firestore.collection('vehicles').doc(vehicle.vin).set(vehicle.toJson());

      // 2. Update the owner's document to add this vehicle's VIN to their list
      if (vehicle.ownerId.isNotEmpty) {
        final ownerDocRef = _firestore.collection('owners').doc(vehicle.ownerId);
        await _firestore.runTransaction((transaction) async {
          final ownerSnapshot = await transaction.get(ownerDocRef);
          if (!ownerSnapshot.exists) {
            print("Owner ${vehicle.ownerId} not found when trying to update their vehicle list after adding vehicle ${vehicle.vin}.");
            // This is a critical issue. If owner doesn't exist, what should happen?
            // For now, we'll log and the vehicle will be orphaned from an owner's list perspective.
            // Consider throwing an error or specific handling.
            return; 
          }
          final List<String> ownerVehicles = List<String>.from((ownerSnapshot.data() as Map<String, dynamic>)['vehicles'] ?? []);
          if (!ownerVehicles.contains(vehicle.vin)) {
            ownerVehicles.add(vehicle.vin);
            transaction.update(ownerDocRef, {'vehicles': ownerVehicles});
            print("Added vehicle ${vehicle.vin} to owner ${vehicle.ownerId}'s list.");
          }
        });
      }

      // 3. Update local list (if this DbManager instance holds a global list)
      // This local `vehicles` list in DbManager might not be the one CustomerDetailScreen uses directly.
      // CustomerDetailScreen fetches its own list via fetchCustomerVehicles.
      // However, if other parts of the app use dbManager.vehicles, update it.
      final newList = [...vehicles, vehicle];
      newList.sort((a, b) { // Keep consistent sorting if any
        int manufacturerCompare = a.manufacturer.compareTo(b.manufacturer);
        if (manufacturerCompare != 0) return manufacturerCompare;
        return a.model.compareTo(b.model);
      });
      vehicles = newList;
      print('Vehicle ${vehicle.vin} added successfully and owner updated.');

    } catch (e) {
      print('Error adding vehicle ${vehicle.vin}: $e');
      // Potentially re-throw or handle more gracefully
    }
  }

  // Update a vehicle
  @action
  Future<void> updateVehicle(String vin, Vehicle vehicle) async {
    try {
      await _firestore.collection('vehicles').doc(vin).update(vehicle.toJson());
      final index = vehicles.indexWhere((v) => v.vin == vin);
      if (index != -1) {
        final List<Vehicle> updatedList = List.from(vehicles);
        updatedList[index] = vehicle;
        updatedList.sort((a, b) {
          int manufacturerCompare = a.manufacturer.compareTo(b.manufacturer);
          if (manufacturerCompare != 0) return manufacturerCompare;
          return a.model.compareTo(b.model);
        });
        vehicles = updatedList;
      }
    } catch (e) {
      print('Error updating vehicle: $e');
    }
  }

  // Delete a vehicle
  @action
  Future<void> deleteVehicle(String vin) async {
    DocumentSnapshot? vehicleDocSnapshot;
    try {
      // 0. Get the vehicle document to find its ownerId
      vehicleDocSnapshot = await _firestore.collection('vehicles').doc(vin).get();
      if (!vehicleDocSnapshot.exists) {
        print('Vehicle $vin not found for deletion.');
        return;
      }
      final vehicleData = vehicleDocSnapshot.data() as Map<String, dynamic>;
      final String ownerId = vehicleData['owner_id'];

      // 1. Delete all work orders associated with this vehicle
      await deleteWorkOrder(vin); 

      // 2. Delete the vehicle itself
      await _firestore.collection('vehicles').doc(vin).delete();
      
      // 3. Update the owner's document to remove this vehicle's VIN from their list
      if (ownerId.isNotEmpty) {
        final ownerDocRef = _firestore.collection('owners').doc(ownerId);
        await _firestore.runTransaction((transaction) async {
          final ownerSnapshot = await transaction.get(ownerDocRef);
          if (!ownerSnapshot.exists) {
            print("Owner $ownerId not found when trying to update their vehicle list after deleting vehicle $vin.");
            return; // Or throw an error
          }
          final List<String> ownerVehicles = List<String>.from((ownerSnapshot.data() as Map<String, dynamic>)['vehicles'] ?? []);
          if (ownerVehicles.contains(vin)) {
            ownerVehicles.remove(vin);
            transaction.update(ownerDocRef, {'vehicles': ownerVehicles});
            print("Removed vehicle $vin from owner $ownerId's list.");
          }
        });
      }

      // 4. Update local list of vehicles (if this DbManager instance holds a global list)
      vehicles = vehicles.where((v) => v.vin != vin).toList();
      print('Vehicle $vin and its work orders deleted successfully, and owner updated.');
    } catch (e) {
      print('Error deleting vehicle $vin: $e');
      // Potentially re-throw or handle more gracefully
    }
  }

  // Stream of vehicles for a specific customer
  Stream<List<Vehicle>> streamCustomerVehicles(String ownerId) {
    return _firestore
        .collection('vehicles')
        .where('owner_id', isEqualTo: ownerId)
        .snapshots()
        .map((snapshot) {
      final customerVehicles = snapshot.docs.map((doc) {
        final data = doc.data(); // No need to cast if Vehicle.fromJson handles it
        return Vehicle.fromJson(data);
      }).toList();
      // Sort vehicles by manufacturer and model
      customerVehicles.sort((a, b) {
        int manufacturerCompare = a.manufacturer.compareTo(b.manufacturer);
        if (manufacturerCompare != 0) return manufacturerCompare;
        return a.model.compareTo(b.model);
      });
      return customerVehicles;
    });
  }

  bool get hasInitialLoad => _hasInitialLoad;
}
