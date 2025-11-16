import 'package:flutter/material.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});
  static const routeName = 'LoginPage';
  static const routePath = '/LoginPage';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('LoginPage')),
      body: SafeArea(
        child: SingleChildScrollView(child: Column(children: [])),
      ),
    );
  }
}
