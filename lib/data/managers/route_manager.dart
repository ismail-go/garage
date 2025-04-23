import 'package:flutter/material.dart';
import 'package:garage/data/model/work_order/work_order.dart';
import 'package:garage/ui/work_order/work_order_screen.dart';
import 'package:garage/ui/work_order/work_order_view_model.dart';

class RouteManager {
  static void showWorkOrderScreen(BuildContext context, WorkOrder order) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => WorkOrderScreen(
          viewModel: WorkOrderViewModel(workOrder: order),
        ),
      ),
    );
  }
}
