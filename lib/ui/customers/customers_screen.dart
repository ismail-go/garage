import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:garage/core/base/base_state.dart';
import 'package:garage/data/model/customer/customer.dart';
import 'package:garage/ui/customer_detail/customer_detail_screen.dart';
import 'package:garage/ui/customers/customers_view_model.dart';
import 'package:garage/ui/widgets/bottom_sheets/add_customer/add_customer_sheet.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../customer_detail/customer_detail_view_model.dart';

class CustomersScreen extends StatefulWidget {
  final CustomersViewModel viewModel;

  const CustomersScreen({
    super.key,
    required this.viewModel,
  });

  @override
  State<CustomersScreen> createState() => _CustomersScreenState(viewModel);
}

class _CustomersScreenState
    extends BaseState<CustomersViewModel, CustomersScreen> {
  late TextEditingController _searchController;
  late FocusNode _searchFocusNode;

  _CustomersScreenState(super.viewModel);

  @override
  void initState() {
    super.initState();
    _searchController = TextEditingController(text: viewModel.searchValue);
    _searchFocusNode = FocusNode();
    _searchFocusNode.addListener(_onFocusChange);
  }

  void _onFocusChange() {
    setState(() {
      // This will trigger a rebuild, allowing AnimatedSwitcher
      // to pick up the change in its child based on _searchFocusNode.hasFocus
    });
  }

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      slivers: [
        SliverToBoxAdapter(
          child: SafeArea(
            bottom: false,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
              child: _searchBar(),
            ),
          ),
        ),
        StreamBuilder<List<Customer>>(
          stream: viewModel.customerStream,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting &&
                !snapshot.hasData) {
              return SliverFillRemaining(
                  child: Center(child: CircularProgressIndicator()));
            }

            if (snapshot.hasError) {
              print("Error in customer stream: ${snapshot.error}");
              return SliverFillRemaining(
                  child: Center(
                      child:
                          Text(AppLocalizations.of(context)!.error('Error loading customers. Please try again.'))));
            }

            final allCustomers = snapshot.data;

            if (allCustomers == null || allCustomers.isEmpty) {
              return SliverFillRemaining(
                  child: Center(child: Text(AppLocalizations.of(context)!.nA)));
            }

            return Observer(builder: (context) {
              final filteredCustomers = allCustomers
                  .where((customer) => searchCondition(customer))
                  .toList();

              if (filteredCustomers.isEmpty) {
                return SliverFillRemaining(
                    child: Center(
                        child: Text(AppLocalizations.of(context)!.nA)));
              }
              
              return SliverPadding(
                padding: EdgeInsets.fromLTRB(
                    16, 0, 16, MediaQuery.of(context).padding.bottom + 16),
                sliver: SliverList(
                  delegate: SliverChildBuilderDelegate(
                    (context, index) {
                      final customer = filteredCustomers[index];
                      return _customerItem(customer);
                    },
                    childCount: filteredCustomers.length,
                  ),
                ),
              );
            });
          },
        ),
      ],
    );
  }

  Widget _customerItem(Customer customer) {
    return Column(
      children: [
        InkWell(
          onTap: () async {
            final customerDetailViewModel = CustomerDetailViewModel(customer.ownerId);
            Navigator.push(
              context,
              CupertinoPageRoute(
                builder: (context) => CustomerDetailScreen(
                  viewModel: customerDetailViewModel,
                ),
              ),
            );
          },
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 10.0),
            child: Row(
              children: [
                Container(
                  width: 52,
                  height: 52,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.grey.shade300,
                    image: customer.profilePhotoUrl.isNotEmpty
                        ? DecorationImage(
                            image: NetworkImage(customer.profilePhotoUrl),
                            fit: BoxFit.cover,
                          )
                        : null,
                  ),
                  child: customer.profilePhotoUrl.isEmpty
                      ? Icon(Icons.person, color: Colors.grey.shade500, size: 28)
                      : null,
                ),
                SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        customer.fullName,
                        style: Theme.of(context).textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.w600,
                            ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      SizedBox(height: 2),
                      Text(
                        customer.companyName.isNotEmpty
                            ? customer.companyName
                            : customer.phoneNumber,
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              color: Colors.grey[600],
                            ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
                Icon(Icons.chevron_right, color: Colors.grey[400], size: 24),
              ],
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(left: 72.0, right: 8.0),
          child: Divider(height: 1, color: Colors.grey[200]),
        ),
      ],
    );
  }

  Widget _searchBar() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Row(
        children: [
          Expanded(
            child: CupertinoSearchTextField(
              controller: _searchController,
              focusNode: _searchFocusNode,
              borderRadius: BorderRadius.circular(12),
              padding: EdgeInsets.symmetric(horizontal: 8, vertical: 12),
              prefixInsets: EdgeInsets.only(left: 12),
              suffixInsets: EdgeInsets.only(right: 12),
              backgroundColor: Colors.grey.shade200,
              smartDashesType: SmartDashesType.disabled,
              smartQuotesType: SmartQuotesType.disabled,
              onChanged: (value) {
                viewModel.searchValue = value;
              },
            ),
          ),
          AnimatedSwitcher(
            duration: const Duration(milliseconds: 200),
            transitionBuilder: (Widget child, Animation<double> animation) {
              return FadeTransition(
                opacity: animation,
                child: SizeTransition(
                  sizeFactor: animation,
                  axis: Axis.horizontal,
                  child: child,
                ),
              );
            },
            child: _searchFocusNode.hasFocus
                ? Padding(
                    key: ValueKey('cancelButton'), // Key for AnimatedSwitcher
                    padding: const EdgeInsets.only(left: 8.0),
                    child: CupertinoButton(
                      padding: EdgeInsets.zero,
                      child: Text(AppLocalizations.of(context)!.cancel),
                      onPressed: () {
                        _searchController.clear();
                        viewModel.searchValue = '';
                        _searchFocusNode.unfocus();
                      },
                    ),
                  )
                : SizedBox.shrink(key: ValueKey('noCancelButton')), // Placeholder when not focused
          ),
        ],
      ),
    );
  }

  bool searchCondition(Customer customer) {
    final searchLower = viewModel.searchValue.toLowerCase();
    return customer.fullName.toLowerCase().contains(searchLower) ||
        customer.companyName.toLowerCase().contains(searchLower) ||
        customer.phoneNumber.toLowerCase().contains(searchLower) ||
        customer.email.toLowerCase().contains(searchLower);
  }

  @override
  void dispose() {
    _searchController.dispose();
    _searchFocusNode.removeListener(_onFocusChange);
    _searchFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget buildFloatingActionButton(BuildContext context) {
    return FloatingActionButton(
      onPressed: () {
        showModalBottomSheet(
          context: context,
          isScrollControlled: true,
          useSafeArea: true,
          builder: (context) =>
              AddCustomerBottomSheet(onAddCustomer: viewModel.addCustomer),
        );
      },
      child: const Icon(Icons.person_add_outlined),
    );
  }
}
