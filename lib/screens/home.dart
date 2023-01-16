import 'package:api_project/providers/authProvider.dart';
import 'package:api_project/providers/categoryProvider.dart';
import 'package:api_project/providers/transactionProvider.dart';
import 'package:flutter/material.dart';
import 'package:api_project/screens/categories.dart';
import 'package:api_project/screens/transactions.dart';
import 'package:provider/provider.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  int selectedIndex = 0;
  List<Widget> widgetOptions = [Transactions(), Categories()];

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Welcome to Flutter',
      home: Scaffold(
        body: widgetOptions.elementAt(selectedIndex),
        bottomNavigationBar: BottomAppBar(
          shape: CircularNotchedRectangle(),
          notchMargin: 4,
          child: BottomNavigationBar(
            backgroundColor: Theme.of(context).primaryColor.withAlpha(0),
            elevation: 0,
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
            currentIndex: selectedIndex,
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
      Provider.of<TransactionProvider>(context, listen: false).clear();
      Provider.of<CategoryProvider>(context, listen: false).clear();
      await provider.logOut();
    } else {
      //Provider.of<CategoryProvider>(context, listen: false).init();
      setState(() {
        selectedIndex = index;
      });
    }

  }
}