import 'package:flutter/material.dart';
import 'OnBoarding.dart';

class LogoScreen extends StatefulWidget {
  @override
  _LogoScreenState createState() => _LogoScreenState();
}

class _LogoScreenState extends State<LogoScreen> {
  double _opacity = 0.0;

  @override
  void initState() {
    super.initState();

    // Mulai animasi fade-in
    Future.delayed(Duration(milliseconds: 500), () {
      setState(() {
        _opacity = 1.0;
      });
    });

    // Navigasi otomatis ke layar berikutnya setelah 5 detik dengan animasi transisi fade-in
    Future.delayed(Duration(seconds: 5), () {
      Navigator.pushReplacement(
        context,
        PageRouteBuilder(
          pageBuilder: (context, animation, secondaryAnimation) => OnboardingScreen(),
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            var tween = Tween(begin: 0.0, end: 1.0).chain(CurveTween(curve: Curves.easeInOut));
            var fadeAnimation = animation.drive(tween);

            return FadeTransition(
              opacity: fadeAnimation,
              child: child,
            );
          },
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: LayoutBuilder(
        builder: (context, constraints) {
          double imageWidth = constraints.maxWidth * 0.6;
          double titleFontSize = constraints.maxWidth * 0.06;
          double subtitleFontSize = constraints.maxWidth * 0.04;

          titleFontSize = titleFontSize.clamp(16.0, 32.0);
          subtitleFontSize = subtitleFontSize.clamp(12.0, 24.0);

          return Center(
            child: AnimatedOpacity(
              duration: Duration(seconds: 2), // Durasi animasi fade-in
              opacity: _opacity,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset(
                    'lib/pov_customer/assets/images/AppLogo.png',
                    width: imageWidth.clamp(100.0, 300.0),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    "NaikPete'",
                    style: TextStyle(
                      fontSize: titleFontSize,
                      fontWeight: FontWeight.bold,
                      color: const Color(0xFF42C8DC),
                    ),
                  ),
                  Text(
                    "Layanan Pete-Pete Online",
                    style: TextStyle(
                      fontSize: subtitleFontSize,
                      color: Colors.black87,
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
