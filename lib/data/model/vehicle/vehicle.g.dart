// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'vehicle.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Vehicle _$VehicleFromJson(Map<String, dynamic> json) => Vehicle(
      createdAt: (json['created_at'] as num).toInt(),
      driverId: json['driver_id'] as String,
      fuelType: json['fuel_type'] as String,
      imageUrl: json['image_url'] as String,
      kilometer: json['kilometer'] as String,
      lastServiceDate: (json['last_service_date'] as num).toInt(),
      manufacturer: json['manufacturer'] as String,
      model: json['model'] as String,
      nextServiceDue: (json['next_service_due'] as num).toInt(),
      ownerId: json['owner_id'] as String,
      plateNo: json['plate_no'] as String,
      updatedAt: (json['updated_at'] as num).toInt(),
      vin: json['vin'] as String,
      year: json['year'] as String,
    );

Map<String, dynamic> _$VehicleToJson(Vehicle instance) => <String, dynamic>{
      'created_at': instance.createdAt,
      'driver_id': instance.driverId,
      'fuel_type': instance.fuelType,
      'image_url': instance.imageUrl,
      'kilometer': instance.kilometer,
      'last_service_date': instance.lastServiceDate,
      'manufacturer': instance.manufacturer,
      'model': instance.model,
      'next_service_due': instance.nextServiceDue,
      'owner_id': instance.ownerId,
      'plate_no': instance.plateNo,
      'updated_at': instance.updatedAt,
      'vin': instance.vin,
      'year': instance.year,
    };
