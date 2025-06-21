import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

class CustomButton extends StatelessWidget {
  final String buttonName; // Button text label
  final Color backgroundColor; // Background color of the button
  final Color textColor; // Text color of the button
  final VoidCallback
      onPressed; // Function to execute when the button is pressed

  const CustomButton({
    super.key,
    required this.buttonName,
    required this.backgroundColor,
    required this.textColor,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 6.h,
      width: 90.w,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(2.w),
          ),
          backgroundColor: Colors.black,
        ),
        child: Text(
          buttonName,
          style:
          TextStyle(color: Colors.white, fontSize: 16.sp),
        ),
      ),
    );
  }
}
