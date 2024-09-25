import 'dart:async';

import 'package:flutter/material.dart';
import 'package:frontend/clients/system_data_client.dart';
import 'package:frontend/utils/colors.dart';
import 'package:frontend/utils/custom_toast.dart';
import 'package:frontend/general_pages/login_page.dart';
import 'package:frontend/models/system_data.dart';

import '../models/session_timer.dart';

class SessionData extends StatefulWidget {
  const SessionData({super.key});

  @override
  State<SessionData> createState() => _SessionDataState();
}

class _SessionDataState extends State<SessionData> {
  DateTime? lastLogin;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    SystemDataClient().getSystemData().then((value) {
      if (value != null && value is SystemData) {
        setState(() {
          SessionTimer().tickCallback = () {
            setState(() {
            });
          };

          SessionTimer().timerEndCallback = () {
            CustomToast.info(context, "Session expired!\nPlease login again");
            Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(builder: (context) => LoginPage()),
                  (route) => false, // Remove all previous routes
            );
          };

          SessionTimer().setSessionTimeInMinutes(value.sessionDurationInMinutes);

          if (value.lastLoginDateTime.isNotEmpty) {
            lastLogin = DateTime.parse(value.lastLoginDateTime).toLocal();
          }

          SessionTimer().start();

        });
      }
    });
  }

  String formatLastLogin(DateTime dateTime) {
    final List<String> months = [
      "Jan",
      "Feb",
      "Mar",
      "Apr",
      "May",
      "Jun",
      "Jul",
      "Aug",
      "Sep",
      "Oct",
      "Nov",
      "Dec"
    ];

    int day = dateTime.day;
    String month = months[dateTime.month - 1];
    int year = dateTime.year;

    bool isAM = true;
    int h = dateTime.hour;
    if (h >= 12) {
      isAM = false;
      h = h - 12;
    }

    String hour = h.toString().padLeft(2, '0');
    String minute = dateTime.minute.toString().padLeft(2, '0');

    return "$month, $day $year\t$hour:$minute ${isAM ? "AM" : "PM"}";
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
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Row(
            children: [
              Text(
                "Last login:\t",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(lastLogin != null ? formatLastLogin(lastLogin!) : ""),
            ],
          ),
        ),
        Text(
          "Time left in session:\t",
          style: TextStyle(
              fontWeight: FontWeight.bold, color: AppColors().textColor),
        ),
        SizedBox(
          width: 40,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                SessionTimer().getCurrentTimeInSeconds() == 0
                    ? "00:00"
                    : formatTime(
                        SessionTimer().getCurrentTimeInSeconds(),
                      ),
              )
            ],
          ),
        )
      ],
    );
  }
}
