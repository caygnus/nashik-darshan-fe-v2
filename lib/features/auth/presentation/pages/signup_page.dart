import 'package:flutter/material.dart';

class SignupPage extends StatelessWidget {
  const SignupPage({super.key});
  static const routeName = 'SignupPage';
  static const routePath = '/SignupPage';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('SignupPage')),
      body: SafeArea(
        child: SingleChildScrollView(child: Column(children: [])),
      ),
    );
  }
}
