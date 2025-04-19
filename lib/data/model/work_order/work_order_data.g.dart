// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'work_order_data.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

WorkOrderData _$WorkOrderDataFromJson(Map<String, dynamic> json) =>
    WorkOrderData(
      workOrders: (json['work_orders'] as List<dynamic>)
          .map((e) => WorkOrder.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$WorkOrderDataToJson(WorkOrderData instance) =>
    <String, dynamic>{
      'work_orders': instance.workOrders,
    };
