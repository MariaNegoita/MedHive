import 'package:flutter/material.dart';

class EmailConfirmationPage extends StatefulWidget {
  const EmailConfirmationPage({super.key});

  static const Color darkbrown = Color.fromRGBO(92, 63, 40, 100);
  static const Color text = Color.fromRGBO(255, 255, 255, 65);
  static const Color button = Color.fromRGBO(255, 255, 255, 100);

  @override
  State<EmailConfirmationPage> createState() => _EmailConfirmationPageState();
}

class _EmailConfirmationPageState extends State<EmailConfirmationPage>{
  
  @override

  Widget build(BuildContext context){
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: SafeArea(
        child: Center(
          child: SizedBox(
            width: 350,
            height: 200,
            child: Align(
              alignment: Alignment.center,
                child: Container(
                  height: 200,
                  width: 350,
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                  color: EmailConfirmationPage.darkbrown,
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

                    const SizedBox(height: 30),

                    Row(
                      children: [

                        const SizedBox(width: 30),

                        const Text(
                          'Email Confirmation Sent!',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: EmailConfirmationPage.text,
                            fontSize: 20,
                            fontWeight: FontWeight.normal,
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 20),

                    Center(
                      child: SizedBox(
                        width: 140,
                        child: ElevatedButton(
                          onPressed: () {},
                          style: ElevatedButton.styleFrom(
                            side: BorderSide(
                              color: EmailConfirmationPage.button,
                              width: 0.25,
                            ),
                            backgroundColor: Colors.transparent,
                            padding:
                              const EdgeInsets.symmetric(vertical: 16),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(14),
                            ),
                            elevation: 6,
                          ),
                          child: const Text(
                          'NEXT',
                            style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: EmailConfirmationPage.text,
                            ),
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
      ),
    );
  }
}
