import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:xmlapp/views/auth/cubit/wilayah_cubit.dart';
import 'package:xmlapp/views/auth/widgets/widget_login_form.dart';

import '../../../core/helper/constant_finals.dart';
import '../../../core/utils/dialog.dart';
import '../../../data/services/auth_service.dart';
import '../widgets/widget_register_form.dart';

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

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) async {
        if (didPop) {
          return;
        }
        final shouldPop = await showExitDialog(context);
        if (shouldPop && context.mounted) {
          Navigator.pop(context);
        }
      },
      child: Scaffold(
        backgroundColor: kWhite,
        body: SafeArea(
          child: SingleChildScrollView(
            child: Padding(
              padding: const .symmetric(horizontal: 16, vertical: 16),
              child: Column(
                crossAxisAlignment: .start,
                children: [
                  const SizedBox(height: 50),
                  Text(
                    'Hallo,',
                    style: TextStyle(
                      fontSize: 32,
                      color: kOrange,
                      fontWeight: .w900,
                    ),
                  ),
                  Text(
                    'Sobat XML!,',
                    style: TextStyle(
                      fontSize: 24,
                      color: kNeutral100,
                      fontWeight: .w500,
                    ),
                  ),
                  const SizedBox(height: 50),
                  Row(
                    children: [
                      Expanded(
                        child: GestureDetector(
                          onTap: () => toggleSelection(true),
                          child: Container(
                            color: Colors.transparent,
                            child: Column(
                              children: [
                                Text(
                                  'Masuk',
                                  style: TextStyle(
                                    color: isLoginSelected
                                        ? kOrange
                                        : kNeutral90,
                                    fontSize: 16,
                                    fontWeight: .w500,
                                  ),
                                ),
                                const SizedBox(height: 10),
                                Container(
                                  height: 2,
                                  color: isLoginSelected ? kOrange : kLightGrey,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 8),
                      Expanded(
                        child: GestureDetector(
                          onTap: () => toggleSelection(false),
                          child: Container(
                            color: Colors.transparent,
                            child: Column(
                              children: [
                                Text(
                                  'Daftar',
                                  style: TextStyle(
                                    color: isLoginSelected
                                        ? kNeutral90
                                        : kOrange,
                                    fontSize: 16,
                                    fontWeight: .w500,
                                  ),
                                ),
                                const SizedBox(height: 10),
                                Container(
                                  height: 2,
                                  color: !isLoginSelected
                                      ? kOrange
                                      : kLightGrey,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),

                  SizedBox(height: 40),
                  isLoginSelected
                      ? LoginFormWidget()
                      : BlocProvider(
                          create: (context) =>
                              WilayahCubit(context.read<AuthService>()),
                          child: RegisterFormWidget(),
                        ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
