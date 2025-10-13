import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class InputField extends StatelessWidget {
  final String hintText;
  final Widget? suffixIcon;
  final Widget? prefixIcon;
  final TextEditingController? controller;
  final List<TextInputFormatter>? inputFormatters;
  final int minLines;
  final String? Function(String?)? validator;
  final TextInputType? keyboardType;
  const InputField({
    super.key,
    required this.hintText,
    this.suffixIcon,
    this.prefixIcon,
    this.controller,
    this.inputFormatters,
    this.minLines = 1,
    this.validator,
    this.keyboardType,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      minLines: minLines,
      maxLines: minLines,
      validator: validator,
      inputFormatters: inputFormatters,
      keyboardType: keyboardType,
      decoration: InputDecoration(
        labelText: hintText,
        labelStyle: const TextStyle(
          textBaseline: TextBaseline.ideographic,
        ),
        suffixIcon: suffixIcon,
        prefixIcon: prefixIcon,
        border: const OutlineInputBorder(
          borderSide: BorderSide(),
        ),
      ),
    );
  }
}
