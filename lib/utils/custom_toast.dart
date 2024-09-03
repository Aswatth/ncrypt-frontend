import 'package:flutter/material.dart';

class CustomToast {
  static void _show(BuildContext context, String message, Color backgroundColor,
      IconData icon) {
    final overlay = Overlay.of(context);

    final overlayEntry = OverlayEntry(
        builder: (context) => ToastWidget(
              message: message,
              iconData: icon,
              backgroundColor: backgroundColor,
            ));

    // Insert the overlay entry into the overlay
    overlay.insert(overlayEntry);

    // Remove the toast after a delay
    Future.delayed(Duration(seconds: 5), () {
      overlayEntry.remove();
    });
  }

  static void success(BuildContext context, String message) {
    return _show(context, message, Colors.green, Icons.check);
  }

  static void error(BuildContext context, String message) {
    return _show(context, message, Colors.red, Icons.close);
  }

  static void info(BuildContext context, String message) {
    return _show(context, message, Colors.blue, Icons.info_outline);
  }

  static void warning(BuildContext context, String message) {
    return _show(context, message, Colors.amber, Icons.warning_amber_outlined);
  }
}

class ToastWidget extends StatefulWidget {
  String message;
  Color backgroundColor;
  IconData iconData;

  ToastWidget(
      {super.key,
      required this.message,
      required this.backgroundColor,
      required this.iconData});

  @override
  State<ToastWidget> createState() => _ToastWidgetState();
}

class _ToastWidgetState extends State<ToastWidget> {
  bool visibility = true;

  @override
  void initState() {
    super.initState();

    Future.delayed(Duration(seconds: 2), () {
      setState(() {
        visibility = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: 20.0, // Distance from the top
      right: 20.0, // Distance from the right
      child: AnimatedOpacity(
        opacity: visibility ? 1.0 : 0.0,
        duration: Duration(milliseconds: 500),
        child: Material(
          color: Colors.transparent,
          child: Container(
            width: 220,
            height: 80,
            decoration: BoxDecoration(
              color: widget.backgroundColor,
              borderRadius: BorderRadius.circular(12.0),
            ),
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Icon(
                    widget.iconData,
                    color: Colors.white,
                  ),
                  SizedBox(
                    width: 8,
                  ),
                  Flexible(
                    child: Text(
                      widget.message,
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
