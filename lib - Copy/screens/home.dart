import 'package:api_project/providers/authProvider.dart';
import 'package:api_project/screens/categories.dart';
import 'package:api_project/screens/transactions.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Home extends StatefulWidget {

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  List<Widget> widgetOptions = [Transactions(), Categories()];
  int selectedIndex = 0; // default will be Transactions()

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: widgetOptions.elementAt(selectedIndex),

        // here's out bottom navigation bar
        bottomNavigationBar: BottomAppBar(
          shape: CircularNotchedRectangle(),
          notchMargin: 4,
          child: BottomNavigationBar(
            backgroundColor: Theme.of(context).primaryColor.withAlpha(0),
            elevation: 0,

            // here we specify all menu items, with labels and icons
            items: const <BottomNavigationBarItem>[
              BottomNavigationBarItem(
                  icon: Icon(Icons.account_balance_wallet),
                  label: 'Transactions'),
              BottomNavigationBarItem(
                  icon: Icon(Icons.category),
                  label: 'Categories'),
              BottomNavigationBarItem(
                  icon: Icon(Icons.logout),
                  label: 'Log out')
            ],
            currentIndex: selectedIndex, // default active menu
            onTap: onItemTapped,
          ),
        ),
      ),
    );
  }
  Future<void> onItemTapped(int index) async {
    if (index == 2) {
      final AuthProvider provider =
      Provider.of<AuthProvider>(context, listen: false);

      await provider.logout();
    } else {
      setState(() {
        selectedIndex = index;
      });
    }
  }
}
