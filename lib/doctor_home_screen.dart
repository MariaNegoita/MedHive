import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:ui'; // Import necesar pentru ImageFilter
import 'dart:io'; // Pentru File
import 'dart:typed_data'; // Pentru Uint8List
import 'package:flutter/foundation.dart'; // Pentru kIsWeb
import 'terms_and_conditions_page.dart';
import 'splash_screen_landing_page.dart';

class Patient {
  final String name;
  final String room;
  final String age;
  final String problem;
  final String? photoUrl;
  final String? localPhotoPath;

  Patient({
    this.name = "",
    this.room = "",
    this.age = "",
    this.problem = "",
    this.photoUrl,
    this.localPhotoPath,
  });

  Patient copyWith({
    String? name,
    String? room,
    String? age,
    String? problem,
    String? photoUrl,
    String? localPhotoPath,
  }) {
    return Patient(
      name: name ?? this.name,
      room: room ?? this.room,
      age: age ?? this.age,
      problem: problem ?? this.problem,
      photoUrl: photoUrl ?? this.photoUrl,
      localPhotoPath: localPhotoPath ?? this.localPhotoPath,
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
  final ImagePicker _picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    _loadPatients();
    _testFirebaseStorage();
  }

  void _testFirebaseStorage() async {
    try {
      print('🧪 Testing Firebase Storage connectivity...');
      final user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        // Test simplu - încearcă să creezi o referință
        final testRef = FirebaseStorage.instance
            .ref()
            .child('test')
            .child('test.txt');
        
        // Încearcă să uploadezi un fișier mic de test
        final testData = Uint8List.fromList('test'.codeUnits);
        await testRef.putData(testData).timeout(
          const Duration(seconds: 10),
          onTimeout: () => throw Exception('Storage test timeout'),
        );
        
        print('✅ Firebase Storage is working correctly');
        
        // Șterge fișierul de test
        await testRef.delete();
      }
    } catch (e) {
      print('❌ Firebase Storage test failed: $e');
      if (e.toString().contains('storage/unauthorized')) {
        print('⚠️ Firebase Storage rules may be too restrictive');
      } else if (e.toString().contains('storage/unknown')) {
        print('⚠️ Firebase Storage may not be activated');
      } else {
        print('⚠️ Firebase Storage connectivity issue');
      }
    }
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
    await _loadPatientsSimple();
  }

  void _forceReloadPatients() async {
    await _loadPatientsSimple();
  }
  
  Future<void> _loadPatientsSimple() async {
    try {
      print('🔄 Loading patients (simple query)...');
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) {
        print('❌ No user logged in');
        if (mounted) {
          setState(() {
            isLoading = false;
          });
        }
        return;
      }
      
      print('👤 User ID: ${user.uid}');

      // Query foarte simplu - doar where doctorId
      final querySnapshot = await FirebaseFirestore.instance
          .collection('patients')
          .where('doctorId', isEqualTo: user.uid)
          .get();

      print('📊 Found ${querySnapshot.docs.length} patients');

      if (mounted) {
        setState(() {
          allPatients = querySnapshot.docs.map((doc) {
            final data = doc.data();
            print('📋 Patient data: $data');
            return Patient(
              name: '${data['firstName'] ?? ''} ${data['lastName'] ?? ''}'.trim(),
              room: data['room'] ?? '',
              age: data['age']?.toString() ?? '',
              problem: data['symptoms'] ?? '',
              photoUrl: data['photoUrl'],
            );
          }).toList();
          
          // Filtrează pacienții în funcție de searchText
          _filterPatients();
          isLoading = false;
        });
      }
      
      print('✅ Loaded ${patients.length} patients');
    } catch (e) {
      print('❌ Error loading patients: $e');
      if (mounted) {
        setState(() {
          isLoading = false;
        });
      }
    }
  }

  Future<void> _loadPatientsWithOptions(bool forceRefresh) async {
    try {
      print('🔄 Loading patients... (force refresh: $forceRefresh)');
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
          print('📋 Patient document ID: ${doc.id}');
          print('📋 Patient data: $data');
          print('📋 PhotoUrl from Firestore: ${data['photoUrl']}');
          print('📋 PhotoUrl type: ${data['photoUrl'].runtimeType}');
          
          final patient = Patient(
            name: '${data['firstName'] ?? ''} ${data['lastName'] ?? ''}'.trim(),
            room: data['room'] ?? '',
            age: data['age']?.toString() ?? '',
            problem: data['symptoms'] ?? '',
            photoUrl: data['photoUrl'],
          );
          
          print('📋 Created patient with photoUrl: ${patient.photoUrl}');
          return patient;
        }).toList();
        
        print('📊 Total patients loaded: ${allPatients.length}');
        for (int i = 0; i < allPatients.length; i++) {
          print('📊 Patient $i: ${allPatients[i].name} - Photo: ${allPatients[i].photoUrl}');
        }
        
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
              _forceReloadPatients();
              setState(() {
                selectedTab = 0; // Reset to Home when form closes
              });
            },
          ),
        );
      },
    ).then((_) {
      // Reset to Home when dialog is dismissed (including when tapping outside)
      setState(() {
        selectedTab = 0;
      });
    });
  }

  void _showSettingsDialog(BuildContext context) {
    showDialog(
      context: context,
      barrierColor: Colors.black12.withOpacity(0.5),
      builder: (BuildContext context) {
        return Dialog(
          backgroundColor: Colors.transparent,
          insetPadding: const EdgeInsets.all(20),
          child: SettingsDialog(),
        );
      },
    ).then((_) {
      // Reset to Home when dialog is dismissed (including when tapping outside)
      setState(() {
        selectedTab = 0;
      });
    });
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
                  const SizedBox(height: 20), // Spațiu de sus
                  // App Icon
                  ClipRect(
                    child: Align(
                      alignment: Alignment.center,
                      heightFactor: 0.6, // Taie 40% total (de 2 ori mai mult)
                      child: Container(
                        transform: Matrix4.translationValues(0, -10, 0), // Mută mai mult în sus
                        child: Image.asset(
                          'assets/images/logo.png',
                          width: 400,
                          height: 300,
                          fit: BoxFit.contain,
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
                          Row(
                            children: [
                              GestureDetector(
                                onTap: () {
                                  // Reîncarcă din Firebase și filtrează din nou
                                  print('🔄 Manual refresh triggered');
                                  _forceReloadPatients();
                                },
                                child: const Icon(
                                  Icons.refresh,
                                  color: Color(0xFFD2B48C),
                                  size: 24,
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
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: 15),

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
                        // Home icon
                        GestureDetector(
                          behavior: HitTestBehavior.opaque,
                          onTap: () {
                            setState(() {
                              selectedTab = 0;
                            });
                            print('Home button tapped!');
                          },
                          child: Icon(
                            Icons.home, 
                            color: selectedTab == 0 ? Colors.orange : Colors.white,
                            size: 24,
                          ),
                        ),
                        
                        // Plus button - constant circle
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
                            decoration: BoxDecoration(
                              color: selectedTab == 1 ? Colors.orange : Colors.white,
                              shape: BoxShape.circle,
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black26,
                                  blurRadius: 2,
                                  offset: Offset(0, 1),
                                ),
                              ],
                            ),
                            child: Icon(
                              Icons.add,
                              color: selectedTab == 1 ? Colors.white : Colors.black,
                              size: 24,
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
                            _showSettingsDialog(context);
                          },
                          child: Icon(
                            Icons.menu, 
                            color: selectedTab == 2 ? Colors.orange : Colors.white,
                            size: 24,
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
            child: ClipRRect(
              borderRadius: BorderRadius.circular(16),
              child: Builder(
                builder: (context) {
                  print('🖼️ Rendering image for patient: ${patient.name}');
                  print('🖼️ PhotoUrl: ${patient.photoUrl}');
                  print('🖼️ PhotoUrl is null: ${patient.photoUrl == null}');
                  print('🖼️ PhotoUrl is empty: ${patient.photoUrl?.isEmpty}');
                  
                  if (patient.photoUrl != null && patient.photoUrl!.isNotEmpty) {
                    print('🖼️ Attempting to load image from: ${patient.photoUrl}');
                    print('🖼️ URL length: ${patient.photoUrl!.length}');
                    print('🖼️ URL starts with https: ${patient.photoUrl!.startsWith('https')}');
                    return Image.network(
                      patient.photoUrl!,
                      width: 80,
                      height: 80,
                      fit: BoxFit.cover,
                      loadingBuilder: (context, child, loadingProgress) {
                        if (loadingProgress == null) {
                          print('🖼️ Image loaded successfully');
                          return child;
                        }
                        print('🖼️ Loading image... ${loadingProgress.cumulativeBytesLoaded}/${loadingProgress.expectedTotalBytes}');
                        return Container(
                          decoration: const BoxDecoration(
                            gradient: LinearGradient(
                              colors: [Color(0xFFF0F0F0), Color(0xFFD8D8D8)],
                            ),
                          ),
                          child: const Center(
                            child: CircularProgressIndicator(
                              valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF4B2A17)),
                              strokeWidth: 2,
                            ),
                          ),
                        );
                      },
                      errorBuilder: (context, error, stackTrace) {
                        print('❌ Error loading image from ${patient.photoUrl}: $error');
                        print('❌ Stack trace: $stackTrace');
                        return Container(
                          decoration: const BoxDecoration(
                            gradient: LinearGradient(
                              colors: [Color(0xFFF0F0F0), Color(0xFFD8D8D8), Color(0xFFC8C8C8)],
                            ),
                          ),
                          child: const Center(
                            child: Icon(
                              Icons.broken_image,
                              color: Color(0xFF4B2A17),
                              size: 30,
                            ),
                          ),
                        );
                      },
                    );
                  } else {
                    print('🖼️ No photo URL available, showing default icon');
                    return Container(
                      decoration: const BoxDecoration(
                        gradient: LinearGradient(
                          colors: [Color(0xFFF0F0F0), Color(0xFFD8D8D8), Color(0xFFC8C8C8)],
                        ),
                      ),
                      child: const Center(
                        child: Icon(
                          Icons.person,
                          color: Color(0xFF4B2A17),
                          size: 40,
                        ),
                      ),
                    );
                  }
                },
              ),
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
  final ImagePicker _picker = ImagePicker();
  String? _selectedImagePath;
  String _photoText = "Choose Photo";
  bool _isSubmitting = false;

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
    if (_isSubmitting) return; // Prevent multiple submissions
    
    if (_formKey.currentState!.validate()) {
      if (mounted) {
        setState(() {
          _isSubmitting = true;
        });
      }
      
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
          setState(() {
            _isSubmitting = false;
          });
          return;
        }

        print('👤 Doctor ID: ${user.uid}');
        print('📝 Patient data: ${_firstNameController.text}, ${_lastNameController.text}');

        String? photoUrl;
        
        // Upload photo if selected
        if (_selectedImagePath != null) {
          print('📸 Photo selected but Firebase Storage requires paid plan');
          
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Photo upload requires Firebase Blaze plan - upgrade billing to enable photos'),
                backgroundColor: Colors.blue,
                duration: Duration(seconds: 4),
              ),
            );
          }
          
          // Firebase Storage necesită plan plătit
          print('📸 Photo upload skipped - Storage requires Blaze plan');
        }

        // Save patient to Firestore
        final patientData = {
          'firstName': _firstNameController.text.trim(),
          'lastName': _lastNameController.text.trim(),
          'age': int.parse(_ageController.text.trim()),
          'room': _roomController.text.trim(),
          'symptoms': _symptomsController.text.trim(),
          'doctorId': user.uid,
          'photoUrl': photoUrl,
          'createdAt': FieldValue.serverTimestamp(),
        };
        
        print('💾 Saving patient data to Firestore: $patientData');
        
        final docRef = await FirebaseFirestore.instance.collection('patients').add(patientData);

        print('✅ Patient saved with ID: ${docRef.id}');
        
        // Verifică că datele au fost salvate corect
        final savedDoc = await docRef.get();
        if (savedDoc.exists) {
          final savedData = savedDoc.data();
          print('🔍 Verification - Saved data: $savedData');
          print('🔍 PhotoUrl in saved data: ${savedData?['photoUrl']}');
        } else {
          print('❌ Document was not saved properly');
        }

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
        if (mounted) {
          setState(() {
            _selectedImagePath = null;
            _photoText = "Choose Photo";
            _isSubmitting = false;
          });
        }

        Navigator.of(context).pop();
        
        // Forțează reîncărcarea listei de pacienți
        print('🔄 Forcing patient list reload...');
        if (widget.onPatientAdded != null) {
          widget.onPatientAdded!();
        }
        
        // Adaugă un delay pentru a permite Firebase să proceseze datele
        await Future.delayed(const Duration(milliseconds: 500));
        
        // Verifică din nou dacă pacientul a fost salvat
        final verifySnapshot = await FirebaseFirestore.instance
            .collection('patients')
            .where('doctorId', isEqualTo: user.uid)
            .limit(1)
            .get();
            
        if (verifySnapshot.docs.isNotEmpty) {
          final latestPatient = verifySnapshot.docs.first.data();
          print('🔍 Latest patient in database: $latestPatient');
          print('🔍 Latest patient photo: ${latestPatient['photoUrl']}');
        } else {
          print('❌ No patients found after save');
        }
      } catch (e) {
        if (mounted) {
          setState(() {
            _isSubmitting = false;
          });
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Error adding patient: $e'),
              backgroundColor: Colors.red,
            ),
          );
        }
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
                const SizedBox(height: 16),
                _buildPhotoField(),
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
                        onPressed: _isSubmitting ? null : _submitForm,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: _isSubmitting ? Colors.grey : Colors.black,
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        child: _isSubmitting
                            ? const Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  SizedBox(
                                    width: 16,
                                    height: 16,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2,
                                      valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                                    ),
                                  ),
                                  SizedBox(width: 8),
                                  Text(
                                    'Saving...',
                                    style: TextStyle(fontSize: 16, color: Colors.white),
                                  ),
                                ],
                              )
                            : const Text(
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

  Widget _buildPhotoField() {
    return GestureDetector(
      onTap: _showImagePicker,
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(color: Colors.black),
          borderRadius: BorderRadius.circular(10),
          color: const Color(0xFFDECBB7),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: Row(
            children: [
              const Icon(
                Icons.camera_alt,
                color: Colors.black,
                size: 20,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  _photoText,
                  style: TextStyle(
                    fontSize: 16,
                    color: _selectedImagePath != null ? Colors.black87 : Colors.black54,
                  ),
                ),
              ),
              if (_selectedImagePath != null)
                const Icon(
                  Icons.check_circle,
                  color: Colors.green,
                  size: 20,
                ),
            ],
          ),
        ),
      ),
    );
  }

  void _showImagePicker() {
    showModalBottomSheet(
      context: context,
      backgroundColor: const Color(0xFFDECBB7),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (BuildContext context) {
        return SafeArea(
          child: Wrap(
            children: [
              ListTile(
                leading: const Icon(Icons.photo_library, color: Color(0xFF4B2A17)),
                title: const Text('Choose from Gallery'),
                onTap: () {
                  Navigator.pop(context);
                  _pickImage(ImageSource.gallery);
                },
              ),
              ListTile(
                leading: const Icon(Icons.photo_camera, color: Color(0xFF4B2A17)),
                title: const Text('Take Photo'),
                onTap: () {
                  Navigator.pop(context);
                  _pickImage(ImageSource.camera);
                },
              ),
            ],
          ),
        );
      },
    );
  }

  Future<void> _pickImage(ImageSource source) async {
    try {
      final XFile? pickedFile = await _picker.pickImage(
        source: source,
        maxWidth: 800,
        maxHeight: 800,
        imageQuality: 85,
      );

      if (pickedFile != null) {
        setState(() {
          _selectedImagePath = pickedFile.path;
          _photoText = 'Photo Selected';
        });
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error picking image: $e'),
          backgroundColor: const Color(0xFF4B2A17),
        ),
      );
    }
  }

  Future<String?> _uploadPhoto(String imagePath) async {
    try {
      print('🔄 Starting simple photo upload...');
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) {
        print('❌ No user authenticated');
        return null;
      }

      // Citește fișierul
      final xFile = XFile(imagePath);
      final bytes = await xFile.readAsBytes();
      print('📄 File read: ${bytes.length} bytes');
      
      if (bytes.isEmpty) {
        throw Exception('Empty file');
      }

      // Upload simplu fără monitoring
      final fileName = 'patient_${DateTime.now().millisecondsSinceEpoch}.jpg';
      final reference = FirebaseStorage.instance
          .ref()
          .child('patient_photos')
          .child(user.uid)
          .child(fileName);

      print('📤 Uploading to Firebase Storage...');
      
      // Upload direct fără timeout complicat
      final uploadTask = reference.putData(
        bytes,
        SettableMetadata(contentType: 'image/jpeg'),
      );
      
      // Așteaptă să se termine
      final snapshot = await uploadTask;
      
      print('✅ Upload completed, getting URL...');
      final downloadUrl = await snapshot.ref.getDownloadURL();
      print('✅ Photo URL: $downloadUrl');
      
      return downloadUrl;
    } catch (e) {
      print('❌ Upload error: $e');
      
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Photo upload failed: ${e.toString()}'),
            backgroundColor: Colors.red,
            duration: const Duration(seconds: 3),
          ),
        );
      }
      return null;
    }
  }
}

class SettingsDialog extends StatelessWidget {
  const SettingsDialog({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BackdropFilter(
      filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
      child: Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: const Color(0xFFDECBB7),
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.2),
              blurRadius: 20,
              offset: const Offset(0, 10),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Header
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Settings',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
                GestureDetector(
                  onTap: () => Navigator.of(context).pop(),
                  child: const Icon(
                    Icons.close,
                    color: Colors.black,
                    size: 24,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            const Divider(color: Colors.black26, thickness: 3),
            
            // Account Section
            _buildMenuItem(
              icon: Icons.person,
              title: 'Account',
              onTap: () => _showMessage(context, 'Account tapped'),
            ),
            const Divider(color: Colors.black26, thickness: 3),
            
            _buildSubMenuItem(
              title: 'Change picture',
              onTap: () => _showMessage(context, 'Change picture tapped'),
            ),
            
            _buildSubMenuItem(
              title: 'Change password',
              onTap: () => _showChangePasswordDialog(context),
            ),
            
            _buildSubMenuItem(
              title: 'Account information',
              onTap: () => _showAccountInfoDialog(context),
            ),
            const Divider(color: Colors.black26, thickness: 3),
            
            // Other Options
            _buildMenuItem(
              icon: Icons.description,
              title: 'Terms & Conditions',
              onTap: () => _showTermsAndConditions(context),
              hasArrow: false,
            ),
            const Divider(color: Colors.black26, thickness: 3),
            
            _buildMenuItem(
              icon: Icons.logout,
              title: 'Log out',
              onTap: () => _handleLogout(context),
            ),
            const Divider(color: Colors.black26, thickness: 3),
            
            _buildMenuItem(
              icon: Icons.person_remove,
              title: 'Delete account',
              onTap: () => _showDeleteAccountDialog(context),
            ),
            const Divider(color: Colors.black26, thickness: 3),
            
            _buildMenuItem(
              icon: Icons.sentiment_satisfied_alt,
              title: 'Feedback',
              onTap: () => _showMessage(context, 'Feedback tapped'),
              hasArrow: false,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMenuItem({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
    bool hasArrow = false,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
        child: Row(
          children: [
            Icon(
              icon,
              color: Colors.black,
              size: 24,
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Text(
                title,
                style: const TextStyle(
                  fontSize: 16,
                  color: Colors.black,
                ),
              ),
            ),
            if (hasArrow)
              const Icon(
                Icons.chevron_right,
                color: Colors.black,
                size: 24,
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildSubMenuItem({
    required String title,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 24),
        child: Row(
          children: [
            Expanded(
              child: Text(
                title,
                style: const TextStyle(
                  fontSize: 16,
                  color: Color(0xFF666666), // Text mai deschis
                ),
              ),
            ),
            const Icon(
              Icons.chevron_right,
              color: Colors.black,
              size: 24,
            ),
          ],
        ),
      ),
    );
  }

  void _handleLogout(BuildContext context) async {
    try {
      await FirebaseAuth.instance.signOut();
      if (context.mounted) {
        Navigator.of(context).pushReplacementNamed('/login');
      }
    } catch (e) {
      _showMessage(context, 'Error logging out: $e');
    }
  }

  void _showDeleteAccountDialog(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false,
      barrierColor: Colors.black.withOpacity(0.5), // Fundal transparent cu blur
      builder: (BuildContext context) {
        return Dialog(
          backgroundColor: Colors.transparent,
          insetPadding: const EdgeInsets.all(20),
          child: DeleteAccountDialog(),
        );
      },
    );
  }

  void _showChangePasswordDialog(BuildContext context) {
    Navigator.of(context).pop(); // Închide Settings dialog-ul
    showDialog(
      context: context,
      barrierColor: Colors.black12.withOpacity(0.5),
      builder: (BuildContext context) {
        return Dialog(
          backgroundColor: Colors.transparent,
          insetPadding: const EdgeInsets.all(20),
          child: ChangePasswordDialog(),
        );
      },
    );
  }

  void _showAccountInfoDialog(BuildContext context) {
    Navigator.of(context).pop(); // Închide Settings dialog-ul
    showDialog(
      context: context,
      barrierColor: Colors.black12.withOpacity(0.5),
      builder: (BuildContext context) {
        return Dialog(
          backgroundColor: Colors.transparent,
          insetPadding: const EdgeInsets.all(20),
          child: AccountInfoDialog(),
        );
      },
    );
  }

  void _showTermsAndConditions(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return const TermsAndConditionsPage();
      },
    );
  }

  void _showMessage(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: const Color(0xFF4B2A17),
      ),
    );
  }

}

class DeleteAccountDialog extends StatefulWidget {
  const DeleteAccountDialog({Key? key}) : super(key: key);

  @override
  State<DeleteAccountDialog> createState() => _DeleteAccountDialogState();
}

class _DeleteAccountDialogState extends State<DeleteAccountDialog> {
  final TextEditingController _passwordController = TextEditingController();
  bool _obscurePassword = true;

  @override
  void dispose() {
    _passwordController.dispose();
    super.dispose();
  }

  void _handleDeleteAccount() async {
    print('🗑️ Delete account button pressed');
    
    if (_passwordController.text.isEmpty) {
      print('❌ Password field is empty');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please enter your password'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    print('🔑 Password provided: ${_passwordController.text.length} characters');

    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        print('👤 Current user: ${user.email}');
        
        // Verifică parola prin re-autentificare
        print('🔐 Attempting re-authentication...');
        final credential = EmailAuthProvider.credential(
          email: user.email!,
          password: _passwordController.text,
        );
        
        await user.reauthenticateWithCredential(credential);
        print('✅ Re-authentication successful');
        
        // Dacă re-autentificarea reușește, șterge contul
        print('🗂️ Deleting user document from Firestore...');
        await FirebaseFirestore.instance
            .collection('users')
            .doc(user.uid)
            .delete();
        print('✅ User document deleted');
        
        // Șterge toate pacienții asociați cu acest doctor
        print('👥 Deleting associated patients...');
        final patientsQuery = await FirebaseFirestore.instance
            .collection('patients')
            .where('doctorId', isEqualTo: user.uid)
            .get();
        
        print('📊 Found ${patientsQuery.docs.length} patients to delete');
        for (var doc in patientsQuery.docs) {
          await doc.reference.delete();
        }
        print('✅ All patients deleted');
        
        // Șterge contul Firebase Auth
        print('🔥 Deleting Firebase Auth user...');
        await user.delete();
        print('✅ Firebase Auth user deleted');
        
        // Afișează mesaj de succes
        print('🎉 Account deletion completed successfully');
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Account deleted successfully'),
              backgroundColor: Colors.green,
              duration: Duration(seconds: 2),
            ),
          );
          
          // Navighează la splash screen după un delay scurt
          print('🔄 Navigating to splash screen...');
          Future.delayed(const Duration(seconds: 2), () {
            if (context.mounted) {
              Navigator.of(context).pushAndRemoveUntil(
                MaterialPageRoute(builder: (context) => MedHiveSplashScreen()),
                (route) => false,
              );
            }
          });
        }
      } else {
        print('❌ No current user found');
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('No user logged in'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } on FirebaseAuthException catch (e) {
      print('❌ Firebase Auth Error: ${e.code} - ${e.message}');
      if (e.code == 'wrong-password' || e.code == 'invalid-credential') {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Incorrect password'),
            backgroundColor: Colors.red,
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error: ${e.message}'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } catch (e) {
      print('❌ General Error: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error deleting account: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 280,
      width: 350,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFF5C3F28), // Fundal maro mai deschis elegant
        borderRadius: BorderRadius.circular(25),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.4),
            blurRadius: 25,
            offset: const Offset(0, 15),
          ),
          BoxShadow(
            color: Colors.white.withOpacity(0.1),
            blurRadius: 5,
            offset: const Offset(0, -2),
          ),
        ],
        border: Border.all(
          color: Colors.white.withOpacity(0.2),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(
                Icons.person_off, 
                color: Colors.white, // Alb complet vizibil
                size: 26
              ),
              const SizedBox(width: 5),
              const Text(
                'Delete account',
                style: TextStyle(
                  color: Colors.white, // Alb complet vizibil
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
                  color: Colors.white, // Alb complet vizibil
                  fontSize: 23,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),

          const SizedBox(height: 20),

          // Câmpul pentru parolă
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.15),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: Colors.white.withOpacity(0.3),
                width: 1.5,
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.2),
                  blurRadius: 8,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: TextField(
              controller: _passwordController,
              obscureText: _obscurePassword,
              textAlignVertical: TextAlignVertical.center,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 14,
              ),
              decoration: InputDecoration(
                hintText: 'Enter your password',
                hintStyle: const TextStyle(
                  color: Colors.white70,
                  fontSize: 14,
                ),
                border: InputBorder.none,
                contentPadding: const EdgeInsets.symmetric(vertical: 12),
                suffixIcon: IconButton(
                  icon: Icon(
                    _obscurePassword ? Icons.visibility : Icons.visibility_off,
                    color: Colors.white,
                    size: 20,
                  ),
                  onPressed: () {
                    setState(() {
                      _obscurePassword = !_obscurePassword;
                    });
                  },
                ),
              ),
            ),
          ),

          const SizedBox(height: 20),

          Row(
            children: [
              SizedBox(
                width: 140,
                child: ElevatedButton(
                  onPressed: _handleDeleteAccount,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFD4A574), // Fundal auriu elegant
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    elevation: 6,
                    shadowColor: Colors.black.withOpacity(0.3),
                  ),
                  child: const Text(
                    'Yes',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
              
              const Spacer(),

              SizedBox(
                width: 140,
                child: ElevatedButton(
                  onPressed: () => Navigator.of(context).pop(),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF8B7355), // Fundal maro elegant
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    elevation: 6,
                    shadowColor: Colors.black.withOpacity(0.3),
                  ),
                  child: const Text(
                    'No',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class ChangePasswordDialog extends StatefulWidget {
  const ChangePasswordDialog({Key? key}) : super(key: key);

  @override
  _ChangePasswordDialogState createState() => _ChangePasswordDialogState();
}

class _ChangePasswordDialogState extends State<ChangePasswordDialog> {
  final _formKey = GlobalKey<FormState>();
  final _oldPasswordController = TextEditingController();
  final _newPasswordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  bool _obscureOldPassword = true;
  bool _obscureNewPassword = true;
  bool _obscureConfirmPassword = true;

  @override
  void dispose() {
    _oldPasswordController.dispose();
    _newPasswordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  void _submitForm() async {
    if (_formKey.currentState!.validate()) {
      if (_newPasswordController.text != _confirmPasswordController.text) {
        _showMessage('New passwords do not match');
        return;
      }

      try {
        final user = FirebaseAuth.instance.currentUser;
        if (user != null) {
          // Verifică parola veche prin re-autentificare
          final credential = EmailAuthProvider.credential(
            email: user.email!,
            password: _oldPasswordController.text,
          );
          
          await user.reauthenticateWithCredential(credential);
          
          // Dacă re-autentificarea reușește, schimbă parola
          await user.updatePassword(_newPasswordController.text);
          
          // Închide dialog-ul de schimbare parolă
          Navigator.of(context).pop();
          
          // Afișează dialog-ul de succes
          _showPasswordChangeSuccessDialog();
        }
      } on FirebaseAuthException catch (e) {
        if (e.code == 'wrong-password') {
          _showMessage('Current password is incorrect');
        } else if (e.code == 'invalid-credential') {
          _showMessage('Current password is incorrect');
        } else {
          _showMessage('Error updating password: ${e.message}');
        }
      } catch (e) {
        _showMessage('Error updating password: $e');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return BackdropFilter(
      filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
      child: Container(
        width: MediaQuery.of(context).size.width * 0.98,
        padding: const EdgeInsets.all(50),
        decoration: BoxDecoration(
          color: const Color(0xFFDECBB7),
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.2),
              blurRadius: 20,
              offset: const Offset(0, 10),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Header
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    const Icon(
                      Icons.person,
                      color: Colors.black,
                      size: 28,
                    ),
                    const SizedBox(width: 16),
                    const Text(
                      'Account',
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                  ],
                ),
                GestureDetector(
                  onTap: () => Navigator.of(context).pop(),
                  child: const Icon(
                    Icons.close,
                    color: Colors.black,
                    size: 28,
                  ),
                ),
              ],
            ),
            const Divider(color: Colors.black26, thickness: 3),
            const SizedBox(height: 20),
            
            // Title
            const Text(
              'Change password',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
            const SizedBox(height: 20),
            
            // Form
            Form(
              key: _formKey,
              child: Column(
                children: [
                  _buildPasswordField(
                    controller: _oldPasswordController,
                    label: 'Current Password',
                    obscureText: _obscureOldPassword,
                    onToggle: () => setState(() => _obscureOldPassword = !_obscureOldPassword),
                  ),
                  const SizedBox(height: 20),
                  _buildPasswordField(
                    controller: _newPasswordController,
                    label: 'New Password',
                    obscureText: _obscureNewPassword,
                    onToggle: () => setState(() => _obscureNewPassword = !_obscureNewPassword),
                  ),
                  const SizedBox(height: 20),
                  _buildPasswordField(
                    controller: _confirmPasswordController,
                    label: 'Confirm New Password',
                    obscureText: _obscureConfirmPassword,
                    onToggle: () => setState(() => _obscureConfirmPassword = !_obscureConfirmPassword),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            
            // Confirm Button
            Center(
              child: SizedBox(
                width: 200,
                child: ElevatedButton(
                  onPressed: _submitForm,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF4B2A17),
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    elevation: 4,
                  ),
                  child: const Text(
                    'Confirm',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPasswordField({
    required TextEditingController controller,
    required String label,
    required bool obscureText,
    required VoidCallback onToggle,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: Color(0xFF666666),
          ),
        ),
        const SizedBox(height: 8),
        Container(
          decoration: BoxDecoration(
            color: const Color(0xFFDECBB7),
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: Colors.black.withOpacity(0.5), width: 3),
          ),
          child: TextFormField(
            controller: controller,
            obscureText: obscureText,
            style: const TextStyle(fontSize: 14),
            decoration: InputDecoration(
              border: InputBorder.none,
              contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
              suffixIcon: IconButton(
                icon: Icon(
                  obscureText ? Icons.visibility : Icons.visibility_off,
                  color: Colors.black,
                  size: 20,
                ),
                onPressed: onToggle,
              ),
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter $label';
              }
              if (value.length < 6) {
                return 'Password must be at least 6 characters';
              }
              return null;
            },
          ),
        ),
      ],
    );
  }

  void _showMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: const Color(0xFF4B2A17),
      ),
    );
  }

  void _showPasswordChangeSuccessDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return Dialog(
          backgroundColor: Colors.transparent,
          insetPadding: const EdgeInsets.all(20),
          child: Container(
            padding: const EdgeInsets.all(30),
            decoration: BoxDecoration(
              color: const Color(0xFFDECBB7),
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.2),
                  blurRadius: 20,
                  offset: const Offset(0, 10),
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Icon de succes
                Container(
                  width: 80,
                  height: 80,
                  decoration: BoxDecoration(
                    color: Colors.green,
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.green.withOpacity(0.3),
                        blurRadius: 15,
                        offset: const Offset(0, 5),
                      ),
                    ],
                  ),
                  child: const Icon(
                    Icons.check,
                    color: Colors.white,
                    size: 50,
                  ),
                ),
                const SizedBox(height: 20),
                
                // Mesaj de succes
                const Text(
                  'Password changed successfully!',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 10),
                
                const Text(
                  'Your password has been updated.',
                  style: TextStyle(
                    fontSize: 14,
                    color: Color(0xFF666666),
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 25),
                
                // Buton Close
                SizedBox(
                  width: 150,
                  child: ElevatedButton(
                    onPressed: () => Navigator.of(context).pop(),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF4B2A17),
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      elevation: 4,
                    ),
                    child: const Text(
                      'CLOSE',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class AccountInfoDialog extends StatefulWidget {
  const AccountInfoDialog({Key? key}) : super(key: key);

  @override
  _AccountInfoDialogState createState() => _AccountInfoDialogState();
}

class _AccountInfoDialogState extends State<AccountInfoDialog> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _accountIdController = TextEditingController();
  final _uidController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _accountIdController.dispose();
    _uidController.dispose();
    super.dispose();
  }

  void _loadUserData() async {
    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        print('👤 Loading user data for: ${user.uid}');
        print('👤 User email from Auth: ${user.email}');
        
        // Încearcă să încarce din Firestore
        final userDoc = await FirebaseFirestore.instance
            .collection('users')
            .doc(user.uid)
            .get();
        
        if (userDoc.exists) {
          final userData = userDoc.data()!;
          print('📋 User data from Firestore: $userData');
          setState(() {
            _nameController.text = userData['fullName'] ?? 'N/A';
            _emailController.text = userData['email'] ?? user.email ?? 'N/A';
            _accountIdController.text = userData['id'] ?? 'N/A';
            _uidController.text = user.uid;
          });
        } else {
          print('⚠️ No Firestore document found, using Auth data');
          // Fallback la datele din Firebase Auth
          setState(() {
            _nameController.text = user.displayName ?? 'N/A';
            _emailController.text = user.email ?? 'N/A';
            _accountIdController.text = 'N/A';
            _uidController.text = user.uid;
          });
        }
      }
    } catch (e) {
      print('❌ Error loading user data: $e');
      // Fallback la datele din Firebase Auth în caz de eroare
      final user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        setState(() {
          _nameController.text = user.displayName ?? 'N/A';
          _emailController.text = user.email ?? 'N/A';
          _accountIdController.text = 'N/A';
          _uidController.text = user.uid;
        });
      }
    }
  }


  @override
  Widget build(BuildContext context) {
    return BackdropFilter(
      filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
      child: Container(
        width: MediaQuery.of(context).size.width * 0.98,
        padding: const EdgeInsets.all(50),
        decoration: BoxDecoration(
          color: const Color(0xFFDECBB7),
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.2),
              blurRadius: 20,
              offset: const Offset(0, 10),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Header
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    const Icon(
                      Icons.person,
                      color: Colors.black,
                      size: 28,
                    ),
                    const SizedBox(width: 16),
                    const Text(
                      'Account',
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                  ],
                ),
                GestureDetector(
                  onTap: () => Navigator.of(context).pop(),
                  child: const Icon(
                    Icons.close,
                    color: Colors.black,
                    size: 28,
                  ),
                ),
              ],
            ),
            const Divider(color: Colors.black26, thickness: 3),
            const SizedBox(height: 20),
            
            // Title
            const Text(
              'Account information',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
            const SizedBox(height: 20),
            
            // Form
            Form(
              key: _formKey,
              child: Column(
                children: [
                  _buildTextField(
                    controller: _nameController,
                    label: 'Name',
                    isReadOnly: true,
                  ),
                  const SizedBox(height: 20),
                  _buildTextField(
                    controller: _emailController,
                    label: 'Email',
                    isReadOnly: true,
                  ),
                  const SizedBox(height: 20),
                  _buildTextField(
                    controller: _accountIdController,
                    label: 'Account ID',
                    isReadOnly: true,
                  ),
                  const SizedBox(height: 20),
                  _buildTextField(
                    controller: _uidController,
                    label: 'User ID (UID)',
                    isReadOnly: true,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            
            // Close Button
            Center(
              child: SizedBox(
                width: 200,
                child: ElevatedButton(
                  onPressed: () => Navigator.of(context).pop(),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF4B2A17),
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    elevation: 4,
                  ),
                  child: const Text(
                    'Close',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    bool isReadOnly = false,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: Color(0xFF666666),
          ),
        ),
        const SizedBox(height: 8),
        Container(
          decoration: BoxDecoration(
            color: const Color(0xFFDECBB7),
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: Colors.black.withOpacity(0.5), width: 3),
          ),
          child: TextFormField(
            controller: controller,
            readOnly: isReadOnly,
            style: TextStyle(
              fontSize: 14,
              color: isReadOnly ? Colors.grey[600] : Colors.black,
            ),
            decoration: InputDecoration(
              border: InputBorder.none,
              contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
            ),
            validator: isReadOnly ? null : (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter $label';
              }
              return null;
            },
          ),
        ),
      ],
    );
  }

  void _showMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: const Color(0xFF4B2A17),
      ),
    );
  }
}