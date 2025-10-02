import 'package:flutter/material.dart';

class PasswordChangePopupPage extends StatefulWidget {
  const PasswordChangePopupPage({super.key});

  static const Color darkbrown = Color.fromRGBO(92, 63, 40, 100);
  static const Color text = Color.fromRGBO(255, 255, 255, 65);
  static const Color button = Color.fromRGBO(255, 255, 255, 100);

  @override
  State<PasswordChangePopupPage> createState() => _PasswordChangePopupPageState();
}

class _PasswordChangePopupPageState extends State<PasswordChangePopupPage>{
  
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
                  color: PasswordChangePopupPage.darkbrown,
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

                        const SizedBox(width: 10),

                        const Text(
                          'Password changed successfully!',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: PasswordChangePopupPage.text,
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
                              color: PasswordChangePopupPage.button,
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
                          'CLOSE',
                            style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: PasswordChangePopupPage.text,
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
