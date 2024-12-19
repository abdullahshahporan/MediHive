import 'package:flutter/material.dart';
import 'reset_password_screen.dart';

class ForgotPasswordOTPScreen extends StatelessWidget {
  final String email;
  const ForgotPasswordOTPScreen({Key? key, required this.email}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 140),
            const Text(
              'Verify OTP',
              style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            const Text(
              'Check your email for the OTP and enter it below.',
              style: TextStyle(color: Colors.grey),
            ),
            const SizedBox(height: 24),
            TextField(
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                hintText: 'Enter OTP',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ResetPasswordScreen(email: email),
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(horizontal: 100, vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: const Text('Verify OTP'),
            ),
          ],
        ),
      ),
    );
  }
}
