import 'package:flutter/material.dart';

void main() {
  runApp(MedHiveApp());
}

class MedHiveApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: MedHiveSplashScreen(),
    );
  }
}

class MedHiveSplashScreen extends StatefulWidget {
  @override
  _MedHiveSplashScreenState createState() => _MedHiveSplashScreenState();
}

class _MedHiveSplashScreenState extends State<MedHiveSplashScreen> 
    with TickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _slideAnimation;
  bool _animationStarted = false;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: Duration(milliseconds: 1500),
      vsync: this,
    );
    
    _slideAnimation = Tween<double>(
      begin: 0.0,
      end: -200.0, // Move up by 200 pixels
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    ));

    // Start animation after 1 second
    Future.delayed(Duration(seconds: 1), () {
      if (mounted) {
        setState(() {
          _animationStarted = true;
        });
        _animationController.forward();
      }
    });
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: const Color(0xFF4B2A17), // dark brown background
      body: Stack(
        children: [
          // Large top circle (centered with small circle)
          AnimatedPositioned(
            duration: Duration(milliseconds: 1500),
            curve: Curves.easeInOut,
            // Center the big circle with the small circle
            top: _animationStarted
                ? (0 + (screenSize.width * 0.6) / 2) - (screenSize.width * 1.6) / 2
                : (screenSize.height * 0.25 + (screenSize.width * 0.6) / 2) - (screenSize.width * 1.6) / 2,
            left: (screenSize.width * 0.2) + (screenSize.width * 0.6) / 2 - (screenSize.width * 1.6) / 2,
            child: Container(
              width: screenSize.width * 1.6,
              height: screenSize.width * 1.6,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: const Color(0xFF7A5A3A), // lighter brown than background, darker than small circle
              ),
            ),
          ),

          // Center middle circle (foreground) with centered logo
          AnimatedPositioned(
            duration: Duration(milliseconds: 1500),
            curve: Curves.easeInOut,
            top: _animationStarted 
                ? 0 // After animation, circle touches the top
                : screenSize.height * 0.25,
            left: 0,
            child: SizedBox(
              width: screenSize.width,
              height: screenSize.width,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  Container(
                    width: screenSize.width,
                    height: screenSize.width,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: const Color(0xFF9B8B83), // taupe-gray
                    ),
                  ),
                  Image.asset(
                    'assets/images/logo.png',
                    width: screenSize.width * 0.8,
                    height: screenSize.width * 0.8,
                  ),
                ],
              ),
            ),
          ),

          // Centered logo and text (remove logo from here)
          AnimatedPositioned(
            duration: Duration(milliseconds: 1500),
            curve: Curves.easeInOut,
            top: _animationStarted 
                ? screenSize.height * 0.5 - 200 
                : screenSize.height * 0.5,
            left: 0,
            right: 0,
            child: Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Image.asset(
                  //   'assets/images/logo.png',
                  //   width: screenSize.width * 0.6 * 0.8,
                  //   height: screenSize.width * 0.6 * 0.8,
                  // ),
                ],
              ),
            ),
          ),

          // LOG IN Button
          AnimatedPositioned(
            duration: Duration(milliseconds: 1500),
            curve: Curves.easeInOut,
            top: _animationStarted 
                ? screenSize.height * 0.7
                : screenSize.height + 100, // Start below screen
            left: screenSize.width * 0.1,
            right: screenSize.width * 0.1,
            child: Container(
              height: 56,
              decoration: BoxDecoration(
                color: const Color(0xFF9B8B83), // taupe-gray matching the circle
                borderRadius: BorderRadius.circular(28),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.3),
                    blurRadius: 12,
                    offset: Offset(0, 6),
                    spreadRadius: 2,
                  ),
                ],
              ),
              child: Center(
                child: Text(
                  'LOG IN',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1.0,
                  ),
                ),
              ),
            ),
          ),

          // SIGN UP Button
          AnimatedPositioned(
            duration: Duration(milliseconds: 1500),
            curve: Curves.easeInOut,
            top: _animationStarted 
                ? screenSize.height * 0.8
                : screenSize.height + 200, // Start below screen with more offset
            left: screenSize.width * 0.1,
            right: screenSize.width * 0.1,
            child: Container(
              height: 56,
              decoration: BoxDecoration(
                color: const Color(0xFF9B8B83), // taupe-gray matching the circle
                borderRadius: BorderRadius.circular(28),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.3),
                    blurRadius: 12,
                    offset: Offset(0, 6),
                    spreadRadius: 2,
                  ),
                ],
              ),
              child: Center(
                child: Text(
                  'SIGN UP',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1.0,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}