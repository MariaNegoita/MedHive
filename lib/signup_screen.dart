import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'login_screen.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  // Brand colors - same as LoginScreen
  static const Color primaryBackground = Color.fromRGBO(80, 52, 30, 1);
  static const Color buttoncolor = Color.fromRGBO(131, 113, 99, 1);
  static const Color buttonshadow = Color.fromRGBO(99, 84, 72, 1);
  static const Color textcolor = Color.fromRGBO(194, 184, 176, 1);

  @override
  _SignUpScreenState createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final _formKey = GlobalKey<FormState>();
  final _fullNameController = TextEditingController();
  final _emailController = TextEditingController();
  final _idController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  bool _isLoading = false;
  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;
  bool _isDoctor = true;

  @override
  void dispose() {
    _fullNameController.dispose();
    _emailController.dispose();
    _idController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  Future<void> _signUp() async {
    print('Sign up started...');
    
    if (!_formKey.currentState!.validate()) {
      print('Form validation failed');
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      print('Creating Firebase Auth user...');
      print('Email: ${_emailController.text.trim()}');
      print('Password length: ${_passwordController.text.length}');
      
      // Creează contul în Firebase Auth
      final userCredential = await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: _emailController.text.trim(),
        password: _passwordController.text,
      );

      print('Firebase Auth user created: ${userCredential.user?.uid}');
      final user = userCredential.user;
      if (user != null) {
        print('Saving user data to Firestore...');
        
        try {
          // Salvează informațiile suplimentare în Firestore cu timeout mai mare
          final userType = _isDoctor ? 'doctor' : 'patient';
          print('Saving user as: $userType');
          
          await FirebaseFirestore.instance.collection('users').doc(user.uid).set({
            'uid': user.uid,
            'email': _emailController.text.trim(),
            'fullName': _fullNameController.text.trim().isEmpty ? 'Unknown' : _fullNameController.text.trim(),
            'id': _idController.text.trim().isEmpty ? 'Unknown' : _idController.text.trim(),
            'userType': userType,
          }).timeout(const Duration(seconds: 10)); // Timeout mărit la 10 secunde

          print('User data saved to Firestore successfully as: $userType');
        } catch (firestoreError) {
          print('Firestore error: $firestoreError');
          // Continuă chiar dacă Firestore eșuează - utilizatorul este creat în Auth
        }
        
        if (mounted) {
          _showMessage('Account created successfully! Please log in.');
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (_) => LoginScreen()),
          );
        }
      } else {
        print('User is null after creation');
        _showMessage('Failed to create user account');
      }
    } on FirebaseAuthException catch (e) {
      print('Firebase Auth error: ${e.code} - ${e.message}');
      _showMessage(_getErrorMessage(e.code));
    } catch (e) {
      print('General error: $e');
      _showMessage('Sign up failed: $e');
    } finally {
      print('Sign up process finished');
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  String _getErrorMessage(String errorCode) {
    switch (errorCode) {
      case 'weak-password':
        return 'The password provided is too weak.';
      case 'email-already-in-use':
        return 'An account already exists for this email.';
      case 'invalid-email':
        return 'The email address is not valid.';
      case 'operation-not-allowed':
        return 'Email/password accounts are not enabled.';
      default:
        return 'Sign up failed. Please try again.';
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
      backgroundColor: SignUpScreen.primaryBackground,
      appBar: AppBar(
        title: const Text('Sign Up'),
        backgroundColor: SignUpScreen.primaryBackground,
        foregroundColor: Colors.white,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: SingleChildScrollView(
        child: Center(
          child: SizedBox(
            width: 700,
            child: Column(
              children: [
                const SizedBox(height: 20),
                Image.asset('assets/images/logo.png', width: 357, height: 186),
                const SizedBox(height: 10),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 30),
                  child: Form(
                      key: _formKey,
                      child: Column(
                        children: [
                          _buildInputField('Full Name', controller: _fullNameController),
                          const SizedBox(height: 20),
                          _buildInputField('Email Address', controller: _emailController),
                          const SizedBox(height: 20),
                          _buildInputField('ID', controller: _idController),
                          const SizedBox(height: 20),
                          _buildInputField(
                            'Password', 
                            controller: _passwordController, 
                            obscureText: _obscurePassword,
                            suffixIcon: IconButton(
                              icon: Icon(
                                _obscurePassword ? Icons.visibility : Icons.visibility_off,
                                color: SignUpScreen.textcolor,
                              ),
                              onPressed: () {
                                setState(() {
                                  _obscurePassword = !_obscurePassword;
                                });
                              },
                            ),
                          ),
                          const SizedBox(height: 20),
                          _buildInputField(
                            'Confirm Password', 
                            controller: _confirmPasswordController, 
                            obscureText: _obscureConfirmPassword,
                            suffixIcon: IconButton(
                              icon: Icon(
                                _obscureConfirmPassword ? Icons.visibility : Icons.visibility_off,
                                color: SignUpScreen.textcolor,
                              ),
                              onPressed: () {
                                setState(() {
                                  _obscureConfirmPassword = !_obscureConfirmPassword;
                                });
                              },
                            ),
                          ),
                          const SizedBox(height: 20),
                          
                          // Doctor/Patient Toggle
                          Center(
                            child: GestureDetector(
                              onTap: () {
                                setState(() {
                                  _isDoctor = !_isDoctor;
                                });
                              },
                              child: Container(
                                width: 120,
                                height: 60,
                                decoration: BoxDecoration(
                                  color: Colors.grey[200],
                                  borderRadius: BorderRadius.circular(30),
                                ),
                                child: Stack(
                                  children: [
                                    AnimatedPositioned(
                                      duration: const Duration(milliseconds: 300),
                                      left: _isDoctor ? 0 : 60,
                                      child: Container(
                                        width: 60,
                                        height: 60,
                                        decoration: BoxDecoration(
                                          color: _isDoctor ? Colors.blue : Colors.green,
                                          shape: BoxShape.circle,
                                        ),
                                        child: Icon(
                                          _isDoctor ? Icons.medical_services : Icons.person,
                                          color: Colors.white,
                                        ),
                                      ),
                                    ),
                                  ],
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
                                  BoxShadow(color: SignUpScreen.buttonshadow, offset: Offset(6, 4.5)),
                                ],
                              ),
                              child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: SignUpScreen.buttoncolor,
                                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                                  elevation: 0,
                                ),
                                onPressed: _isLoading ? null : _signUp,
                                child: _isLoading
                                    ? const CircularProgressIndicator(color: SignUpScreen.primaryBackground)
                                    : const Text(
                                  'Sign Up',
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
                              'Already have an account? Log In',
                              style: TextStyle(
                                color: SignUpScreen.textcolor,
                                fontSize: 16,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                const SizedBox(height: 20),
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
        boxShadow: [BoxShadow(color: SignUpScreen.buttonshadow, offset: Offset(6, 4.5))],
        borderRadius: BorderRadius.circular(30),
      ),
      child: TextFormField(
        controller: controller,
        obscureText: obscureText,
        style: const TextStyle(color: Colors.white),
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: const TextStyle(color: SignUpScreen.textcolor),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(30.0),
            borderSide: BorderSide.none,
          ),
          filled: true,
          fillColor: SignUpScreen.buttoncolor,
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
          if (hint == 'Full Name') {
            if (value == null || value.trim().isEmpty) {
              return 'Please enter your full name';
            }
          } else if (hint == 'Email Address') {
            if (value == null || value.isEmpty) {
              return 'Please enter your email';
            }
            if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value)) {
              return 'Please enter a valid email';
            }
          } else if (hint == 'ID') {
            if (value == null || value.trim().isEmpty) {
              return 'Please enter your ID';
            }
          } else if (hint == 'Password') {
            if (value == null || value.isEmpty) {
              return 'Please enter your password';
            }
            if (value.length < 6) {
              return 'Password must be at least 6 characters';
            }
          } else if (hint == 'Confirm Password') {
            if (value == null || value.isEmpty) {
              return 'Please confirm your password';
            }
            if (value != _passwordController.text) {
              return 'Passwords do not match';
            }
          }
          return null;
        },
      ),
    );
  }
}
