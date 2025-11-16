import 'package:flutter/material.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});
  static const routeName = 'ProfilePage';
  static const routePath = '/ProfilePage';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('ProfilePage')),
      body: const SafeArea(
        child: SingleChildScrollView(child: Column(children: [])),
      ),
    );
  }
}
