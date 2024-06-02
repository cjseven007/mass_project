import 'package:flutter/material.dart';

class TextBox extends StatelessWidget {
  final String text;
  final TextEditingController controller;
  const TextBox({super.key, required this.text, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 5),
          child: Text(
            text,
            style: const TextStyle(fontSize: 16),
          ),
        ),
        TextField(
          controller: controller,
          keyboardType: TextInputType.number,
          decoration: InputDecoration(
            hintText: text,
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(15),
            ),
          ),
        ),
      ],
    );
  }
}
