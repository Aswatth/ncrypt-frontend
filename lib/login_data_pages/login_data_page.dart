import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:frontend/clients/login_data_client.dart';
import 'package:frontend/clients/master_password_client.dart';
import 'package:frontend/custom_snack_bar/custom_snackbar.dart';
import 'package:frontend/custom_snack_bar/status.dart';
import 'package:frontend/login_data_pages/add_login_data.dart';
import 'package:frontend/login_data_pages/edit_login_data.dart';
import 'package:frontend/models/login.dart';

class LoginDataPage extends StatefulWidget {
  const LoginDataPage({super.key});

  @override
  State<LoginDataPage> createState() => _LoginDataPageState();
}

class _LoginDataPageState extends State<LoginDataPage> {
  late LoginDataClient client;

  List<LoginData> _loginDataList = [];
  List<LoginData> _filteredDataList = [];

  @override
  void initState() {
    super.initState();

    client = LoginDataClient();

    getAllLoginData();
  }

  void getAllLoginData() {
    client.getAllLoginData().then((value) {
      if (value is List<dynamic>) {
        setState(() {
          _loginDataList = value.map((m) => m as LoginData).toList();
          _filteredDataList = _loginDataList;
        });
      }
    });
  }

  void updateFavourite(LoginData data) {
    LoginDataClient().updateLoginData(data.name, data).then((value) {
      if (!(value != null && value is String && value.isEmpty)) {
        ScaffoldMessenger.of(context).showSnackBar(CustomSnackBar(
                status: Status.error, content: "Unable to update favourites")
            .show());
      }
    });
  }

  void delete(LoginData data, int index) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return SimpleDialog(
            title: Text("Are you sure?"),
            children: [
              Column(
                children: [
                  Text.rich(TextSpan(children: [
                    TextSpan(text: "Do you want to delete "),
                    TextSpan(
                        text: data.name,
                        style: TextStyle(fontWeight: FontWeight.bold)),
                    TextSpan(text: " entirely?")
                  ])),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        ElevatedButton.icon(
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                          label: Text("No"),
                          // icon: Icon(Icons.close),
                        ),
                        ElevatedButton.icon(
                            onPressed: () {
                              client.deleteLoginData(data.name).then((value) {
                                if (value is String && value.isEmpty) {
                                  setState(() {
                                    _loginDataList.remove(data);
                                    _filteredDataList = _loginDataList;
                                  });
                                  Navigator.of(context).pop();
                                  ScaffoldMessenger.of(context).showSnackBar(
                                      CustomSnackBar(
                                              status: Status.success,
                                              content: "Successfully deleted!")
                                          .show());
                                } else {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                      CustomSnackBar(
                                              status: Status.error,
                                              content: value)
                                          .show());
                                }
                              });
                            },
                            label: Text("Yes"),
                            // icon: Icon(Icons.check),
                            style: ElevatedButton.styleFrom(
                                backgroundColor:
                                    Theme.of(context).colorScheme.primary,
                                iconColor:
                                    Theme.of(context).colorScheme.surface,
                                foregroundColor:
                                    Theme.of(context).colorScheme.surface)),
                      ],
                    ),
                  )
                ],
              )
            ],
          );
        });
  }

  void copyPasswordToClipboard(LoginData data, String username) {
    client.getDecryptedPassword(data.name, username).then((value) {
      if (value is String && value.isNotEmpty) {
        Clipboard.setData(ClipboardData(text: value)).then((_) {
          ScaffoldMessenger.of(context).showSnackBar(CustomSnackBar(
                  status: Status.info,
                  content: "Copied decrypted password to clipboard")
              .show());
        });
      }
    });
  }

  void getMasterPassword(LoginData data, String username) {
    String enteredPassword = "";
    bool result = false;
    showDialog(
        context: context,
        builder: (context) {
          return SimpleDialog(
            contentPadding: EdgeInsets.all(12),
            children: [
              TextFormField(
                obscureText: true,
                onChanged: (value) {
                  setState(() {
                    enteredPassword = value;
                  });
                },
                decoration: InputDecoration(
                    hintText: "Enter master password",
                    label: Text("Master Password")),
              ),
              SizedBox(
                height: 20,
              ),
              ElevatedButton(
                  onPressed: () {
                    MasterPasswordClient()
                        .validateMasterPassword(enteredPassword)
                        .then((value) {
                      if (value == "true") {
                        copyPasswordToClipboard(data, username);
                        Navigator.of(context).pop();
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                            CustomSnackBar(status: Status.error, content: value)
                                .show());
                      }
                    });
                  },
                  child: Text("Validate"))
            ],
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context)
              .push(
            MaterialPageRoute(
              builder: (context) => AddLoginData(),
            ),
          )
              .then((value) {
            getAllLoginData();
          });
        },
        child: Icon(Icons.add),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: TextFormField(
              decoration: InputDecoration(
                hintText: "Search",
              ),
              onChanged: (value) {
                setState(() {
                  _filteredDataList = _loginDataList
                      .where((m) =>
                          m.name.toLowerCase().startsWith(value.toLowerCase()))
                      .toList();
                });
              },
            ),
          ),
          _loginDataList.isEmpty
              ? Center(child: Text("No data"))
              : ListView.builder(
                  shrinkWrap: true,
                  itemCount: _filteredDataList.length,
                  itemBuilder: (BuildContext context, int index) {
                    LoginData data = _filteredDataList[index];
                    return ExpansionTile(
                        leading: SizedBox(
                          width: 70,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              data.attributes.isFavourite
                                  ? IconButton(
                                      onPressed: () {
                                        setState(() {
                                          data.attributes.isFavourite = false;
                                        });
                                        updateFavourite(data);
                                      },
                                      icon: Icon(
                                        Icons.star,
                                        color: Colors.amber,
                                      ),
                                    )
                                  : IconButton(
                                      onPressed: () {
                                        setState(() {
                                          data.attributes.isFavourite = true;
                                        });
                                        updateFavourite(data);
                                      },
                                      icon: Icon(
                                        Icons.star_border,
                                      ),
                                    ),
                              data.attributes.requireMasterPassword
                                  ? Icon(Icons.lock)
                                  : Container()
                            ],
                          ),
                        ),
                        title: Text(data.name),
                        subtitle: Text(data.url),
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              ElevatedButton.icon(
                                onPressed: () {
                                  Navigator.of(context)
                                      .push(MaterialPageRoute(
                                          builder: (BuildContext context) =>
                                              EditLoginDataPage(
                                                  dataToEdit: data)))
                                      .then((value) {
                                    getAllLoginData();
                                  });
                                },
                                label: Text("Edit"),
                                iconAlignment: IconAlignment.start,
                                icon: Icon(Icons.edit),
                              ),
                              ElevatedButton.icon(
                                onPressed: () {
                                  setState(() {
                                    delete(data, index);
                                  });
                                },
                                label: Text("Delete"),
                                iconAlignment: IconAlignment.start,
                                icon: Icon(Icons.delete),
                              ),
                            ],
                          ),
                          Column(
                            children: data.accounts.map((m) {
                              return Row(
                                children: [
                                  Expanded(
                                    child: ListTile(
                                      leading: Icon(Icons.person),
                                      title: Text(m.username!),
                                      trailing: IconButton(
                                        icon: Icon(Icons.copy),
                                        onPressed: () async {
                                          await Clipboard.setData(
                                              ClipboardData(text: m.username!));
                                        },
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                    child: ListTile(
                                      leading: Icon(Icons.password),
                                      title: Text(m.password!),
                                      trailing: IconButton(
                                        icon: Icon(Icons.copy),
                                        onPressed: () async {
                                          if (data.attributes
                                              .requireMasterPassword) {
                                            getMasterPassword(
                                                data, m.username!);
                                          } else {
                                            copyPasswordToClipboard(
                                                data, m.username!);
                                          }
                                        },
                                      ),
                                    ),
                                  ),
                                  Divider()
                                ],
                              );
                            }).toList(),
                          ),
                        ]);
                  })
        ],
      ),
    );
  }
}
