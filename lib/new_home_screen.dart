import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class NewHomeScreen extends StatefulWidget {
  const NewHomeScreen({super.key});

  @override
  _NewHomeScreenState createState() => _NewHomeScreenState();
}

class _NewHomeScreenState extends State<NewHomeScreen> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final CollectionReference users = FirebaseFirestore.instance.collection('users');

  @override
  Widget build(BuildContext context) {
    final user = _auth.currentUser;
    
    return Scaffold(
      backgroundColor: const Color(0xFF50341E),
      body: SafeArea(
        child: user != null 
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
                    child: Text('Error: ${snapshot.error}', 
                      style: const TextStyle(color: Colors.white)),
                  );
                }
                
                final userData = snapshot.data?.data() as Map<String, dynamic>?;
                final fullName = userData?['fullName'] ?? 'User';
                final userType = userData?['id'] ?? 'N/A';
                final userRole = userData?['userType'] ?? 'user';
                
                return SingleChildScrollView(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Header with logo and user info
                      Row(
                        children: [
                          Image.asset(
                            'assets/images/logo.png',
                            width: 80,
                            height: 40,
                          ),
                          const Spacer(),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                            decoration: BoxDecoration(
                              color: userRole == 'doctor' ? Colors.blue : Colors.green,
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Text(
                              userRole == 'doctor' ? 'Doctor' : 'Patient',
                              style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 12,
                              ),
                            ),
                          ),
                          const SizedBox(width: 8),
                          IconButton(
                            icon: const Icon(Icons.logout, color: Colors.white),
                            onPressed: () async {
                              await _auth.signOut();
                              if (context.mounted) {
                                Navigator.of(context).pop();
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text('Signed out successfully'),
                                    backgroundColor: Color(0xFF4B2A17),
                                  ),
                                );
                              }
                            },
                          ),
                        ],
                      ),
                      
                      const SizedBox(height: 30),
                      
                      // Welcome section
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(24),
                        decoration: BoxDecoration(
                          color: const Color(0xFF837163),
                          borderRadius: BorderRadius.circular(20),
                          boxShadow: [
                            BoxShadow(
                              color: const Color(0xFF635448),
                              offset: const Offset(6, 4.5),
                            ),
                          ],
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Container(
                                  width: 60,
                                  height: 60,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: userRole == 'doctor' ? Colors.blue : Colors.green,
                                  ),
                                  child: Icon(
                                    userRole == 'doctor' ? Icons.medical_services : Icons.person,
                                    size: 30,
                                    color: Colors.white,
                                  ),
                                ),
                                const SizedBox(width: 16),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'Welcome back,',
                                        style: const TextStyle(
                                          color: Color(0xFFC2B8B0),
                                          fontSize: 16,
                                        ),
                                      ),
                                      Text(
                                        fullName,
                                        style: const TextStyle(
                                          color: Colors.white,
                                          fontSize: 24,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 16),
                            Text(
                              'Email: $userType',
                              style: const TextStyle(
                                color: Color(0xFFC2B8B0),
                                fontSize: 14,
                              ),
                            ),
                          ],
                        ),
                      ),
                      
                      const SizedBox(height: 30),
                      
                      // Quick actions section
                      Text(
                        'Quick Actions',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      
                      const SizedBox(height: 16),
                      
                      // Action buttons
                      if (userRole == 'doctor') ...[
                        _buildActionCard(
                          icon: Icons.people,
                          title: 'My Patients',
                          subtitle: 'View and manage your patients',
                          color: Colors.blue,
                          onTap: () {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('My Patients feature coming soon!'),
                                backgroundColor: Color(0xFF4B2A17),
                              ),
                            );
                          },
                        ),
                        const SizedBox(height: 16),
                        _buildActionCard(
                          icon: Icons.calendar_today,
                          title: 'Appointments',
                          subtitle: 'Schedule and view appointments',
                          color: Colors.green,
                          onTap: () {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('Appointments feature coming soon!'),
                                backgroundColor: Color(0xFF4B2A17),
                              ),
                            );
                          },
                        ),
                      ] else ...[
                        _buildActionCard(
                          icon: Icons.search,
                          title: 'Find Doctors',
                          subtitle: 'Search for healthcare providers',
                          color: Colors.blue,
                          onTap: () {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('Find Doctors feature coming soon!'),
                                backgroundColor: Color(0xFF4B2A17),
                              ),
                            );
                          },
                        ),
                        const SizedBox(height: 16),
                        _buildActionCard(
                          icon: Icons.medical_information,
                          title: 'My Records',
                          subtitle: 'View your medical history',
                          color: Colors.green,
                          onTap: () {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('My Records feature coming soon!'),
                                backgroundColor: Color(0xFF4B2A17),
                              ),
                            );
                          },
                        ),
                      ],
                      
                      const SizedBox(height: 16),
                      
                      // Common features for both user types
                      _buildActionCard(
                        icon: Icons.settings,
                        title: 'Settings',
                        subtitle: 'Manage your account settings',
                        color: Colors.orange,
                        onTap: () {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Settings feature coming soon!'),
                              backgroundColor: Color(0xFF4B2A17),
                            ),
                          );
                        },
                      ),
                      
                      const SizedBox(height: 16),
                      
                      _buildActionCard(
                        icon: Icons.help,
                        title: 'Help & Support',
                        subtitle: 'Get help and contact support',
                        color: Colors.purple,
                        onTap: () {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Help & Support feature coming soon!'),
                              backgroundColor: Color(0xFF4B2A17),
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                );
              },
            )
          : Center(
              child: Text('No user data', 
                style: const TextStyle(color: Colors.white)),
            ),
      ),
    );
  }

  Widget _buildActionCard({
    required IconData icon,
    required String title,
    required String subtitle,
    required Color color,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: const Color(0xFF837163),
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: const Color(0xFF635448),
              offset: const Offset(4, 3),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              width: 50,
              height: 50,
              decoration: BoxDecoration(
                color: color,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(
                icon,
                color: Colors.white,
                size: 24,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    subtitle,
                    style: const TextStyle(
                      color: Color(0xFFC2B8B0),
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            ),
            const Icon(
              Icons.arrow_forward_ios,
              color: Color(0xFFC2B8B0),
              size: 16,
            ),
          ],
        ),
      ),
    );
  }
}
