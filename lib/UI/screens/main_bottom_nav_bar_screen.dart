import 'package:flutter/material.dart';
import 'package:medi_hive/UI/screens/profile_screen.dart';
import 'package:medi_hive/UI/utils/appbar.dart';

import 'cancel_listing.dart';
import 'completed_list.dart';
import 'new_list_screen.dart';
import 'progress_screen.dart';
class MainBottomNavBarScreen extends StatefulWidget {
  const MainBottomNavBarScreen({super.key});

  @override
  State<MainBottomNavBarScreen> createState() => _MainBottomNavBarScreenState();
}

class _MainBottomNavBarScreenState extends State<MainBottomNavBarScreen> {
  int _selectedindex = 0;
  ThemeMode _themeMode = ThemeMode.system;
  final List<Widget> _screens = [
    NewMedicineScreen(),
    CompleteMedicineScreen(),
    CancelledTaskScreen(),
    ProgressMedicineScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData.light(),
      darkTheme: ThemeData.dark(),
      themeMode: _themeMode,
      home: Scaffold(
        appBar: MediHiveAppBar(),
        body: _screens[_selectedindex],
        bottomNavigationBar: NavigationBar(
          selectedIndex: _selectedindex,
          onDestinationSelected: (int index) {
            _selectedindex = index;
            setState(() {});
          },
          destinations: const [
            NavigationDestination(
              icon: Icon(Icons.new_label),
              label: 'New',
            ),
            NavigationDestination(
              icon: Icon(Icons.check_box),
              label: 'completed',
            ),
            NavigationDestination(
              icon: Icon(Icons.location_on_outlined),
              label: 'Maps',
            ),
            NavigationDestination(
              icon: Icon(Icons.add_ic_call_sharp),
              label: 'Emergency',
            ),
          ],
        ),
        drawer: Drawer(
          child: ListView(
            padding: EdgeInsets.zero,
            children: [
              DrawerHeader(
                decoration: BoxDecoration(
                  color: Theme.of(context).primaryColor,
                ),
                child: const Text(
                  'MediHve',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                  ),
                ),
              ),
              ListTile(
                leading: const Icon(Icons.person),
                title: const Text('Profile'),
                onTap: () {
                  // Handle profile navigation
                  Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ProfileScreen(),
                      ),
                      (route) => false);
                },
              ),
              ListTile(
                leading: const Icon(Icons.settings),
                title: const Text('Settings'),
                onTap: () {
                  // Handle settings navigation
                  Navigator.pop(context);
                },
              ),
              ListTile(
                leading: const Icon(Icons.brightness_6),
                title: const Text('Theme'),
                onTap: () {
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: const Text('Select Theme'),
                        content: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            ListTile(
                              title: const Text('Light Mode'),
                              onTap: () {
                                setState(() {
                                  _themeMode = ThemeMode.light;
                                });
                                Navigator.pop(context);
                              },
                            ),
                            ListTile(
                              title: const Text('Dark Mode'),
                              onTap: () {
                                setState(() {
                                  _themeMode = ThemeMode.dark;
                                });
                                Navigator.pop(context);
                              },
                            ),
                            ListTile(
                              title: const Text('System Default'),
                              onTap: () {
                                setState(() {
                                  _themeMode = ThemeMode.system;
                                });
                                Navigator.pop(context);
                              },
                            ),
                          ],
                        ),
                      );
                    },
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
