import 'package:client/core/utils/validators.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class CustomField extends StatelessWidget {
  final String hintText;
  final TextEditingController controller;
  final bool isObscureText;
  final String? Function(String?)? validator;
  final TextInputType? keyboardType;
  const CustomField({
    super.key,
    required this.hintText,
    required this.controller,
    this.isObscureText = false,
    this.validator,
    this.keyboardType,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(hintText: hintText),
      keyboardType: keyboardType,
      autocorrect: !isObscureText,
      enableSuggestions: !isObscureText,
      inputFormatters: [
        LengthLimitingTextInputFormatter(Validators.maxFieldLength),
      ],
      validator: validator ?? (value) => Validators.required(value, hintText),
      obscureText: isObscureText,
    );
  }
}
