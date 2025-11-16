import 'package:flutter/material.dart';

class CategoryPage extends StatelessWidget {
  const CategoryPage({super.key});
  static const routeName = 'CategoryPage';
  static const routePath = '/CategoryPage';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('CategoryPage')),
      body: const SafeArea(
        child: SingleChildScrollView(child: Column(children: [])),
      ),
    );
  }
}
