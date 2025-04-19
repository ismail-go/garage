import 'package:garage/data/model/work_order/work_order.dart';
import 'package:json_annotation/json_annotation.dart';

part 'work_order_data.g.dart';

@JsonSerializable()
class WorkOrderData {

  @JsonKey(name: 'work_orders')
  List<WorkOrder> workOrders = [];

  WorkOrderData({
    required this.workOrders,
  });

  factory WorkOrderData.fromJson(Map<String, dynamic> json) => _$WorkOrderDataFromJson(json);

  Map<String, dynamic> toJson() => _$WorkOrderDataToJson(this);
}
