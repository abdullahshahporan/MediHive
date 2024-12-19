import 'package:flutter/material.dart';

class PrimaryPage extends StatelessWidget {
  const PrimaryPage({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Redirect(),
    );
  }
}
class Redirect extends StatelessWidget {
  const Redirect({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('MediHive'),
          backgroundColor: Colors.teal.shade500,
        ),

      );
  }
}

