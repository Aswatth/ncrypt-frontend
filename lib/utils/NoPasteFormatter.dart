import 'package:flutter/services.dart';

class NoPasteFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue,
      TextEditingValue newValue,
      ) {
    if (newValue.text.length > oldValue.text.length &&
        newValue.text.length - oldValue.text.length > 1) {
      return oldValue;
    }
    return newValue;
  }
}