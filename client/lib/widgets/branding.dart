import 'package:flutter/material.dart';

class BrandingLogo extends StatelessWidget {
  final double fontSize;

  const BrandingLogo({super.key, this.fontSize = 100});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        "Ref-Link",
        style: TextStyle(
          color: Colors.grey,
          fontWeight: FontWeight.bold,
          fontSize: fontSize,
        ),
      ),
    );
  }
}
