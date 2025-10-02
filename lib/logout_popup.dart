import 'package:flutter/material.dart';

class LogOutPage extends StatefulWidget {
  const LogOutPage({super.key});

  static const Color darkbrown = Color.fromRGBO(92, 63, 40, 100);
  static const Color deleteaccounttext = Color.fromRGBO(255, 255, 255, 65);
  static const Color textandbutton = Color.fromRGBO(255, 255, 255, 84);

  @override
  State<LogOutPage> createState() => _LogOutPageState();
}

class _LogOutPageState extends State<LogOutPage>{
  
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
                  color: LogOutPage.darkbrown,
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
                        Icon(Icons.exit_to_app, color: LogOutPage.deleteaccounttext, size: 26),
                        const SizedBox(width: 5),
                        const Text(
                          'Log out',
                          style: TextStyle(
                            color: LogOutPage.deleteaccounttext,
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    
                    const SizedBox(height: 10),
                    Row(
                      children: [
                        const SizedBox(width: 87),
                        const Text(
                          'Are you sure?',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: LogOutPage.deleteaccounttext,
                            fontSize: 23,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 15),

                    Row(
                      children: [
                        SizedBox(
                          width: 140,
                          child: ElevatedButton(
                            onPressed: () {},
                            style: ElevatedButton.styleFrom(
                              side: BorderSide(
                                color: LogOutPage.textandbutton,
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
                              'Yes',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: LogOutPage.textandbutton,
                              ),
                            ),
                          ),
                        ),
                        
                        const Spacer(),

                        SizedBox(
                          width: 140,
                          child: ElevatedButton(
                            onPressed: () {},
                            style: ElevatedButton.styleFrom(
                              side: BorderSide(
                                color: LogOutPage.textandbutton,
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
                              'No',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: LogOutPage.textandbutton,
                              ),
                            ),
                          ),
                        ),
                      ],
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
