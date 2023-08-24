// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';

class FullWidthButton extends StatelessWidget {
  const FullWidthButton({
    Key? key,
    required this.text,
    required this.onPress,
    required this.color,
  }) : super(key: key);

  final String text;
  final VoidCallback onPress;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPress,
      style: ElevatedButton.styleFrom(
          minimumSize: const Size(double.infinity, 40), backgroundColor: color),
      child: Text(
        text,
        style: const TextStyle(fontSize: 20, color: Colors.white),
      ),
    );
  }
}
