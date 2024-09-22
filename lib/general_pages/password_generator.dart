import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:frontend/clients/system_data_client.dart';
import 'package:frontend/models/password_generator_preference.dart';
import 'package:frontend/utils/custom_toast.dart';

class PasswordGenerator extends StatefulWidget {
  const PasswordGenerator({super.key});

  @override
  State<PasswordGenerator> createState() => _PasswordGeneratorState();
}

class _PasswordGeneratorState extends State<PasswordGenerator> {
  final int MIN_LENGTH = 8;
  final int MAX_LENGTH = 20;
  PasswordGeneratorPreference preference =
      PasswordGeneratorPreference.defaultSetup();

  String? generatedPassword;

  @override
  void initState() {
    super.initState();
    fetchPreference();
  }

  void fetchPreference() {
    SystemDataClient().getPasswordGeneratorPreference().then((value) {
      if (value != null && value is PasswordGeneratorPreference) {
        setState(() {
          preference = value;
        });
      } else {
        if (context.mounted) {
          CustomToast.error(
              context, "Error occurred while fetching preference");
        }
      }
    });
  }

  void generatePassword() {
    SystemDataClient().getGeneratedPassword().then((value) {
      if (value != null && value is String && value.isNotEmpty) {
        setState(() {
          generatedPassword = value;
        });
      }
    });
  }

  void copyToClipboard(BuildContext context) {
    Clipboard.setData(ClipboardData(text: generatedPassword!)).then((value) {
      if (context.mounted) {
        CustomToast.info(context, "Copied to clipboard");
      }
    });
  }

  void updatePreference() {
    SystemDataClient()
        .updatePasswordGeneratorPreference(preference)
        .then((value) {
      if (value is String && value.isNotEmpty) {
        if (context.mounted) {
          CustomToast.error(context, value);
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return SimpleDialog(
      children: [
        Column(
          children: [
            generatedPassword == null
                ? Text(
                    "Generated password",
                    style: TextStyle(fontStyle: FontStyle.italic),
                  )
                : Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(generatedPassword!,
                          style: TextStyle(
                              fontWeight: FontWeight.bold, letterSpacing: 2)),
                      IconButton(
                        onPressed: () {
                          copyToClipboard(context);
                        },
                        icon: Icon(Icons.copy),
                      ),
                    ],
                  ),
            ListTile(
              title: Text("Should have digits?"),
              trailing: Switch(
                value: preference.hasDigits,
                onChanged: (_) {
                  setState(() {
                    preference.hasDigits = !preference.hasDigits;
                    updatePreference();
                  });
                },
              ),
            ),
            ListTile(
              title: Text("Should have uppercase letters?"),
              trailing: Switch(
                value: preference.hasUpperCase,
                onChanged: (_) {
                  setState(() {
                    preference.hasUpperCase = !preference.hasUpperCase;
                    updatePreference();
                  });
                },
              ),
            ),
            ListTile(
              title: Text(
                  "Should have special characters !, @, #, \$, %, ^, &, *"),
              trailing: Switch(
                value: preference.hasSpecialChar,
                onChanged: (_) {
                  setState(() {
                    preference.hasSpecialChar = !preference.hasSpecialChar;
                    updatePreference();
                  });
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15.0),
              child: Row(
                children: [
                  Expanded(child: Text("Password length")),
                  IconButton(
                    onPressed: () {
                      setState(() {
                        if (preference.length > MIN_LENGTH) {
                          preference.length -= 1;
                          updatePreference();
                        }
                      });
                    },
                    icon: Icon(Icons.remove),
                  ),
                  Text(preference.length.toString().padLeft(2, '0')),
                  IconButton(
                    onPressed: () {
                      setState(() {
                        if (preference.length < MAX_LENGTH) {
                          preference.length += 1;
                          updatePreference();
                        }
                      });
                    },
                    icon: Icon(Icons.add),
                  )
                ],
              ),
            ),
            Container(
              width: double.infinity,
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: ElevatedButton(
                    onPressed: () {
                      generatePassword();
                    },
                    child: Text("generate".toUpperCase())),
              ),
            )
          ],
        )
      ],
    );
  }
}
