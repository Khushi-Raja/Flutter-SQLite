import 'package:flutter/material.dart';

class CustomContainer extends StatelessWidget {
  final String data;
  final Color? color;
  final EdgeInsetsGeometry? padding;
  final AlignmentGeometry? alignment;
  final double? fontSize;

  const CustomContainer(
      {super.key,
      required this.data,
      this.color,
      this.padding,
      this.alignment,
      this.fontSize});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: padding,
      alignment: alignment ?? Alignment.center,
      child: Text(
        data,
        style: TextStyle(
            fontWeight: FontWeight.w500, color: color, fontSize: fontSize),
      ),
    );
  }
}
