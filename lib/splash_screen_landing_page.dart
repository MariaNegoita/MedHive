import 'package:flutter/material.dart';
import 'login_screen.dart';
import 'signup_screen.dart';

// Root widget that sets up the MaterialApp configuration
class MedHiveApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false, // Hide debug banner for cleaner UI
      home: MedHiveSplashScreen(), // Start with the splash screen
    );
  }
}

// Splash screen widget that handles the initial app loading animation
class MedHiveSplashScreen extends StatefulWidget {
  @override
  _MedHiveSplashScreenState createState() => _MedHiveSplashScreenState();
}

// State class for the splash screen with animation capabilities
class _MedHiveSplashScreenState extends State<MedHiveSplashScreen> 
    with TickerProviderStateMixin { // Provides vsync for animations
  
  // Animation controller to manage the slide-up animation
  late AnimationController _animationController;
  
  // Animation that defines the slide-up movement
  late Animation<double> _slideAnimation;
  
  // Flag to track when the animation should start
  bool _animationStarted = false;


  // Method to handle LOG IN button press
  void _handleLogin() {
    Navigator.of(context).push(
      MaterialPageRoute(builder: (_) => LoginScreen()),
    );
  }

  // Method to handle SIGN UP button press
  void _handleSignUp() {
    Navigator.of(context).push(
      MaterialPageRoute(builder: (_) => SignUpScreen()),
    );
  }


  @override
  void initState() {
    super.initState();
    
    // Initialize animation controller with 1.5 second duration
    _animationController = AnimationController(
      duration: Duration(milliseconds: 1500),
      vsync: this,
    );
    
    // Create slide animation: moves elements up by 200 pixels
    _slideAnimation = Tween<double>(
      begin: 0.0,        // Starting position
      end: -200.0,       // End position (200px up)
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut, // Smooth acceleration and deceleration
    ));

    // Delay animation start by 1 second for dramatic effect
    Future.delayed(Duration(seconds: 1), () {
      if (mounted) { // Check if widget is still mounted
        setState(() {
          _animationStarted = true; // Trigger animation state
        });
        _animationController.forward(); // Start the animation
      }
    });
  }

  @override
  void dispose() {
    // Clean up animation controller to prevent memory leaks
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Get screen dimensions for responsive design
    final screenSize = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: const Color(0xFF50341E), // Dark brown background - same as login/signup
      body: Stack(
        children: [
          // Large background circle that creates depth
          AnimatedPositioned(
            duration: Duration(milliseconds: 1500),
            curve: Curves.easeInOut,
            // Calculate position to keep big circle centered with small circle
            top: _animationStarted
                ? (0 + (screenSize.width * 0.6) / 2) - (screenSize.width * 1.6) / 2
                : (screenSize.height * 0.25 + (screenSize.width * 0.6) / 2) - (screenSize.width * 1.6) / 2,
            left: (screenSize.width * 0.2) + (screenSize.width * 0.6) / 2 - (screenSize.width * 1.6) / 2,
            child: Container(
              width: screenSize.width * 1.6,  // 160% of screen width
              height: screenSize.width * 1.6, // 160% of screen height
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: const Color(0xFF7A5A3A), // Medium brown - lighter than background, darker than small circle
              ),
            ),
          ),

          // Foreground circle that contains the logo
          AnimatedPositioned(
            duration: Duration(milliseconds: 1500),
            curve: Curves.easeInOut,
            top: _animationStarted 
                ? 0 // After animation: circle touches the top of screen
                : screenSize.height * 0.25, // Initial position: 25% down from top
            left: 0, // Start from left edge
            child: SizedBox(
              width: screenSize.width,  // Full screen width
              height: screenSize.width, // Full screen width (creates perfect circle)
              child: Stack(
                alignment: Alignment.center, // Center logo within circle
                children: [
                  // The circle background
                  Container(
                    width: screenSize.width,
                    height: screenSize.width,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: const Color(0xFF9B8B83), // Taupe-gray color
                    ),
                  ),
                  // Logo image centered within the circle
                  Image.asset(
                    'assets/images/logo.png',
                    width: screenSize.width * 0.8,  // 80% of circle width
                    height: screenSize.width * 0.8, // 80% of circle height
                  ),
                ],
              ),
            ),
          ),

          // LOG IN Button - slides up from below screen
          AnimatedPositioned(
            duration: Duration(milliseconds: 1500),
            curve: Curves.easeInOut,
            top: _animationStarted 
                ? screenSize.height * 0.7  // Final position: 70% down from top
                : screenSize.height + 100, // Start position: 100px below screen (invisible)
            left: screenSize.width * 0.1,  // 10% margin from left
            right: screenSize.width * 0.1, // 10% margin from right (80% width total)
            child: GestureDetector(
              onTap: _handleLogin, // Handle LOG IN button press
              child: Container(
                height: 56, // Standard button height
                decoration: BoxDecoration(
                  color: const Color(0xFF9B8B83), // Taupe-gray matching the circle
                  borderRadius: BorderRadius.circular(28), // Pill-shaped with rounded corners
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.3), // Darker shadow for depth
                      blurRadius: 12,                       // Blur effect
                      offset: Offset(0, 6),                 // Shadow below button
                      spreadRadius: 2,                      // Shadow spread
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
                      letterSpacing: 1.0, // Spacing between letters for readability
                    ),
                  ),
                ),
              ),
            ),
          ),

          // SIGN UP Button - slides up from below screen with offset
          AnimatedPositioned(
            duration: Duration(milliseconds: 1500),
            curve: Curves.easeInOut,
            top: _animationStarted 
                ? screenSize.height * 0.8  // Final position: 80% down from top
                : screenSize.height + 200, // Start position: 200px below screen (more offset than LOG IN)
            left: screenSize.width * 0.1,  // 10% margin from left
            right: screenSize.width * 0.1, // 10% margin from right (80% width total)
            child: GestureDetector(
              onTap: _handleSignUp, // Handle SIGN UP button press
              child: Container(
                height: 56, // Standard button height
                decoration: BoxDecoration(
                  color: const Color(0xFF9B8B83), // Taupe-gray matching the circle
                  borderRadius: BorderRadius.circular(28), // Pill-shaped with rounded corners
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.3), // Darker shadow for depth
                      blurRadius: 12,                       // Blur effect
                      offset: Offset(0, 6),                 // Shadow below button
                      spreadRadius: 2,                      // Shadow spread
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
                      letterSpacing: 1.0, // Spacing between letters for readability
                    ),
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