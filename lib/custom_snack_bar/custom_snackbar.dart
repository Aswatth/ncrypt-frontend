import 'package:flutter/material.dart';
import 'package:frontend/custom_snack_bar/status.dart';

class CustomSnackBar {
  final Status status;
  final String content;

  CustomSnackBar({required this.status, required this.content});

  IconData _getIcon() {
    switch (status) {
      case Status.info:
        return Icons.info;
      case Status.success:
        return Icons.thumb_up_sharp;
      case Status.error:
        return Icons.error;
      case Status.warning:
        return Icons.warning;
    }
  }

  Color _getBackgroundColor() {
    switch (status) {
      case Status.info:
        return Colors.blueAccent;
      case Status.success:
        return Colors.green;
      case Status.error:
        return Colors.red;
      case Status.warning:
        return Colors.yellow;
    }
  }

  SnackBar show() {
    return SnackBar(
      content: Row(
        children: [Icon(_getIcon(), color: Colors.white,), SizedBox(width: 20.0,), Expanded(child: Text(this.content))],
      ),
      backgroundColor: _getBackgroundColor(),
    );
  }
}
