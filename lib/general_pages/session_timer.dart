import 'dart:async';

import 'package:flutter/material.dart';
import 'package:frontend/custom_snack_bar/custom_snackbar.dart';
import 'package:frontend/custom_snack_bar/status.dart';
import 'package:frontend/custom_toast/custom_toast.dart';
import 'package:frontend/general_pages/login_page.dart';

class SessionTimer extends StatefulWidget {
  final int time_in_seconds;
  SessionTimer({super.key,required this.time_in_seconds});

  @override
  State<SessionTimer> createState() => _SessionTimerState();
}

class _SessionTimerState extends State<SessionTimer> {

  Timer? _timer;
  int current_time_in_seconds = 0;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    current_time_in_seconds = widget.time_in_seconds;
    startTimer();
  }

  void startTimer() {
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      if (current_time_in_seconds == 0) {
        setState(() {
          CustomToast.info(context, "Session expired!\nPlease login again");
          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (context) => LoginPage()),
                (route) => false, // Remove all previous routes
          );
          timer.cancel();
        });
      } else {
        setState(() {
          current_time_in_seconds--;
        });
      }
    });
  }

  String formatTime(int seconds) {
    int minutes = seconds ~/ 60;
    int remainingSeconds = seconds % 60;
    return '${minutes.toString().padLeft(2, '0')}:${remainingSeconds.toString().padLeft(2, '0')}';
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _timer!.cancel();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Center(child: Text("Session")),
        Text(formatTime(current_time_in_seconds), style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),),
      ],
    );
  }
}
