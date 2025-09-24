import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:ui'; // Import necesar pentru ImageFilter

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
  List<Patient> allPatients = []; // Toate pacienții din Firebase
  List<Patient> patients = []; // Pacienții filtrați pentru afișare
  bool isLoading = true;
  int selectedTab = 0; // 0 = Home, 1 = Plus, 2 = Menu

  @override
  void initState() {
    super.initState();
    _loadPatients();
  }

  void _filterPatients() {
    if (searchText.isEmpty) {
      patients = List.from(allPatients);
    } else {
      patients = allPatients.where((patient) {
        final searchLower = searchText.toLowerCase();
        return patient.name.toLowerCase().contains(searchLower) ||
               patient.room.toLowerCase().contains(searchLower) ||
               patient.age.toLowerCase().contains(searchLower) ||
               patient.problem.toLowerCase().contains(searchLower);
      }).toList();
    }
    print('🔍 Filtered ${patients.length} patients for search: "$searchText"');
  }

  void _loadPatients() async {
    try {
      print('🔄 Loading patients...');
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) {
        print('❌ No user logged in');
        setState(() {
          isLoading = false;
        });
        return;
      }
      
      print('👤 User ID: ${user.uid}');

      final querySnapshot = await FirebaseFirestore.instance
          .collection('patients')
          .where('doctorId', isEqualTo: user.uid)
          .get();

      print('📊 Found ${querySnapshot.docs.length} patients');

      setState(() {
        allPatients = querySnapshot.docs.map((doc) {
          final data = doc.data();
          print('📋 Patient data: $data');
          return Patient(
            name: '${data['firstName'] ?? ''} ${data['lastName'] ?? ''}'.trim(),
            room: data['room'] ?? '',
            age: data['age']?.toString() ?? '',
            problem: data['symptoms'] ?? '',
          );
        }).toList();
        
        // Filtrează pacienții în funcție de searchText
        _filterPatients();
        isLoading = false;
      });
      
      print('✅ Loaded ${patients.length} patients');
    } catch (e) {
      print('❌ Error loading patients: $e');
      setState(() {
        isLoading = false;
      });
    }
  }

  void _showPatientForm(BuildContext context) {
    showDialog(
      context: context,
      barrierColor: Colors.black12.withOpacity(0.5),
      builder: (BuildContext context) {
        return Dialog(
          backgroundColor: Colors.transparent,
          insetPadding: const EdgeInsets.all(20),
          child: PatientFormDialog(
            onPatientAdded: () {
              _loadPatients();
              setState(() {
                selectedTab = 0; // Reset to Home when form closes
              });
            },
          ),
        );
      },
    );
  }

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
                                  _filterPatients();
                                });
                              },
                              style: const TextStyle(fontSize: 17, color: Colors.white),
                              decoration: const InputDecoration(
                                hintText: "Search patients...",
                                hintStyle: TextStyle(fontSize: 17, color: Color(0xFFD2B48C)),
                                border: InputBorder.none,
                                contentPadding: EdgeInsets.zero,
                                isDense: true,
                              ),
                            ),
                          ),
                          const SizedBox(width: 12),
                          GestureDetector(
                            onTap: () {
                              // Reîncarcă din Firebase și filtrează din nou
                              _loadPatients();
                            },
                            child: const Icon(
                              Icons.search,
                              color: Color(0xFFD2B48C),
                              size: 24,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: 40),


                  const SizedBox(height: 20),

                  // Patient Cards
                  Expanded(
                    child: isLoading
                        ? const Center(
                            child: CircularProgressIndicator(
                              color: Colors.white,
                            ),
                          )
                        : patients.isEmpty
                            ? const Center(
                                child: Text(
                                  'No patients found.\nTap the + button to add a patient.',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 16,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              )
                            : ListView.builder(
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
                        GestureDetector(
                          behavior: HitTestBehavior.opaque,
                          onTap: () {
                            setState(() {
                              selectedTab = 0;
                            });
                            print('Home button tapped!');
                          },
                          child: Container(
                            width: 24,
                            height: 24,
                            decoration: selectedTab == 0 
                                ? BoxDecoration(
                                    color: const Color(0xFFD2B48C).withOpacity(0.3),
                                    borderRadius: BorderRadius.circular(4),
                                  )
                                : null,
                            child: CustomPaint(
                              painter: HomeIconPainter(),
                            ),
                          ),
                        ),
                        
                        // Plus button
                        GestureDetector(
                          behavior: HitTestBehavior.opaque,
                          onTap: () {
                            setState(() {
                              selectedTab = 1;
                            });
                            print('Plus button tapped!');
                            _showPatientForm(context);
                          },
                          child: Container(
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
                        ),
                        
                        // Menu icon
                        GestureDetector(
                          behavior: HitTestBehavior.opaque,
                          onTap: () {
                            setState(() {
                              selectedTab = 2;
                            });
                            print('Menu button tapped!');
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('Menu button pressed'),
                                backgroundColor: Color(0xFF4B2A17),
                                duration: Duration(seconds: 2),
                              ),
                            );
                          },
                          child: Container(
                            width: 24,
                            height: 24,
                            child: CustomPaint(
                              painter: MenuIconPainter(),
                            ),
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
  final Color color;
  
  HomeIconPainter({this.color = Colors.white});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
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

class PatientFormDialog extends StatefulWidget {
  final VoidCallback? onPatientAdded;
  
  const PatientFormDialog({Key? key, this.onPatientAdded}) : super(key: key);

  @override
  State<PatientFormDialog> createState() => _PatientFormDialogState();
}

class _PatientFormDialogState extends State<PatientFormDialog> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _ageController = TextEditingController();
  final TextEditingController _roomController = TextEditingController();
  final TextEditingController _symptomsController = TextEditingController();

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _ageController.dispose();
    _roomController.dispose();
    _symptomsController.dispose();
    super.dispose();
  }

  void _submitForm() async {
    if (_formKey.currentState!.validate()) {
      try {
        print('💾 Saving patient...');
        // Get current user
        final user = FirebaseAuth.instance.currentUser;
        if (user == null) {
          print('❌ No user logged in');
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('You must be logged in to add patients'),
              backgroundColor: Colors.red,
            ),
          );
          return;
        }

        print('👤 Doctor ID: ${user.uid}');
        print('📝 Patient data: ${_firstNameController.text}, ${_lastNameController.text}');

        // Save patient to Firestore
        final docRef = await FirebaseFirestore.instance.collection('patients').add({
          'firstName': _firstNameController.text.trim(),
          'lastName': _lastNameController.text.trim(),
          'age': int.parse(_ageController.text.trim()),
          'room': _roomController.text.trim(),
          'symptoms': _symptomsController.text.trim(),
          'doctorId': user.uid,
          'createdAt': FieldValue.serverTimestamp(),
        });

        print('✅ Patient saved with ID: ${docRef.id}');

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Patient added successfully!'),
            backgroundColor: Colors.green,
          ),
        );

        // Clear form
        _firstNameController.clear();
        _lastNameController.clear();
        _ageController.clear();
        _roomController.clear();
        _symptomsController.clear();

        Navigator.of(context).pop();
        
        // Reload patients list and reset to Home
        if (widget.onPatientAdded != null) {
          widget.onPatientAdded!();
        }
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error adding patient: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return BackdropFilter(
      filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
      child: Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: Color(0xFFDECBB7),
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.2),
              blurRadius: 20,
              offset: const Offset(0, 10),
            ),
          ],
        ),
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const Text(
                  'Add patient:',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 20),
                _buildTextField(
                  controller: _firstNameController,
                  label: 'First name',
                  icon: Icons.person,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter first name';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                _buildTextField(
                  controller: _lastNameController,
                  label: 'Last name',
                  icon: Icons.person_outline,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter last name';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                _buildTextField(
                  controller: _ageController,
                  label: 'Age',
                  icon: Icons.calendar_today,
                  keyboardType: TextInputType.number,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter age';
                    }
                    if (int.tryParse(value) == null) {
                      return 'Please enter a valid number';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                _buildTextField(
                  controller: _roomController,
                  label: 'Room',
                  icon: Icons.meeting_room,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter room number';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                _buildTextField(
                  controller: _symptomsController,
                  label: 'Symptoms',
                  icon: Icons.healing,
                  maxLines: 3,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please describe symptoms';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 24),
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                          // Reset to Home when canceling
                          if (widget.onPatientAdded != null) {
                            widget.onPatientAdded!();
                          }
                        },
                        style: OutlinedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          side: const BorderSide(color: Colors.black),
                        ),
                        child: const Text(
                          'Cancel',
                          style: TextStyle(color: Colors.black),
                        ),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: _submitForm,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.black,
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        child: const Text(
                          'Submit',
                          style: TextStyle(fontSize: 16, color: Color(0xFFDECBB7)),
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
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    TextInputType keyboardType = TextInputType.text,
    int maxLines = 1,
    required String? Function(String?) validator,
  }) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      maxLines: maxLines,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon, color: Colors.black),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: Colors.black),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: Colors.black, width: 2),
        ),
        filled: true,
        fillColor: Color(0xFFDECBB7),
      ),
      validator: validator,
    );
  }
}