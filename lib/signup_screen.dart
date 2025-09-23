import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'login_screen.dart';

class SignUpScreen extends StatefulWidget {
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
  bool _isPressed = false;

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
    
    // Test simplu - doar verifică dacă email și parolă sunt completate
    if (_emailController.text.trim().isEmpty || _passwordController.text.isEmpty) {
      _showMessage('Please fill in email and password');
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
      backgroundColor: const Color(0xFF50341E), // Fundal maro închis ca în codul tău
      appBar: AppBar(
        title: const Text('Sign Up'),
        backgroundColor: const Color(0xFF50341E),
        foregroundColor: Colors.white,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(height: 40),
                
                // Logo
                Image.asset(
                  'assets/images/logo.png', // Folosesc logo-ul existent
                  width: 400,
                  height: 200,
                  fit: BoxFit.cover,
                ),

                // Full Name Field
                Padding(
                  padding: const EdgeInsets.fromLTRB(30, 10, 30, 10),
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(100),
                      boxShadow: [
                        BoxShadow(
                          color: const Color(0xFF635448),
                          offset: const Offset(6, 4.5),
                        ),
                      ],
                    ),
                    child: TextFormField(
                      controller: _fullNameController,
                      keyboardType: TextInputType.name,
                      style: const TextStyle(color: Colors.white),
                      decoration: InputDecoration(
                        labelStyle: const TextStyle(color: Colors.white),
                        hintText: 'Full Name',
                        hintStyle: const TextStyle(color: Color(0xFFC2B8B0)),
                        prefixIcon: const Icon(Icons.person, color: Colors.white),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(100.0),
                        ),
                        filled: true,
                        fillColor: const Color(0xFF837163),
                        contentPadding: const EdgeInsets.symmetric(vertical: 8, horizontal: 10),
                        isDense: true,
                      ),
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return 'Full name is required';
                        }
                        return null;
                      },
                    ),
                  ),
                ),

                // Email Field
                Padding(
                  padding: const EdgeInsets.fromLTRB(30, 10, 30, 10),
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(100),
                      boxShadow: [
                        BoxShadow(
                          color: const Color(0xFF635448),
                          offset: const Offset(6, 4.5),
                        ),
                      ],
                    ),
                    child: TextFormField(
                      controller: _emailController,
                      keyboardType: TextInputType.emailAddress,
                      style: const TextStyle(color: Colors.white),
                      decoration: InputDecoration(
                        labelStyle: const TextStyle(color: Colors.white),
                        hintText: 'Email',
                        hintStyle: const TextStyle(color: Color(0xFFC2B8B0)),
                        prefixIcon: const Icon(Icons.email, color: Colors.white),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(100.0),
                        ),
                        filled: true,
                        fillColor: const Color(0xFF837163),
                        contentPadding: const EdgeInsets.symmetric(vertical: 8, horizontal: 10),
                        isDense: true,
                      ),
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return 'Email is required';
                        }
                        final emailRegex = RegExp(r'^\S+@\S+\.[\S]+$');
                        if (!emailRegex.hasMatch(value.trim())) {
                          return 'Enter a valid email';
                        }
                        return null;
                      },
                    ),
                  ),
                ),

                // ID Field
                Padding(
                  padding: const EdgeInsets.fromLTRB(30, 10, 30, 10),
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(100),
                      boxShadow: [
                        BoxShadow(
                          color: const Color(0xFF635448),
                          offset: const Offset(6, 4.5),
                        ),
                      ],
                    ),
                    child: TextFormField(
                      controller: _idController,
                      keyboardType: TextInputType.number,
                      style: const TextStyle(color: Colors.white),
                      decoration: InputDecoration(
                        labelStyle: const TextStyle(color: Colors.white),
                        hintText: 'ID',
                        hintStyle: const TextStyle(color: Color(0xFFC2B8B0)),
                        prefixIcon: const Icon(Icons.perm_identity, color: Colors.white),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(100.0),
                        ),
                        filled: true,
                        fillColor: const Color(0xFF837163),
                        contentPadding: const EdgeInsets.symmetric(vertical: 8, horizontal: 10),
                        isDense: true,
                      ),
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return 'ID is required';
                        }
                        return null;
                      },
                    ),
                  ),
                ),

                // Password Field
                Padding(
                  padding: const EdgeInsets.fromLTRB(30, 10, 30, 10),
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(100),
                      boxShadow: [
                        BoxShadow(
                          color: const Color(0xFF635448),
                          offset: const Offset(6, 4.5),
                        ),
                      ],
                    ),
                    child: TextFormField(
                      controller: _passwordController,
                      obscureText: _obscurePassword,
                      style: const TextStyle(color: Colors.white),
                      decoration: InputDecoration(
                        labelStyle: const TextStyle(color: Colors.white),
                        hintText: 'Password',
                        hintStyle: const TextStyle(color: Color(0xFFC2B8B0)),
                        prefixIcon: const Icon(Icons.lock, color: Colors.white),
                        suffixIcon: IconButton(
                          icon: Icon(
                            _obscurePassword ? Icons.visibility : Icons.visibility_off,
                            color: Colors.white,
                          ),
                          onPressed: () {
                            setState(() {
                              _obscurePassword = !_obscurePassword;
                            });
                          },
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(100.0),
                        ),
                        filled: true,
                        fillColor: const Color(0xFF837163),
                        contentPadding: const EdgeInsets.symmetric(vertical: 8, horizontal: 10),
                        isDense: true,
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Password is required';
                        }
                        if (value.length < 6) {
                          return 'Password must be at least 6 characters';
                        }
                        return null;
                      },
                    ),
                  ),
                ),

                // Re-enter Password Field
                Padding(
                  padding: const EdgeInsets.fromLTRB(30, 10, 30, 10),
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(100),
                      boxShadow: [
                        BoxShadow(
                          color: const Color(0xFF635448),
                          offset: const Offset(6, 4.5),
                        ),
                      ],
                    ),
                    child: TextFormField(
                      controller: _confirmPasswordController,
                      obscureText: _obscureConfirmPassword,
                      style: const TextStyle(color: Colors.white),
                      decoration: InputDecoration(
                        labelStyle: const TextStyle(color: Colors.white),
                        hintText: 'Re-enter Password',
                        hintStyle: const TextStyle(color: Color(0xFFC2B8B0)),
                        prefixIcon: const Icon(Icons.lock, color: Colors.white),
                        suffixIcon: IconButton(
                          icon: Icon(
                            _obscureConfirmPassword ? Icons.visibility : Icons.visibility_off,
                            color: Colors.white,
                          ),
                          onPressed: () {
                            setState(() {
                              _obscureConfirmPassword = !_obscureConfirmPassword;
                            });
                          },
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(100.0),
                        ),
                        filled: true,
                        fillColor: const Color(0xFF837163),
                        contentPadding: const EdgeInsets.symmetric(vertical: 8, horizontal: 10),
                        isDense: true,
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please confirm your password';
                        }
                        if (value != _passwordController.text) {
                          return 'Passwords do not match';
                        }
                        return null;
                      },
                    ),
                  ),
                ),

                // Doctor/Patient Toggle
                Padding(
                  padding: const EdgeInsets.fromLTRB(30, 10, 30, 10),
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

                // Sign Up Button
                Padding(
                  padding: const EdgeInsets.fromLTRB(30, 10, 30, 10),
                  child: Center(
                    child: GestureDetector(
                    onTapDown: (_) => setState(() => _isPressed = true),
                    onTapUp: (_) => setState(() => _isPressed = false),
                    onTapCancel: () => setState(() => _isPressed = false),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 20),
                      transform: Matrix4.translationValues(
                        _isPressed ? 6 : 0,
                        _isPressed ? 4.5 : 0,
                        0,
                      ),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(100),
                        boxShadow: _isPressed
                            ? []
                            : [
                                const BoxShadow(
                                  color: Color(0xFF635448),
                                  offset: Offset(6, 4.5),
                                  blurRadius: 0,
                                ),
                              ],
                      ),
                      child: ElevatedButton(
                        onPressed: _isLoading ? null : _signUp,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF837163),
                          foregroundColor: const Color(0xFFDF965A),
                          shadowColor: Colors.transparent,
                          elevation: 0,
                          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(100),
                          ),
                        ),
                        child: _isLoading
                            ? const SizedBox(
                                width: 20,
                                height: 20,
                                child: CircularProgressIndicator(
                                  color: Color(0xFFDF965A),
                                  strokeWidth: 2,
                                ),
                              )
                            : const Text(
                                'Sign up',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                      ),
                    ),
                  ),
                ),
                ),

                const SizedBox(height: 40),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
