// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'customer.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Customer _$CustomerFromJson(Map<String, dynamic> json) => Customer(
      address: json['address'] as String,
      companyName: json['company_name'] as String,
      createdAt: (json['created_at'] as num).toInt(),
      email: json['email'] as String,
      fullName: json['full_name'] as String,
      nationalId: json['national_id'] as String,
      ownerId: json['owner_id'] as String,
      ownerType: json['owner_type'] as String,
      phoneNumber: json['phone_number'] as String,
      profilePhotoUrl: json['profile_photo_url'] as String,
      taxId: json['tax_id'] as String,
      updatedAt: (json['updated_at'] as num).toInt(),
      vehicles:
          (json['vehicles'] as List<dynamic>).map((e) => e as String).toList(),
    );

Map<String, dynamic> _$CustomerToJson(Customer instance) => <String, dynamic>{
      'address': instance.address,
      'company_name': instance.companyName,
      'created_at': instance.createdAt,
      'email': instance.email,
      'full_name': instance.fullName,
      'national_id': instance.nationalId,
      'owner_id': instance.ownerId,
      'owner_type': instance.ownerType,
      'phone_number': instance.phoneNumber,
      'profile_photo_url': instance.profilePhotoUrl,
      'tax_id': instance.taxId,
      'updated_at': instance.updatedAt,
      'vehicles': instance.vehicles,
    };
