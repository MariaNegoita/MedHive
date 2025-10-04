import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class FeedbackPage extends StatefulWidget {
  const FeedbackPage({super.key});

  static const Color beige = Color.fromRGBO(222, 203, 183, 1);
  static const Color darkBrown = Color.fromRGBO(80, 52, 30, 1);

  @override
  State<FeedbackPage> createState() => _FeedbackPageState();
}

class _FeedbackPageState extends State<FeedbackPage> {
  double rating = 3;
  String? navigationEase;
  String? clarity;
  bool infoAccurate = true;
  bool dataSafe = true;
  bool healthcareNeedsMet = true;
  final TextEditingController suggestionsController = TextEditingController();

  @override
  void dispose() {
    suggestionsController.dispose();
    super.dispose();
  }

  void _submitFeedback() async {
    // Collect all feedback data
    final feedbackData = {
      'rating': rating,
      'navigationEase': navigationEase,
      'clarity': clarity,
      'infoAccurate': infoAccurate,
      'dataSafe': dataSafe,
      'healthcareNeedsMet': healthcareNeedsMet,
      'suggestions': suggestionsController.text,
      'timestamp': DateTime.now().toIso8601String(),
    };

    // Print to console for debugging
    print('📝 Feedback submitted:');
    print('Rating: $rating');
    print('Navigation Ease: $navigationEase');
    print('Clarity: $clarity');
    print('Info Accurate: $infoAccurate');
    print('Data Safe: $dataSafe');
    print('Healthcare Needs Met: $healthcareNeedsMet');
    print('Suggestions: ${suggestionsController.text}');

    // Send email with feedback
    await _sendFeedbackEmail(feedbackData);

    // Show thank you screen
    _showThankYouScreen();
  }

  Future<void> _sendFeedbackEmail(Map<String, dynamic> feedbackData) async {
    try {
      final subject = 'MedHive Feedback - ${DateTime.now().toString().split(' ')[0]}';
      
      final body = '''
MedHive Feedback Report
=====================

Date: ${DateTime.now().toString().split(' ')[0]}
Time: ${DateTime.now().toString().split(' ')[1]}

1. Overall Rating: ${feedbackData['rating']}/5

2. Navigation Ease: ${feedbackData['navigationEase'] ?? 'Not answered'}

3. Information Clarity: ${feedbackData['clarity'] ?? 'Not answered'}

4. Information Accurate: ${feedbackData['infoAccurate'] ? 'Yes' : 'No'}

5. Data Safety: ${feedbackData['dataSafe'] ? 'Yes' : 'No'}

6. Healthcare Needs Met: ${feedbackData['healthcareNeedsMet'] ? 'Yes' : 'No'}

7. Suggestions for Improvement:
${feedbackData['suggestions'].isEmpty ? 'No suggestions provided' : feedbackData['suggestions']}

---
This feedback was submitted through the MedHive mobile application.
''';

      final Uri emailUri = Uri(
        scheme: 'mailto',
        path: 'medhive0@gmail.com',
        query: 'subject=${Uri.encodeComponent(subject)}&body=${Uri.encodeComponent(body)}',
      );

      if (await canLaunchUrl(emailUri)) {
        await launchUrl(emailUri);
        print('📧 Email client opened successfully');
      } else {
        print('❌ Could not open email client');
        // Fallback: copy to clipboard
        _showEmailFallback(body);
      }
    } catch (e) {
      print('❌ Error sending email: $e');
      _showEmailFallback('Error occurred while preparing email');
    }
  }

  void _showEmailFallback(String content) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Please send feedback to: medhive0@gmail.com'),
        backgroundColor: Color(0xFF4B2A17),
        duration: Duration(seconds: 5),
      ),
    );
  }

  void _showThankYouScreen() {
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(
        builder: (_) => const ThankYouScreen(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF4A3728), // Dark background
      appBar: AppBar(
        title: const Text('Feedback'),
        backgroundColor: const Color(0xFF4A3728),
        foregroundColor: Colors.white,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Center(
            child: Container(
              width: 600,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: FeedbackPage.beige,
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
                      const Icon(Icons.tag_faces_rounded,
                          color: FeedbackPage.darkBrown, size: 28),
                      const SizedBox(width: 8),
                      const Text(
                        'Feedback',
                        style: TextStyle(
                          color: FeedbackPage.darkBrown,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const Spacer(),
                      GestureDetector(
                        onTap: () => Navigator.of(context).pop(),
                        child: const Icon(Icons.close,
                            color: FeedbackPage.darkBrown, size: 22),
                      ),
                    ],
                  ),

                  const Divider(color: FeedbackPage.darkBrown),

                  const SizedBox(height: 8),

                  const Text(
                    '1. How would you rate your overall experience?',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: FeedbackPage.darkBrown,
                    ),
                  ),
                  Slider(
                    activeColor: FeedbackPage.darkBrown,
                    value: rating,
                    min: 1,
                    max: 5,
                    divisions: 4,
                    label: rating.round().toString(),
                    onChanged: (value) {
                      setState(() => rating = value);
                    },
                  ),

                  const SizedBox(height: 16),

                  const Text(
                    '2. How easy was it to navigate the app?',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: FeedbackPage.darkBrown,
                    ),
                  ),
                  Column(
                    children: [
                      RadioListTile<String>(
                        activeColor: FeedbackPage.darkBrown,
                        title: const Text('Very easy',
                            style: TextStyle(color: FeedbackPage.darkBrown)),
                        value: 'Very easy',
                        groupValue: navigationEase,
                        onChanged: (value) {
                          setState(() => navigationEase = value);
                        },
                      ),
                      RadioListTile<String>(
                        activeColor: FeedbackPage.darkBrown,
                        title: const Text('Somewhat easy',
                            style: TextStyle(color: FeedbackPage.darkBrown)),
                        value: 'Somewhat easy',
                        groupValue: navigationEase,
                        onChanged: (value) {
                          setState(() => navigationEase = value);
                        },
                      ),
                      RadioListTile<String>(
                        activeColor: FeedbackPage.darkBrown,
                        title: const Text('Difficult',
                            style: TextStyle(color: FeedbackPage.darkBrown)),
                        value: 'Difficult',
                        groupValue: navigationEase,
                        onChanged: (value) {
                          setState(() => navigationEase = value);
                        },
                      ),
                    ],
                  ),

                  const SizedBox(height: 16),

                  const Text(
                    '3. Was the information easy to understand?',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: FeedbackPage.darkBrown,
                    ),
                  ),
                  Column(
                    children: [
                      RadioListTile<String>(
                        activeColor: FeedbackPage.darkBrown,
                        title: const Text('Very clear',
                            style: TextStyle(color: FeedbackPage.darkBrown)),
                        value: 'Very clear',
                        groupValue: clarity,
                        onChanged: (value) {
                          setState(() => clarity = value);
                        },
                      ),
                      RadioListTile<String>(
                        activeColor: FeedbackPage.darkBrown,
                        title: const Text('Somewhat clear',
                            style: TextStyle(color: FeedbackPage.darkBrown)),
                        value: 'Somewhat clear',
                        groupValue: clarity,
                        onChanged: (value) {
                          setState(() => clarity = value);
                        },
                      ),
                      RadioListTile<String>(
                        activeColor: FeedbackPage.darkBrown,
                        title: const Text('Confusing',
                            style: TextStyle(color: FeedbackPage.darkBrown)),
                        value: 'Confusing',
                        groupValue: clarity,
                        onChanged: (value) {
                          setState(() => clarity = value);
                        },
                      ),
                    ],
                  ),

                  const SizedBox(height: 16),

                  const Text(
                    '4. Did you feel the medical information provided was accurate and reliable?',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: FeedbackPage.darkBrown,
                    ),
                  ),
                  SwitchListTile(
                    activeColor: FeedbackPage.darkBrown,
                    title: Text(
                      infoAccurate ? 'Yes' : 'No',
                      style: const TextStyle(color: FeedbackPage.darkBrown),
                    ),
                    value: infoAccurate,
                    onChanged: (value) {
                      setState(() => infoAccurate = value);
                    },
                  ),

                  const SizedBox(height: 16),

                  const Text(
                    '5. Do you feel your data is safe in the app?',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: FeedbackPage.darkBrown,
                    ),
                  ),
                  SwitchListTile(
                    activeColor: FeedbackPage.darkBrown,
                    title: Text(
                      dataSafe ? 'Yes' : 'No',
                      style: const TextStyle(color: FeedbackPage.darkBrown),
                    ),
                    value: dataSafe,
                    onChanged: (value) {
                      setState(() => dataSafe = value);
                    },
                  ),

                  const SizedBox(height: 16),

                  const Text(
                    '6. Did the app meet your healthcare needs?',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: FeedbackPage.darkBrown,
                    ),
                  ),
                  SwitchListTile(
                    activeColor: FeedbackPage.darkBrown,
                    title: Text(
                      healthcareNeedsMet ? 'Yes' : 'No',
                      style: const TextStyle(color: FeedbackPage.darkBrown),
                    ),
                    value: healthcareNeedsMet,
                    onChanged: (value) {
                      setState(() => healthcareNeedsMet = value);
                    },
                  ),

                  const SizedBox(height: 16),

                  const Text(
                    '7. What would you improve about the app?',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: FeedbackPage.darkBrown,
                    ),
                  ),
                  TextField(
                    controller: suggestionsController,
                    decoration: InputDecoration(
                      hintText: 'Enter your feedback here',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: const BorderSide(color: FeedbackPage.darkBrown),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: const BorderSide(color: FeedbackPage.darkBrown, width: 2),
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                          horizontal: 14, vertical: 12),
                    ),
                    maxLines: 3,
                  ),

                  const SizedBox(height: 30),
                  
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: _submitFeedback,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: FeedbackPage.darkBrown,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14),
                        ),
                        elevation: 6,
                      ),
                      child: const Text(
                        'Submit Feedback',
                        style: TextStyle(
                          color: FeedbackPage.beige,
                          fontSize: 16,
                          fontWeight: FontWeight.bold
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class ThankYouScreen extends StatelessWidget {
  const ThankYouScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF4A3728),
      body: SafeArea(
        child: Center(
          child: Container(
            width: 400,
            padding: const EdgeInsets.all(40),
            decoration: BoxDecoration(
              color: const Color(0xFFDECBB7),
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
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(
                  Icons.check_circle,
                  color: Color(0xFF4B2A17),
                  size: 80,
                ),
                const SizedBox(height: 20),
                const Text(
                  'Thank You!',
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF4B2A17),
                  ),
                ),
                const SizedBox(height: 16),
                const Text(
                  'Your feedback has been submitted successfully.',
                  style: TextStyle(
                    fontSize: 16,
                    color: Color(0xFF4B2A17),
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 8),
                const Text(
                  'We appreciate your input and will use it to improve MedHive.',
                  style: TextStyle(
                    fontSize: 14,
                    color: Color(0xFF666666),
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 30),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.of(context).pop(); // Go back to doctor home
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF4B2A17),
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                      elevation: 6,
                    ),
                    child: const Text(
                      'Continue',
                      style: TextStyle(
                        color: Color(0xFFDECBB7),
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
