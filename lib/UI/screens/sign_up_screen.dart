import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:medi_hive/UI/screens/sign_in_screen.dart';

import 'confirmation_screen.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({Key? key}) : super(key: key);

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _mobileController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _inProgress = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Top Decorative Section
            Stack(
              children: [
                Container(
                  height: 200,
                  decoration: const BoxDecoration(
                    color: Colors.blue,
                    borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(50),
                      bottomRight: Radius.circular(50),
                    ),
                  ),
                ),
                Positioned(
                  top: 50,
                  left: 16,
                  child: IconButton(
                    icon: const Icon(Icons.arrow_back, color: Colors.white),
                    onPressed: () => Navigator.pop(context),
                  ),
                ),
                Positioned(
                  top: 70,
                  left: MediaQuery.of(context).size.width / 2 - 40,
                  child: const Text(
                    'Sign Up',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 24,
                    ),
                  ),
                ),
              ],
            ),

            // Form Section
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildTextField(
                      controller: _emailController,
                      hintText: 'Email',
                      keyboardType: TextInputType.emailAddress,
                      validator: (value) => value!.isEmpty || !value.contains('@')
                          ? 'Enter a valid email'
                          : null,
                    ),
                    const SizedBox(height: 16),
                    _buildTextField(
                      controller: _firstNameController,
                      hintText: 'First Name',
                      validator: (value) =>
                      value!.isEmpty ? 'Enter your first name' : null,
                    ),
                    const SizedBox(height: 16),
                    _buildTextField(
                      controller: _lastNameController,
                      hintText: 'Last Name',
                      validator: (value) =>
                      value!.isEmpty ? 'Enter your last name' : null,
                    ),
                    const SizedBox(height: 16),
                    _buildTextField(
                      controller: _mobileController,
                      hintText: 'Mobile Number',
                      keyboardType: TextInputType.phone,
                      validator: (value) =>
                      value!.isEmpty || value.length < 11
                          ? 'Enter a valid mobile number'
                          : null,
                    ),
                    const SizedBox(height: 16),
                    _buildTextField(
                      controller: _passwordController,
                      hintText: 'Password',
                      obscureText: true,
                      validator: (value) =>
                      value!.isEmpty || value.length < 6
                          ? 'Password must be at least 6 characters'
                          : null,
                    ),
                    const SizedBox(height: 24),
                    Center(
                      child: ElevatedButton(
                        onPressed: _onTapSignUpButton,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blue,
                          padding: const EdgeInsets.symmetric(
                              horizontal: 100, vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        child: const Text(
                          'Sign Up',
                          style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    Center(
                      child: RichText(
                        text: TextSpan(
                          text: 'Already have an account? ',
                          style: const TextStyle(color: Colors.black54),
                          children: [
                            TextSpan(
                              text: 'Sign In',
                              style: const TextStyle(
                                color: Colors.blue,
                                fontWeight: FontWeight.bold,
                              ),
                              recognizer: TapGestureRecognizer()
                                ..onTap = () => Navigator.pushAndRemoveUntil(
                                  context,
                                  MaterialPageRoute(builder: (context) => const SignInScreen()),
                                      (route) => false,
                            ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String hintText,
    TextInputType keyboardType = TextInputType.text,
    bool obscureText = false,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      obscureText: obscureText,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      decoration: InputDecoration(
        hintText: hintText,
        filled: true,
        fillColor: const Color(0xFFF5F5F5),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8.0),
          borderSide: BorderSide.none,
        ),
        contentPadding:
        const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      ),
      validator: validator,
    );
  }

  Future<void> _onTapSignUpButton() async {
    if (_formKey.currentState!.validate()) {
      final confirm = await showDialog<bool>(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Confirm Sign Up'),
          content:
           Text('Are you sure you want to create a new account? Plese Recheck the details before proceeding.'),

          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: const Text('No'),
            ),
            ElevatedButton(
              onPressed: () => Navigator.pop(context, true),
              child: const Text('Yes'),
            ),
          ],
        ),
      );
      if (confirm == true) {
        _signUpWithFirebase();
      }
    }
  }

  Future<void> _signUpWithFirebase() async {
    setState(() {
      _inProgress = true;
    });

    try {
      UserCredential userCredential =
      await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: _emailController.text.trim(),
        password: _passwordController.text,
      );

      User? user = userCredential.user;
      if (user != null) {
        DatabaseReference userRef =
        FirebaseDatabase.instance.ref('users/${user.uid}');
        await userRef.set({
          'email': _emailController.text.trim(),
          'firstName': _firstNameController.text.trim(),
          'lastName': _lastNameController.text.trim(),
          'mobile': _mobileController.text.trim(),
        });

        await user.sendEmailVerification();
        await FirebaseAuth.instance.signOut();

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
              content: Text(
                  'Account created successfully! A verification email has been sent.')),
        );

        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => const ConfirmationScreen()),
              (route) => false,
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.toString())),
      );
    } finally {
      setState(() {
        _inProgress = false;
      });
    }
  }

  @override
  void dispose() {
    _emailController.dispose();
    _firstNameController.dispose();
    _lastNameController.dispose();
    _mobileController.dispose();
    _passwordController.dispose();
    super.dispose();
  }
}

