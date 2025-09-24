import 'dart:io';

import 'package:flutter/material.dart';
import 'package:xmlapp/views/auth/widgets/login_form.dart';

import '../../../core/helper/constant_finals.dart';
import '../widgets/register_form.dart';

class AuthPage extends StatefulWidget {
  const AuthPage({super.key});

  @override
  State<AuthPage> createState() => _AuthPageState();
}

class _AuthPageState extends State<AuthPage> {
  bool isLoginSelected = true;
  bool isChecked = false;
  bool isRegisterChecked = false;

  void toggleSelection(bool isLogin) {
    setState(() {
      isLoginSelected = isLogin;
    });
  }

  void toggleCheckbox(bool? value) {
    setState(() {
      isChecked = value ?? false;
    });
  }

  void toggleRegisterCheckbox(bool? value) {
    setState(() {
      isRegisterChecked = value ?? false;
    });
  }

  Future<bool> onWillPop() async {
    return await showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('Keluar Aplikasi?'),
            content: const Text('Apakah kamu yakin ingin keluar?'),
            actions: <Widget>[
              TextButton(
                onPressed: () => Navigator.of(context).pop(false),
                child: const Text('Tidak'),
              ),
              TextButton(onPressed: () => exit(0), child: const Text('Ya')),
            ],
          ),
        ) ??
        false;
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: onWillPop,
      child: Scaffold(
        backgroundColor: kWhite,
        body: SafeArea(
          child: SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 50),
                  Text(
                    'Hallo,',
                    style: TextStyle(
                      fontSize: 32,
                      color: kOrange,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  Text(
                    'Sobat XML!,',
                    style: TextStyle(
                      fontSize: 24,
                      color: kNeutral100,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 50),
                  Row(
                    children: [
                      Expanded(
                        child: GestureDetector(
                          onTap: () => toggleSelection(true),
                          child: Column(
                            children: [
                              Text(
                                'Log in',
                                style: TextStyle(
                                  color: isLoginSelected ? kOrange : kNeutral90,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              const SizedBox(height: 10),
                              Container(
                                height: 2,
                                color: isLoginSelected
                                    ? kOrange
                                    : Colors.transparent,
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 8),
                      Expanded(
                        child: GestureDetector(
                          onTap: () => toggleSelection(false),
                          child: Column(
                            children: [
                              Text(
                                'Daftar',
                                style: TextStyle(
                                  color: isLoginSelected ? kNeutral90 : kOrange,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              const SizedBox(height: 10),
                              Container(
                                height: 2,
                                color: !isLoginSelected
                                    ? kOrange
                                    : Colors.transparent,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),

                  SizedBox(height: 40),
                  isLoginSelected ? LoginFormWidget() : RegisterFormWidget(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
