import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:medi_hive/UI/screens/welcome_screen.dart';
import 'package:medi_hive/UI/utils/appbar.dart';
import 'emergency_screen.dart';
import 'web_view.dart';
import 'new_medicine_list_screen.dart';

import 'profile_screen.dart';
import 'map_screen.dart';

class MainBottomNavBarScreen extends StatefulWidget {
  const MainBottomNavBarScreen({Key? key}) : super(key: key);

  @override
  State<MainBottomNavBarScreen> createState() => _MainBottomNavBarScreenState();
}

class _MainBottomNavBarScreenState extends State<MainBottomNavBarScreen> {
  int _selectedIndex = 0;

  final List<Widget> _screens = [
    const NewMedicineScreen(),
    const MapScreen(),
    const WebViewScreen(),
  ];

  void _onSignOut() async {
    await FirebaseAuth.instance.signOut();
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => const WelcomeScreen()),
      (_) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData.light(),
      darkTheme: ThemeData.dark(),

      home: Scaffold(
        backgroundColor: Colors.grey.shade100,
        appBar: const MediHiveAppBar(),
        body: _screens[_selectedIndex],
        bottomNavigationBar: BottomNavigationBar(
          currentIndex: _selectedIndex,
          onTap: (index) {
            if (index == 3) {
              // Navigate to ProfileScreen directly
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const ProfileScreen()),
              );
            } else {
              setState(() {
                _selectedIndex = index; // Update index for other screens
              });
            }
          },
          selectedItemColor: Colors.green,
          unselectedItemColor: Colors.grey,
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.moving_sharp),
              label: 'New',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.location_on_outlined),
              label: 'Maps', // Navigate to MapScreen
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.shopping_cart_rounded),
              label: 'Medi Cart',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.person),
              label: 'Profile',
            ),
          ],
        ),
        drawer: Drawer(
          child: Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.green, Colors.lightBlue],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            child: ListView(
              padding: EdgeInsets.zero,
              children: [
                const DrawerHeader(
                  child: Text(
                    'MediHive',
                    style: TextStyle(color: Colors.white, fontSize: 24),
                  ),
                ),
                ListTile(
                  leading: const Icon(Icons.person, color: Colors.white),
                  title: const Text('Profile',
                      style: TextStyle(color: Colors.white)),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const ProfileScreen()),
                    );
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.call, color: Colors.white),
                  title: const Text('Emergency Contact',
                      style: TextStyle(color: Colors.white)),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const EmergencyScreen()),
                    );
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.logout, color: Colors.white),
                  title: const Text('Sign Out',
                      style: TextStyle(color: Colors.white)),
                  onTap: _onSignOut,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
