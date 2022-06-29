import 'package:api_project/providers/authProvider.dart';
import 'package:api_project/screens/categories.dart';
import 'package:api_project/screens/home.dart';
import 'package:api_project/screens/login.dart';
import 'package:api_project/screens/register.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import './providers/categoryProvider.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      key:GlobalObjectKey(context),
      create: (context) => AuthProvider(),
      child: Consumer<AuthProvider>(builder: (context, authProvider, child) {
        return MultiProvider(
            providers: [
              ChangeNotifierProvider<CategoryProvider>(
                create: (context) => CategoryProvider(authProvider),
              )
            ],
            child: MaterialApp(
              title: 'title',

              routes: {
                '/': (context) {
                  final authProvider = Provider.of<AuthProvider>(context);
                  if (authProvider.isAuthenticated) {
                    return Home();
                  } else {
                    return Login();
                  }
                },
                '/login': (context) => Login(),
                '/register': (context) => Register(),
                '/categories': (context) => Categories(),
              },
            ));
      }),
    );
  }
}
