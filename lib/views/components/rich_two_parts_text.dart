import 'package:flutter/material.dart';

class RichTwoPartstext extends StatelessWidget {
  final String leftPart;
  final String rightPart;
  const RichTwoPartstext({
    super.key,
    required this.leftPart,
    required this.rightPart,
  });

  @override
  Widget build(BuildContext context) {
    return RichText(
        text: TextSpan(
            style: const TextStyle(
              color: Colors.white70,
              height: 1.5,
            ),
            children: [
          TextSpan(
              text: leftPart,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
              )),
          TextSpan(
            text: ' $rightPart',
          ),
        ]));
  }
}
