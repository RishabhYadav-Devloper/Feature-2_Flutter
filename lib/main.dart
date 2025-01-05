import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(primarySwatch: Colors.blue),
      home: AnimatedButtonScreen(),
    );
  }
}

class AnimatedButtonScreen extends StatefulWidget {
  @override
  _AnimatedButtonScreenState createState() => _AnimatedButtonScreenState();
}

class _AnimatedButtonScreenState extends State<AnimatedButtonScreen> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  late Animation<Color?> _colorAnimation;

  bool _isButtonPressed = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );

    _scaleAnimation = Tween<double>(begin: 1.0, end: 1.2).animate(
      CurvedAnimation(parent: _controller, curve: Curves.elasticInOut),
    );

    _colorAnimation = ColorTween(begin: Colors.blue, end: Colors.green).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _onButtonPressed() {
    setState(() {
      _isButtonPressed = true; // Mark button as pressed to trigger animation
    });
    _controller.forward(); // Start the animation when the button is pressed

    // Simulate some action like API call or animation delay, then reset the button.
    Future.delayed(Duration(seconds: 1), () {
      setState(() {
        _isButtonPressed = false; // Reset button after 1 second
      });
      _controller.reverse(); // Reverse the animation
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Animated Botton')),
      body: Center(
        child: GestureDetector(
          onTap: _onButtonPressed, // Handle tap event
          child: AnimatedBuilder(
            animation: _controller,
            builder: (context, child) {
              return Transform.scale(
                scale: _scaleAnimation.value,
                child: Material(
                  color: _colorAnimation.value,
                  borderRadius: BorderRadius.circular(30),
                  child: InkWell(
                    borderRadius: BorderRadius.circular(30),
                    splashColor: Colors.white.withOpacity(0.5), // Ripple effect color
                    highlightColor: Colors.transparent, // Transparent highlight
                    child: Container(
                      padding: EdgeInsets.symmetric(vertical: 15, horizontal: 40),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(30),
                        boxShadow: [
                          if (!_isButtonPressed)
                            BoxShadow(
                              color: Colors.blue.withOpacity(0.5),
                              blurRadius: 10,
                              spreadRadius: 2,
                              offset: Offset(0, 5),
                            ),
                        ],
                      ),
                      child: Text(
                        _isButtonPressed ? 'Processing...' : 'Press Me',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}