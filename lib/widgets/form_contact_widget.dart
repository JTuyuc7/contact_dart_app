import 'package:flutter/material.dart';

class FormContactWidget extends StatelessWidget {
  final TextEditingController controller;
  final String labelText;
  final String validationText;
  final TextInputType keyboardType;
  bool shouldValidate = false;

  FormContactWidget({
    super.key,
    required this.controller,
    required this.labelText,
    required this.validationText,
    required this.keyboardType,
    this.shouldValidate = false,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      keyboardType: keyboardType,
      controller: controller,
      decoration: InputDecoration(labelText: labelText),
      validator: (value) {
        if (shouldValidate) {
          if (value == null || value.isEmpty) {
            return validationText;
          }
        }
        return null;
      },
    );
  }
}
