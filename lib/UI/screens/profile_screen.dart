import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';

import 'main_bottom_nav_bar_screen.dart';
import 'sign_in_screen.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _currentPasswordController = TextEditingController();
  final TextEditingController _newPasswordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();

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
        _nameController.text = '${data['firstName'] ?? ''} ${data['lastName'] ?? ''}';
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
    if (_isEditing &&
        (_newPasswordController.text != _confirmPasswordController.text)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('New passwords do not match!')),
      );
      return;
    }

    if (_isEditing && _newPasswordController.text == _currentPasswordController.text) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('New password cannot be the same as the old password!')),
      );
      return;
    }

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
        'firstName': _nameController.text.split(' ').first.trim(),
        'lastName': _nameController.text.split(' ').length > 1
            ? _nameController.text.split(' ').last.trim()
            : '',
        'mobile': _phoneController.text.trim(),
      });

      if (_newPasswordController.text.isNotEmpty) {
        await user.updatePassword(_newPasswordController.text.trim());
        await FirebaseAuth.instance.signOut();

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
                'Password updated successfully! Please log in again to continue.'),
          ),
        );

        Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (context) => const SignInScreen()),
              (route) => false,
        );
        return;
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
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => const MainBottomNavBarScreen()),
        );
        return false;
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text('My Profile'),
          backgroundColor: Colors.teal,
        ),
        body: _inProgress
            ? const Center(child: CircularProgressIndicator())
            : Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              _buildProfileField(
                icon: Icons.person,
                label: 'Name',
                controller: _nameController,
                readOnly: !_isEditing,
              ),
              const SizedBox(height: 16),
              _buildProfileField(
                icon: Icons.email,
                label: 'Email',
                controller: _emailController,
                readOnly: true,
              ),
              const SizedBox(height: 16),
              _buildProfileField(
                icon: Icons.phone,
                label: 'Phone Number',
                controller: _phoneController,
                readOnly: !_isEditing,
              ),
              const SizedBox(height: 16),
              _buildProfileField(
                icon: Icons.lock,
                label: 'Password',
                controller: _currentPasswordController,
                readOnly: true,
                obscureText: true,
              ),
              if (_isEditing) ...[
                const SizedBox(height: 16),
                _buildProfileField(
                  icon: Icons.lock,
                  label: 'New Password',
                  controller: _newPasswordController,
                  obscureText: true,
                ),
                const SizedBox(height: 16),
                _buildProfileField(
                  icon: Icons.lock_outline,
                  label: 'Confirm New Password',
                  controller: _confirmPasswordController,
                  obscureText: true,
                ),
              ],
              const Spacer(),
              ElevatedButton(
                onPressed: _isEditing ? _updateProfile : () {
                  setState(() {
                    _isEditing = true;
                  });
                },
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size(double.infinity, 48),
                  backgroundColor: Colors.teal,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: Text(
                  _isEditing ? 'Save Changes' : 'Update Profile',
                  style: const TextStyle(fontSize: 16),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildProfileField({
    required IconData icon,
    required String label,
    required TextEditingController controller,
    bool readOnly = false,
    bool obscureText = false,
  }) {
    return TextField(
      controller: controller,
      readOnly: readOnly,
      obscureText: obscureText,
      decoration: InputDecoration(
        prefixIcon: Icon(icon, color: Colors.teal),
        labelText: label,
        labelStyle: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
        filled: true,
        fillColor: Colors.grey.shade100,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      ),
    );
  }
}
