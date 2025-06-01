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
      await _firestore.collection('owners').doc(ownerId).delete();
      customers = customers.where((c) => c.ownerId != ownerId).toList();
    } catch (e) {
      print('Error deleting customer: $e');
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
      
      if (snapshot.docs.isNotEmpty) {
        await snapshot.docs.first.reference.delete();
        workOrders = workOrders.where((w) => w.vehicleId != vehicleId).toList();
      }
    } catch (e) {
      print('Error deleting work order: $e');
    }
  }

  // Stream of customers for real-time updates
  Stream<List<Customer>> streamCustomers() {
    return _firestore.collection('owners').snapshots().map((snapshot) {
      return snapshot.docs.map((doc) {
        final data = doc.data();
        return Customer.fromJson(data);
      }).toList();
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
      await _firestore.collection('vehicles').doc(vehicle.vin).set(vehicle.toJson());
      vehicles = [...vehicles, vehicle];
      vehicles.sort((a, b) {
        int manufacturerCompare = a.manufacturer.compareTo(b.manufacturer);
        if (manufacturerCompare != 0) return manufacturerCompare;
        return a.model.compareTo(b.model);
      });
    } catch (e) {
      print('Error adding vehicle: $e');
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
    try {
      await _firestore.collection('vehicles').doc(vin).delete();
      vehicles = vehicles.where((v) => v.vin != vin).toList();
    } catch (e) {
      print('Error deleting vehicle: $e');
    }
  }

  // Stream of vehicles for a specific customer for real-time updates
  Stream<List<Vehicle>> streamCustomerVehicles(String ownerId) {
    return _firestore
        .collection('vehicles')
        .where('owner_id', isEqualTo: ownerId)
        .snapshots()
        .map((snapshot) {
          final vehicles = snapshot.docs.map((doc) {
            final data = doc.data();
            return Vehicle.fromJson(data);
          }).toList();

          // Sort vehicles by manufacturer and model
          vehicles.sort((a, b) {
            int manufacturerCompare = a.manufacturer.compareTo(b.manufacturer);
            if (manufacturerCompare != 0) return manufacturerCompare;
            return a.model.compareTo(b.model);
          });

          return vehicles;
        });
  }

  bool get hasInitialLoad => _hasInitialLoad;
}
