import 'package:flutter/material.dart';
import 'package:Ncrypt/clients/system_data_client.dart';
import 'package:Ncrypt/models/auto_backup_setting.dart';
import 'package:Ncrypt/utils/custom_toast.dart';
import 'package:Ncrypt/utils/file_loader.dart';

class UpdateAutoBackup extends StatefulWidget {
  final Function(AutoBackupSetting autoBackupSetting)? callback;

  UpdateAutoBackup({super.key, this.callback});

  @override
  State<UpdateAutoBackup> createState() => _UpdateAutoBackupState();
}

class _UpdateAutoBackupState extends State<UpdateAutoBackup> {
  final _formKey = GlobalKey<FormState>();

  late AutoBackupSetting _autoBackupSetting;
  late bool _enableAutomaticBackup;
  late String _backupLocation;
  late final TextEditingController _backupFileNameController;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _backupFileNameController = TextEditingController();
    if (SystemDataClient().SYSTEM_DATA == null) {
      _enableAutomaticBackup = false;
      _backupLocation = "";
      _backupFileNameController.text = "";
    } else {
      _enableAutomaticBackup =
          SystemDataClient().SYSTEM_DATA!.autoBackupSetting.isEnabled;
      _backupLocation =
          SystemDataClient().SYSTEM_DATA!.autoBackupSetting.backupLocation;
      _backupFileNameController.text =
          SystemDataClient().SYSTEM_DATA!.autoBackupSetting.backupFileName;
    }
  }

  void saveUpdates() {
    _autoBackupSetting = AutoBackupSetting(_enableAutomaticBackup,
        _backupLocation, _backupFileNameController.text);
    SystemDataClient()
        .updateAutomaticBackupData(_autoBackupSetting)
        .then((value) {
      if (context.mounted) {
        if (value == null || (value is String && value.isEmpty)) {
          CustomToast.success(context, "Updated successfully");
          setState(() {
            SystemDataClient().SYSTEM_DATA!.autoBackupSetting =
                AutoBackupSetting(_enableAutomaticBackup, _backupLocation,
                    _backupFileNameController.text);
          });
          Navigator.of(context).pop();
        } else {
          CustomToast.error(context, value);
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          ListTile(
            title: Text("Automatic backup on application close"),
            trailing: Switch(
                value: _enableAutomaticBackup,
                onChanged: (value) {
                  setState(() {
                    _enableAutomaticBackup = value;
                  });
                }),
          ),
          _enableAutomaticBackup
              ? Column(
                  children: [
                    ListTile(
                      title: _backupLocation.isEmpty
                          ? Text("Choose import data location")
                          : Text(_backupLocation),
                      trailing: ElevatedButton(
                        onPressed: () {
                          FileUtils().pickFolder().then((value) {
                            if (value == null) {
                              if (context.mounted) {
                                CustomToast.error(
                                    context, "Unable to select folder");
                              }
                            } else {
                              setState(() {
                                _backupLocation = value;
                              });
                            }
                          });
                        },
                        child: Text("Choose".toUpperCase()),
                      ),
                    ),
                    ListTile(
                      title: TextFormField(
                        controller: _backupFileNameController,
                        maxLength: 16,
                        decoration: InputDecoration(
                          label: Text(
                            "Pick a file name",
                          ),
                          hintMaxLines: 16,
                          hintStyle:
                              TextStyle(color: Colors.white24, fontSize: 14),
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
                    ),
                  ],
                )
              : Container(),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    if (_enableAutomaticBackup && _backupLocation.isEmpty) {
                      CustomToast.error(
                          context, "Please select backup folder");
                      return;
                    }
                    if (widget.callback != null) {
                      widget.callback!(AutoBackupSetting(
                          _enableAutomaticBackup,
                          _backupLocation,
                          _backupFileNameController.text));
                    } else {
                      saveUpdates();
                    }
                  }
                },
                child: Text("Save".toUpperCase())),
          )
        ],
      ),
    );
  }
}
