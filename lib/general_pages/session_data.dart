import 'dart:async';

import 'package:flutter/material.dart';
import 'package:frontend/clients/system_data_client.dart';
import 'package:frontend/custom_toast/custom_toast.dart';
import 'package:frontend/general_pages/login_page.dart';
import 'package:frontend/models/system_data.dart';

class SessionData extends StatefulWidget {
  const SessionData({super.key});

  @override
  State<SessionData> createState() => _SessionDataState();
}

class _SessionDataState extends State<SessionData> {
  Timer? _timer;
  int sessionTimeInSeconds = 0;
  DateTime? lastLogin;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getSystemData();
    startTimer();
  }

  void getSystemData() {
    SystemDataClient().getSystemData().then((value) {
      if (value != null && value is SystemData) {
        setState(() {
          sessionTimeInSeconds = value.sessionTimeInMinutes * 60;
          lastLogin = DateTime.parse(value.lastLoginDateTime).toLocal();
        });
      }
    });
  }

  void startTimer() {
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      if (sessionTimeInSeconds == 0) {
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
          sessionTimeInSeconds--;
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
    if(dateTime.hour >= 12) {
      isAM = false;
    }

    String hour = dateTime.hour.toString().padLeft(2, '0');
    String minute = dateTime.minute.toString().padLeft(2, '0');

    return "$month, $day $year $hour:$minute ${isAM ? "AM" : "PM"}";
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
        ListTile(
          title: Text("Session"),
          trailing: Text(
            formatTime(sessionTimeInSeconds),
            style: TextStyle(
                fontSize: 28, fontWeight: FontWeight.bold, color: Colors.white),
          ),
        ),
        ListTile(
          title: Text("Last login"),
          trailing:
              lastLogin == null ? Text("-") : Text(formatLastLogin(lastLogin!),style: TextStyle(
                  fontSize: 14 ,color: Colors.white),),
        )
      ],
    );
  }
}
