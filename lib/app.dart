import 'package:flutter/material.dart';
import 'package:medi_hive/UI/screens/welcome_screen.dart';

import 'UI/utils/appcolor.dart';

class MediHive extends StatefulWidget {
  const MediHive({super.key});
  static GlobalKey<NavigatorState> navigatorkey = GlobalKey<NavigatorState>();

  @override
  State<MediHive> createState() => _MediHiveState();
}

class _MediHiveState extends State<MediHive> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(

      navigatorKey: MediHive.navigatorkey,
      theme: ThemeData(
        textTheme: const TextTheme(),
        inputDecorationTheme: _inputDecorationTheme(),
        elevatedButtonTheme: _elevatedButtonThemeData(),
      ),
      home:const WelcomeScreen(),
    );
  }
  ElevatedButtonThemeData _elevatedButtonThemeData()
  {
    return ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColor.themeColor,
        foregroundColor: Colors.white,
        padding:
        const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 12),
        fixedSize: const Size.fromWidth(double.maxFinite),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
    );
  }
  InputDecorationTheme _inputDecorationTheme() {
    return InputDecorationTheme(
      fillColor: Colors.white,
      filled: true,
      hintStyle:const TextStyle(
        fontWeight: FontWeight.w300,
      ),
      border: _inputBorder(),
      enabledBorder: _inputBorder(),
      errorBorder: _inputBorder(),
      focusedBorder: _inputBorder(),
    );
  }

  OutlineInputBorder _inputBorder() {
    return OutlineInputBorder(
      borderSide: BorderSide.none,
      borderRadius: BorderRadius.circular(8),
    );
  }
}