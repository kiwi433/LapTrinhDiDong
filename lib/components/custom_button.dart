import 'package:flutter/material.dart';

class CustomButton extends StatelessWidget {
  final VoidCallback onPressed;
  final double? width;
  final double height;
  final String text;
  final Color color;
  final Color borderColor;
  final Color textColor;
  final double radius;

  const CustomButton({
    super.key,
    required this.onPressed,
    this.width,
    this.height = 42.0,
    required this.text,
    this.color = const Color.fromARGB(255, 198, 40, 40),
    this.textColor = Colors.black,
    this.radius = 8.6,
    this.borderColor = Colors.yellow,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      child: ElevatedButton(
        onPressed: onPressed,
        style: ButtonStyle(
          backgroundColor: MaterialStateProperty.all(Colors.red[800]),
        ),
        child: Text(
          text,
          style: const TextStyle(color: Colors.white),
        ),
      ),
    );
  }
}
