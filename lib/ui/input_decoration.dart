import 'package:flutter/material.dart';

class InputDecorations {
  static InputDecoration authInputDecoration({
   required String hintText, 
   required String labelText,
   IconData? prefixIcon,
  }) {
    return InputDecoration(
      enabledBorder: const UnderlineInputBorder(
        borderSide: BorderSide(
          color: Colors.deepPurple,
        ),
      ),
      focusedBorder: const UnderlineInputBorder(
        borderSide: BorderSide(
          color: Colors.deepPurple,
          width: 2,
        ),
      ),
      hintText: hintText,
      hintStyle: TextStyle(
        color: Colors.grey[400],
        fontSize: 12,
      ),
      labelText: labelText,
      labelStyle: const TextStyle(
        color: Colors.grey,
        fontSize: 12,
      ),
      prefixIcon: prefixIcon != null
        ? Icon(prefixIcon, color: Colors.deepPurple)
        : null
    );
  }
}