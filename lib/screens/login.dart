import 'dart:ui';

import 'package:flutter/material.dart';

import '../widgets/widgets.dart';
import 'screens.dart';

class Login extends StatelessWidget {
  Login({Key? key}) : super(key: key);

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  double getFormWidth(context) {
    if (MediaQuery.of(context).size.width > 1200) {
      return MediaQuery.of(context).size.width / 4;
    }
    if (MediaQuery.of(context).size.width > 786) {
      return MediaQuery.of(context).size.width / 3;
    }
    if (MediaQuery.of(context).size.width > 600) {
      return MediaQuery.of(context).size.width / 2;
    }
    return MediaQuery.of(context).size.width;
  }

  @override
  Widget build(BuildContext context) {
    final double height = MediaQuery.of(context).size.height;
    return Scaffold(
      body: Container(
        height: height,
        width: MediaQuery.of(context).size.width,
        decoration: const BoxDecoration(
          boxShadow: <BoxShadow>[
            BoxShadow(
              color: Colors.purpleAccent,
              offset: Offset(2, 4),
              blurRadius: 2.2,
              spreadRadius: 1.2,
            )
          ],
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Colors.purpleAccent,
              Colors.blueAccent,
            ],
          ),
        ),
        child: Stack(
          alignment: Alignment.center,
          children: [
            Container(
              width: getFormWidth(context),
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: ListView(
                children: [
                  const Padding(
                    padding: EdgeInsets.only(top: 150.0, bottom: 40),
                    child: Text(
                      'Login Page',
                      style: TextStyle(fontSize: 60, color: Colors.white),
                    ),
                  ),
                  LoginPage(
                    formKey: _formKey,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
