/*import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';

class AddNewMedicineScreen extends StatefulWidget {
  const AddNewMedicineScreen({Key? key}) : super(key: key);

  @override
  State<AddNewMedicineScreen> createState() => _AddNewMedicineScreenState();
}

class _AddNewMedicineScreenState extends State<AddNewMedicineScreen> {
  final _formKey = GlobalKey<FormState>();
  final DatabaseReference _databaseRef = FirebaseDatabase.instance.ref('users');
  final FirebaseAuth _auth = FirebaseAuth.instance;

  String? _medicineType;
  String? _medicineName;
  int? _quantity;
  int? _frequency;
  int? _days;
  int? _alarmBefore;
  List<TimeOfDay?> _times = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add New Medicine'),
        backgroundColor: Colors.blueAccent,
        centerTitle: true,
      ),
      body: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: Form(
          key: _formKey,
          child: ListView(
            padding: const EdgeInsets.all(16.0),
            children: [
              const Text(
                "Medicine Details",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.blueAccent,
                ),
              ),
              const SizedBox(height: 16),
              // Medicine Type Dropdown
              _buildGestureField(
                DropdownButtonFormField<String>(
                  decoration: _inputDecoration("Medicine Type"),
                  items: const [
                    DropdownMenuItem(value: 'syrup', child: Text('Syrup')),
                    DropdownMenuItem(value: 'capsule', child: Text('Capsule')),
                    DropdownMenuItem(value: 'tablet', child: Text('Tablet')),
                  ],
                  onChanged: (value) {
                    setState(() {
                      _medicineType = value;
                    });
                  },
                  validator: (value) =>
                  value == null ? 'Please select a medicine type' : null,
                ),
              ),
              const SizedBox(height: 16),
              // Medicine Name Field
              _buildGestureField(
                TextFormField(
                  decoration: _inputDecoration("Medicine Name"),
                  onSaved: (value) => _medicineName = value,
                  validator: (value) =>
                  value!.isEmpty ? 'Please enter the medicine name' : null,
                ),
              ),
              const SizedBox(height: 16),
              // Quantity Field
              _buildGestureField(
                TextFormField(
                  decoration: _inputDecoration("Quantity"),
                  keyboardType: TextInputType.number,
                  onSaved: (value) => _quantity = int.tryParse(value!),
                  validator: (value) =>
                  value!.isEmpty || int.tryParse(value) == null
                      ? 'Please enter a valid quantity' : null,
                ),
              ),
              const SizedBox(height: 16),
              // Frequency Field
              _buildGestureField(
                TextFormField(
                  decoration: _inputDecoration("How Many Times a Day"),
                  keyboardType: TextInputType.number,
                  onChanged: (value) {
                    final freq = int.tryParse(value);
                    if (freq != null && freq > 0) {
                      setState(() {
                        _frequency = freq;
                        _times = List.generate(freq, (_) => null);
                      });
                    }
                  },
                  onSaved: (value) => _frequency = int.tryParse(value!),
                  validator: (value) =>
                  value!.isEmpty || int.tryParse(value) == null
                      ? 'Please enter a valid frequency' : null,
                ),
              ),
              const SizedBox(height: 16),
              // Dynamic Time Selection
              if (_frequency != null && _frequency! > 0)
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "Set Times",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.blueAccent,
                      ),
                    ),
                    ...List.generate(
                      _frequency!,
                          (index) => ListTile(
                        title: Text(
                          'Time ${index + 1}',
                          style: const TextStyle(color: Colors.black87),
                        ),
                        subtitle: Text(
                          _times[index] != null
                              ? _times[index]!.format(context)
                              : 'Not Set',
                          style: const TextStyle(color: Colors.black54),
                        ),
                        trailing: IconButton(
                          icon: const Icon(Icons.access_time,
                              color: Colors.blueAccent),
                          onPressed: () {
                            _pickTime(index);
                          },
                        ),
                      ),
                    ),
                  ],
                ),
              const SizedBox(height: 16),
              // Number of Days Field
              _buildGestureField(
                TextFormField(
                  decoration: _inputDecoration("Number of Days"),
                  keyboardType: TextInputType.number,
                  onSaved: (value) => _days = int.tryParse(value!),
                  validator: (value) =>
                  value!.isEmpty || int.tryParse(value) == null
                      ? 'Please enter a valid number of days' : null,
                ),
              ),
              const SizedBox(height: 16),
              // Alarm Notification Dropdown
              _buildGestureField(
                DropdownButtonFormField<int>(
                  decoration: _inputDecoration("Alarm Notification Before"),
                  items: const [
                    DropdownMenuItem(value: 5, child: Text('5 minutes earlier')),
                    DropdownMenuItem(
                        value: 10, child: Text('10 minutes earlier')),
                    DropdownMenuItem(
                        value: 15, child: Text('15 minutes earlier')),
                  ],
                  onChanged: (value) {
                    setState(() {
                      _alarmBefore = value;
                    });
                  },
                  validator: (value) => value == null
                      ? 'Please select an alarm notification time'
                      : null,
                ),
              ),
              const SizedBox(height: 30),
              // Add Medicine Button
              Center(
                child: ElevatedButton(
                  onPressed: _submit,
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 100, vertical: 16),
                    backgroundColor: Colors.blueAccent,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text(
                    'Add Medicine',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Input Decoration
  InputDecoration _inputDecoration(String label) {
    return InputDecoration(
      labelText: label,
      labelStyle: const TextStyle(color: Colors.black87),
      filled: true,
      fillColor: Colors.grey.shade200,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide.none,
      ),
    );
  }

  // Gesture Wrapper for Fields
  Widget _buildGestureField(Widget field) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: field,
    );
  }

  // Open Time Picker
  Future<void> _pickTime(int index) async {
    final time = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );
    if (time != null) {
      setState(() {
        _times[index] = time;
      });
    }
  }

  // Submit Form Data
  void _submit() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      final userId = _auth.currentUser?.uid;

      if (userId != null) {
        final newMedicineRef =
        _databaseRef.child(userId).child('medicines').push();

        await newMedicineRef.set({
          "type": _medicineType,
          "name": _medicineName,
          "quantity": _quantity,
          "frequency": _frequency,
          "originalFrequency": _frequency,
          "days": _days,
          "completedDays": 0,
          "startDate": DateTime.now().toIso8601String().split('T')[0],
          "alarmBefore": _alarmBefore,
          "times": _times
              .map((time) => time != null ? time.format(context) : null)
              .toList(),
        });

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Medicine added successfully!')),
        );

        Navigator.pop(context);
      }
    }
  }
}
*/
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';

class AddNewMedicineScreen extends StatefulWidget {
  const AddNewMedicineScreen({Key? key}) : super(key: key);

  @override
  State<AddNewMedicineScreen> createState() => _AddNewMedicineScreenState();
}

class _AddNewMedicineScreenState extends State<AddNewMedicineScreen> {
  final _formKey = GlobalKey<FormState>();
  final DatabaseReference _databaseRef = FirebaseDatabase.instance.ref('users');
  final FirebaseAuth _auth = FirebaseAuth.instance;

  String? _medicineType;
  String? _medicineName;
  int? _quantity;
  int? _frequency;
  int? _days;
  int? _alarmBefore;
  List<TimeOfDay?> _times = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add New Medicine'),
        backgroundColor: Colors.blueAccent,
        centerTitle: true,
      ),
      body: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: Form(
          key: _formKey,
          child: ListView(
            padding: const EdgeInsets.all(16.0),
            children: [
              const Text(
                "Medicine Details",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.blueAccent,
                ),
              ),
              const SizedBox(height: 16),
              // Medicine Type Dropdown
              _buildGestureField(
                DropdownButtonFormField<String>(
                  decoration: _inputDecoration("Medicine Type"),
                  items: const [
                    DropdownMenuItem(value: 'syrup', child: Text('Syrup')),
                    DropdownMenuItem(value: 'capsule', child: Text('Capsule')),
                    DropdownMenuItem(value: 'tablet', child: Text('Tablet')),
                  ],
                  onChanged: (value) {
                    setState(() {
                      _medicineType = value;
                    });
                  },
                  validator: (value) =>
                  value == null ? 'Please select a medicine type' : null,
                ),
              ),
              const SizedBox(height: 16),
              // Medicine Name Field
              _buildGestureField(
                TextFormField(
                  decoration: _inputDecoration("Medicine Name"),
                  onSaved: (value) => _medicineName = value,
                  validator: (value) =>
                  value!.isEmpty ? 'Please enter the medicine name' : null,
                ),
              ),
              const SizedBox(height: 16),
              // Quantity Field
              _buildGestureField(
                TextFormField(
                  decoration: _inputDecoration("Quantity"),
                  keyboardType: TextInputType.number,
                  onSaved: (value) => _quantity = int.tryParse(value!),
                  validator: (value) =>
                  value!.isEmpty || int.tryParse(value) == null
                      ? 'Please enter a valid quantity'
                      : null,
                ),
              ),
              const SizedBox(height: 16),
              // Frequency Field
              _buildGestureField(
                TextFormField(
                  decoration: _inputDecoration("How Many Times a Day"),
                  keyboardType: TextInputType.number,
                  onChanged: (value) {
                    final freq = int.tryParse(value);
                    if (freq != null && freq > 0) {
                      setState(() {
                        _frequency = freq;
                        _times = List.generate(freq, (_) => null);
                      });
                    }
                  },
                  onSaved: (value) => _frequency = int.tryParse(value!),
                  validator: (value) =>
                  value!.isEmpty || int.tryParse(value) == null
                      ? 'Please enter a valid frequency'
                      : null,
                ),
              ),
              const SizedBox(height: 16),
              // Dynamic Time Selection
              if (_frequency != null && _frequency! > 0)
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "Set Times",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.blueAccent,
                      ),
                    ),
                    ...List.generate(
                      _frequency!,
                          (index) => ListTile(
                        title: Text(
                          'Time ${index + 1}',
                          style: const TextStyle(color: Colors.black87),
                        ),
                        subtitle: Text(
                          _times[index] != null
                              ? _times[index]!.format(context)
                              : 'Not Set',
                          style: const TextStyle(color: Colors.black54),
                        ),
                        trailing: IconButton(
                          icon: const Icon(Icons.access_time,
                              color: Colors.blueAccent),
                          onPressed: () {
                            _pickTime(index);
                          },
                        ),
                      ),
                    ),
                  ],
                ),
              const SizedBox(height: 16),
              // Number of Days Field
              _buildGestureField(
                TextFormField(
                  decoration: _inputDecoration("Number of Days"),
                  keyboardType: TextInputType.number,
                  onSaved: (value) => _days = int.tryParse(value!),
                  validator: (value) =>
                  value!.isEmpty || int.tryParse(value) == null
                      ? 'Please enter a valid number of days'
                      : null,
                ),
              ),
              const SizedBox(height: 16),
              // Alarm Notification Dropdown
              _buildGestureField(
                DropdownButtonFormField<int>(
                  decoration: _inputDecoration("Alarm Notification Before"),
                  items: const [
                    DropdownMenuItem(value: 5, child: Text('5 minutes earlier')),
                    DropdownMenuItem(
                        value: 10, child: Text('10 minutes earlier')),
                    DropdownMenuItem(
                        value: 15, child: Text('15 minutes earlier')),
                  ],
                  onChanged: (value) {
                    setState(() {
                      _alarmBefore = value;
                    });
                  },
                  validator: (value) => value == null
                      ? 'Please select an alarm notification time'
                      : null,
                ),
              ),
              const SizedBox(height: 30),
              // Add Medicine Button
              Center(
                child: ElevatedButton(
                  onPressed: _submit,
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 100, vertical: 16),
                    backgroundColor: Colors.blueAccent,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text(
                    'Add Medicine',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  InputDecoration _inputDecoration(String label) {
    return InputDecoration(
      labelText: label,
      labelStyle: const TextStyle(color: Colors.black87),
      filled: true,
      fillColor: Colors.grey.shade200,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide.none,
      ),
    );
  }

  Widget _buildGestureField(Widget field) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: field,
    );
  }

  Future<void> _pickTime(int index) async {
    final time = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );
    if (time != null) {
      setState(() {
        _times[index] = time;
      });
    }
  }

  void _submit() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      final userId = _auth.currentUser?.uid;

      if (userId != null) {
        final newMedicineRef =
        _databaseRef.child(userId).child('medicines').push();

        await newMedicineRef.set({
          "type": _medicineType,
          "name": _medicineName,
          "quantity": _quantity,
          "frequency": _frequency,
          "originalFrequency": _frequency,
          "days": _days,
          "completedDays": 0,
          "startDate": DateTime.now().toIso8601String().split('T')[0],
          "alarmBefore": _alarmBefore,
          "times": _times
              .map((time) =>
          time != null ? "${time.hour}:${time.minute}" : null)
              .toList(),
        });

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Medicine added successfully!')),
        );

        Navigator.pop(context);
      }
    }
  }
}
