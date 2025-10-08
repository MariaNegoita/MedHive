import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'dart:convert';
import 'dart:math'; // Import pentru funcții matematice (sin, cos, etc.)
import 'dart:async'; // Import pentru Timer
import 'doctor_home_screen.dart'; // Import pentru clasa Patient

class PatientDetailsScreen extends StatefulWidget {
  final Patient patient;

  const PatientDetailsScreen({
    super.key,
    required this.patient,
  });

  @override
  State<PatientDetailsScreen> createState() => _PatientDetailsScreenState();
}

class _PatientDetailsScreenState extends State<PatientDetailsScreen> {
  final TextEditingController _noteController = TextEditingController();
  bool _isSavingNote = false;
  bool _isLoadingNotes = true;
  String _patientDocId = '';
  
  // Vital signs data
  int _heartRate = 75;
  int _spO2 = 98;
  int _respRate = 14;
  double _temperature = 36.8;
  int _systolicBP = 120;
  int _diastolicBP = 80;
  int _co2 = 38;
  Timer? _vitalSignsTimer;

  @override
  void initState() {
    super.initState();
    _loadPatientNotes();
    _startVitalSignsUpdates();
  }

  @override
  void dispose() {
    _noteController.dispose();
    _vitalSignsTimer?.cancel();
    super.dispose();
  }

  void _startVitalSignsUpdates() {
    // Actualizează valorile la fiecare 4 secunde
    _vitalSignsTimer = Timer.periodic(const Duration(seconds: 4), (timer) {
      if (mounted) {
        setState(() {
          // Heart Rate: variază între 70-85 BPM (simulare realistă)
          _heartRate = 70 + Random().nextInt(16);
          
          // SpO2: variază între 96-100% (normal range)
          _spO2 = 96 + Random().nextInt(5);
          
          // Respiratory Rate: 12-18 breaths/min
          _respRate = 12 + Random().nextInt(7);
          
          // Temperature: 36.2-37.2°C
          _temperature = 36.2 + Random().nextDouble() * 1.0;
          
          // Blood Pressure: variații mici
          _systolicBP = 115 + Random().nextInt(11); // 115-125
          _diastolicBP = 75 + Random().nextInt(11); // 75-85
          
          // CO2: 35-45 mmHg
          _co2 = 35 + Random().nextInt(11);
        });
      }
    });
  }

  Future<void> _loadPatientNotes() async {
    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        // Găsește documentul pacientului în Firebase
        final patientQuery = await FirebaseFirestore.instance
            .collection('patients')
            .where('doctorId', isEqualTo: user.uid)
            .where('firstName', isEqualTo: widget.patient.name.split(' ').first)
            .where('lastName', isEqualTo: widget.patient.name.split(' ').length > 1 
                ? widget.patient.name.split(' ').last 
                : '')
            .limit(1)
            .get();

        if (patientQuery.docs.isNotEmpty) {
          final patientDoc = patientQuery.docs.first;
          _patientDocId = patientDoc.id;
          
          // Încarcă nota salvată (dacă există)
          final patientData = patientDoc.data();
          if (patientData.containsKey('note') && patientData['note'] != null) {
            setState(() {
              _noteController.text = patientData['note'];
              _isLoadingNotes = false;
            });
          } else {
            setState(() {
              _isLoadingNotes = false;
            });
          }
        } else {
          setState(() {
            _isLoadingNotes = false;
          });
        }
      }
    } catch (e) {
      print('Error loading notes: $e');
      setState(() {
        _isLoadingNotes = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: const Color(0xFF8B7355), // Background maro
        body: SafeArea(
          child: SingleChildScrollView(
            child: Column(
              children: [
                // Header
                Container(
                  padding: const EdgeInsets.all(20),
                  child: Row(
                    children: [
                      GestureDetector(
                        onTap: () => Navigator.of(context).pop(),
                        child: const Icon(
                          Icons.arrow_back,
                          color: Colors.white,
                          size: 28,
                        ),
                      ),
                      const SizedBox(width: 20),
                      const Expanded(
                        child: Text(
                          'Patient Details',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ],
                  ),
                ),

                // Main Content
                Container(
                  margin: const EdgeInsets.symmetric(horizontal: 20),
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: const Color(0xFFD2B48C), // Lighter brown background
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: const Color(0xFF4B2A17), width: 2),
                  ),
                  child: Column(
                    children: [
                      // Patient Photo
                      RepaintBoundary(
                        child: Container(
                          width: 120,
                          height: 120,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(12),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.1),
                                blurRadius: 8,
                                offset: const Offset(0, 4),
                              ),
                            ],
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(12),
                            child: _buildPatientPhoto(),
                          ),
                        ),
                      ),

                      const SizedBox(height: 20),

                      // Patient Information
                      RepaintBoundary(
                        child: Align(
                          alignment: Alignment.centerLeft,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              _buildInfoRow("Name:", widget.patient.name),
                              _buildInfoRow("Room:", widget.patient.room),
                              _buildInfoRow("Age:", widget.patient.age),
                              _buildInfoRow("Problem:", widget.patient.problem),
                            ],
                          ),
                        ),
                      ),

                      const SizedBox(height: 20),

                      // Medical Monitor Display
                      Container(
                        width: double.infinity,
                        height: 280,
                        decoration: BoxDecoration(
                          color: Colors.black,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: Colors.grey.shade600, width: 1),
                        ),
                        child: _buildMedicalMonitor(),
                      ),

                      const SizedBox(height: 20),

                      // Notes Section
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(color: const Color(0xFF4B2A17), width: 2),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.05),
                              blurRadius: 8,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: _isLoadingNotes
                          ? const Center(
                              child: CircularProgressIndicator(
                                color: Color(0xFF4B2A17),
                              ),
                            )
                          : TextField(
                              controller: _noteController,
                              minLines: 3,
                              maxLines: 8,
                              textAlignVertical: TextAlignVertical.top,
                              decoration: const InputDecoration(
                                hintText: '📝 Add your notes here...',
                                hintStyle: TextStyle(
                                  color: Colors.grey,
                                  fontSize: 14,
                                  fontStyle: FontStyle.italic,
                                ),
                                border: InputBorder.none,
                                contentPadding: EdgeInsets.zero,
                              ),
                              style: const TextStyle(
                                fontSize: 14,
                                color: Colors.black,
                                height: 1.4,
                              ),
                            ),
                      ),

                      const SizedBox(height: 16),

                      // Save Note Button
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: _isSavingNote ? null : _saveNote,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF4B2A17),
                            padding: const EdgeInsets.symmetric(vertical: 10),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            elevation: 2,
                          ),
                          child: _isSavingNote
                            ? const Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  SizedBox(
                                    width: 20,
                                    height: 20,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2,
                                      valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                                    ),
                                  ),
                                  SizedBox(width: 8),
                                  Text(
                                    'Saving...',
                                    style: TextStyle(
                                      fontSize: 14,
                                      color: Colors.white,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ],
                              )
                            : const Text(
                                '💾 Save Note',
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.white,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
    );
  }

  Widget _buildPatientPhoto() {
    if (widget.patient.photoUrl != null && widget.patient.photoUrl!.isNotEmpty) {
      if (widget.patient.photoUrl!.startsWith('data:image/')) {
        // Base64 image
        final base64String = widget.patient.photoUrl!.split(',')[1];
        final bytes = base64Decode(base64String);
        
        return Image.memory(
          bytes,
          width: 120,
          height: 120,
          fit: BoxFit.cover,
          gaplessPlayback: true, // Previne flickering
          errorBuilder: (context, error, stackTrace) {
            return const Icon(
              Icons.person,
              size: 60,
              color: Color(0xFF4B2A17),
            );
          },
        );
      } else {
        // Firebase URL
        return Image.network(
          widget.patient.photoUrl!,
          width: 120,
          height: 120,
          fit: BoxFit.cover,
          gaplessPlayback: true, // Previne flickering
          cacheWidth: 120, // Optimizare cache
          cacheHeight: 120, // Optimizare cache
          errorBuilder: (context, error, stackTrace) {
            return const Icon(
              Icons.person,
              size: 60,
              color: Color(0xFF4B2A17),
            );
          },
        );
      }
    } else {
      return const Icon(
        Icons.person,
        size: 60,
        color: Color(0xFF4B2A17),
      );
    }
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        children: [
          SizedBox(
            width: 80,
            child: Text(
              label,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Color(0xFF4B2A17),
              ),
            ),
          ),
          Expanded(
            child: Text(
              value.isEmpty ? 'N/A' : value,
              style: const TextStyle(
                fontSize: 16,
                color: Color(0xFF2C2C2C),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMedicalMonitor() {
    return Container(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          // Monitor Header
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 8),
            decoration: BoxDecoration(
              color: Colors.grey.shade800,
              borderRadius: BorderRadius.circular(4),
            ),
            child: const Text(
              'PATIENT MONITOR',
              style: TextStyle(
                color: Colors.white,
                fontSize: 14,
                fontWeight: FontWeight.bold,
                letterSpacing: 1,
              ),
              textAlign: TextAlign.center,
            ),
          ),
          
          const SizedBox(height: 12),
          
          // Vital Signs Display
          Expanded(
            child: Row(
              children: [
                // Left side - Waveforms
                Expanded(
                  flex: 3,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      _buildWaveformLine(Colors.green, 'ECG'),
                      _buildWaveformLine(Colors.yellow, 'RESP'),
                      _buildWaveformLine(Colors.lightBlue, 'SpO2'),
                      _buildWaveformLine(Colors.pink, 'CO2'),
                      _buildWaveformLine(Colors.orange, 'IBP'),
                      _buildWaveformLine(Colors.red, 'CVP'),
                    ],
                  ),
                ),
                
                const SizedBox(width: 16),
                
                // Right side - Values
                Expanded(
                  flex: 2,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      _buildVitalValue(_heartRate.toString(), Colors.green, 'bpm'),
                      _buildVitalValue(_respRate.toString(), Colors.yellow, ''),
                      _buildVitalValue('${_spO2}%', Colors.lightBlue, ''),
                      _buildVitalValue('${_co2}mmHg', Colors.pink, ''),
                      _buildVitalValue('${_systolicBP}/${_diastolicBP}', Colors.orange, 'mmHg'),
                      _buildVitalValue('${(_systolicBP + _diastolicBP * 2) ~/ 3}', Colors.red, 'mmHg'),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildWaveformLine(Color color, String label) {
    return Container(
      height: 25,
      child: Row(
        children: [
          SizedBox(
            width: 35,
            child: Text(
              label,
              style: TextStyle(
                color: color,
                fontSize: 10,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Expanded(
            child: AnimatedWaveform(
              color: color,
              label: label,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildVitalValue(String value, Color color, String label) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Text(
          value,
          style: TextStyle(
            color: color,
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(width: 8),
        Text(
          label,
          style: const TextStyle(
            color: Colors.white70,
            fontSize: 10,
          ),
        ),
      ],
    );
  }

  Future<void> _saveNote() async {
    if (_noteController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please enter a note'),
          backgroundColor: Colors.orange,
        ),
      );
      return;
    }

    setState(() {
      _isSavingNote = true;
    });

    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        // Dacă avem ID-ul documentului pacientului, actualizează-l direct
        if (_patientDocId.isNotEmpty) {
          await FirebaseFirestore.instance
              .collection('patients')
              .doc(_patientDocId)
              .update({
            'note': _noteController.text.trim(),
            'noteUpdatedAt': FieldValue.serverTimestamp(),
          });
        } else {
          // Altfel, caută pacientul și actualizează
          final patientQuery = await FirebaseFirestore.instance
              .collection('patients')
              .where('doctorId', isEqualTo: user.uid)
              .where('firstName', isEqualTo: widget.patient.name.split(' ').first)
              .where('lastName', isEqualTo: widget.patient.name.split(' ').length > 1 
                  ? widget.patient.name.split(' ').last 
                  : '')
              .limit(1)
              .get();

          if (patientQuery.docs.isNotEmpty) {
            final patientDoc = patientQuery.docs.first;
            await patientDoc.reference.update({
              'note': _noteController.text.trim(),
              'noteUpdatedAt': FieldValue.serverTimestamp(),
            });
          }
        }

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Note saved successfully!'),
            backgroundColor: Colors.green,
          ),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error saving note: $e'),
          backgroundColor: Colors.red,
        ),
      );
    } finally {
      setState(() {
        _isSavingNote = false;
      });
    }
  }
}

// Animated Waveform Widget
class AnimatedWaveform extends StatefulWidget {
  final Color color;
  final String label;

  const AnimatedWaveform({
    Key? key,
    required this.color,
    required this.label,
  }) : super(key: key);

  @override
  State<AnimatedWaveform> createState() => _AnimatedWaveformState();
}

class _AnimatedWaveformState extends State<AnimatedWaveform>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return CustomPaint(
          painter: WaveformPainter(
            color: widget.color,
            animationValue: _controller.value,
            label: widget.label,
          ),
          size: const Size(double.infinity, 25),
        );
      },
    );
  }
}

class WaveformPainter extends CustomPainter {
  final Color color;
  final double animationValue;
  final String label;

  WaveformPainter({
    required this.color,
    required this.animationValue,
    required this.label,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.0
      ..strokeCap = StrokeCap.round;

    final path = Path();
    final offset = animationValue * size.width;

    switch (label) {
      case 'ECG':
        // ECG/Heart Rate waveform - mai dramatic
        for (double x = 0; x < size.width; x += 1) {
          final adjustedX = (x + offset) % size.width;
          final normalizedX = (adjustedX / size.width) * 2 * pi;
          
          double y = size.height / 2;
          
          // Simulează un ECG real: P wave, QRS complex, T wave
          final phase = normalizedX % (2 * pi);
          
          if (phase < 0.3) {
            // P wave (atrial depolarization)
            y += sin(phase * 10) * 3;
          } else if (phase >= 1.0 && phase < 1.4) {
            // QRS complex (ventricular depolarization) - spike
            if (phase < 1.1) {
              y -= (phase - 1.0) * 100; // Q wave down
            } else if (phase < 1.25) {
              y += (phase - 1.1) * 150; // R wave up (tall spike)
            } else {
              y -= (phase - 1.25) * 80; // S wave down
            }
          } else if (phase >= 1.6 && phase < 2.2) {
            // T wave (ventricular repolarization)
            y += sin((phase - 1.6) * 5) * 5;
          }
          
          if (x == 0) {
            path.moveTo(x, y);
          } else {
            path.lineTo(x, y);
          }
        }
        break;
        
      case 'RESP':
        // Respiratory waveform - smooth sine wave
        for (double x = 0; x < size.width; x += 1) {
          final adjustedX = (x + offset) % size.width;
          final normalizedX = (adjustedX / size.width) * 2 * pi;
          
          final y = size.height / 2 + sin(normalizedX) * 12;
          
          if (x == 0) {
            path.moveTo(x, y);
          } else {
            path.lineTo(x, y);
          }
        }
        break;
        
      case 'SpO2':
        // SpO2 waveform - plethysmographic wave
        for (double x = 0; x < size.width; x += 1) {
          final adjustedX = (x + offset) % size.width;
          final normalizedX = (adjustedX / size.width) * 4 * pi;
          
          final y = size.height / 2 + 
              sin(normalizedX) * 8 + 
              sin(normalizedX * 2) * 3 +
              sin(normalizedX * 0.5) * 2;
          
          if (x == 0) {
            path.moveTo(x, y);
          } else {
            path.lineTo(x, y);
          }
        }
        break;
        
      case 'CO2':
        // CO2 waveform - square wave pattern
        for (double x = 0; x < size.width; x += 1) {
          final adjustedX = (x + offset) % size.width;
          final normalizedX = (adjustedX / size.width) * 4 * pi;
          
          double y = size.height / 2;
          if (sin(normalizedX) > 0) {
            y += 10;
          } else {
            y -= 10;
          }
          
          if (x == 0) {
            path.moveTo(x, y);
          } else {
            path.lineTo(x, y);
          }
        }
        break;
        
      case 'IBP':
        // Invasive Blood Pressure - arterial waveform
        for (double x = 0; x < size.width; x += 1) {
          final adjustedX = (x + offset) % size.width;
          final normalizedX = (adjustedX / size.width) * 3 * pi;
          
          final y = size.height / 2 + 
              sin(normalizedX) * 10 +
              sin(normalizedX * 3) * 4;
          
          if (x == 0) {
            path.moveTo(x, y);
          } else {
            path.lineTo(x, y);
          }
        }
        break;
        
      case 'CVP':
        // Central Venous Pressure - smaller amplitude
        for (double x = 0; x < size.width; x += 1) {
          final adjustedX = (x + offset) % size.width;
          final normalizedX = (adjustedX / size.width) * 2 * pi;
          
          final y = size.height / 2 + 
              sin(normalizedX) * 5 +
              sin(normalizedX * 0.5) * 2;
          
          if (x == 0) {
            path.moveTo(x, y);
          } else {
            path.lineTo(x, y);
          }
        }
        break;
    }

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(WaveformPainter oldDelegate) {
    return oldDelegate.animationValue != animationValue;
  }
}

