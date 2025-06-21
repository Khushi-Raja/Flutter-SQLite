import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

class CustomTextButton extends StatelessWidget {
  final void Function()? onPressed;
  final String data;
  final Color? color;
  const CustomTextButton({super.key, this.onPressed, required this.data, this.color});

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: () => Navigator.pop(context),
      style: ButtonStyle(
        overlayColor: WidgetStateProperty.all(Colors.transparent),
        padding: WidgetStateProperty.all(EdgeInsets.zero),
        tapTargetSize: MaterialTapTargetSize.shrinkWrap, // optional
      ),
      child: Text(
        data,
        style: TextStyle(fontSize: 16.sp, color: color),
      ),
    );
  }
}
