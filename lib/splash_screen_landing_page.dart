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
          // Large top circle
          AnimatedPositioned(
            duration: Duration(milliseconds: 1500),
            curve: Curves.easeInOut,
            top: _animationStarted 
                ? -screenSize.width * 0.6 - 200 
                : -screenSize.width * 0.6,
            left: -screenSize.width * 0.3,
            child: Container(
              width: screenSize.width * 1.6,
              height: screenSize.width * 1.6,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: const Color(0xFF3B2010), // slightly darker brown
              ),
            ),
          ),

          // Center middle circle (foreground)
          AnimatedPositioned(
            duration: Duration(milliseconds: 1500),
            curve: Curves.easeInOut,
            top: _animationStarted 
                ? screenSize.height * 0.25 - 200 
                : screenSize.height * 0.25,
            left: screenSize.width * 0.2,
            child: Container(
              width: screenSize.width * 0.6,
              height: screenSize.width * 0.6,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: const Color(0xFF9B8B83), // taupe-gray
              ),
            ),
          ),

          // Centered logo and text
          AnimatedPositioned(
            duration: Duration(milliseconds: 1500),
            curve: Curves.easeInOut,
            top: _animationStarted 
                ? screenSize.height * 0.35 - 200 
                : screenSize.height * 0.35,
            left: 0,
            right: 0,
            child: Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Image.asset(
                    'assets/images/logo.png',
                    width: screenSize.width * 0.6 * 0.8,
                    height: screenSize.width * 0.6 * 0.8,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}