import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'doctor_home_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  // Brand colors
  static const Color primaryBackground = Color.fromRGBO(80, 52, 30, 1);
  static const Color buttoncolor = Color.fromRGBO(131, 113, 99, 1);
  static const Color buttonshadow = Color.fromRGBO(99, 84, 72, 1);
  static const Color textcolor = Color.fromRGBO(194, 184, 176, 1);

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isLoading = false;
  bool _obscurePassword = true;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _login() async {
    print('Login started...');
    if (!_formKey.currentState!.validate()) {
      print('Form validation failed');
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      print('Signing in with Firebase Auth...');
      final userCredential = await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: _emailController.text.trim(),
        password: _passwordController.text,
      );

      print('Login successful: ${userCredential.user?.uid}');
      final user = userCredential.user;
      if (user != null) {
        print('Updating lastLogin in Firestore...');
        try {
          // Actualizează lastLogin în Firestore cu timeout
          await FirebaseFirestore.instance.collection('users').doc(user.uid).update({
            'lastLogin': DateTime.now().toIso8601String(),
          }).timeout(const Duration(seconds: 10));
          print('LastLogin updated successfully');
        } catch (firestoreError) {
          print('Firestore update error: $firestoreError');
          // Continuă chiar dacă Firestore eșuează
        }

        if (mounted) {
          _showMessage('Logged in as ${user.email ?? 'Unknown'}');
          print('✅ NAVIGATING TO DOCTOR HOME SCREEN');
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (_) => DoctorHomeScreen()),
          );
        }
      }
    } on FirebaseAuthException catch (e) {
      print('Firebase Auth error: ${e.code} - ${e.message}');
      _showMessage(_getErrorMessage(e.code));
    } catch (e) {
      print('General error: $e');
      _showMessage('Login failed: $e');
    } finally {
      print('Login process finished');
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  String _getErrorMessage(String errorCode) {
    switch (errorCode) {
      case 'user-not-found':
        return 'No user found with this email address.';
      case 'wrong-password':
        return 'Wrong password provided.';
      case 'invalid-email':
        return 'The email address is not valid.';
      case 'user-disabled':
        return 'This user account has been disabled.';
      case 'too-many-requests':
        return 'Too many attempts. Please try again later.';
      default:
        return 'Login failed. Please try again.';
    }
  }

  void _showMessage(String message) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: const Color(0xFF4B2A17),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: LoginScreen.primaryBackground,
      appBar: AppBar(
        title: const Text('Login'),
        backgroundColor: LoginScreen.primaryBackground,
        foregroundColor: Colors.white,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: SafeArea(
        child: Center(
          child: SizedBox(
            width: 700,
            child: Column(
              children: [
                const Spacer(flex: 2),
                Image.asset('assets/images/logo.png', width: 357, height: 186),
                const Spacer(flex: 1),
                Expanded(
                  flex: 6,
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.symmetric(horizontal: 30),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        children: [
                          _buildInputField('Email Address', controller: _emailController),
                          const SizedBox(height: 20),
                          _buildInputField(
                            'Password', 
                            controller: _passwordController, 
                            obscureText: _obscurePassword,
                            suffixIcon: IconButton(
                              icon: Icon(
                                _obscurePassword ? Icons.visibility : Icons.visibility_off,
                                color: LoginScreen.textcolor,
                              ),
                              onPressed: () {
                                setState(() {
                                  _obscurePassword = !_obscurePassword;
                                });
                              },
                            ),
                          ),
                          Align(
                            alignment: Alignment.centerRight,
                            child: TextButton(
                              onPressed: () {}, // TODO: implement reset password
                              child: const Text(
                                'Forgot password?',
                                style: TextStyle(
                                  color: LoginScreen.textcolor,
                                  decoration: TextDecoration.underline,
                                  decorationColor: LoginScreen.textcolor,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 20),
                          Center(
                            child: Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(30),
                                boxShadow: [
                                  BoxShadow(color: LoginScreen.buttonshadow, offset: Offset(6, 4.5)),
                                ],
                              ),
                              child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: LoginScreen.buttoncolor,
                                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                                  elevation: 0,
                                ),
                                onPressed: _isLoading ? null : _login,
                                child: _isLoading
                                    ? const CircularProgressIndicator(color: LoginScreen.primaryBackground)
                                    : const Text(
                                  'Log in',
                                  style: TextStyle(
                                    color: Color(0xFFDF965A),
                                    fontWeight: FontWeight.bold,
                                    fontSize: 18,
                                  ),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 20),
                          TextButton(
                            onPressed: () => Navigator.of(context).pop(),
                            child: const Text(
                              'Don\'t have an account? Sign Up',
                              style: TextStyle(
                                color: LoginScreen.textcolor,
                                fontSize: 16,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                const Spacer(flex: 1),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildInputField(String hint, {required TextEditingController controller, bool obscureText = false, Widget? suffixIcon}) {
    return Container(
      width: 700,
      decoration: BoxDecoration(
        boxShadow: [BoxShadow(color: LoginScreen.buttonshadow, offset: Offset(6, 4.5))],
        borderRadius: BorderRadius.circular(30),
      ),
      child: TextFormField(
        controller: controller,
        obscureText: obscureText,
        style: const TextStyle(color: Colors.white),
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: const TextStyle(color: LoginScreen.textcolor),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(30.0),
            borderSide: BorderSide.none,
          ),
          filled: true,
          fillColor: LoginScreen.buttoncolor,
          contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          suffixIcon: suffixIcon,
          isDense: true,
          errorStyle: const TextStyle(fontSize: 12),
          errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(30.0),
            borderSide: BorderSide.none,
          ),
          focusedErrorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(30.0),
            borderSide: BorderSide.none,
          ),
        ),
        validator: (value) {
          if (hint == 'Email Address') {
            if (value == null || value.isEmpty) {
              return 'Please enter your email';
            }
            if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value)) {
              return 'Please enter a valid email';
            }
          } else if (hint == 'Password') {
            if (value == null || value.isEmpty) {
              return 'Please enter your password';
            }
            if (value.length < 6) {
              return 'Password must be at least 6 characters';
            }
          }
          return null;
        },
      ),
    );
  }
}
