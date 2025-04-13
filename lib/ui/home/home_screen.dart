import 'package:flutter/material.dart';
import 'package:garage/core/base/base_state.dart';
import 'package:garage/gen/assets.gen.dart';
import 'package:garage/ui/home/home_view_model.dart';

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
          child: Text("İş Emirleri", style: Theme.of(context).textTheme.titleMedium),
        ),
        _workOrderCardItem(context),
        _workOrderCardItem(context),
        _workOrderCardItem(context),
        _workOrderCardItem(context),
        _workOrderCardItem(context),
        _workOrderCardItem(context),
        _workOrderCardItem(context),
      ],
    );
  }

  Card _workOrderCardItem(BuildContext context) {
    return Card(
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
                    Text("İsmail Gözen ", style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
                  ],
                ),
                Row(
                  children: [
                    Assets.icons.repairmanIcon.svg(height: 18, width: 18, color: Colors.black45),
                    SizedBox(width: 4.0),
                    Text("Mehmet Usta ", style: Theme.of(context).textTheme.titleMedium),
                    Spacer(),
                    Text("Beklemede", style: Theme.of(context).textTheme.titleMedium?.copyWith(color: Colors.red)),
                  ],
                ),
                Row(
                  children: [
                    Assets.icons.truckIcon.svg(height: 12, width: 12, color: Colors.black45),
                    SizedBox(width: 4.0),
                    Text("20 ADY 012", style: Theme.of(context).textTheme.titleMedium?.copyWith(color: Colors.grey)),
                    Spacer(),
                    Icon(Icons.calendar_month, size: 20, color: Colors.black45),
                    Text("Dün", style: Theme.of(context).textTheme.titleMedium?.copyWith(color: Colors.grey)),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    ));
  }

  Column _availableCreditCard(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 16.0),
          child: Text("En Uygun Kart", style: Theme.of(context).textTheme.titleMedium),
        ),
        Card(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text("Kart No: ", style: Theme.of(context).textTheme.titleMedium),
                    Text("1231 1231 2342 3424", style: Theme.of(context).textTheme.titleMedium?.copyWith(color: Colors.grey)),
                    Spacer(),
                    Icon(Icons.copy),
                  ],
                ),
                Row(
                  children: [
                    Text("Kart Tarih: ", style: Theme.of(context).textTheme.titleMedium),
                    Text("12/03", style: Theme.of(context).textTheme.titleMedium?.copyWith(color: Colors.grey)),
                  ],
                ),
                Row(
                  children: [
                    Text("Hesap Kesim Tarihi: ", style: Theme.of(context).textTheme.titleMedium),
                    Text("12/03", style: Theme.of(context).textTheme.titleMedium?.copyWith(color: Colors.grey)),
                  ],
                ),
                Row(
                  children: [
                    Text("Son Ödeme Tarihi: ", style: Theme.of(context).textTheme.titleMedium),
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
