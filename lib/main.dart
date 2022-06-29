import 'package:flutter/material.dart';
import 'package:api_project/providers/authProvider.dart';
import 'package:api_project/providers/categoryProvider.dart';
import 'package:api_project/screens/categories.dart';
import 'package:api_project/screens/home.dart';
import 'package:api_project/screens/login.dart';
import 'package:api_project/screens/register.dart';
import 'package:provider/provider.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => AuthProvider(),
      child: Consumer<AuthProvider>(
        builder: (context, authProvider, child) {
          return MultiProvider(
            providers: [
              ChangeNotifierProvider<CategoryProvider>(
                  create: (context) => CategoryProvider(authProvider)),
            ],
            child: MaterialApp(
              title: 'Welcome to Flutter',
              routes: {
                '/': (context) {
                  final authProvider = Provider.of<AuthProvider>(context);
                  if (authProvider.isAuthenticated) {
                    Provider.of<CategoryProvider>(context, listen: false)
                        .init();
                    return Home();
                  } else {
                    return Login();
                  }
                },
                '/login': (context) => Login(),
                '/register': (context) => Register(),
                '/home': (context) => Home(),
                '/categories': (context) => Categories(),
              },
            ),
          );
        },
      ),
    );
  }
}
