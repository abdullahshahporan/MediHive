import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:medi_hive/app.dart';
void main() {
  WidgetsFlutterBinding.ensureInitialized();
  Firebase.initializeApp();
  runApp(MediHive());
}

