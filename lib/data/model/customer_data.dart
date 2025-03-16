import 'package:garage/data/model/customer.dart';

class CustomerData {
  List<Customer> customers = [];

  CustomerData({
    required this.customers,
  });

  // From JSON to CustomerList
  factory CustomerData.fromJson(Map<String, dynamic> json) {
    var customersJson = json['customers'] as List;
    List<Customer> customersList = customersJson.map((i) => Customer.fromJson(i)).toList();
    return CustomerData(customers: customersList);
  }

  // From CustomerList to JSON
  Map<String, dynamic> toJson() {
    List<Map<String, dynamic>> customersJson = customers.map((customer) => customer.toJson()).toList();
    return {'customers': customersJson};
  }
}
