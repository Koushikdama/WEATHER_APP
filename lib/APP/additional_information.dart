// ignore_for_file: file_names

import 'package:flutter/material.dart';

class AdditionalInformation extends StatelessWidget {
  final IconData icon;
  final String condition;
  final String digit;

  const AdditionalInformation(
      {super.key,
      required this.icon,
      required this.condition,
      required this.digit});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Icon(
          icon,
          size: 40,
        ),
        const SizedBox(height: 15),
        Text(
          condition,
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
        ),
        const SizedBox(height: 10),
        Text(digit,
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 20))
      ],
    );
  }
}
