import 'package:api_project/providers/authProvider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'dart:io';
import 'package:flutter/services.dart';
import 'package:device_info/device_info.dart';

class Register extends StatefulWidget {
  @override
  State<Register> createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final passwordConfirmController = TextEditingController();

  String errorMessage = '';
  late String deviceName;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getDeviceName();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Register'),
      ),
      body: Container(
        color: Theme
            .of(context)
            .primaryColorDark,
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
                        controller: nameController,
                        validator: (String? value) {
                          if (value!.isEmpty) {
                            return 'Enter name';
                          }
                          return null;
                        },
                        onChanged: (text) => setState(() => errorMessage = ''),
                        keyboardType: TextInputType.text,
                        decoration: InputDecoration(
                          labelText: 'Name',
                        ),
                      ),
                      TextFormField(
                        controller: emailController,
                        validator: (String? value) {
                          if (value!.isEmpty) {
                            return 'Enter email';
                          }
                          return null;
                        },
                        onChanged: (text) => setState(() => errorMessage = ''),
                        keyboardType: TextInputType.emailAddress,
                        decoration: InputDecoration(
                          labelText: 'Email',
                        ),
                      ),
                      TextFormField(
                        obscureText: true,
                        enableSuggestions: false,
                        autocorrect: false,
                        keyboardType: TextInputType.visiblePassword,
                        controller: passwordController,
                        validator: (String? value) {
                          if (value!.isEmpty) {
                            return 'Enter password';
                          }
                          return null;
                        },
                        onChanged: (text) => setState(() => errorMessage = ''),
                        decoration: InputDecoration(
                          labelText: 'Passord',
                        ),
                      ),
                      TextFormField(
                        obscureText: true,
                        enableSuggestions: false,
                        autocorrect: false,
                        keyboardType: TextInputType.visiblePassword,
                        controller: passwordConfirmController,
                        validator: (String? value) {
                          if (value!.isEmpty) {
                            return 'Repeat password';
                          }
                          return null;
                        },
                        onChanged: (text) => setState(() => errorMessage = ''),
                        decoration: InputDecoration(
                          labelText: 'Confirm Passord',
                        ),
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
                          onTap: () => Navigator.pop(context),
                          child: Text('Back to Login'),
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
    final AuthProvider provider = Provider.of<AuthProvider>(
        context, listen: false);
    try {
      await provider.register(
          nameController.text,
          emailController.text,
          passwordController.text,
          passwordConfirmController.text,
          deviceName);
      Navigator.pop(context);
    } catch (Exception) {
      print(Exception);
      setState(() {
        // The exception message comes with "Exception: ..." in the beginning, we don't need it
        errorMessage = Exception.toString().replaceAll('Exception: ', '');
      });
    }
  }

  Future <void> getDeviceName() async {
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
        deviceName = 'Fails to get platform version';
      });
    }
  }


}
