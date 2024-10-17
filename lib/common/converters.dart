import 'package:flutter/material.dart';

class Converters {
  static String convertToCamelCase(String text) {
    final words = text.split(' ');
    return '${words[0][0].toLowerCase()}${words[0].substring(1)}${words.sublist(1).map((w) => w.capitalize()).join()}';
  }

  static String convertToSnakeCase(String text) {
    final words = text.split(' ');
    return '${words[0][0].toLowerCase()}${words[0].substring(1)}${words.sublist(1).map((w) => '_${w[0].toLowerCase()}${w.substring(1)}').join()}';
  }

  static Color initialsToColor(String initails) {
    final initialsSum = initails.codeUnits.reduce((a, b) => a + b);

    return Colors.primaries[initialsSum % Colors.primaries.length];
  }
}

extension StringExtension on String {
  String capitalize() {
    if (isEmpty) {
      return this;
    }
    return '${this[0].toUpperCase()}${substring(1)}';
  }
}
