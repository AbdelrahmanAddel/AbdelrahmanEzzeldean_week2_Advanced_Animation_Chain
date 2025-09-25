import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(home: TaskAnimation());
  }
}

class TaskAnimation extends StatefulWidget {
  const TaskAnimation({super.key});

  @override
  State<TaskAnimation> createState() => _TaskAnimationState();
}

class _TaskAnimationState extends State<TaskAnimation>
    with TickerProviderStateMixin {
  late Animation<double> _scale;
  late Animation<double> _scaleTwo;
  late Animation<double> _scaleThree;
  late Animation<Color?> _containerColor;

  late AnimationController _animationControllerOne;
  late AnimationController _animationControllerTwo;
  late AnimationController _animationControllerThree;

  @override
  void initState() {
    super.initState();

    _animationControllerOne = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    )..forward();

    _animationControllerTwo = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );

    _animationControllerThree = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );

    // sequence logic
    _animationControllerOne.addStatusListener((state) {
      if (state == AnimationStatus.completed) {
        _animationControllerTwo.forward();
      }
    });

    _animationControllerTwo.addStatusListener((state) {
      if (state == AnimationStatus.completed) {
        _animationControllerThree.forward();
      }
    });

    _animationControllerThree.addStatusListener((state) {
      if (state == AnimationStatus.completed) {
        _animationControllerOne.reset();
        _animationControllerTwo.reset();
        _animationControllerThree.reset();
        _animationControllerOne.forward();
      }
    });

    // scale
    _scale = Tween<double>(begin: 0.2, end: 1).animate(
      CurvedAnimation(parent: _animationControllerOne, curve: Curves.easeInOut),
    );
    _scaleTwo = Tween<double>(begin: 0.2, end: 1).animate(
      CurvedAnimation(parent: _animationControllerTwo, curve: Curves.easeInOut),
    );
    _scaleThree = Tween<double>(begin: 0.2, end: 1).animate(
      CurvedAnimation(
        parent: _animationControllerThree,
        curve: Curves.easeInOut,
      ),
    );

    _containerColor = ColorTween(
      begin: Colors.blueAccent.shade100.withOpacity(0.3),
      end: Colors.blueAccent.shade100,
    ).animate(_animationControllerTwo);
  }

  @override
  void dispose() {
    _animationControllerOne.dispose();
    _animationControllerTwo.dispose();
    _animationControllerThree.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ScaleTransition(
              scale: _scale,
              child: AnimatedBuilder(
                animation: _containerColor,
                builder: (context, child) {
                  return _animationContainerBuild(_containerColor.value!);
                },
              ),
            ),
            ScaleTransition(
              scale: _scaleTwo,
              child: AnimatedBuilder(
                animation: _containerColor,
                builder: (context, child) {
                  return _animationContainerBuild(_containerColor.value!);
                },
              ),
            ),
            ScaleTransition(
              scale: _scaleThree,
              child: AnimatedBuilder(
                animation: _containerColor,
                builder: (context, child) {
                  return _animationContainerBuild(_containerColor.value!);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _animationContainerBuild(Color color) {
    return Container(
      width: 30,
      height: 30,
      decoration: BoxDecoration(shape: BoxShape.circle, color: color),
    );
  }
}
