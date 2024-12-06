import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';

import 'main_bottom_nav_bar_screen.dart';
//import 'main_screen.dart'; // Import your MainScreen here
import 'sign_in_screen.dart'; // Import SignInScreen

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  bool _inProgress = false;
  bool _isEditing = false;

  @override
  void initState() {
    super.initState();
    _fetchUserProfile();
  }

  Future<void> _fetchUserProfile() async {
    setState(() {
      _inProgress = true;
    });

    try {
      User? user = FirebaseAuth.instance.currentUser;
      if (user == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('No user is signed in.')),
        );
        return;
      }

      DatabaseReference userRef =
      FirebaseDatabase.instance.ref('users/${user.uid}');
      DataSnapshot snapshot = await userRef.get();

      if (snapshot.exists) {
        Map data = snapshot.value as Map;
        _emailController.text = data['email'] ?? '';
        _firstNameController.text = data['firstName'] ?? '';
        _lastNameController.text = data['lastName'] ?? '';
        _phoneController.text = data['mobile'] ?? '';
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('No user data found.')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to load profile: $e')),
      );
    } finally {
      setState(() {
        _inProgress = false;
      });
    }
  }

  Future<void> _updateProfile() async {
    setState(() {
      _inProgress = true;
    });

    try {
      User? user = FirebaseAuth.instance.currentUser;
      if (user == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('No user is signed in.')),
        );
        return;
      }

      DatabaseReference userRef =
      FirebaseDatabase.instance.ref('users/${user.uid}');
      await userRef.update({
        'firstName': _firstNameController.text.trim(),
        'lastName': _lastNameController.text.trim(),
        'mobile': _phoneController.text.trim(),
      });

      if (_passwordController.text.isNotEmpty) {
        // Update password and log out the user
        await user.updatePassword(_passwordController.text.trim());
        await FirebaseAuth.instance.signOut();

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
                'Password updated successfully! Please log in again to continue.'),
          ),
        );

        // Navigate to the Login Screen after sign out
        Navigator.of(context).pushAndRemoveUntil(

          MaterialPageRoute(builder: (context) => const SignInScreen()),
              (route) => false,
        );

        return; // Stop further execution
      }

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Profile updated successfully!')),
      );

      setState(() {
        _isEditing = false;
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to update profile: $e')),
      );
    } finally {
      setState(() {
        _inProgress = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        // Redirect back to the main screen instead of exiting the app
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => const MainBottomNavBarScreen()),
        );
        return false; // Prevent the default behavior of exiting the app
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Profile'),
          backgroundColor: Colors.blueAccent,
        ),
        body: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.blue.shade100, Colors.blue.shade400],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
          ),
          child: _inProgress
              ? const Center(child: CircularProgressIndicator())
              : SingleChildScrollView(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Your Profile',
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 24),
                _buildProfileField(
                  controller: _emailController,
                  label: 'Email',
                  readOnly: true,
                ),
                const SizedBox(height: 16),
                _buildProfileField(
                  controller: _firstNameController,
                  label: 'First Name',
                  readOnly: !_isEditing,
                ),
                const SizedBox(height: 16),
                _buildProfileField(
                  controller: _lastNameController,
                  label: 'Last Name',
                  readOnly: !_isEditing,
                ),
                const SizedBox(height: 16),
                _buildProfileField(
                  controller: _phoneController,
                  label: 'Mobile Number',
                  keyboardType: TextInputType.phone,
                  readOnly: !_isEditing,
                ),
                if (_isEditing)
                  const SizedBox(height: 16),
                if (_isEditing)
                  _buildProfileField(
                    controller: _passwordController,
                    label: 'New Password',
                    obscureText: true,
                  ),
                const SizedBox(height: 32),
                Center(
                  child: ElevatedButton(
                    onPressed: _isEditing ? _updateProfile : () {
                      setState(() {
                        _isEditing = true;
                      });
                    },
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 48, vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: Text(
                      _isEditing ? 'Save Changes' : 'Edit Profile',
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildProfileField({
    required TextEditingController controller,
    required String label,
    TextInputType keyboardType = TextInputType.text,
    bool obscureText = false,
    bool readOnly = false,
  }) {
    return TextField(
      controller: controller,
      keyboardType: keyboardType,
      obscureText: obscureText,
      readOnly: readOnly,
      decoration: InputDecoration(
        labelText: label,
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.0),
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16.0,
          vertical: 12.0,
        ),
      ),
    );
  }
}

