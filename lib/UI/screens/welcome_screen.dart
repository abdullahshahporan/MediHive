/*import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'main_bottom_nav_bar_screen.dart';
import 'sign_in_screen.dart';
import 'sign_up_screen.dart';

class WelcomeScreen extends StatefulWidget {
  const WelcomeScreen({Key? key}) : super(key: key);

  @override
  State<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  @override
  void initState() {
    super.initState();
    _checkIfUserIsLoggedIn();
  }

  Future<void> _checkIfUserIsLoggedIn() async {
    await Future.delayed(const Duration(seconds: 0)); // Show welcome screen for 2 seconds

    // Check if the user is logged in
    User? user = FirebaseAuth.instance.currentUser;

    if (user != null) {
      // If user is logged in, navigate to the main screen
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => const MainBottomNavBarScreen()),
            (route) => false,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Background Logo
          Positioned.fill(
            child: Image.asset(
              'assets/images/logo.png', // Replace this with the actual logo path
              fit: BoxFit.cover,
            ),
          ),
          // Buttons at the Bottom
          Positioned(
            bottom: 50,
            left: 0,
            right: 0,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                // Log In Button
                ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const SignInScreen()),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    padding: const EdgeInsets.symmetric(horizontal: 100, vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text(
                    'Log In',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                // Sign Up Button
                ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const SignUpScreen()),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    padding: const EdgeInsets.symmetric(horizontal: 100, vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text(
                    'Sign Up',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

*/
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:permission_handler/permission_handler.dart';
import 'main_bottom_nav_bar_screen.dart';
import 'sign_in_screen.dart';
import 'sign_up_screen.dart';

class WelcomeScreen extends StatefulWidget {
  const WelcomeScreen({Key? key}) : super(key: key);

  @override
  State<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  @override
  void initState() {
    super.initState();
    _checkIfUserIsLoggedIn();
    _showNotificationPermissionDialog();
  }

  Future<void> _checkIfUserIsLoggedIn() async {
    // Check if the user is logged in
    User? user = FirebaseAuth.instance.currentUser;

    if (user != null) {
      // If user is logged in, navigate to the main screen
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => const MainBottomNavBarScreen()),
            (route) => false,
      );
    }
  }

  Future<void> _showNotificationPermissionDialog() async {
    var status = await Permission.notification.status;

    if (status.isDenied) {
      // Show permission request dialog
      final allowPermission = await showDialog<bool>(
        context: context,
        barrierDismissible: false,
        builder: (context) {
          return AlertDialog(
            title: const Text('Enable Notifications'),
            content: const Text(
              'This app requires notification permissions to send you reminders. Would you like to enable it?',
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop(false); // Permission denied
                },
                child: const Text('Deny'),
              ),
              ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pop(true); // Permission granted
                },
                child: const Text('Allow'),
              ),
            ],
          );
        },
      );

      if (allowPermission == true) {
        // Request notification permission
        if (await Permission.notification.request().isGranted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Notification enabled!')),
          );
        } else {
          // If permanently denied, guide user to settings
          _showSettingsDialog();
        }
      }
    }
  }

  Future<void> _showSettingsDialog() async {
    await showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Enable Notifications'),
          content: const Text(
            'To enable notifications, go to your device settings and allow notifications for this app.',
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                openAppSettings(); // Open app settings
                Navigator.of(context).pop();
              },
              child: const Text('Go to Settings'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Background Logo
          Positioned.fill(
            child: Image.asset(
              'assets/images/logo.png', // Replace this with the actual logo path
              fit: BoxFit.cover,
            ),
          ),
          // Buttons at the Bottom
          Positioned(
            bottom: 50,
            left: 0,
            right: 0,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                // Log In Button
                ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const SignInScreen()),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    padding: const EdgeInsets.symmetric(
                        horizontal: 100, vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text(
                    'Log In',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                // Sign Up Button
                ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const SignUpScreen()),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    padding: const EdgeInsets.symmetric(
                        horizontal: 100, vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text(
                    'Sign Up',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
