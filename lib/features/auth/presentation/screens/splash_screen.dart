import 'package:flutter/material.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            //Animate the logo
            Image.asset('assets/images/blue Logo.png', width: 200, height: 200),
            SizedBox(height: 4),
            Text(
              '...Moving your World Faster',
              style: TextStyle(
                color: Colors.black87,
                //fontSize: AppFonts.body,
                //fontWeight: AppFonts.regular,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
