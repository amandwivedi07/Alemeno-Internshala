import 'package:ameno/helpers.dart';
import 'package:flutter/material.dart';

class GoodJobScreen extends StatelessWidget {
  const GoodJobScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          'GOOD JOB',
          style: TextStyle(
              fontSize: 48, fontWeight: FontWeight.bold, color: kPrimaryColor),
        )
      ],
    ));
  }
}
