import 'package:garage/data/model/customer/customer.dart';
import 'package:json_annotation/json_annotation.dart';

part 'customer_data.g.dart';

@JsonSerializable()
class CustomerData {
  List<Customer> customers = [];

  CustomerData({
    required this.customers,
  });

  factory CustomerData.fromJson(Map<String, dynamic> json) => _$CustomerDataFromJson(json);

  Map<String, dynamic> toJson() => _$CustomerDataToJson(this);
}
