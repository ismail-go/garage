import 'package:garage/core/base/base_view_model.dart';
import 'package:garage/data/managers/db_manager.dart';
import 'package:garage/data/model/work_order/work_order.dart';
import 'package:mobx/mobx.dart';

part 'home_view_model.g.dart';

class HomeViewModel = _HomeViewModel with _$HomeViewModel;

abstract class _HomeViewModel extends BaseViewModel with Store {
  List<WorkOrder> get workOrders => dbManager.workOrders;

  @override
  void init() {
    dbManager.initWorkOrders();
  }

  @override
  void dispose() {
    // TODO: implement dispose
  }
}
