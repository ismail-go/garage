import 'package:flutter/material.dart';
import 'package:garage/core/base/base_view_model.dart';
import 'package:garage/data/model/work_order/work_order.dart';
import 'package:mobx/mobx.dart';

part 'work_order_view_model.g.dart';

class WorkOrderViewModel extends _WorkOrderViewModel with _$WorkOrderViewModel {
  WorkOrderViewModel({required WorkOrder workOrder}) {
    this.workOrder = workOrder;
  }
}

abstract class _WorkOrderViewModel extends BaseViewModel with Store {
  late WorkOrder workOrder;

  int processIndex = 2;

  final completeColor = Color(0xff5e6172);
  final inProgressColor = Color(0xff5ec792);
  final todoColor = Color(0xffd1d2d7);

  final processes = [
    'Giriş',
    'Kontrol',
    'Tamir',
    'Test',
    'Teslim',
  ];

  Color getColor(int index) {
    if (index == processIndex) {
      return inProgressColor;
    } else if (index < processIndex) {
      return completeColor;
    } else {
      return todoColor;
    }
  }

  final TextEditingController controller = TextEditingController();

  @override
  void init() {
    // TODO: implement init
  }

  @override
  void dispose() {
    // TODO: implement dispose
  }
}
