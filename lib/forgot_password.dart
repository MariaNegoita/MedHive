import 'package:flutter/material.dart';

class ForgotPasswordPage extends StatefulWidget {
  const ForgotPasswordPage({super.key});

  static const Color beige = Color.fromRGBO(222, 203, 183, 100);
  static const Color darkBrown = Color.fromRGBO(80, 52, 30, 100);

  @override
  State<ForgotPasswordPage> createState() => _ForgotPasswordPageState();
}

class _ForgotPasswordPageState extends State<ForgotPasswordPage> {

  @override
  Widget build(BuildContext context) {
    
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: SafeArea(
        child: Stack(
          children: [
            // Page content
            Column(
              children: [
                // Change email form
                Expanded(
                  child: Align(
                    alignment: Alignment.center,
                    child: SingleChildScrollView(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Container(
                        height: 450,
                        width: double.infinity,
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          color:Color.fromRGBO(222, 203, 183, 100),
                          borderRadius: BorderRadius.circular(20),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.18),
                              blurRadius: 18,
                              offset: const Offset(0, 8),
                            ),
                          ],
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Icon(Icons.person, color: Color.fromRGBO(80, 52, 30, 100), size: 28),
                                const SizedBox(width: 8),
                                const Text(
                                  'Account',
                                  style: TextStyle(
                                    color: Color.fromRGBO(80, 52, 30, 100),
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const Spacer(),
                                GestureDetector(
                                  onTap: () => Navigator.of(context).maybePop(),
                                  child: Icon(Icons.close, color: Color.fromRGBO(80, 52, 30, 100), size: 22),
                                ),
                              ],
                            ),

                            const Divider(color: Color.fromRGBO(80, 52, 30, 100)),
                            
                            const SizedBox(height: 12),

                            const Text(
                              'Forgot password',
                              style: TextStyle(
                                fontSize: 26,
                                fontWeight: FontWeight.bold,
                                color: Color.fromRGBO(80, 52, 30, 100),
                              ),
                            ),
                            const SizedBox(height: 10),
                            const Text(
                              'You will recieve an email containing the code for changing the password',
                              style: TextStyle(
                                fontSize: 26,
                                fontWeight: FontWeight.bold,
                                color: Color.fromRGBO(80, 52, 30, 100),
                              ),
                            ),

                            const SizedBox(height: 18),

                            const Text(
                              'Email Address',
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                                color: Color.fromRGBO(80, 52, 30, 100),
                              ),
                            ),

                            const SizedBox(height: 12),

                            TextField(
                              decoration: InputDecoration(
                                hintText: 'you@example.com',
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                contentPadding: const EdgeInsets.symmetric(
                                    horizontal: 14, vertical: 12),
                              ),
                            ),

                            const SizedBox(height: 18),

                            SizedBox(
                              width: double.infinity,
                              child: ElevatedButton(
                                onPressed: () {},
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Color.fromRGBO(80, 52, 30, 100),
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 16),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(14),
                                  ),
                                  elevation: 6,
                                ),
                                child: const Text(
                                  'Send email',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: Color.fromRGBO(222, 203, 183, 100),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
