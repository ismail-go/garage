import 'package:flutter/material.dart';
import 'package:garage/core/base/base_state.dart';
import 'package:garage/data/helper.dart';
import 'package:garage/data/managers/route_manager.dart';
import 'package:garage/data/model/work_order/work_order.dart';
import 'package:garage/gen/assets.gen.dart';
import 'package:garage/ui/home/home_view_model.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => HomeScreenState(HomeViewModel());
}

class HomeScreenState extends BaseState<HomeViewModel, HomeScreen> {
  HomeScreenState(super.viewModel);

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: EdgeInsets.all(16).add(EdgeInsets.only(bottom: MediaQuery.of(context).padding.bottom, top: MediaQuery.of(context).padding.top)),
      children: [
        _availableCreditCard(context),
        SizedBox(height: 16),
        _workOrders(context),
      ],
    );
  }

  Column _workOrders(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 16.0),
          child: Text(AppLocalizations.of(context)!.workOrders, style: Theme.of(context).textTheme.titleMedium),
        ),
        ...List.generate(viewModel.workOrders.length, (index) => _workOrderCardItem(viewModel.workOrders[index]))
      ],
    );
  }

  Widget _workOrderCardItem(WorkOrder order) {
    return InkWell(
      onTap: () {
        RouteManager.showWorkOrderScreen(context, order);
      },
      child: Card(
          child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          children: [
            CircleAvatar(
              child: Icon(Icons.person),
            ),
            SizedBox(width: 8.0),
            Expanded(
              child: Column(
                children: [
                  Row(
                    children: [
                      Icon(Icons.person_3, size: 20, color: Colors.black45),
                      SizedBox(width: 4.0),
                      Text(order.customerName, style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
                    ],
                  ),
                  Row(
                    children: [
                      Assets.icons.repairmanIcon.svg(height: 18, width: 18, color: Colors.black45),
                      SizedBox(width: 4.0),
                      Text(order.repairmanName, style: Theme.of(context).textTheme.titleMedium),
                      Spacer(),
                      Text(order.workState.state.name, style: Theme.of(context).textTheme.titleMedium?.copyWith(color: Colors.red)),
                    ],
                  ),
                  Row(
                    children: [
                      Assets.icons.truckIcon.svg(height: 12, width: 12, color: Colors.black45),
                      SizedBox(width: 4.0),
                      Text(order.vehicleId, style: Theme.of(context).textTheme.titleMedium?.copyWith(color: Colors.grey)),
                      Spacer(),
                      Icon(Icons.calendar_month, size: 20, color: Colors.black45),
                      Text(formatSmartDate(order.workState.time), style: Theme.of(context).textTheme.titleMedium?.copyWith(color: Colors.grey)),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      )),
    );
  }

  Column _availableCreditCard(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 16.0),
          child: Text(AppLocalizations.of(context)!.bestCard, style: Theme.of(context).textTheme.titleMedium),
        ),
        Card(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(AppLocalizations.of(context)!.cardNumber, style: Theme.of(context).textTheme.titleMedium),
                    Text("1231 1231 2342 3424", style: Theme.of(context).textTheme.titleMedium?.copyWith(color: Colors.grey)),
                    Spacer(),
                    Icon(Icons.copy),
                  ],
                ),
                Row(
                  children: [
                    Text(AppLocalizations.of(context)!.cardDate, style: Theme.of(context).textTheme.titleMedium),
                    Text("12/03", style: Theme.of(context).textTheme.titleMedium?.copyWith(color: Colors.grey)),
                  ],
                ),
                Row(
                  children: [
                    Text(AppLocalizations.of(context)!.accountCutoffDate, style: Theme.of(context).textTheme.titleMedium),
                    Text("12/03", style: Theme.of(context).textTheme.titleMedium?.copyWith(color: Colors.grey)),
                  ],
                ),
                Row(
                  children: [
                    Text(AppLocalizations.of(context)!.lastPaymentDate, style: Theme.of(context).textTheme.titleMedium),
                    Text("12/03", style: Theme.of(context).textTheme.titleMedium?.copyWith(color: Colors.grey)),
                  ],
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
