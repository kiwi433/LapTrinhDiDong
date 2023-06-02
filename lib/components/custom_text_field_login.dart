import 'package:flutter/material.dart';

class CustomText extends StatelessWidget {
  final TextEditingController controller;
  final String hintText;
  final String lableText;
  final IconData? icon; //? được phép null
  final bool obscureText;
  final double radius;

  const CustomText({
    super.key,
    required this.controller,
    required this.hintText,
    this.icon,
    this.obscureText = false,
    this.radius = 14.0,
    required this.lableText,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 50.0,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(radius),
      ),
      child: TextFormField(
        onChanged: (text) {
          print('First text field: $text');
        },
        controller: controller,
        obscureText: obscureText,
        decoration: InputDecoration(
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.red),
            borderRadius: BorderRadius.circular(radius),
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(radius),
          ),
          hintText: hintText,
          labelText: lableText,
          floatingLabelStyle:
              MaterialStateTextStyle.resolveWith((Set<MaterialState> states) {
            final Color color = states.contains(MaterialState.error)
                ? Theme.of(context).colorScheme.error
                : Colors.deepPurple;
            return TextStyle(color: color, letterSpacing: 1.3);
          }),
          hintStyle: TextStyle(color: Colors.grey.withOpacity(0.86)),
          prefixIcon: icon == null
              ? null
              : Icon(
                  icon,
                  color: Colors.red[800],
                ),
          prefixIconConstraints: const BoxConstraints(minWidth: 50.0),
        ),
        autovalidateMode: AutovalidateMode.always,
      ),
    );
  }
}
