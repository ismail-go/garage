import 'package:json_annotation/json_annotation.dart';

part 'vehicle.g.dart';

@JsonSerializable()
class Vehicle {
  @JsonKey(name: 'created_at')
  final int createdAt;

  @JsonKey(name: 'driver_id')
  final String driverId;

  @JsonKey(name: 'fuel_type')
  final String fuelType;

  @JsonKey(name: 'image_url')
  final String imageUrl;

  @JsonKey(name: 'kilometer')
  final String kilometer;

  @JsonKey(name: 'last_service_date')
  final int lastServiceDate;

  @JsonKey(name: 'manufacturer')
  final String manufacturer;

  @JsonKey(name: 'model')
  final String model;

  @JsonKey(name: 'next_service_due')
  final int nextServiceDue;

  @JsonKey(name: 'owner_id')
  final String ownerId;

  @JsonKey(name: 'plate_no')
  final String plateNo;

  @JsonKey(name: 'updated_at')
  final int updatedAt;

  @JsonKey(name: 'vin')
  final String vin;

  @JsonKey(name: 'year')
  final String year;

  Vehicle({
    required this.createdAt,
    required this.driverId,
    required this.fuelType,
    required this.imageUrl,
    required this.kilometer,
    required this.lastServiceDate,
    required this.manufacturer,
    required this.model,
    required this.nextServiceDue,
    required this.ownerId,
    required this.plateNo,
    required this.updatedAt,
    required this.vin,
    required this.year,
  });

  factory Vehicle.fromJson(Map<String, dynamic> json) => _$VehicleFromJson(json);

  Map<String, dynamic> toJson() => _$VehicleToJson(this);

  Vehicle copyWith({
    int? createdAt,
    String? driverId,
    String? fuelType,
    String? imageUrl,
    String? kilometer,
    int? lastServiceDate,
    String? manufacturer,
    String? model,
    int? nextServiceDue,
    String? ownerId,
    String? plateNo,
    int? updatedAt,
    String? vin,
    String? year,
  }) {
    return Vehicle(
      createdAt: createdAt ?? this.createdAt,
      driverId: driverId ?? this.driverId,
      fuelType: fuelType ?? this.fuelType,
      imageUrl: imageUrl ?? this.imageUrl,
      kilometer: kilometer ?? this.kilometer,
      lastServiceDate: lastServiceDate ?? this.lastServiceDate,
      manufacturer: manufacturer ?? this.manufacturer,
      model: model ?? this.model,
      nextServiceDue: nextServiceDue ?? this.nextServiceDue,
      ownerId: ownerId ?? this.ownerId,
      plateNo: plateNo ?? this.plateNo,
      updatedAt: updatedAt ?? this.updatedAt,
      vin: vin ?? this.vin,
      year: year ?? this.year,
    );
  }
} 