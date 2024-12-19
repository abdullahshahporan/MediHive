import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:medi_hive/app.dart';
import 'package:timezone/data/latest.dart' as tz;
void main() {
  WidgetsFlutterBinding.ensureInitialized();
  Firebase.initializeApp();
  tz.initializeTimeZones();
  runApp(MediHive());
}

