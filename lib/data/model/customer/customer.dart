import 'package:json_annotation/json_annotation.dart';

part 'customer.g.dart';

@JsonSerializable()
class Customer {
  @JsonKey(name: 'address')
  final String address;

  @JsonKey(name: 'company_name')
  final String companyName;

  @JsonKey(name: 'created_at')
  final int createdAt;

  @JsonKey(name: 'email')
  final String email;

  @JsonKey(name: 'full_name')
  final String fullName;

  @JsonKey(name: 'national_id')
  final String nationalId;

  @JsonKey(name: 'owner_id')
  final String ownerId;

  @JsonKey(name: 'owner_type')
  final String ownerType;

  @JsonKey(name: 'phone_number')
  final String phoneNumber;

  @JsonKey(name: 'profile_photo_url')
  final String profilePhotoUrl;

  @JsonKey(name: 'tax_id')
  final String taxId;

  @JsonKey(name: 'updated_at')
  final int updatedAt;

  @JsonKey(name: 'vehicles')
  final List<String> vehicles;

  Customer({
    required this.address,
    required this.companyName,
    required this.createdAt,
    required this.email,
    required this.fullName,
    required this.nationalId,
    required this.ownerId,
    required this.ownerType,
    required this.phoneNumber,
    required this.profilePhotoUrl,
    required this.taxId,
    required this.updatedAt,
    required this.vehicles,
  });

  factory Customer.fromJson(Map<String, dynamic> json) => _$CustomerFromJson(json);

  Map<String, dynamic> toJson() => _$CustomerToJson(this);
}
