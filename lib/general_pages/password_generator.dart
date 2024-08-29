import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:frontend/clients/system_data_client.dart';

class PasswordGenerator extends StatefulWidget {
  const PasswordGenerator({super.key});

  @override
  State<PasswordGenerator> createState() => _PasswordGeneratorState();
}

class _PasswordGeneratorState extends State<PasswordGenerator> {
  bool hasDigits = false;
  bool hasUpperCase = false;
  bool hasSpecialChar = false;
  final int MIN_LENGTH = 8;
  final int MAX_LENGTH = 20;
  late int length;

  String? generatedPassword;

  final LayerLink _layerLink = LayerLink();
  OverlayEntry? copyPasswordToolTip;

  @override
  void initState() {
    super.initState();
    length = MIN_LENGTH;
  }

  void generatePassword() {
    SystemDataClient()
        .getGeneratedPassword(hasDigits, hasUpperCase, hasSpecialChar, length)
        .then((value) {
      if (value != null && value is String && value.isNotEmpty) {
        setState(() {
          generatedPassword = value;
        });
      }
    });
  }

  void copyToClipboard(BuildContext context) {
    final overlay = Overlay.of(context);

    Clipboard.setData(ClipboardData(text: generatedPassword!)).then((value) {
      setState(() {
        copyPasswordToolTip = OverlayEntry(
          builder: (context) {
            return Positioned(
              width: 150,
              child: CompositedTransformFollower(
                offset: Offset(0, -20),
                link: _layerLink,
                child: Material(
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      color: Colors.green,
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(4.0),
                      child: Align(
                          alignment: Alignment.center,
                          child: Text("Copied to clipboard")),
                    ),
                  ),
                ),
              ),
            );
          },
        );

        overlay.insert(copyPasswordToolTip!);
      });

      Future.delayed(Duration(seconds: 2), () {
        setState(() {
          if (copyPasswordToolTip != null) {
            copyPasswordToolTip!.remove();
            copyPasswordToolTip = null;
          }
        });
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
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
                  CompositedTransformTarget(
                    link: _layerLink,
                    child: IconButton(
                      onPressed: () {
                        copyToClipboard(context);
                      },
                      icon: Icon(Icons.copy),
                    ),
                  )
                ],
              ),
        ListTile(
          title: Text("Should have digits?"),
          trailing: Switch(
            value: hasDigits,
            onChanged: (_) {
              setState(() {
                hasDigits = !hasDigits;
              });
            },
          ),
        ),
        ListTile(
          title: Text("Should have uppercase letters?"),
          trailing: Switch(
            value: hasUpperCase,
            onChanged: (_) {
              setState(() {
                hasUpperCase = !hasUpperCase;
              });
            },
          ),
        ),
        ListTile(
          title: Text("Should have special characters !, @, #, \$, %, ^, &, *"),
          trailing: Switch(
            value: hasSpecialChar,
            onChanged: (_) {
              setState(() {
                hasSpecialChar = !hasSpecialChar;
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
                    if (length > MIN_LENGTH) {
                      length -= 1;
                    }
                  });
                },
                icon: Icon(Icons.remove),
              ),
              Text(length.toString().padLeft(2, '0')),
              IconButton(
                onPressed: () {
                  setState(() {
                    if (length < MAX_LENGTH) {
                      length += 1;
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
                child: Text("GENERATE")),
          ),
        )
      ],
    );
  }
}
