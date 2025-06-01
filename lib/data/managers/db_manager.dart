import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:garage/data/model/customer/customer.dart';
import 'package:garage/data/model/work_order/work_order.dart';
import 'package:mobx/mobx.dart';
import 'dart:convert';
import 'package:garage/data/fake_data.dart';

part 'db_manager.g.dart';

final DbManager dbManager = DbManager._internal();

class DbManager = _DbManager with _$DbManager;

abstract class _DbManager with Store {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  _DbManager._internal();

  @observable
  List<Customer> customers = [];

  @observable
  List<WorkOrder> workOrders = [];

  // Initialize customers from Firestore owners collection
  @action
  Future<void> initCustomers() async {
    try {
      final QuerySnapshot snapshot = await _firestore.collection('owners').get();
      customers = snapshot.docs.map((doc) {
        final data = doc.data() as Map<String, dynamic>;
        return Customer.fromJson(data);
      }).toList();
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
      await _firestore.collection('owners').add(customer.toJson());
      customers = [customer, ...customers];
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
  Future<void> updateCustomer(String nationalId, Customer customer) async {
    try {
      final QuerySnapshot snapshot = await _firestore
          .collection('owners')
          .where('national_id', isEqualTo: nationalId)
          .get();
      
      if (snapshot.docs.isNotEmpty) {
        await snapshot.docs.first.reference.update(customer.toJson());
        final index = customers.indexWhere((c) => c.nationalId == nationalId);
        if (index != -1) {
          final List<Customer> updatedList = List.from(customers);
          updatedList[index] = customer;
          customers = updatedList;
        }
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
  Future<void> deleteCustomer(String nationalId) async {
    try {
      final QuerySnapshot snapshot = await _firestore
          .collection('owners')
          .where('national_id', isEqualTo: nationalId)
          .get();
      
      if (snapshot.docs.isNotEmpty) {
        await snapshot.docs.first.reference.delete();
        customers = customers.where((c) => c.nationalId != nationalId).toList();
        // Force a refresh of the customers list if it's empty
        if (customers.isEmpty) {
          await initCustomers();
        }
      }
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
      
      // Refresh the customers list
      await initCustomers();
    } catch (e) {
      print('Error adding sample owners: $e');
    }
  }
}
