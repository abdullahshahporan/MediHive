/*import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'main_bottom_nav_bar_screen.dart'; // Your main screen
import 'forgot_password_screen.dart'; // Your forgot password screen

class SignInScreen extends StatefulWidget {
  const SignInScreen({Key? key}) : super(key: key);

  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _inProgress = false;

  @override
  void initState() {
    super.initState();
    _checkAuthenticationState();
  }

  /// Check if the user is already signed in
  Future<void> _checkAuthenticationState() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null && user.emailVerified) {
      // Navigate directly to the main screen if the user is already signed in and verified
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
                  top: 70,
                  left: MediaQuery.of(context).size.width / 2 - 40,
                  child: const Text(
                    'Log In',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 24,
                    ),
                  ),
                ),
              ],
            ),

            // Login Form Section
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildTextField(
                      controller: _emailController,
                      hintText: 'E-mail number',
                      keyboardType: TextInputType.emailAddress,
                      validator: (value) => value!.isEmpty
                          ? 'Enter a valid e-mail number'
                          : null,
                    ),
                    const SizedBox(height: 16),
                    _buildTextField(
                      controller: _passwordController,
                      hintText: 'Password',
                      obscureText: true,
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Enter a valid password';
                        }
                        if (value.length <= 2) {
                          return 'Password must be more than 2 characters';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 24),
                    Center(
                      child: ElevatedButton(
                        onPressed: _inProgress ? null : _onTapSignInButton,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blue,
                          padding: const EdgeInsets.symmetric(
                              horizontal: 100, vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        child: const Text(
                          'Log In',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    Center(
                      child: TextButton(
                        onPressed: _onTapForgotPassword,
                        child: const Text(
                          'Forgot Password?',
                          style: TextStyle(
                            color: Colors.blue,
                            fontWeight: FontWeight.bold,
                          ),
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
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      ),
      validator: validator,
    );
  }

  void _onTapSignInButton() {
    if (_formKey.currentState!.validate()) {
      _signInWithFirebase();
    }
  }

  Future<void> _signInWithFirebase() async {
    setState(() {
      _inProgress = true;
    });

    try {
      UserCredential userCredential = await FirebaseAuth.instance
          .signInWithEmailAndPassword(
        email: _emailController.text.trim(),
        password: _passwordController.text,
      );

      User? user = userCredential.user;

      if (user != null && user.emailVerified) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Signed in successfully!')),
        );

        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(
              builder: (context) => const MainBottomNavBarScreen()),
              (route) => false,
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
              content: Text(
                  'Email not verified. Please verify your email and try again.')),
        );
        await FirebaseAuth.instance.signOut(); // Sign out unverified users
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

  void _onTapForgotPassword() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const ForgotPasswordScreen(),
      ),
    );
  }
}*/
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'main_bottom_nav_bar_screen.dart'; // Your main screen
import 'forgot_password_screen.dart'; // Your forgot password screen
import 'sign_up_screen.dart'; // Your sign-up screen

class SignInScreen extends StatefulWidget {
  const SignInScreen({Key? key}) : super(key: key);

  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _inProgress = false;

  @override
  void initState() {
    super.initState();
    _checkAuthenticationState();
  }

  /// Check if the user is already signed in
  Future<void> _checkAuthenticationState() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null && user.emailVerified) {
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
                  top: 70,
                  left: MediaQuery.of(context).size.width / 2 - 40,
                  child: const Text(
                    'Log In',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 24,
                    ),
                  ),
                ),
              ],
            ),

            // Login Form Section
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildTextField(
                      controller: _emailController,
                      hintText: 'E-mail number',
                      keyboardType: TextInputType.emailAddress,
                      validator: (value) => value!.isEmpty
                          ? 'Enter a valid e-mail number'
                          : null,
                    ),
                    const SizedBox(height: 16),
                    _buildTextField(
                      controller: _passwordController,
                      hintText: 'Password',
                      obscureText: true,
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Enter a valid password';
                        }
                        if (value.length <= 2) {
                          return 'Password must be more than 2 characters';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 24),
                    Center(
                      child: ElevatedButton(
                        onPressed: _inProgress ? null : _onTapSignInButton,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blue,
                          padding: const EdgeInsets.symmetric(
                              horizontal: 100, vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        child: const Text(
                          'Log In',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    Center(
                      child: TextButton(
                        onPressed: _onTapForgotPassword,
                        child: const Text(
                          'Forgot Password?',
                          style: TextStyle(
                            color: Colors.blue,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    Center(
                      child: TextButton(
                        onPressed: _onTapSignUp,
                        child: const Text(
                          "Don't have an account? Sign Up",
                          style: TextStyle(
                            color: Colors.blue,
                            fontWeight: FontWeight.bold,
                          ),
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
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      ),
      validator: validator,
    );
  }

  void _onTapSignInButton() {
    if (_formKey.currentState!.validate()) {
      _signInWithFirebase();
    }
  }

  Future<void> _signInWithFirebase() async {
    setState(() {
      _inProgress = true;
    });

    try {
      UserCredential userCredential = await FirebaseAuth.instance
          .signInWithEmailAndPassword(
        email: _emailController.text.trim(),
        password: _passwordController.text,
      );

      User? user = userCredential.user;

      if (user != null && user.emailVerified) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Signed in successfully!')),
        );

        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(
              builder: (context) => const MainBottomNavBarScreen()),
              (route) => false,
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
              content: Text(
                  'Email not verified. Please verify your email and try again.')),
        );
        await FirebaseAuth.instance.signOut(); // Sign out unverified users
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

  void _onTapForgotPassword() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const ForgotPasswordScreen(),
      ),
    );
  }

  void _onTapSignUp() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const SignUpScreen(),
      ),
    );
  }
}
