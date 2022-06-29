import 'dart:io';
import 'package:api_project/providers/authProvider.dart';
import 'package:device_info/device_info.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

class Login extends StatefulWidget {
  Login();
  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  late String deviceName;
  String errorMessage = '';

  @override
  void initState() {
    super.initState();
    getDeviceName();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Login'),
      ),
      body: Container(
        color: Theme.of(context).primaryColorDark,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Card(
              elevation: 8,
              margin: EdgeInsets.only(left: 16, right: 16),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      TextFormField(
                        keyboardType: TextInputType.emailAddress,
                        controller: emailController,
                        decoration: InputDecoration(
                          labelText: 'Email',
                        ),
                        validator: (String? value) {
                          // Validation condition
                          if (value!.trim().isEmpty) {
                            return 'Please enter email';
                          }

                          return null;
                        },
                      ),
                      TextFormField(
                        keyboardType: TextInputType.text,
                        controller: passwordController,
                        obscureText: true,
                        autocorrect: false,
                        enableSuggestions: false,
                        decoration: InputDecoration(labelText: 'Password'),
                        validator: (String? value) {
                          // Validation condition
                          if (value!.isEmpty) {
                            return 'Please enter password';
                          }

                          return null;
                        },
                      ),
                      ElevatedButton(
                        onPressed: () => submit(),
                        child: Text('Login'),
                        style: ElevatedButton.styleFrom(
                            minimumSize: Size(double.infinity, 36)),
                      ),
                      Text(errorMessage, style: TextStyle(color: Colors.red)),

                      Padding(
                        padding: const EdgeInsets.only(top: 20),
                        child: InkWell(
                          onTap: ()=>Navigator.pushNamed(context, '/register'),
                          child: Text('Register new user'),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> submit() async {
    final form = _formKey.currentState;

    if (!form!.validate()) {
      return;
    }

    final AuthProvider provider = Provider.of<AuthProvider>(context, listen: false);
    try {
      await provider.login(
          emailController.text,
          passwordController.text,
          deviceName
      );
    } catch (Exception) {
      setState(() {
        errorMessage = Exception.toString().replaceAll('Exception: ', '');
      });
    }
  }

  Future<void> getDeviceName() async {
    final DeviceInfoPlugin deviceInfoPlugin = DeviceInfoPlugin();

    try {
      if (Platform.isAndroid) {
        var build = await deviceInfoPlugin.androidInfo;
        setState(() {
          deviceName = build.model;
        });
      } else if (Platform.isIOS) {
        var build = await deviceInfoPlugin.iosInfo;
        setState(() {
          deviceName = build.model;
        });
      }
    } on PlatformException {
      setState(() {
        deviceName = 'Failed to get platform version';
      });
    }
  }
}
