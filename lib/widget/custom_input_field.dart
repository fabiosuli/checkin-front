import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class CustomInputField extends StatelessWidget {
  final String label;
  final double width;
  final TextInputType? keyboardType;
  final List<TextInputFormatter>? inputFormatters;
  final double fontSize;
  final TextEditingController? controller;

  const CustomInputField({
    super.key,
    required this.label,
    required this.width,
    this.keyboardType,
    this.inputFormatters,
    this.fontSize = 14.0,
    this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      child: TextField(
        controller: controller,
        keyboardType: keyboardType,
        inputFormatters: inputFormatters,
        style: TextStyle(fontSize: fontSize),
        decoration: InputDecoration(
          labelText: label,
          labelStyle: const TextStyle(color: Colors.black),
          fillColor: Colors.grey[200],
          filled: true,
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8.0),
            borderSide: const BorderSide(
              color: Colors.lightBlue,
              width: 2.0,
            ),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8.0),
            borderSide: const BorderSide(
              color: Colors.grey,
              width: 1.0,
            ),
          ),
        ),
      ),
    );
  }
}
