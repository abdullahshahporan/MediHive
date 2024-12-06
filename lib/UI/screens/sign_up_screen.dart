import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({Key? key}) : super(key: key);

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _emailTEController = TextEditingController();
  final TextEditingController _firstNameTEController = TextEditingController();
  final TextEditingController _lastNameTEController = TextEditingController();
  final TextEditingController _mobileTEController = TextEditingController();
  final TextEditingController _passwordTEController = TextEditingController();
  bool _inProgress = false;

  @override
  Widget build(BuildContext context) {
    TextTheme textTheme = Theme.of(context).textTheme;

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.blue.shade100, Colors.blue.shade400],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 82),
                Text(
                  'Join With Us',
                  style: textTheme.headlineMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 24),
                _buildSignUpForm(),
                const SizedBox(height: 24),
                Center(
                  child: _buildHaveAccountSection(),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSignUpForm() {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          _buildTextField(
            controller: _emailTEController,
            hintText: 'Email',
            keyboardType: TextInputType.emailAddress,
            validator: (value) =>
            value!.isEmpty || !value.contains('@') ? 'Enter valid email' : null,
          ),
          const SizedBox(height: 8),
          _buildTextField(
            controller: _firstNameTEController,
            hintText: 'First name',
            validator: (value) => value!.isEmpty ? 'Enter first name' : null,
          ),
          const SizedBox(height: 8),
          _buildTextField(
            controller: _lastNameTEController,
            hintText: 'Last name',
            validator: (value) => value!.isEmpty ? 'Enter last name' : null,
          ),
          const SizedBox(height: 8),
          _buildTextField(
            controller: _mobileTEController,
            hintText: 'Mobile',
            keyboardType: TextInputType.phone,
            validator: (value) =>
            value!.isEmpty || value.length < 10 ? 'Enter valid mobile number' : null,
          ),
          const SizedBox(height: 8),
          _buildTextField(
            controller: _passwordTEController,
            hintText: 'Password',
            obscureText: true,
            validator: (value) => value!.isEmpty || value.length < 6
                ? 'Password must be at least 6 characters'
                : null,
          ),
          const SizedBox(height: 24),
          Visibility(
            visible: !_inProgress,
            replacement: const CircularProgressIndicator(),
            child: ElevatedButton(
              onPressed: _onTapNextButton,
              child: const Icon(Icons.arrow_circle_right_outlined),
            ),
          ),
        ],
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
        fillColor: Colors.white,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8.0),
        ),
      ),
      validator: validator,
    );
  }

  Widget _buildHaveAccountSection() {
    return RichText(
      text: TextSpan(
        style: const TextStyle(
          color: Colors.black,
          fontWeight: FontWeight.w600,
          fontSize: 14,
          letterSpacing: 0.5,
        ),
        text: "Have account? ",
        children: [
          TextSpan(
            text: 'Sign In',
            style: const TextStyle(color: Colors.blue),
            recognizer: TapGestureRecognizer()..onTap = _onTapSignIn,
          ),
        ],
      ),
    );
  }

  void _onTapNextButton() {
    if (_formKey.currentState!.validate()) {
      _signUpWithFirebase();
    }
  }

  Future<void> _signUpWithFirebase() async {
    setState(() {
      _inProgress = true;
    });

    try {
      // Sign up with Firebase Authentication
      UserCredential userCredential = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(
        email: _emailTEController.text.trim(),
        password: _passwordTEController.text,
      );

      User? user = userCredential.user;
      if (user != null) {
        // Save user data to Firebase Realtime Database
        DatabaseReference userRef =
        FirebaseDatabase.instance.ref('users/${user.uid}');
        await userRef.set({
          'email': _emailTEController.text.trim(),
          'firstName': _firstNameTEController.text.trim(),
          'lastName': _lastNameTEController.text.trim(),
          'mobile': _mobileTEController.text.trim(),
        });

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('User successfully signed up!')),
        );
        _clearTextFields();
        Navigator.pop(context); // Navigate to the previous screen
      }
    } on FirebaseAuthException catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.message ?? 'An error occurred')),
      );
    } finally {
      setState(() {
        _inProgress = false;
      });
    }
  }

  void _clearTextFields() {
    _emailTEController.clear();
    _firstNameTEController.clear();
    _lastNameTEController.clear();
    _mobileTEController.clear();
    _passwordTEController.clear();
  }

  void _onTapSignIn() {
    Navigator.pop(context);
  }

  @override
  void dispose() {
    _emailTEController.dispose();
    _firstNameTEController.dispose();
    _lastNameTEController.dispose();
    _mobileTEController.dispose();
    _passwordTEController.dispose();
    super.dispose();
  }
}
