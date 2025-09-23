import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class HomePage extends StatelessWidget {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final CollectionReference users = FirebaseFirestore.instance.collection('users');

  @override
  Widget build(BuildContext context) {
    final user = _auth.currentUser;
    final userEmail = user?.email ?? 'Unknown user';
    
    return Scaffold(
      appBar: AppBar(
        title: const Text('MedHive Home'),
        backgroundColor: const Color(0xFF50341E),
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () async {
              await _auth.signOut();
              if (context.mounted) {
                Navigator.of(context).pop();
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Signed out')),
                );
              }
            },
          )
        ],
      ),
      backgroundColor: const Color(0xFF50341E),
      body: user != null 
        ? StreamBuilder<DocumentSnapshot>(
            stream: users.doc(user.uid).snapshots(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(
                  child: CircularProgressIndicator(color: Colors.white),
                );
              }
              
              if (snapshot.hasError) {
                return Center(
                  child: Text('Error: ${snapshot.error}', style: const TextStyle(color: Colors.white)),
                );
              }
              
              final userData = snapshot.data?.data() as Map<String, dynamic>?;
              final fullName = userData?['fullName'] ?? 'User';
              final userType = userData?['id'] ?? 'N/A';
              final userRole = userData?['userType'] ?? 'user';
              
              return Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      width: 120,
                      height: 120,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: const Color(0xFF9B8B83),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.3),
                            blurRadius: 12,
                            offset: const Offset(0, 6),
                          ),
                        ],
                      ),
                      child: Icon(
                        userRole == 'doctor' ? Icons.medical_services : Icons.person,
                        size: 60,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 24),
                    Text(
                      'Welcome, $fullName!',
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Email: $userEmail',
                      style: const TextStyle(
                        fontSize: 16,
                        color: Color(0xFF9B8B83),
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'ID: $userType',
                      style: const TextStyle(
                        fontSize: 16,
                        color: Color(0xFF9B8B83),
                      ),
                    ),
                    const SizedBox(height: 4),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      decoration: BoxDecoration(
                        color: userRole == 'doctor' ? Colors.blue : Colors.green,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        userRole == 'doctor' ? 'Doctor' : 'Patient',
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    const SizedBox(height: 32),
                    ElevatedButton(
                      onPressed: () async {
                        await users.add({
                          'email': userEmail,
                          'createdAt': FieldValue.serverTimestamp(),
                        });
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('User added to Firestore')),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF9B8B83),
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(28),
                        ),
                      ),
                      child: const Text("Test Firestore"),
                    ),
                  ],
                ),
              );
            },
          )
        : Center(
            child: Text('No user data', style: const TextStyle(color: Colors.white)),
          ),
    );
  }
}



