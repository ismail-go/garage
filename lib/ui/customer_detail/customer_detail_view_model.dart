import 'package:garage/core/base/base_view_model.dart';
import 'package:mobx/mobx.dart';

import '../../data/model/customer.dart';

part 'customer_detail_view_model.g.dart';

class CustomerDetailViewModel extends _CustomerDetailViewModel with _$CustomerDetailViewModel {
  final Customer customer;

  CustomerDetailViewModel(this.customer);
}

abstract class _CustomerDetailViewModel extends BaseViewModel with Store {
  @override
  void init() {}

  @override
  void dispose() {
    // TODO: implement dispose
  }
}
