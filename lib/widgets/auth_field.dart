import 'package:flutter/material.dart';

class AuthField extends StatelessWidget {
  final String hinttext;
  final TextEditingController controller;
  final bool isObscureText;

  const AuthField({
    super.key,
    required this.hinttext,
    required this.controller,
    this.isObscureText = false, required Icon prefixIcon,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(hintText: hinttext),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return "$hinttext is missing!";
        }
        return null;
      },
      obscureText: isObscureText,
      obscuringCharacter: '*',
    );
  }
}
