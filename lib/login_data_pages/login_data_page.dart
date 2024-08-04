import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:frontend/clients/login_data_client.dart';
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

  void showSnackBar(dynamic content) {
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(content)));
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
          TextFormField(
            decoration: InputDecoration(
              hintText: "Search",
              icon: Icon(Icons.search),
            ),
            onChanged: (value) {
              setState(() {
                _filteredDataList = _loginDataList.where((m) => m.name.startsWith(value)).toList();
              });
            },
          ),
          // TextButton(onPressed: () {}, child: Text("Add login data")),
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
                    subtitle: GestureDetector(
                      child: Text(data.url),
                      onTap: () {
                        print("URL: ${data.url}");
                      },
                    ),
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          IconButton(onPressed: () {}, icon: Icon(Icons.edit)),
                          IconButton(
                              onPressed: () {
                                client.deleteLoginData(data.name).then((value) {
                                  if (value is String && value.isEmpty) {
                                    setState(() {
                                      _loginDataList.removeAt(index);
                                    });
                                    showSnackBar(data.name + " deleted!");
                                  } else {
                                    showSnackBar(value);
                                  }
                                });
                              },
                              icon: Icon(Icons.delete)),
                        ],
                      ),
                      Column(
                        children: data.accounts.map((m) {
                          return Column(
                            children: [
                              ListTile(
                                leading: IconButton(
                                  icon: Icon(Icons.copy),
                                  onPressed: () async {
                                    await Clipboard.setData(
                                        ClipboardData(text: m.username!));
                                  },
                                ),
                                title: Text("Username:" + m.username!),
                              ),
                              ListTile(
                                leading: IconButton(
                                  icon: Icon(Icons.copy),
                                  onPressed: () async {
                                    await Clipboard.setData(
                                        ClipboardData(text: m.password!));
                                  },
                                ),
                                title: Text("Password: " + m.password!),
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
