import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';


class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  // Brand colors - same as LoginScreen
  static const Color primaryBackground = Color.fromRGBO(80, 52, 30, 1);
  static const Color buttoncolor = Color.fromRGBO(131, 113, 99, 1);
  static const Color buttonshadow = Color.fromRGBO(99, 84, 72, 1);
  static const Color textcolor = Color.fromRGBO(194, 184, 176, 1);
  static const Color darkBrown = Color.fromRGBO(75, 42, 23, 1);
  static const Color beige = Color(0xFFDECBB7);
  static const Color orange = Color.fromRGBO(255, 165, 0, 1);

  @override
  _ForgotPasswordScreenState createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  bool _isLoading = false;

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  Future<void> _sendPasswordResetEmail() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      print('🔄 Sending password reset email to: ${_emailController.text.trim()}');
      
      await FirebaseAuth.instance.sendPasswordResetEmail(
        email: _emailController.text.trim(),
      );
      
      print('✅ Password reset email sent successfully');
      
      if (mounted) {
        _showMessage('Password reset email sent to ${_emailController.text.trim()}! Check your inbox and spam folder.');
        Navigator.of(context).pop();
      }
    } on FirebaseAuthException catch (e) {
      print('❌ Firebase Auth error: ${e.code} - ${e.message}');
      _showMessage(_getErrorMessage(e.code));
    } catch (e) {
      print('❌ General error: $e');
      _showMessage('Failed to send reset email: $e');
    } finally {
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
        return 'No account found with this email address. Please check your email or create a new account.';
      case 'invalid-email':
        return 'The email address is not valid. Please enter a correct email address.';
      case 'user-disabled':
        return 'This account has been disabled. Please contact support.';
      case 'too-many-requests':
        return 'Too many reset attempts. Please wait a few minutes before trying again.';
      default:
        return 'Failed to send reset email. Please check your internet connection and try again.';
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
      backgroundColor: ForgotPasswordScreen.primaryBackground,
      appBar: AppBar(
        title: const Text('Forgot Password'),
        backgroundColor: ForgotPasswordScreen.primaryBackground,
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
            child: Center(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 30),
                child: Form(
                  key: _formKey,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                          // Main Dialog Box
                          Card(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16),
                            ),
                            elevation: 8,
                            color: ForgotPasswordScreen.beige,
                            child: Column(
                              children: [
                                // Header Section
                                Container(
                                  width: double.infinity,
                                  decoration: BoxDecoration(
                                    color: ForgotPasswordScreen.beige,
                                    borderRadius: const BorderRadius.only(
                                      topLeft: Radius.circular(16),
                                      topRight: Radius.circular(16),
                                    ),
                                  ),
                                  padding: const EdgeInsets.all(24),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Row(
                                        children: [
                                          const Icon(
                                            Icons.person,
                                            color: ForgotPasswordScreen.darkBrown,
                                            size: 20,
                                          ),
                                          const SizedBox(width: 8),
                                          const Text(
                                            'Account',
                                            style: TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.w500,
                                              color: ForgotPasswordScreen.darkBrown,
                                            ),
                                          ),
                                        ],
                                      ),
                                      IconButton(
                                        onPressed: () => Navigator.of(context).pop(),
                                        icon: const Icon(
                                          Icons.close,
                                          color: ForgotPasswordScreen.darkBrown,
                                          size: 20,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                
                                // Main Content
                                Padding(
                                  padding: const EdgeInsets.all(40),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      const Text(
                                        'Forgot Password',
                                        style: TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold,
                                          color: ForgotPasswordScreen.darkBrown,
                                        ),
                                      ),
                                      const SizedBox(height: 16),
                                      const Text(
                                        'You will receive an email containing the code for changing the password.',
                                        style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.w500,
                                          color: ForgotPasswordScreen.darkBrown,
                                        ),
                                      ),
                                      const SizedBox(height: 24),
                                      const Text(
                                        'Email',
                                        style: TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.w500,
                                          color: ForgotPasswordScreen.darkBrown,
                                        ),
                                      ),
                                      const SizedBox(height: 8),
                                      Container(
                                        decoration: BoxDecoration(
                                          color: ForgotPasswordScreen.beige,
                                          borderRadius: BorderRadius.circular(8),
                                          border: Border.all(
                                            color: ForgotPasswordScreen.darkBrown,
                                            width: 1,
                                          ),
                                        ),
                                        child: TextFormField(
                                          controller: _emailController,
                                          keyboardType: TextInputType.emailAddress,
                                          style: const TextStyle(
                                            color: ForgotPasswordScreen.darkBrown,
                                            fontSize: 16,
                                          ),
                                          decoration: const InputDecoration(
                                            hintText: 'Enter your email address',
                                            hintStyle: TextStyle(
                                              color: ForgotPasswordScreen.textcolor,
                                              fontSize: 16,
                                            ),
                                            border: InputBorder.none,
                                            contentPadding: EdgeInsets.all(16),
                                          ),
                                          validator: (value) {
                                            if (value == null || value.isEmpty) {
                                              return 'Please enter your email';
                                            }
                                            if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value)) {
                                              return 'Please enter a valid email';
                                            }
                                            return null;
                                          },
                                        ),
                                      ),
                                      const SizedBox(height: 24),
                                      Center(
                                        child: Container(
                                          decoration: BoxDecoration(
                                            borderRadius: BorderRadius.circular(30),
                                            boxShadow: [
                                              BoxShadow(
                                                color: ForgotPasswordScreen.buttonshadow,
                                                offset: const Offset(6, 4.5),
                                              ),
                                            ],
                                          ),
                                          child: ElevatedButton(
                                            style: ElevatedButton.styleFrom(
                                              backgroundColor: ForgotPasswordScreen.buttoncolor,
                                              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                                              shape: RoundedRectangleBorder(
                                                borderRadius: BorderRadius.circular(30),
                                              ),
                                              elevation: 0,
                                            ),
                                            onPressed: _isLoading ? null : _sendPasswordResetEmail,
                                            child: _isLoading
                                                ? const CircularProgressIndicator(
                                                    color: ForgotPasswordScreen.primaryBackground,
                                                  )
                                                : const Text(
                                                    'Send Reset Email',
                                                    style: TextStyle(
                                                      color: Color(0xFFDF965A),
                                                      fontWeight: FontWeight.bold,
                                                      fontSize: 18,
                                                    ),
                                                  ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
