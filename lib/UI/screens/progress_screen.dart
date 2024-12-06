import 'package:flutter/material.dart';

class ProgressMedicineScreen extends StatelessWidget {
  const ProgressMedicineScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      itemCount: 10,
      itemBuilder: (context, index) {
        //return const TaskCard();
      },
      separatorBuilder: (context, index) {
        return const SizedBox(
          height: 8,
        );
      },
    );
  }
}