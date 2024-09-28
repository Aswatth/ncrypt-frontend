import 'package:flutter/material.dart';
import 'package:frontend/clients/system_data_client.dart';
import 'package:frontend/general_pages/signin_page.dart';
import 'package:frontend/general_pages/update_auto_backup.dart';
import 'package:frontend/master_password_pages/set_password.dart';
import 'package:frontend/models/auto_backup_setting.dart';
import 'package:frontend/utils/custom_toast.dart';

class Setup extends StatefulWidget {
  const Setup({super.key});

  @override
  State<Setup> createState() => _SetupState();
}

class _SetupState extends State<Setup> {
  late final String masterPassword;
  late final AutoBackupSetting autoBackupSetting;

  int currentStep = 0;

  void setup() {
    SystemDataClient().setup(masterPassword, autoBackupSetting).then((value) {
      if (context.mounted) {
        if (value == null || (value is String && value.isEmpty)) {
          Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(builder: (context) => SignInPage()),
            (route) => false,
          );
        } else {
          CustomToast.error(context, value as String);
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stepper(
          type: StepperType.horizontal,
          currentStep: currentStep,
          onStepContinue: () {
            setState(() {
              currentStep = (currentStep + 1) % 2;
            });
          },
          controlsBuilder: (context, details) {
            return Container();
          },
          steps: [
            Step(
                content: SetPassword(
                  callback: (_) {
                    setState(() {
                      masterPassword = _;
                      currentStep += 1;
                    });
                  },
                ),
                isActive: currentStep == 0,
                title: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text("Set master password"),
                ),
                state:
                    currentStep == 0 ? StepState.editing : StepState.complete),
            Step(
                content: UpdateAutoBackup(
                  callback: (setting) {
                    autoBackupSetting = setting;
                    print("here");
                    setup();
                  },
                ),
                title: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text("Auto backup"),
                ),
                isActive: currentStep == 1)
          ]),
    );
  }
}
