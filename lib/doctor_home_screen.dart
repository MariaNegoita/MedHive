import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Patient {
  final String name;
  final String room;
  final String age;
  final String problem;

  Patient({
    this.name = "",
    this.room = "",
    this.age = "",
    this.problem = "",
  });

  Patient copyWith({
    String? name,
    String? room,
    String? age,
    String? problem,
  }) {
    return Patient(
      name: name ?? this.name,
      room: room ?? this.room,
      age: age ?? this.age,
      problem: problem ?? this.problem,
    );
  }
}

class DoctorHomeScreen extends StatefulWidget {
  const DoctorHomeScreen({super.key});

  @override
  _DoctorHomeScreenState createState() => _DoctorHomeScreenState();
}

class _DoctorHomeScreenState extends State<DoctorHomeScreen> {
  String searchText = "";
  List<Patient> patients = [
    Patient(),
    Patient(),
    Patient(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFF4A3728),
              Color(0xFF6B4423),
              Color(0xFF8B7355),
              Color(0xFFA0856B),
              Color(0xFFB8956F),
              Color(0xFFD2B48C),
            ],
          ),
        ),
        child: SafeArea(
          child: Stack(
            children: [
              Column(
                children: [
                  // App Icon
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.only(top: 60, bottom: 30),
                    child: Center(
                      child: Container(
                        width: 140,
                        height: 140,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(32),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.3),
                              blurRadius: 8,
                              offset: const Offset(0, 4),
                            ),
                          ],
                          border: Border.all(color: Colors.white.withOpacity(0.05), width: 1),
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(32),
                          child: Image.asset(
                            'assets/images/logo2.png',
                            width: 140,
                            height: 140,
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                    ),
                  ),

                  // Search Bar
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(horizontal: 30),
                    child: Container(
                      height: 60,
                      decoration: BoxDecoration(
                        color: Colors.black.withOpacity(0.45),
                        borderRadius: BorderRadius.circular(15),
                        border: Border.all(color: Colors.white.withOpacity(0.1), width: 1),
                      ),
                      padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 18),
                      child: Row(
                        children: [
                          Expanded(
                            child: TextField(
                              onChanged: (value) {
                                setState(() {
                                  searchText = value;
                                });
                              },
                              style: const TextStyle(fontSize: 17, color: Colors.white),
                              decoration: const InputDecoration(
                                hintText: "Search patients...",
                                hintStyle: TextStyle(fontSize: 17, color: Color(0xFFD2B48C)),
                                border: InputBorder.none,
                              ),
                            ),
                          ),
                          const SizedBox(width: 8),
                          Container(
                            width: 22,
                            height: 22,
                            decoration: const BoxDecoration(
                              color: Color(0xFFD2B48C),
                              shape: BoxShape.circle,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: 40),

                  // Patient Cards
                  Expanded(
                    child: ListView.builder(
                      padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 20),
                      itemCount: patients.length,
                      itemBuilder: (context, index) {
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 20),
                          child: PatientCard(
                            patient: patients[index],
                            onPatientChange: (updatedPatient) {
                              setState(() {
                                patients[index] = updatedPatient;
                              });
                            },
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),

              // Bottom Navigation
              Positioned(
                bottom: 15,
                left: 0,
                right: 0,
                child: Center(
                  child: Container(
                    width: MediaQuery.of(context).size.width * 0.85,
                    height: 60,
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [Colors.black, Color(0xFF1A1A1A), Colors.black],
                      ),
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.3),
                          blurRadius: 8,
                          offset: const Offset(0, 4),
                        ),
                      ],
                      border: Border.all(color: Colors.white.withOpacity(0.1), width: 1),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        // Home icon
                        Container(
                          width: 24,
                          height: 24,
                          child: CustomPaint(
                            painter: HomeIconPainter(),
                          ),
                        ),
                        
                        // Plus button
                        Container(
                          width: 36,
                          height: 36,
                          decoration: const BoxDecoration(
                            color: Colors.white,
                            shape: BoxShape.circle,
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black26,
                                blurRadius: 2,
                                offset: Offset(0, 1),
                              ),
                            ],
                          ),
                          child: CustomPaint(
                            painter: PlusIconPainter(),
                          ),
                        ),
                        
                        // Menu icon
                        Container(
                          width: 24,
                          height: 24,
                          child: CustomPaint(
                            painter: MenuIconPainter(),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class PatientCard extends StatelessWidget {
  final Patient patient;
  final Function(Patient) onPatientChange;

  const PatientCard({
    super.key,
    required this.patient,
    required this.onPatientChange,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.92),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
        border: Border.all(color: Colors.white.withOpacity(0.3), width: 1),
      ),
      padding: const EdgeInsets.all(25),
      child: Row(
        children: [
          Expanded(
            child: Column(
              children: [
                PatientField(
                  label: "Name:",
                  value: patient.name,
                  onChanged: (value) => onPatientChange(patient.copyWith(name: value)),
                ),
                const SizedBox(height: 12),
                PatientField(
                  label: "Room:",
                  value: patient.room,
                  onChanged: (value) => onPatientChange(patient.copyWith(room: value)),
                ),
                const SizedBox(height: 12),
                PatientField(
                  label: "Age:",
                  value: patient.age,
                  onChanged: (value) => onPatientChange(patient.copyWith(age: value)),
                ),
                const SizedBox(height: 12),
                PatientField(
                  label: "Problem:",
                  value: patient.problem,
                  onChanged: (value) => onPatientChange(patient.copyWith(problem: value)),
                ),
              ],
            ),
          ),
          const SizedBox(width: 20),
          Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFFF0F0F0), Color(0xFFD8D8D8), Color(0xFFC8C8C8)],
              ),
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 3,
                  offset: const Offset(0, 2),
                ),
              ],
              border: Border.all(color: Colors.black.withOpacity(0.05), width: 1),
            ),
          ),
        ],
      ),
    );
  }
}

class PatientField extends StatelessWidget {
  final String label;
  final String value;
  final Function(String) onChanged;

  const PatientField({
    super.key,
    required this.label,
    required this.value,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        SizedBox(
          width: 75,
          child: Text(
            label,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: Color(0xFF1A1A1A),
            ),
          ),
        ),
        Expanded(
          child: TextField(
            onChanged: onChanged,
            style: const TextStyle(fontSize: 16, color: Color(0xFF2C2C2C)),
            decoration: const InputDecoration(
              border: InputBorder.none,
              contentPadding: EdgeInsets.zero,
            ),
            controller: TextEditingController(text: value)
              ..selection = TextSelection.collapsed(offset: value.length),
          ),
        ),
      ],
    );
  }
}

class HomeIconPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.5;

    final path = Path();
    path.moveTo(4, 10);
    path.lineTo(12, 3);
    path.lineTo(20, 10);
    path.lineTo(20, 19);
    path.lineTo(16, 19);
    path.lineTo(16, 13);
    path.lineTo(8, 13);
    path.lineTo(8, 19);
    path.lineTo(4, 19);
    path.close();

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class PlusIconPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.black
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.5;

    // Vertical line
    canvas.drawLine(
      const Offset(18, 8),
      const Offset(18, 28),
      paint,
    );

    // Horizontal line
    canvas.drawLine(
      const Offset(8, 18),
      const Offset(28, 18),
      paint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class MenuIconPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.5;

    // Three horizontal lines
    canvas.drawLine(const Offset(4, 6), const Offset(20, 6), paint);
    canvas.drawLine(const Offset(4, 12), const Offset(20, 12), paint);
    canvas.drawLine(const Offset(4, 18), const Offset(20, 18), paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}