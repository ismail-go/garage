// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'work_order.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

WorkOrder _$WorkOrderFromJson(Map<String, dynamic> json) => WorkOrder(
      customerName: json['customer_name'] as String,
      repairmanName: json['repairman_name'] as String,
      repairmanId: json['repairman_id'] as String,
      customerTcNo: json['customer_tc_no'] as String,
      telNo: json['tel_no'] as String,
      plateNo: json['plate_no'] as String,
      workState: WorkState.fromJson(json['work_state'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$WorkOrderToJson(WorkOrder instance) => <String, dynamic>{
      'customer_name': instance.customerName,
      'repairman_name': instance.repairmanName,
      'repairman_id': instance.repairmanId,
      'customer_tc_no': instance.customerTcNo,
      'tel_no': instance.telNo,
      'plate_no': instance.plateNo,
      'work_state': instance.workState,
    };
