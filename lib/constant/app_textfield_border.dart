import 'package:flutter/material.dart';

class AppTextfieldBorder {
  static OutlineInputBorder focusedBorder = OutlineInputBorder(
    borderRadius: BorderRadius.circular(12),
    borderSide: const BorderSide(color: Color(0XFF23408F), width: 1),
  );

  static OutlineInputBorder enabledBorder = OutlineInputBorder(
    borderSide: const BorderSide(color: Color(0XFFDEDEDE), width: 1),
    borderRadius: BorderRadius.circular(12),
  );

  static OutlineInputBorder errorBorder = OutlineInputBorder(
    borderRadius: BorderRadius.circular(12),
    borderSide:
        const BorderSide(color: Color.fromARGB(255, 215, 5, 5), width: 1),
  );
  static OutlineInputBorder focusedErrorBorder = OutlineInputBorder(
    borderRadius: BorderRadius.circular(12),
    borderSide:
        const BorderSide(color: Color.fromARGB(255, 215, 5, 5), width: 1.6),
  );
}
