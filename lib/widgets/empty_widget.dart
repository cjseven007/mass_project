import 'package:flutter/material.dart';

class EmptyWidget extends StatelessWidget {
  final String text;
  const EmptyWidget({super.key, required this.text});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          height: MediaQuery.of(context).size.height / 3,
        ),
        Center(
          child: Text(
            text,
            style: TextStyle(color: Color(0xff0f7497), fontSize: 20),
          ),
        ),
      ],
    );
  }
}
