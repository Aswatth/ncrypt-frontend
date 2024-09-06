import 'package:flutter/material.dart';
import 'package:frontend/clients/system_data_client.dart';
import 'package:frontend/utils/custom_toast.dart';
import 'package:frontend/master_password_pages/update_password.dart';
import 'package:frontend/utils/file_loader.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          ListTile(
            title: Text("Update master password"),
            onTap: () {
              showDialog(
                  context: (context),
                  builder: (BuildContext context) {
                    return UpdateMasterPasswordPage();
                  });
            },
          ),
          ListTile(
            title: Text("Update automatic backup data"),
            onTap: () {
              showDialog(
                  context: context,
                  builder: (context) {
                    return AutomaticBackupData();
                  });
            },
          )
        ],
      ),
    );
  }
}

class AutomaticBackupData extends StatefulWidget {
  const AutomaticBackupData({super.key});

  @override
  State<AutomaticBackupData> createState() => _AutomaticBackupDataState();
}

class _AutomaticBackupDataState extends State<AutomaticBackupData> {
  late bool _automaticBackup;
  late String _backupFolderPath;
  late final TextEditingController _backupFileNameController;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _automaticBackup = SystemDataClient().SYSTEM_DATA!.automaticBackup;
    _backupFolderPath = SystemDataClient().SYSTEM_DATA!.automaticBackupLocation;
    _backupFileNameController = TextEditingController(
        text: SystemDataClient().SYSTEM_DATA!.backupFileName);
  }

  @override
  Widget build(BuildContext context) {
    return SimpleDialog(
      children: [
        ListTile(
          title: Text("Automatic backup on application close"),
          trailing: Switch(
              value: _automaticBackup,
              onChanged: (value) {
                setState(() {
                  _automaticBackup = value;
                });
              }),
        ),
        _automaticBackup
            ? ListTile(
                title: _backupFolderPath.isEmpty
                    ? Text("Choose import data location")
                    : Text(_backupFolderPath),
                trailing: ElevatedButton(
                  onPressed: () {
                    FileUtils().pickFolder().then((value) {
                      if (value == null) {
                        if (context.mounted) {
                          CustomToast.error(context, "Unable to select folder");
                        }
                      } else {
                        setState(() {
                          _backupFolderPath = value;
                        });
                      }
                    });
                  },
                  child: Text("Choose"),
                ),
              )
            : Container(),
        _automaticBackup
            ? ListTile(
                title: TextFormField(
                  controller: _backupFileNameController,
                  maxLength: 16,
                  decoration: InputDecoration(
                    label: Text(
                      "Pick a file name",
                    ),
                    hintMaxLines: 16,
                    hintStyle: TextStyle(color: Colors.white24, fontSize: 14),
                    hintText: "File name",
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "File name cannot be empty";
                    }
                    return null;
                  },
                ),
                subtitle: Text(
                  "The file name would be appended with date and time while saving.",
                  style: TextStyle(fontStyle: FontStyle.italic),
                ),
              )
            : Container(),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: ElevatedButton(
              onPressed: () {
                SystemDataClient()
                    .updateAutomaticBackupData(_automaticBackup,
                        _backupFolderPath, _backupFileNameController.text)
                    .then((value) {
                  if (context.mounted) {
                    if (value == null || (value is String && value.isEmpty)) {
                      CustomToast.success(context, "Updated successfully");
                      setState(() {
                        SystemDataClient().SYSTEM_DATA!.automaticBackup =
                            _automaticBackup;
                        SystemDataClient()
                            .SYSTEM_DATA!
                            .automaticBackupLocation = _backupFolderPath;
                        SystemDataClient().SYSTEM_DATA!.backupFileName =
                            _backupFileNameController.text;
                      });
                      Navigator.of(context).pop();
                    } else {
                      CustomToast.error(context, value);
                    }
                  }
                });
              },
              child: Text("Save")),
        )
      ],
    );
  }
}
