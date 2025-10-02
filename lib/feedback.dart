import 'package:flutter/material.dart';

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
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
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
                        onTap: () => Navigator.of(context).maybePop(),
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
                    title: Text(infoAccurate ? 'Yes' : 'No'),
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
                    title: Text(dataSafe ? 'Yes' : 'No'),
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
                    title: Text(healthcareNeedsMet ? 'Yes' : 'No'),
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
                      onPressed: () {
                        print('Rating: $rating');
                        print('Navigation Ease: $navigationEase');
                        print('Clarity: $clarity');
                        print('Info Accurate: $infoAccurate');
                        print('Data Safe: $dataSafe');
                        print('Healthcare Needs Met: $healthcareNeedsMet');
                        print('Suggestions: ${suggestionsController.text}');
                      },
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
