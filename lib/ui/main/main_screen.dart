import 'package:flutter/material.dart';
import 'package:garage/core/base/base_state.dart';
import 'package:garage/data/model/customer/customer.dart';
import 'package:garage/ui/customers/customers_screen.dart';
import 'package:garage/ui/customers/customers_view_model.dart';
import 'package:garage/ui/home/home_screen.dart';
import 'package:garage/ui/main/main_view_model.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:garage/ui/widgets/bottom_sheets/add_customer/add_customer_sheet.dart';
import 'package:garage/ui/widgets/custom_bars/blurred_app_bar.dart';
import 'package:garage/ui/widgets/custom_bars/blurred_bottom_nav_bar.dart';
import 'package:garage/ui/widgets/bottom_sheets/base_bottom_sheet.dart';

class MainScreen extends StatefulWidget {
  final void Function(Locale)? onLocaleChanged;
  const MainScreen({super.key, this.onLocaleChanged});

  @override
  State<MainScreen> createState() => _MainScreenState(MainViewModel());
}

class _MainScreenState extends BaseState<MainViewModel, MainScreen> {
  final CustomersViewModel _customersViewModel = CustomersViewModel();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  _MainScreenState(super.viewModel);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      extendBodyBehindAppBar: true,
      resizeToAvoidBottomInset: true,
      extendBody: true,
      appBar: BlurredAppBar(
        leading: IconButton(
          icon: Icon(Icons.menu),
          onPressed: () => _scaffoldKey.currentState?.openDrawer(),
        ),
        title: Observer(builder: (context) {
          return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Text(viewModel.currentIndex == 0 ? "Gözen Otomotiv" : "Müşteriler"),
          );
        }),
      ),
      floatingActionButton: Observer(builder: (context) {
        // Only show FAB on the Customers screen (index 1)
        if (viewModel.currentIndex == 1) {
          return FloatingActionButton(
            onPressed: () {
              showModalBottomSheet(
                context: context,
                isScrollControlled: true,
                useSafeArea: true,
                builder: (context) => AddCustomerBottomSheet(
                  onAddCustomer: (customer) async {
                    await _customersViewModel.addCustomer(customer);
                  },
                ),
              );
            },
            child: const Icon(Icons.add),
          );
        }
        return const SizedBox.shrink(); // Return an empty widget instead of null
      }),
      bottomNavigationBar: Observer(builder: (context) {
        return BlurredBottomNavigationBar(
          items: const [
            BottomNavigationBarItem(icon: Icon(Icons.home), label: ""), 
            BottomNavigationBarItem(icon: Icon(Icons.group), label: "")
          ],
          onTap: (value) {
            viewModel.currentIndex = value;
            viewModel.pageController.animateToPage(value, duration: Duration(milliseconds: 200), curve: Curves.linear);
          },
          currentIndex: viewModel.currentIndex,
        );
      }),
      body: PageView(
        controller: viewModel.pageController,
        onPageChanged: (value) {
          viewModel.currentIndex = value;
        },
        children: [
          HomeScreen(),
          CustomersScreen(viewModel: _customersViewModel),
        ],
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              decoration: BoxDecoration(
                color: Theme.of(context).primaryColor,
              ),
              child: Text('Garage Manager', style: TextStyle(color: Colors.white, fontSize: 20)),
            ),
            ListTile(
              leading: Icon(Icons.language),
              title: Text('Change Language'),
              onTap: () async {
                Navigator.pop(context);
                final currentLocale = Localizations.localeOf(context);
                final selected = await showModalBottomSheet<Locale>(
                  context: context,
                  isScrollControlled: true,
                  backgroundColor: Colors.transparent,
                  builder: (context) => BaseBottomSheet(
                    
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 16.0),
                          child: Text('Select Language', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                        ),
                        _LanguageTile(
                          locale: Locale('en'),
                          selected: currentLocale.languageCode == 'en',
                          title: 'English',
                          onTap: () => Navigator.pop(context, Locale('en')),
                        ),
                        _LanguageTile(
                          locale: Locale('tr'),
                          selected: currentLocale.languageCode == 'tr',
                          title: 'Türkçe',
                          onTap: () => Navigator.pop(context, Locale('tr')),
                        ),
                        SizedBox(height: 24),
                      ],
                    ),
                  ),
                );
                if (selected != null && widget.onLocaleChanged != null) {
                  widget.onLocaleChanged!(selected);
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}

// Language tile widget for the language picker
class _LanguageTile extends StatelessWidget {
  final Locale locale;
  final bool selected;
  final String title;
  final VoidCallback onTap;
  const _LanguageTile({required this.locale, required this.selected, required this.title, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: onTap,
        child: Container(
          decoration: BoxDecoration(
            border: Border.all(
              color: selected ? Theme.of(context).colorScheme.primary : Colors.grey[300]!,
              width: selected ? 2.5 : 1.0,
            ),
            borderRadius: BorderRadius.circular(12),
            color: selected ? Theme.of(context).colorScheme.primary.withOpacity(0.08) : Colors.transparent,
          ),
          child: ListTile(
            leading: Icon(Icons.language, color: selected ? Theme.of(context).colorScheme.primary : null),
            title: Text(title, style: TextStyle(fontWeight: selected ? FontWeight.bold : FontWeight.normal)),
            trailing: selected ? Icon(Icons.check, color: Theme.of(context).colorScheme.primary, size: 28, weight: 900) : null,
          ),
        ),
      ),
    );
  }
}
