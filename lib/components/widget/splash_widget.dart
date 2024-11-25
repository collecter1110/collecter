import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class SplashWidget extends StatelessWidget {
  const SplashWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: Stack(
        alignment: Alignment.center,
        children: [
          Center(
            child: Padding(
              padding: EdgeInsets.symmetric(
                horizontal: 90.0.w,
              ),
              child: Image.asset(
                'assets/images/image_logo.png',
                color: Colors.black,
              ),
            ),
          ),
          Positioned(
            top: MediaQuery.of(context).size.height * 0.42,
            child: Image.asset(
              'assets/images/image_logo_text.png',
              width: 150.0.w,
              fit: BoxFit.contain,
            ),
          ),
        ],
      ),
    );
  }
}
