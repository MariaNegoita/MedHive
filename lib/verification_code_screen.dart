import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

// Clasă pentru stocarea codurilor în memorie (pentru demo)
class _VerificationCodeStorage {
  static final Map<String, String> _codes = {};
  static final Map<String, DateTime> _expiry = {};

  static void setCode(String email, String code) {
    _codes[email] = code;
    _expiry[email] = DateTime.now().add(const Duration(minutes: 10));
  }

  static String? getCode(String email) {
    if (_expiry[email] != null && DateTime.now().isAfter(_expiry[email]!)) {
      _codes.remove(email);
      _expiry.remove(email);
      return null;
    }
    return _codes[email];
  }

  static void removeCode(String email) {
    _codes.remove(email);
    _expiry.remove(email);
  }
}

class VerificationCodeScreen extends StatefulWidget {
  final String email;
  
  const VerificationCodeScreen({super.key, required this.email});

  // Brand colors - same as other screens
  static const Color primaryBackground = Color.fromRGBO(80, 52, 30, 1);
  static const Color buttoncolor = Color.fromRGBO(131, 113, 99, 1);
  static const Color buttonshadow = Color.fromRGBO(99, 84, 72, 1);
  static const Color textcolor = Color.fromRGBO(194, 184, 176, 1);
  static const Color darkBrown = Color.fromRGBO(75, 42, 23, 1);
  static const Color beige = Color(0xFFDECBB7);
  static const Color orange = Color.fromRGBO(255, 165, 0, 1);

  @override
  _VerificationCodeScreenState createState() => _VerificationCodeScreenState();
}

class _VerificationCodeScreenState extends State<VerificationCodeScreen> {
  final _formKey = GlobalKey<FormState>();
  final _codeController = TextEditingController();
  bool _isLoading = false;

  @override
  void dispose() {
    _codeController.dispose();
    super.dispose();
  }

  Future<void> _verifyCode() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      // Verifică codul din stocarea în memorie
      final storedCode = _VerificationCodeStorage.getCode(widget.email);

      if (storedCode == null) {
        _showMessage('No verification code found or code has expired. Please request a new one.');
        return;
      }

      // Verifică dacă codul introdus este corect
      if (_codeController.text.trim() != storedCode) {
        _showMessage('Invalid verification code. Please try again.');
        return;
      }

      // Șterge codul după verificare
      _VerificationCodeStorage.removeCode(widget.email);

      if (mounted) {
        _showMessage('Code verified successfully! You can now reset your password.');
        Navigator.of(context).pop();
      }
    } catch (e) {
      _showMessage('Error verifying code: $e');
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
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
      backgroundColor: VerificationCodeScreen.primaryBackground,
      appBar: AppBar(
        title: const Text('Verification Code'),
        backgroundColor: VerificationCodeScreen.primaryBackground,
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
                        color: VerificationCodeScreen.beige,
                        child: Column(
                          children: [
                            // Header Section
                            Container(
                              width: double.infinity,
                              decoration: BoxDecoration(
                                color: VerificationCodeScreen.beige,
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
                                        color: VerificationCodeScreen.darkBrown,
                                        size: 20,
                                      ),
                                      const SizedBox(width: 8),
                                      const Text(
                                        'Account',
                                        style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.w500,
                                          color: VerificationCodeScreen.darkBrown,
                                        ),
                                      ),
                                    ],
                                  ),
                                  IconButton(
                                    onPressed: () => Navigator.of(context).pop(),
                                    icon: const Icon(
                                      Icons.close,
                                      color: VerificationCodeScreen.darkBrown,
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
                                      color: VerificationCodeScreen.darkBrown,
                                    ),
                                  ),
                                  const SizedBox(height: 16),
                                  const Text(
                                    'Enter the 4-digit code sent on your email.',
                                    style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.w500,
                                      color: VerificationCodeScreen.darkBrown,
                                    ),
                                  ),
                                  const SizedBox(height: 24),
                                  const Text(
                                    'Code',
                                    style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w500,
                                      color: VerificationCodeScreen.darkBrown,
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  Container(
                                    decoration: BoxDecoration(
                                      color: VerificationCodeScreen.beige,
                                      borderRadius: BorderRadius.circular(8),
                                      border: Border.all(
                                        color: VerificationCodeScreen.darkBrown,
                                        width: 1,
                                      ),
                                    ),
                                    child: TextFormField(
                                      controller: _codeController,
                                      keyboardType: TextInputType.number,
                                      maxLength: 4,
                                      style: const TextStyle(
                                        color: VerificationCodeScreen.darkBrown,
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                        letterSpacing: 2,
                                      ),
                                      textAlign: TextAlign.center,
                                      decoration: const InputDecoration(
                                        hintText: '1234',
                                        hintStyle: TextStyle(
                                          color: VerificationCodeScreen.textcolor,
                                          fontSize: 16,
                                        ),
                                        border: InputBorder.none,
                                        contentPadding: EdgeInsets.all(16),
                                        counterText: '',
                                      ),
                                      validator: (value) {
                                        if (value == null || value.isEmpty) {
                                          return 'Please enter the code';
                                        }
                                        if (value.length != 4) {
                                          return 'Code must be 4 digits';
                                        }
                                        if (!RegExp(r'^\d{4}$').hasMatch(value)) {
                                          return 'Code must contain only numbers';
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
                                            color: VerificationCodeScreen.buttonshadow,
                                            offset: const Offset(6, 4.5),
                                          ),
                                        ],
                                      ),
                                      child: ElevatedButton(
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor: VerificationCodeScreen.buttoncolor,
                                          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(30),
                                          ),
                                          elevation: 0,
                                        ),
                                        onPressed: _isLoading ? null : _verifyCode,
                                        child: _isLoading
                                            ? const CircularProgressIndicator(
                                                color: VerificationCodeScreen.primaryBackground,
                                              )
                                            : const Text(
                                                'Verify Code',
                                                style: TextStyle(
                                                  color: Color(0xFFDF965A),
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 18,
                                                ),
                                              ),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(height: 16),
                                  TextButton(
                                    onPressed: () {
                                      Navigator.of(context).pop();
                                    },
                                    child: const Text(
                                      'Didn\'t receive code? Request new one',
                                      style: TextStyle(
                                        color: VerificationCodeScreen.textcolor,
                                        fontSize: 16,
                                        decoration: TextDecoration.underline,
                                        decorationColor: VerificationCodeScreen.textcolor,
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
