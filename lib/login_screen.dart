import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  // Brand colors
  static const Color primaryBackground = Color.fromRGBO(80, 52, 30, 1);
  static const Color buttoncolor = Color.fromRGBO(131, 113, 99, 1);
  static const Color buttonshadow = Color.fromRGBO(99, 84, 72, 1);
  static const Color textcolor = Color.fromRGBO(194, 184, 176, 1);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  bool _isLoading = false;

  Future<void> _login() async {
    setState(() => _isLoading = true);
    try {
      final userCredential = await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: _emailController.text.trim(),
        password: _passwordController.text.trim(),
      );

      // If successful → navigate or show success
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Login successful!")),
      );
      print("User logged in: ${userCredential.user?.email}");
    } on FirebaseAuthException catch (e) {
      // Error handling
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.message ?? "Login failed")),
      );
    } finally {
      setState(() => _isLoading = false);
    }
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: SizedBox(
            width: 700,
            child: Column(
              children: [
                const Spacer(flex: 2),
                Image.asset('logo.png', width: 357, height: 186),
                const Spacer(flex: 1),
                Expanded(
                  flex: 6,
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.symmetric(horizontal: 30),
                    child: Column(
                      children: [
                        _buildInputField('Email Address', controller: _emailController),
                        const SizedBox(height: 20),
                        _buildInputField('Password', controller: _passwordController, obscureText: true),
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
                        Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(30),
                            boxShadow: [
                              BoxShadow(color: LoginScreen.buttonshadow, offset: Offset(0, 4)),
                            ],
                          ),
                          child: SizedBox(
                            width: 500,
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: LoginScreen.buttoncolor,
                                padding: const EdgeInsets.symmetric(vertical: 16),
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                                elevation: 0,
                              ),
                              onPressed: _isLoading ? null : _login,
                              child: _isLoading
                                  ? const CircularProgressIndicator(color: LoginScreen.primaryBackground)
                                  : const Text(
                                      'LOG IN',
                                      style: TextStyle(
                                        color: LoginScreen.primaryBackground,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16,
                                      ),
                                    ),
                            ),
                          ),
                        ),
                      ],
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

  Widget _buildInputField(String hint, {required TextEditingController controller, bool obscureText = false}) {
    return Container(
      width: 700,
      decoration: BoxDecoration(
        color: LoginScreen.buttoncolor,
        boxShadow: [BoxShadow(color: LoginScreen.buttonshadow, offset: Offset(0, 4))],
        borderRadius: BorderRadius.circular(30),
      ),
      child: TextField(
        controller: controller,
        obscureText: obscureText,
        style: const TextStyle(color: LoginScreen.textcolor),
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: const TextStyle(color: LoginScreen.textcolor),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        ),
      ),
    );
  }
}
