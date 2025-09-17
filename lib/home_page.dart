import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class HomePage extends StatelessWidget {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final CollectionReference users = FirebaseFirestore.instance.collection('users');

  @override
  Widget build(BuildContext context) {
    final userEmail = _auth.currentUser?.email ?? 'Unknown user';
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home'),
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
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.verified_user, size: 64),
            const SizedBox(height: 16),
            Text('Welcome, $userEmail'),
            const SizedBox(height: 24),
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
              child: const Text("Add User to Firestore"),
            ),
          ],
        ),
      ),
    );
  }
}



