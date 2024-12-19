/*import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'add_new_medicine_screen.dart';

class NewMedicineScreen extends StatefulWidget {
  const NewMedicineScreen({Key? key}) : super(key: key);

  @override
  State<NewMedicineScreen> createState() => _NewMedicineScreenState();
}

class _NewMedicineScreenState extends State<NewMedicineScreen> {
  final DatabaseReference _databaseRef = FirebaseDatabase.instance.ref('users');
  final FirebaseAuth _auth = FirebaseAuth.instance;

  List<Map<dynamic, dynamic>> _medicineList = [];
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _fetchMedicines();
    _resetMedicinesIfNeeded();
  }

  /// Fetch medicines from Firebase Realtime Database
  Future<void> _fetchMedicines() async {
    final userId = _auth.currentUser?.uid;
    if (userId != null) {
      _databaseRef.child(userId).child('medicines').onValue.listen((event) {
        final data = event.snapshot.value as Map<dynamic, dynamic>?;
        if (data != null) {
          _medicineList = data.entries
              .map((e) => {"id": e.key, "data": e.value})
              .toList();
        } else {
          _medicineList = [];
        }
        setState(() {
          _loading = false;
        });
      });
    }
  }

  /// Reset medicine data daily if needed
  Future<void> _resetMedicinesIfNeeded() async {
    final userId = _auth.currentUser?.uid;
    if (userId != null) {
      final medicinesRef = _databaseRef.child(userId).child('medicines');
      final snapshot = await medicinesRef.get();

      if (snapshot.exists) {
        final data = snapshot.value as Map<dynamic, dynamic>;

        for (final entry in data.entries) {
          final medicine = entry.value as Map<dynamic, dynamic>;
          final id = entry.key;
          final startDate = DateTime.parse(medicine['startDate']);
          final completedDays = medicine['completedDays'] ?? 0;
          final days = medicine['days'] ?? 1;
          final originalFrequency =
              medicine['originalFrequency'] ?? medicine['frequency'];

          // Check if the course has expired
          if (completedDays >= days) {
            await medicinesRef.child(id).remove();
            continue;
          }

          // Reset frequency for the day if needed
          final now = DateTime.now();
          if (now.difference(startDate).inDays > completedDays) {
            await medicinesRef.child(id).update({
              "frequency": originalFrequency,
              "completedDays": completedDays + 1,
            });
          }
        }
      }
    }
  }

  Future<void> _deleteMedicine(String id) async {
    final userId = _auth.currentUser?.uid;
    if (userId != null) {
      await _databaseRef.child(userId).child('medicines').child(id).remove();
    }
  }

  /// Show a small pop-up confirmation dialog
  Future<void> _showDeleteConfirmation(String id) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Delete Medicine'),
          content: const Text('Are you sure you want to delete this medicine?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context, false); // Cancel deletion
              },
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context, true); // Confirm deletion
              },
              child: const Text('Delete'),
            ),
          ],
        );
      },
    );

    if (confirm == true) {
      await _deleteMedicine(id);
    }
  }


  /// Complete a medicine dose
  Future<void> _completeMedicine(String id) async {
    final userId = _auth.currentUser?.uid;
    if (userId != null) {
      final medicineRef =
      _databaseRef.child(userId).child('medicines').child(id);
      final snapshot = await medicineRef.get();

      if (snapshot.exists) {
        final data = snapshot.value as Map<dynamic, dynamic>;
        int remaining = data['frequency'] ?? 0;
        final int originalFrequency =
            data['originalFrequency'] ?? remaining;
        final int completedDays = data['completedDays'] ?? 0;
        final int days = data['days'] ?? 1;

        if (remaining > 1) {
          remaining--;
          await medicineRef.update({'frequency': remaining});
        } else {
          if (completedDays + 1 < days) {
            await medicineRef.update({
              'frequency': originalFrequency,
              'completedDays': completedDays + 1,
            });
          } else {
            await medicineRef.remove();
          }
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : _medicineList.isEmpty
          ? const Center(child: Text('No medicines added yet!'))
          : ListView.builder(
        itemCount: _medicineList.length,
        itemBuilder: (context, index) {
          final medicine = _medicineList[index]['data'];
          final id = _medicineList[index]['id'];
          return Card(
            elevation: 4,
            margin: const EdgeInsets.symmetric(
                horizontal: 16, vertical: 8),
            child: ListTile(
              title: Text(
                medicine['name'],
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                      'Quantity: ${medicine['quantity']} ${medicine['type'] == 'syrup' ? 'mL' : 'pieces'} per time'),
                  Text('Remaining: ${medicine['frequency'] ?? 0}'),
                  Text(
                      'Days Left: ${medicine['days'] - (medicine['completedDays'] ?? 0)}'),
                ],
              ),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    icon: const Icon(Icons.check_circle,
                        color: Colors.green),
                    onPressed: () async {
                      await _completeMedicine(id);
                    },
                  ),
                  IconButton(
                    icon: const Icon(Icons.delete,
                        color: Colors.redAccent),
                    onPressed: () async {
                      await _showDeleteConfirmation(id);
                    },
                  ),
                ],
              ),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const AddNewMedicineScreen(),
            ),
          );
        },
        backgroundColor: Colors.white70,
        child: const Icon(Icons.add),
      ),
    );
  }
}*/
/*import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;
import 'add_new_medicine_screen.dart';

class NewMedicineScreen extends StatefulWidget {
  const NewMedicineScreen({Key? key}) : super(key: key);

  @override
  State<NewMedicineScreen> createState() => _NewMedicineScreenState();
}

class _NewMedicineScreenState extends State<NewMedicineScreen> {
  final DatabaseReference _databaseRef = FirebaseDatabase.instance.ref('users');
  final FirebaseAuth _auth = FirebaseAuth.instance;

  final FlutterLocalNotificationsPlugin _notificationsPlugin =
  FlutterLocalNotificationsPlugin();

  List<Map<dynamic, dynamic>> _medicineList = [];
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _initializeNotifications();
    _fetchMedicines();
    _resetMedicinesIfNeeded();
  }

  /// Initialize notifications
  void _initializeNotifications() async {
    const androidSettings = AndroidInitializationSettings('@mipmap/ic_launcher');
    const initializationSettings = InitializationSettings(android: androidSettings);

    await _notificationsPlugin.initialize(initializationSettings);
    tz.initializeTimeZones();
  }

  /// Schedule an alarm for a given time
  Future<void> _scheduleAlarm(String medicineName, int alarmId, TimeOfDay time, int minutesBefore) async {
    final now = DateTime.now();
    final alarmTime = DateTime(
      now.year,
      now.month,
      now.day,
      time.hour,
      time.minute,
    ).subtract(Duration(minutes: minutesBefore));

    if (alarmTime.isAfter(now)) {
      await _notificationsPlugin.zonedSchedule(
        alarmId,
        'Medicine Reminder',
        'Time to take $medicineName',
        tz.TZDateTime.from(alarmTime, tz.local),
        const NotificationDetails(
          android: AndroidNotificationDetails(
            'medicine_reminder_channel',
            'Medicine Reminder',
            channelDescription: 'Reminder to take your medicine',
            importance: Importance.max,
            priority: Priority.high,
            icon: '@mipmap/ic_launcher',
          ),
        ),
        androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
        uiLocalNotificationDateInterpretation: UILocalNotificationDateInterpretation.absoluteTime,
      );
    }
  }

  /// Fetch medicines from Firebase Realtime Database
  Future<void> _fetchMedicines() async {
    final userId = _auth.currentUser?.uid;
    if (userId != null) {
      _databaseRef.child(userId).child('medicines').onValue.listen((event) {
        final data = event.snapshot.value as Map<dynamic, dynamic>?;
        if (data != null) {
          _medicineList = data.entries
              .map((e) => {"id": e.key, "data": e.value})
              .toList();
          _scheduleAlarmsForMedicines();
        } else {
          _medicineList = [];
        }
        setState(() {
          _loading = false;
        });
      });
    }
  }

  /// Schedule alarms for all medicines
  void _scheduleAlarmsForMedicines() {
    int alarmId = 0;
    for (var medicine in _medicineList) {
      final medicineData = medicine['data'];
      final name = medicineData['name'] ?? 'Medicine';
      final times = medicineData['times'] as List<dynamic>;
      final alarmBefore = medicineData['alarmBefore'] ?? 5;

      for (var timeString in times) {
        if (timeString != null) {
          final timeParts = timeString.split(':');
          final time = TimeOfDay(
            hour: int.parse(timeParts[0]),
            minute: int.parse(timeParts[1]),
          );
          _scheduleAlarm(name, alarmId, time, alarmBefore);
          alarmId++;
        }
      }
    }
  }

  /// Reset medicine data daily if needed
  Future<void> _resetMedicinesIfNeeded() async {
    final userId = _auth.currentUser?.uid;
    if (userId != null) {
      final medicinesRef = _databaseRef.child(userId).child('medicines');
      final snapshot = await medicinesRef.get();

      if (snapshot.exists) {
        final data = snapshot.value as Map<dynamic, dynamic>;

        for (final entry in data.entries) {
          final medicine = entry.value as Map<dynamic, dynamic>;
          final id = entry.key;
          final startDate = DateTime.parse(medicine['startDate']);
          final completedDays = medicine['completedDays'] ?? 0;
          final days = medicine['days'] ?? 1;
          final originalFrequency =
              medicine['originalFrequency'] ?? medicine['frequency'];

          if (completedDays >= days) {
            await medicinesRef.child(id).remove();
            continue;
          }

          final now = DateTime.now();
          if (now.difference(startDate).inDays > completedDays) {
            await medicinesRef.child(id).update({
              "frequency": originalFrequency,
              "completedDays": completedDays + 1,
            });
          }
        }
      }
    }
  }

  Future<void> _deleteMedicine(String id) async {
    final userId = _auth.currentUser?.uid;
    if (userId != null) {
      await _databaseRef.child(userId).child('medicines').child(id).remove();
    }
  }

  Future<void> _showDeleteConfirmation(String id) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Delete Medicine'),
          content: const Text('Are you sure you want to delete this medicine?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () => Navigator.pop(context, true),
              child: const Text('Delete'),
            ),
          ],
        );
      },
    );

    if (confirm == true) {
      await _deleteMedicine(id);
    }
  }

  Future<void> _completeMedicine(String id) async {
    final userId = _auth.currentUser?.uid;
    if (userId != null) {
      final medicineRef = _databaseRef.child(userId).child('medicines').child(id);
      final snapshot = await medicineRef.get();

      if (snapshot.exists) {
        final data = snapshot.value as Map<dynamic, dynamic>;
        int remaining = data['frequency'] ?? 0;
        final int originalFrequency = data['originalFrequency'] ?? remaining;
        final int completedDays = data['completedDays'] ?? 0;
        final int days = data['days'] ?? 1;

        if (remaining > 1) {
          remaining--;
          await medicineRef.update({'frequency': remaining});
        } else {
          if (completedDays + 1 < days) {
            await medicineRef.update({
              'frequency': originalFrequency,
              'completedDays': completedDays + 1,
            });
          } else {
            await medicineRef.remove();
          }
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Your Medicines')),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : _medicineList.isEmpty
          ? const Center(child: Text('No medicines added yet!'))
          : ListView.builder(
        itemCount: _medicineList.length,
        itemBuilder: (context, index) {
          final medicine = _medicineList[index]['data'];
          final id = _medicineList[index]['id'];
          return Card(
            elevation: 4,
            margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: ListTile(
              title: Text(
                medicine['name'],
                style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Quantity: ${medicine['quantity']} ${medicine['type'] == 'syrup' ? 'mL' : 'pieces'} per time'),
                  Text('Remaining: ${medicine['frequency'] ?? 0}'),
                  Text('Days Left: ${medicine['days'] - (medicine['completedDays'] ?? 0)}'),
                ],
              ),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    icon: const Icon(Icons.check_circle, color: Colors.green),
                    onPressed: () => _completeMedicine(id),
                  ),
                  IconButton(
                    icon: const Icon(Icons.delete, color: Colors.redAccent),
                    onPressed: () => _showDeleteConfirmation(id),
                  ),
                ],
              ),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const AddNewMedicineScreen(),
            ),
          );
        },
        backgroundColor: Colors.white70,
        child: const Icon(Icons.add),
      ),
    );
  }
}*/
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;
import 'package:audioplayers/audioplayers.dart';
import 'add_new_medicine_screen.dart';

class NewMedicineScreen extends StatefulWidget {
  const NewMedicineScreen({Key? key}) : super(key: key);

  @override
  State<NewMedicineScreen> createState() => _NewMedicineScreenState();
}

class _NewMedicineScreenState extends State<NewMedicineScreen> {
  final DatabaseReference _databaseRef = FirebaseDatabase.instance.ref('users');
  final FirebaseAuth _auth = FirebaseAuth.instance;

  final FlutterLocalNotificationsPlugin _notificationsPlugin =
  FlutterLocalNotificationsPlugin();
  final AudioPlayer _audioPlayer = AudioPlayer(); // Audio player instance

  List<Map<dynamic, dynamic>> _medicineList = [];
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _initializeNotifications();
    _fetchMedicines();
    _resetMedicinesIfNeeded();
  }

  /// Initialize notifications and timezone
  void _initializeNotifications() async {
    const androidSettings = AndroidInitializationSettings('@mipmap/ic_launcher');
    const initializationSettings =
    InitializationSettings(android: androidSettings);

    await _notificationsPlugin.initialize(initializationSettings);
    tz.initializeTimeZones();
  }

  /// Schedule an alarm for a given time
  Future<void> _scheduleAlarm(
      String medicineName, int alarmId, TimeOfDay time, int minutesBefore) async {
    final now = DateTime.now();
    final alarmTime = DateTime(
      now.year,
      now.month,
      now.day,
      time.hour,
      time.minute,
    ).subtract(Duration(minutes: minutesBefore));

    if (alarmTime.isAfter(now)) {
      await _notificationsPlugin.zonedSchedule(
        alarmId,
        'Medicine Reminder',
        'Time to take $medicineName',
        tz.TZDateTime.from(alarmTime, tz.local),
        const NotificationDetails(
          android: AndroidNotificationDetails(
            'medicine_reminder_channel',
            'Medicine Reminder',
            channelDescription: 'Reminder to take your medicine',
            importance: Importance.max,
            priority: Priority.high,
            playSound: true,
          ),
        ),
        androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
        uiLocalNotificationDateInterpretation:
        UILocalNotificationDateInterpretation.absoluteTime,
      );

      // Schedule an alarm sound
      Future.delayed(alarmTime.difference(now), () async {
        await _playAlarmSound();
      });
    }
  }

  /// Play alarm sound
  Future<void> _playAlarmSound() async {
    try {
      await _audioPlayer.play(AssetSource('audio/alarm.mp3'), volume: 5.0);
    } catch (e) {
      print("Error playing alarm sound: $e");
    }
  }

  /// Fetch medicines from Firebase Realtime Database
  Future<void> _fetchMedicines() async {
    final userId = _auth.currentUser?.uid;
    if (userId != null) {
      _databaseRef.child(userId).child('medicines').onValue.listen((event) {
        final data = event.snapshot.value as Map<dynamic, dynamic>?;
        if (data != null) {
          _medicineList = data.entries
              .map((e) => {"id": e.key, "data": e.value})
              .toList();
          _scheduleAlarmsForMedicines();
        } else {
          _medicineList = [];
        }
        setState(() {
          _loading = false;
        });
      });
    }
  }

  /// Schedule alarms for all medicines
  void _scheduleAlarmsForMedicines() {
    int alarmId = 0; // Unique ID for each alarm
    for (var medicine in _medicineList) {
      final medicineData = medicine['data'];
      final name = medicineData['name'] ?? 'Medicine';
      final times = medicineData['times'] as List<dynamic>;
      final alarmBefore = medicineData['alarmBefore'] ?? 5;

      for (var timeString in times) {
        if (timeString != null) {
          final timeParts = timeString.split(':');
          final time = TimeOfDay(
            hour: int.parse(timeParts[0]),
            minute: int.parse(timeParts[1]),
          );
          _scheduleAlarm(name, alarmId, time, alarmBefore);
          alarmId++;
        }
      }
    }
  }

  /// Reset medicine data daily if needed
  Future<void> _resetMedicinesIfNeeded() async {
    final userId = _auth.currentUser?.uid;
    if (userId != null) {
      final medicinesRef = _databaseRef.child(userId).child('medicines');
      final snapshot = await medicinesRef.get();

      if (snapshot.exists) {
        final data = snapshot.value as Map<dynamic, dynamic>;

        for (final entry in data.entries) {
          final medicine = entry.value as Map<dynamic, dynamic>;
          final id = entry.key;
          final startDate = DateTime.parse(medicine['startDate']);
          final completedDays = medicine['completedDays'] ?? 0;
          final days = medicine['days'] ?? 1;
          final originalFrequency =
              medicine['originalFrequency'] ?? medicine['frequency'];

          if (completedDays >= days) {
            await medicinesRef.child(id).remove();
            continue;
          }

          final now = DateTime.now();
          if (now.difference(startDate).inDays > completedDays) {
            await medicinesRef.child(id).update({
              "frequency": originalFrequency,
              "completedDays": completedDays + 1,
            });
          }
        }
      }
    }
  }

  Future<void> _deleteMedicine(String id) async {
    final userId = _auth.currentUser?.uid;
    if (userId != null) {
      await _databaseRef.child(userId).child('medicines').child(id).remove();
    }
  }

  Future<void> _showDeleteConfirmation(String id) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Delete Medicine'),
          content: const Text('Are you sure you want to delete this medicine?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () => Navigator.pop(context, true),
              child: const Text('Delete'),
            ),
          ],
        );
      },
    );

    if (confirm == true) {
      await _deleteMedicine(id);
    }
  }

  Future<void> _completeMedicine(String id) async {
    final userId = _auth.currentUser?.uid;
    if (userId != null) {
      final medicineRef = _databaseRef.child(userId).child('medicines').child(id);
      final snapshot = await medicineRef.get();

      if (snapshot.exists) {
        final data = snapshot.value as Map<dynamic, dynamic>;
        int remaining = data['frequency'] ?? 0;
        final int originalFrequency = data['originalFrequency'] ?? remaining;
        final int completedDays = data['completedDays'] ?? 0;
        final int days = data['days'] ?? 1;

        if (remaining > 1) {
          remaining--;
          await medicineRef.update({'frequency': remaining});
        } else {
          if (completedDays + 1 < days) {
            await medicineRef.update({
              'frequency': originalFrequency,
              'completedDays': completedDays + 1,
            });
          } else {
            await medicineRef.remove();
          }
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Your Medicines')),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : _medicineList.isEmpty
          ? const Center(child: Text('No medicines added yet!'))
          : ListView.builder(
        itemCount: _medicineList.length,
        itemBuilder: (context, index) {
          final medicine = _medicineList[index]['data'];
          final id = _medicineList[index]['id'];
          return Card(
            elevation: 4,
            margin: const EdgeInsets.symmetric(
                horizontal: 16, vertical: 8),
            child: ListTile(
              title: Text(
                medicine['name'],
                style: const TextStyle(
                    fontSize: 16, fontWeight: FontWeight.bold),
              ),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                      'Quantity: ${medicine['quantity']} ${medicine['type'] == 'syrup' ? 'mL' : 'pieces'} per time'),
                  Text('Remaining: ${medicine['frequency'] ?? 0}'),
                  Text(
                      'Days Left: ${medicine['days'] - (medicine['completedDays'] ?? 0)}'),
                ],
              ),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    icon: const Icon(Icons.check_circle,
                        color: Colors.green),
                    onPressed: () => _completeMedicine(id),
                  ),
                  IconButton(
                    icon: const Icon(Icons.delete,
                        color: Colors.redAccent),
                    onPressed: () => _showDeleteConfirmation(id),
                  ),
                ],
              ),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const AddNewMedicineScreen(),
            ),
          );
        },
        backgroundColor: Colors.white70,
        child: const Icon(Icons.add),
      ),
    );
  }
}

