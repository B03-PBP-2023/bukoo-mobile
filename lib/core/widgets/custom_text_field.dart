import 'package:flutter/material.dart';

class CustomTextField extends StatelessWidget {
  final TextEditingController controller;
  final String labelText;
  final String? hintText;
  final Widget? prefixIcon;
  final Widget? suffixIcon;
  final bool obscureText;
  final Function(String?)? validator;
  final String? errorText;
  final TextInputType? keyboardType;
  final int? maxLines;
  final int? minLines;

  const CustomTextField({
    super.key,
    required this.controller,
    required this.labelText,
    this.hintText,
    this.prefixIcon,
    this.suffixIcon,
    this.obscureText = false,
    this.validator,
    this.errorText,
    this.keyboardType,
    this.maxLines,
    this.minLines,
  });

  static final inputDecoration = InputDecoration(
    hintStyle: const TextStyle(color: Colors.grey, fontSize: 16.0),
    contentPadding:
        const EdgeInsets.symmetric(horizontal: 24.0, vertical: 12.0),
    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(16.0),
      borderSide: const BorderSide(color: Colors.grey, width: 2.0),
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(16.0),
      borderSide: const BorderSide(color: Color(0xFF354259), width: 2.0),
    ),
    errorBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(16.0),
      borderSide: const BorderSide(color: Colors.grey, width: 2.0),
    ),
    focusedErrorBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(16.0),
      borderSide: const BorderSide(color: Colors.grey, width: 2.0),
    ),
  );

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(labelText,
            style:
                const TextStyle(fontSize: 18.0, fontWeight: FontWeight.w500)),
        const SizedBox(height: 8.0),
        TextFormField(
          controller: controller,
          obscureText: obscureText,
          obscuringCharacter: '*',
          keyboardType: keyboardType,
          maxLines: obscureText ? 1 : maxLines,
          minLines: minLines,
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'This field must not be empty';
            }
            if (validator != null) {
              return validator!(value);
            }
            return null;
          },
          decoration: inputDecoration.copyWith(
            errorText: errorText,
            errorMaxLines: 2,
            prefixIcon: prefixIcon,
            prefixIconColor: Colors.grey[400]!,
            suffixIcon: suffixIcon,
            suffixIconColor: Colors.grey[400]!,
            hintText: hintText,
          ),
        ),
      ],
    );
  }
}
