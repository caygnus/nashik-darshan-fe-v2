import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class InputField extends StatelessWidget {
  final String hintText;
  final Widget? suffixIcon;
  final Widget? prefixIcon;
  final TextEditingController? controller;
  final List<TextInputFormatter>? inputFormatters;
  final int minLines;
  final int? maxLines;
  final String? Function(String?)? validator;
  final TextInputType? keyboardType;
  final bool obscureText;
  final TextCapitalization textCapitalization;
  final bool autocorrect;
  final bool readOnly;
  final void Function(String)? onChanged;
  const InputField({
    super.key,
    required this.hintText,
    this.suffixIcon,
    this.prefixIcon,
    this.controller,
    this.inputFormatters,
    this.minLines = 1,
    this.maxLines,
    this.validator,
    this.keyboardType,
    this.obscureText = false,
    this.textCapitalization = TextCapitalization.none,
    this.autocorrect = true,
    this.readOnly = false,
    this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      minLines: minLines,
      maxLines: maxLines,
      validator: validator,
      inputFormatters: inputFormatters,
      keyboardType: keyboardType,
      decoration: InputDecoration(
        labelText: hintText,
        labelStyle: const TextStyle(textBaseline: TextBaseline.ideographic),
        suffixIcon: suffixIcon,
        prefixIcon: prefixIcon,
        // border: const OutlineInputBorder(borderSide: BorderSide()),
      ),
      obscureText: obscureText,
      textCapitalization: textCapitalization,
      autocorrect: autocorrect,
      readOnly: readOnly,
      onChanged: onChanged,
    );
  }
}
