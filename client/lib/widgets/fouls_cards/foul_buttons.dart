import 'package:flutter/material.dart';

class FoulsCardsFoulButtons extends StatelessWidget {
  final bool red;
  final bool subtractionMode;
  final VoidCallback onMinorFoul;
  final VoidCallback onMajorFoul;

  const FoulsCardsFoulButtons({
    super.key,
    required this.red,
    required this.subtractionMode,
    required this.onMinorFoul,
    required this.onMajorFoul,
  });

  Widget _largeButton({required VoidCallback onPressed, required Widget child}) {
    return Container(
      margin: EdgeInsets.all(20),
      padding: EdgeInsets.all(10),
      width: double.infinity,
      child: OutlinedButton(
        style: OutlinedButton.styleFrom(
          backgroundColor: red ? Colors.red : Colors.blue,
          shadowColor: Colors.black,
          side: BorderSide(color: Colors.black, width: 5),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8), // square corners
          ),
        ),
        onPressed: onPressed,
        child: child,
      ),
    );
  }

  Widget _label(String kind) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        if (subtractionMode)
          Text(
            "SUBTRACT",
            style: TextStyle(
              color: Colors.yellow,
              fontSize: 40,
              fontWeight: FontWeight.bold,
              decoration: TextDecoration.underline,
            ),
          ),
        Text(
          kind,
          style: TextStyle(
            color: Colors.white,
            fontSize: 40,
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          "FOUL",
          style: TextStyle(
            color: Colors.white,
            fontSize: 40,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        Expanded(child: _largeButton(onPressed: onMinorFoul, child: _label("MINOR"))),
        Expanded(child: _largeButton(onPressed: onMajorFoul, child: _label("MAJOR"))),
      ],
    );
  }
}
