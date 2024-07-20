import 'package:flutter/material.dart';

class TextFormWidget extends StatelessWidget {
  const TextFormWidget(
      {super.key,
      required this.Controller,
      required this.label,
      required this.keyboardType,
      this.validator,
      this.maxLine,
      this.minLine});

  final TextEditingController Controller;
  final String label;
  final String? Function(String?)? validator;
  final TextInputType? keyboardType;
  final int? maxLine;
  final int? minLine;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 7),
      child: TextFormField(
        maxLines:maxLine ?? 1 ,
        minLines: minLine,
        keyboardType: keyboardType,
        validator: validator,
        autovalidateMode:
            validator != null ? AutovalidateMode.onUserInteraction : null,
        controller: Controller,
        decoration:
            InputDecoration(label: Text(label), border: const OutlineInputBorder()),
      ),
    );
  }
}
