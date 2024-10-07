import 'package:flutter/material.dart';
import 'package:Ncrypt/clients/system_data_client.dart';
import 'package:Ncrypt/utils/DateTimeFormatter.dart';
import 'package:Ncrypt/utils/custom_toast.dart';
import 'package:Ncrypt/general_pages/signin_page.dart';
import 'package:Ncrypt/models/system_data.dart';

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
    SessionTimer().tickCallback = () {
      setState(() {
        if (SessionTimer().getCurrentTimeInSeconds() == 60) {
          showDialog(
            context: context,
            barrierDismissible: false,
            builder: (context) {
              return SimpleDialog(
                title: Text("Warning"),
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20.0, vertical: 12),
                    child: Text(
                        "Session will expire in 1 minute.\nDo you want to extend it?"),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      ElevatedButton(
                        onPressed: () {
                          SystemDataClient().backup().then((value) {
                            if (value != null &&
                                (value is String && value.isNotEmpty)) {
                              if (context.mounted) {
                                CustomToast.error(context, value);
                              }
                            }
                          });
                          Navigator.of(context).pop();
                        },
                        child: Text("No"),
                      ),
                      ElevatedButton(
                          onPressed: () {
                            SystemDataClient().extendSession().then((value) {
                              if (value == null) {
                                setState(() {
                                  SessionTimer().reset();
                                  SessionTimer().start();
                                  Navigator.of(context).pop();
                                  CustomToast.info(
                                      context, "Session extended");
                                });
                              } else {
                                if (context.mounted) {
                                  CustomToast.error(context, value);
                                }
                              }
                            });
                          },
                          child: Text("Yes"),
                          style: ElevatedButton.styleFrom(
                              backgroundColor:
                              Theme.of(context).colorScheme.primary,
                              iconColor:
                              Theme.of(context).colorScheme.surface,
                              foregroundColor:
                              Theme.of(context).colorScheme.surface))
                    ],
                  )
                ],
              );
            },
          );
        }
      });
    };

    SessionTimer().timerEndCallback = () {
      CustomToast.info(context, "Session expired!\nPlease login again");
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => SignInPage()),
            (route) => false,
      );
    };

    SessionTimer().setSessionTimeInMinutes(
        SystemDataClient().SYSTEM_DATA!.sessionDurationInMinutes);

    if (SystemDataClient().SYSTEM_DATA!.lastLoginDateTime.isNotEmpty) {
      lastLogin =
          DateTime.parse(SystemDataClient().SYSTEM_DATA!.lastLoginDateTime)
              .toLocal();
    }

    SessionTimer().start();
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
              Text(lastLogin != null
                  ? DateTimeFormatter().formatDateTime(lastLogin!)
                  : ""),
            ],
          ),
        ),
        Text(
          "Time left in session:\t",
          style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Theme.of(context).textTheme.bodyMedium?.color),
        ),
        SizedBox(
          width: 40,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                SessionTimer().getCurrentTimeInSeconds() == 0
                    ? "00:00"
                    : DateTimeFormatter().formatTimeMMSS(
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
