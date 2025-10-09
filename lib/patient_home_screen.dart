import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class PatientHomeScreen extends StatefulWidget {
  const PatientHomeScreen({super.key});

  @override
  _PatientHomeScreenState createState() => _PatientHomeScreenState();
}

class _PatientHomeScreenState extends State<PatientHomeScreen> {
  int selectedTab = 0; // 0 = Home, 1 = Chat, 2 = Menu

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFF50341E), 
              Color(0xFFDBC1A6), 
              Color(0xFFDECBB7), 
            ],
            stops: [0.0, 0.7, 1.0],
          ),
        ),
        child: Column(
          children: [
            // Top bar
            SafeArea(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Image.asset(
                      'assets/images/logo.png',
                      width: 140,
                      height: 40,
                      fit: BoxFit.contain,
                      errorBuilder: (context, error, stackTrace) {
                        return const Text(
                          "MedHive",
                          style: TextStyle(
                            color: Colors.orange,
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        );
                      },
                    ),
                    GestureDetector(
                      onTap: () async {
                        await FirebaseAuth.instance.signOut();
                        if (mounted) {
                          Navigator.of(context).pushReplacementNamed('/login');
                        }
                      },
                      child: const Icon(
                        Icons.exit_to_app,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
            ), 

            // Main content area
            Expanded(
              child: Center(
                child: Container(
                  margin: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: const Color(0xFFDECBB7),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: const Color(0xFF50341E),
                      width: 2,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.2),
                        blurRadius: 6,
                        offset: const Offset(0, 3),
                      ),
                    ],
                  ),
                  child: Stack(
                    children: const [
                      Center(
                        child: Text(
                          'Work in Progress',
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF50341E),
                          ),
                        ),
                      ),
                      Positioned(
                        top: 8,
                        right: 8,
                        child: Icon(Icons.fullscreen, color: Colors.black54),
                      ),
                    ],
                  ),
                ),
              ),
            ),

            // Bottom navigation bar 
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              decoration: BoxDecoration(
                color: Colors.black,
                borderRadius: BorderRadius.circular(32),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.3),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  GestureDetector(
                    onTap: () => setState(() => selectedTab = 0),
                    child: Icon(
                      Icons.home, 
                      color: selectedTab == 0 ? Colors.orange : Colors.white,
                    ),
                  ),
                  GestureDetector(
                    onTap: () => setState(() => selectedTab = 1),
                    child: Icon(
                      Icons.chat_bubble_outline, 
                      color: selectedTab == 1 ? Colors.orange : Colors.white,
                    ),
                  ),
                  GestureDetector(
                    onTap: () => setState(() => selectedTab = 2),
                    child: Icon(
                      Icons.menu, 
                      color: selectedTab == 2 ? Colors.orange : Colors.white,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
