import 'package:flutter/material.dart';
import 'package:intl/intl.dart'; // To get time for greeting
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:medi_hive/UI/screens/profile_screen.dart';
import 'package:medi_hive/UI/screens/sign_in_screen.dart';
import 'package:medi_hive/UI/utils/appcolor.dart';

class MediHiveAppBar extends StatelessWidget implements PreferredSizeWidget {
  const MediHiveAppBar({
    Key? key,
    this.isProfileScreenOpen = false,
  }) : super(key: key);

  final bool isProfileScreenOpen;

  // Function to get the current greeting based on the time of day
  String getGreetingMessage() {
    final hour = DateTime.now().hour;
    if (hour < 12) {
      return 'Good Morning';
    } else if (hour < 17) {
      return 'Good Afternoon';
    } else {
      return 'Good Evening';
    }
  }

  // Function to fetch user's name from Firebase
  Future<String?> fetchUserName() async {
    try {
      User? user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        DatabaseReference userRef =
        FirebaseDatabase.instance.ref('users/${user.uid}');
        DataSnapshot snapshot = await userRef.get();
        if (snapshot.exists) {
          Map data = snapshot.value as Map;
          return data['firstName'] ?? 'User';
        }
      }
    } catch (e) {
      debugPrint('Error fetching user name: $e');
    }
    return 'User';
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        if (isProfileScreenOpen) {
          return;
        }
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => const ProfileScreen(), // Navigate to profile
          ),
        );
      },
      child: FutureBuilder<String?>(
        future: fetchUserName(), // Fetch the user's name asynchronously
        builder: (context, snapshot) {
          String greeting = getGreetingMessage();
          String name = snapshot.data ?? 'User';

          return AppBar(
            backgroundColor: AppColor.themeColor,
            title: Row(
              children: [
                /*CircleAvatar(
                  radius: 18,
                  backgroundColor: Colors.white,
                  child: Image.asset(
                    'assets/images/propic.jpg',
                    fit: BoxFit.scaleDown,
                  ),
                ),
                const SizedBox(
                  width: 16,
                ),*/
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '$greeting, $name!',
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                        ),
                      ),
                      Text(
                        FirebaseAuth.instance.currentUser?.email ?? 'e-mail',
                        style: const TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w400,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),
                IconButton(
                  onPressed: () async {
                    await FirebaseAuth.instance.signOut(); // Log out user
                    Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const SignInScreen(), // Replace with your sign-in screen
                      ),
                          (route) => false,
                    );
                  },
                  icon: const Icon(Icons.logout),
                ),
              ],
            ),
          );
        },
      ),
    );
  }



  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
