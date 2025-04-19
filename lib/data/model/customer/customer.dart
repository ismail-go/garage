import 'package:json_annotation/json_annotation.dart';

part 'customer.g.dart';

@JsonSerializable()
class Customer {
  String name;
  String surname;
  @JsonKey(name: 'tc_no')
  String tcNo;
  @JsonKey(name: 'tax_no')
  String taxNo;
  @JsonKey(name: 'tel_no')
  String telNo;
  String address;
  double debit;

  Customer({
    required this.name,
    required this.surname,
    required this.tcNo,
    required this.taxNo,
    required this.telNo,
    required this.address,
    required this.debit,
  });

  factory Customer.fromJson(Map<String, dynamic> json) => _$CustomerFromJson(json);

  Map<String, dynamic> toJson() => _$CustomerToJson(this);
}
