import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class NavButton extends StatelessWidget {
  final bool isSelected;
  final String iconName;
  final VoidCallback onTap;

  const NavButton({
    super.key,
    required this.isSelected,
    required this.iconName,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: SizedBox(
          child: Image.asset(
            'assets/icons/${iconName}.png',
            color: isSelected ? Colors.white : Colors.grey[600],
            height: 22.h,
          ),
        ),
      ),
    );
  }
}
