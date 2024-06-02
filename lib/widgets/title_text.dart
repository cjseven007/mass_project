import 'package:flutter/material.dart';

class TitleText extends StatelessWidget {
  final String title;
  const TitleText({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 12, 0, 0),
      child: Text(
        title,
        style: const TextStyle(
            color: Color(0xff0f7497),
            fontSize: 24,
            fontWeight: FontWeight.w900),
      ),
    );
  }
}
