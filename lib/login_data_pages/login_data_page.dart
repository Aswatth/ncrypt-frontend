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
                  .where((m) => m.name.toLowerCase().startsWith(value.toLowerCase()))
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
                                      client.getDecryptedPassword(data.name, m.username!).then((value) async {
                                        if(value is String && value.isNotEmpty) {
                                          showSnackBar("Copied decrypted password to clipboard");
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
