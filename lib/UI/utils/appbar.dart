import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';

class MediHiveAppBar extends StatelessWidget implements PreferredSizeWidget {
  const MediHiveAppBar({

    Key? key,
    this.isProfileScreenOpen = false,
  }) : super(key: key);

  final bool isProfileScreenOpen;

  // Function to get the current greeting based on the time of day
  String getGreetingMessage() {
    final hour = DateTime.now().hour;
    if (hour > 5 && hour < 11) {
      return 'Good Morning';
    } else if (hour >= 11 && hour < 13) {
      return 'Good Noon';
    } else if (hour >= 13 && hour < 17) {
      return 'Good Afternoon';
    } else if (hour >= 17 && hour < 21) {
      return 'Good Evening';
    } else {
      return 'Good Night';
    }
  }

  // Function to fetch the user's first name from Firebase
  Future<String?> fetchUserName() async {
    try {
      User? user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        DatabaseReference userRef = FirebaseDatabase.instance.ref('users/${user.uid}');
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
    return FutureBuilder<String?>(
      future: fetchUserName(),
      builder: (context, snapshot) {
        final greeting = getGreetingMessage();
        final name = snapshot.data ?? 'User';
        final email = FirebaseAuth.instance.currentUser?.email ?? 'email@example.com';

        return AppBar(
          backgroundColor: Colors.teal.shade500,
          title: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '$greeting, $name!',
                style: const TextStyle(fontSize: 18, color: Colors.white),
              ),
              Text(
                email,
                style: const TextStyle(fontSize: 12, color: Colors.white70),
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}

