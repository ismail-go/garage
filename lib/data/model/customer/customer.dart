import 'package:json_annotation/json_annotation.dart';

part 'customer.g.dart';

@JsonSerializable()
class Customer {
  @JsonKey(name: 'address')
  String address;

  @JsonKey(name: 'company_name')
  String companyName;

  @JsonKey(name: 'created_at')
  int createdAt;

  @JsonKey(name: 'email')
  String email;

  @JsonKey(name: 'full_name')
  String fullName;

  @JsonKey(name: 'national_id')
  String nationalId;

  @JsonKey(name: 'owner_id')
  String ownerId;

  @JsonKey(name: 'owner_type')
  String ownerType;

  @JsonKey(name: 'phone_number')
  String phoneNumber;

  @JsonKey(name: 'profile_photo_url')
  String profilePhotoUrl;

  @JsonKey(name: 'tax_id')
  String taxId;

  @JsonKey(name: 'updated_at')
  int updatedAt;

  @JsonKey(name: 'vehicles')
  List<String> vehicles;

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

  Customer copyWith({
    String? address,
    String? companyName,
    int? createdAt,
    String? email,
    String? fullName,
    String? nationalId,
    String? ownerId,
    String? ownerType,
    String? phoneNumber,
    String? profilePhotoUrl,
    String? taxId,
    int? updatedAt,
    List<String>? vehicles,
  }) {
    return Customer(
      address: address ?? this.address,
      companyName: companyName ?? this.companyName,
      createdAt: createdAt ?? this.createdAt,
      email: email ?? this.email,
      fullName: fullName ?? this.fullName,
      nationalId: nationalId ?? this.nationalId,
      ownerId: ownerId ?? this.ownerId,
      ownerType: ownerType ?? this.ownerType,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      profilePhotoUrl: profilePhotoUrl ?? this.profilePhotoUrl,
      taxId: taxId ?? this.taxId,
      updatedAt: updatedAt ?? this.updatedAt,
      vehicles: vehicles ?? this.vehicles,
    );
  }
}
