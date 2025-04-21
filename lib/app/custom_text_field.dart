import 'package:flutter/material.dart';

class CustomTextField extends StatelessWidget {
  final TextEditingController controller;
  final String prefixIconPath;
  final String? suffixIconPath;
  final bool? obscureText;
  const CustomTextField({
    super.key,
    required this.controller,
    required this.prefixIconPath,
    this.suffixIconPath,
    this.obscureText,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      obscureText: obscureText ?? false,
      controller: controller,
      decoration: InputDecoration(
        prefixIcon: Image.asset(prefixIconPath),
        suffixIcon:
            suffixIconPath != null
                ? Image.asset(
                  suffixIconPath!,
                )
                : null,
      ),
    );
  }
}
