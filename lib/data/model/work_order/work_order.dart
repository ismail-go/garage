import 'package:garage/data/model/work_state/work_state.dart';
import 'package:json_annotation/json_annotation.dart';

part 'work_order.g.dart';

@JsonSerializable()
class WorkOrder {
  @JsonKey(name: 'customer_name')
  String customerName;
  @JsonKey(name: 'repairman_name')
  String repairmanName;
  @JsonKey(name: 'repairman_id')
  String repairmanId;
  @JsonKey(name: 'customer_id')
  String customerId;
  @JsonKey(name: 'phone_number')
  String phoneNumber;
  @JsonKey(name: 'vehicle_id')
  String vehicleId;
  @JsonKey(name: 'work_state')
  WorkState workState;

  WorkOrder({
    required this.customerName,
    required this.repairmanName,
    required this.repairmanId,
    required this.customerId,
    required this.phoneNumber,
    required this.vehicleId,
    required this.workState,
  });

  factory WorkOrder.fromJson(Map<String, dynamic> json) => _$WorkOrderFromJson(json);

  Map<String, dynamic> toJson() => _$WorkOrderToJson(this);
}
