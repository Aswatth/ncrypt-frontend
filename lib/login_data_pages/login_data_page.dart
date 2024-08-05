import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:frontend/clients/login_data_client.dart';
import 'package:frontend/custom_snack_bar/custom_snackbar.dart';
import 'package:frontend/custom_snack_bar/status.dart';
import 'package:frontend/login_data_pages/add_login_data.dart';
import 'package:frontend/models/attributes.dart';
import 'package:frontend/models/login.dart';
import 'package:frontend/models/login_account.dart';

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
      if (value is List<LoginData>) {
        setState(() {
          _loginDataList = value;
          _filteredDataList = _loginDataList;
        });
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
                    TextSpan(
                        text:
                        "Do you want to delete "),
                    TextSpan(
                        text: data.name,
                        style: TextStyle(
                            fontWeight:
                            FontWeight.bold)),
                    TextSpan(text: " entirely?")
                  ])),
                  Padding(
                    padding:
                    const EdgeInsets.all(8.0),
                    child: Row(
                      mainAxisAlignment:
                      MainAxisAlignment
                          .spaceEvenly,
                      children: [
                        ElevatedButton.icon(
                          onPressed: () {
                            Navigator.of(context)
                                .pop();
                          },
                          label: Text("No"),
                          icon: Icon(Icons.close),
                          style: ElevatedButton
                              .styleFrom(
                            backgroundColor:
                            Colors.red,
                            foregroundColor:
                            Colors.white,
                          ),
                        ),
                        ElevatedButton.icon(
                          onPressed: () {
                            client
                                .deleteLoginData(
                                data.name)
                                .then((value) {
                              if (value is String &&
                                  value.isEmpty) {
                                setState(() {
                                  _loginDataList
                                      .removeAt(
                                      index);
                                });
                                Navigator.of(context)
                                    .pop();
                                ScaffoldMessenger.of(
                                    context)
                                    .showSnackBar(CustomSnackBar(
                                    status: Status
                                        .success,
                                    content:
                                    "Successfully deleted!")
                                    .show());
                              } else {
                                ScaffoldMessenger.of(
                                    context)
                                    .showSnackBar(CustomSnackBar(
                                    status: Status
                                        .error,
                                    content:
                                    value)
                                    .show());
                              }
                            });
                          },
                          label: Text("Yes"),
                          icon: Icon(Icons.check),
                          style: ElevatedButton
                              .styleFrom(
                            backgroundColor:
                            Colors.green,
                            foregroundColor:
                            Colors.white,
                          ),
                        )
                      ],
                    ),
                  )
                ],
              )
            ],
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: TextFormField(
          decoration: InputDecoration(
            hintText: "Search",
            icon: Icon(Icons.search),
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
          ListView.builder(
              shrinkWrap: true,
              itemCount: _filteredDataList.length,
              itemBuilder: (BuildContext context, int index) {
                LoginData data = _filteredDataList[index];
                return ExpansionTile(
                    leading: data.attributes.isFavourite
                        ? Icon(
                            Icons.star,
                            color: Colors.amber,
                          )
                        : Icon(Icons.star_border),
                    title: Text(data.name),
                    subtitle: Text(data.url),
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          ElevatedButton.icon(
                            onPressed: () {},
                            label: Text("Edit"),
                            iconAlignment: IconAlignment.start,
                            icon: Icon(Icons.edit),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.green,
                              foregroundColor: Colors.white,
                            ),
                          ),
                          ElevatedButton.icon(
                            onPressed: () {
                              delete(data, index);
                            },
                            label: Text("Delete"),
                            iconAlignment: IconAlignment.start,
                            icon: Icon(Icons.delete),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.red,
                              foregroundColor: Colors.white,
                            ),
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
                                      client
                                          .getDecryptedPassword(
                                              data.name, m.username!)
                                          .then((value) async {
                                        if (value is String &&
                                            value.isNotEmpty) {
                                          ScaffoldMessenger.of(context)
                                              .showSnackBar(CustomSnackBar(
                                                      status: Status.info,
                                                      content:
                                                          "Copied decrypted password to clipboard")
                                                  .show());
                                        }
                                        await Clipboard.setData(
                                            ClipboardData(text: value));
                                      });
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
