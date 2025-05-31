// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'work_order.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

WorkOrder _$WorkOrderFromJson(Map<String, dynamic> json) => WorkOrder(
      customerName: json['customer_name'] as String,
      repairmanName: json['repairman_name'] as String,
      repairmanId: json['repairman_id'] as String,
      customerId: json['customer_id'] as String,
      phoneNumber: json['phone_number'] as String,
      vehicleId: json['vehicle_id'] as String,
      workState: WorkState.fromJson(json['work_state'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$WorkOrderToJson(WorkOrder instance) => <String, dynamic>{
      'customer_name': instance.customerName,
      'repairman_name': instance.repairmanName,
      'repairman_id': instance.repairmanId,
      'customer_id': instance.customerId,
      'phone_number': instance.phoneNumber,
      'vehicle_id': instance.vehicleId,
      'work_state': instance.workState,
    };
