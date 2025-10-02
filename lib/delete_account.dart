import 'package:flutter/material.dart';

class DeleteAccountPage extends StatefulWidget {
  const DeleteAccountPage({super.key});

  static const Color darkbrown = Color.fromRGBO(92, 63, 40, 100);
  static const Color deleteaccounttext = Color.fromRGBO(255, 255, 255, 65);
  static const Color textandbutton = Color.fromRGBO(255, 255, 255, 84);

  @override
  State<DeleteAccountPage> createState() => _DeleteAccountPageState();
}

class _DeleteAccountPageState extends State<DeleteAccountPage>{
  
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
                  color: DeleteAccountPage.darkbrown,
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
                        Icon(Icons.person_off, color: DeleteAccountPage.deleteaccounttext, size: 26),
                        const SizedBox(width: 5),
                        const Text(
                          'Delete account',
                          style: TextStyle(
                            color: DeleteAccountPage.deleteaccounttext,
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
                            color: DeleteAccountPage.deleteaccounttext,
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
                                color: DeleteAccountPage.textandbutton,
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
                                color: DeleteAccountPage.textandbutton,
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
                                color: DeleteAccountPage.textandbutton,
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
                                color: DeleteAccountPage.textandbutton,
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
