import 'package:flutter/material.dart';

class TermsAndConditionsPage extends StatefulWidget {
  const TermsAndConditionsPage({super.key});

  static const Color beige = Color.fromRGBO(222, 203, 183, 1);
  static const Color darkBrown = Color.fromRGBO(80, 52, 30, 1);

  @override
  State<TermsAndConditionsPage> createState() => _TermsAndConditionsPageState();
}

class _TermsAndConditionsPageState extends State<TermsAndConditionsPage> {
  final ScrollController _scrollController = ScrollController();
  bool _isAtBottom = false;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(() {
      if (_scrollController.offset >=
              _scrollController.position.maxScrollExtent &&
          !_scrollController.position.outOfRange) {
        setState(() {
          _isAtBottom = true;
        });
      }
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  bool get _canAccept => _isAtBottom;

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      child: Container(
        width: 600,
        height: 700,
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: TermsAndConditionsPage.beige,
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
                const Icon(Icons.description,
                    color: TermsAndConditionsPage.darkBrown, size: 28),
                const SizedBox(width: 8),
                const Text(
                  'Terms & Conditions',
                  style: TextStyle(
                    color: TermsAndConditionsPage.darkBrown,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const Spacer(),
                GestureDetector(
                  onTap: () => Navigator.of(context).pop(),
                  child: const Icon(Icons.close,
                      color: TermsAndConditionsPage.darkBrown, size: 22),
                ),
              ],
            ),
            const Divider(color: TermsAndConditionsPage.darkBrown),
            const SizedBox(height: 8),

            Expanded(
              child: Scrollbar(
                thumbVisibility: true,
                controller: _scrollController,
                child: SingleChildScrollView(
                  controller: _scrollController,
                  child: const SelectableText(
                    '''
MedHive - Terms and Conditions
Effective Date: 10.10.2025

1. Introduction
These Terms and Conditions govern your access to and use of the MedHive application ("App"). MedHive is a software platform built to provide hospitals and authorized healthcare providers with real-time patient information. By accessing or using the App, you agree to be bound by these Terms.

2. Scope and Use
MedHive is provided to hospitals and healthcare organizations ("Customers"). Only authorized users such as hospital staff and clinicians may access the App and patient information.

3. Medical Disclaimer
MedHive provides real-time information to support care delivery. It does not replace professional medical judgment, diagnosis, or treatment. All medical decisions must be made by qualified healthcare professionals.

4. Privacy and Data Protection
MedHive values your privacy. Any personal or health-related data is processed in compliance with applicable healthcare data protection laws (such as HIPAA, GDPR). Hospitals remain responsible for ensuring patient consent and lawful use of data.

5. Intellectual Property
All content, software, and trademarks within MedHive remain the property of MedHive or its licensors. Unauthorized reproduction, modification, or distribution is prohibited.

6. Limitations of Liability
MedHive is provided "as is" without warranties of any kind. To the maximum extent permitted by law, MedHive is not liable for indirect or consequential damages arising from the use of the App.

7. Termination
MedHive may suspend or terminate access in cases of misuse, security risks, or violations of these Terms. Hospitals may also request termination of user access.

8. Updates and Modifications
MedHive may update these Terms from time to time. Continued use of the App after changes means acceptance of the updated Terms.

9. Governing Law
These Terms shall be governed by the applicable laws of the Customer's jurisdiction, unless otherwise agreed.

10. Contact
For inquiries regarding these Terms:
MedHive Legal Team
Email: legal@medhive.com

By using MedHive, you acknowledge that you have read, understood, and agree to these Terms and Conditions.
                    ''',
                    style: TextStyle(
                      color: TermsAndConditionsPage.darkBrown,
                      fontSize: 14,
                      height: 1.4,
                    ),
                  ),
                ),
              ),
            ),

            const SizedBox(height: 20),

            Row(
              children: [
                Icon(
                  Icons.check_circle,
                  color: TermsAndConditionsPage.darkBrown,
                  size: 24,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    'I have read and agree to the Terms & Conditions',
                    style: TextStyle(
                      color: TermsAndConditionsPage.darkBrown,
                      fontWeight: FontWeight.normal,
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 10),

            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                      onPressed: _canAccept
                          ? () {
                              Navigator.of(context).pop();
                            }
                          : null,
                style: ElevatedButton.styleFrom(
                  backgroundColor: TermsAndConditionsPage.darkBrown,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                  elevation: 6,
                ),
                        child: Text(
                          _canAccept ? 'Accept' : 'Scroll to Accept',
                          style: const TextStyle(
                            color: TermsAndConditionsPage.beige,
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
