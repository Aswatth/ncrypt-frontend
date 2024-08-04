import 'package:flutter/material.dart';
import 'package:frontend/clients/login_data_client.dart';
import 'package:frontend/models/attributes.dart';
import 'package:frontend/models/login.dart';
import 'package:frontend/models/login_account.dart';

class AddLoginData extends StatefulWidget {
  const AddLoginData({super.key});

  @override
  State<AddLoginData> createState() => _AddLoginDataState();
}

class _AddLoginDataState extends State<AddLoginData> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  bool _isFavourite = false;
  bool _requireMasterPassword = false;

  List<Account> _accountList = [];

  void addLoginData() {
    LoginDataClient client = LoginDataClient();
    client.addLoginData(LoginData(
        name: _nameController.text,
        url: "",
        attributes: Attributes(
            isFavourite: _isFavourite,
            requireMasterPassword: _requireMasterPassword),
        accounts: _accountList)).then((value) {
          if(value is String && value.isEmpty) {
            Navigator.of(context).pop();
          } else {
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(value)));
          }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
          child: Form(
        key: _formKey,
        child: Column(
          children: [
            TextFormField(
              controller: _nameController,
              decoration: InputDecoration(hintText: "Name"),
              maxLength: 16,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Name cannot be empty';
                }
              },
            ),
            ListTile(
              leading: _isFavourite
                  ? IconButton(
                      onPressed: () {
                        setState(() {
                          _isFavourite = !_isFavourite;
                        });
                      },
                      icon: Icon(
                        Icons.favorite,
                        color: Colors.red,
                      ))
                  : IconButton(
                      onPressed: () {
                        setState(() {
                          _isFavourite = !_isFavourite;
                        });
                      },
                      icon: Icon(Icons.heart_broken_outlined)),
              title: Text("Favourite"),
            ),
            ListTile(
              leading: _requireMasterPassword
                  ? IconButton(
                      onPressed: () {
                        setState(() {
                          _requireMasterPassword = !_requireMasterPassword;
                        });
                      },
                      icon: Icon(
                        Icons.lock_rounded,
                        color: Colors.red,
                      ))
                  : IconButton(
                      onPressed: () {
                        setState(() {
                          _requireMasterPassword = !_requireMasterPassword;
                        });
                      },
                      icon: Icon(Icons.key_off)),
              title: Text("Require master password"),
            ),
            Align(
              alignment: Alignment.centerRight,
              child: TextButton(
                onPressed: () {
                  setState(() {
                    _accountList.add(Account.empty());
                  });
                },
                child: Text("Add account"),
              ),
            ),
            Flexible(
              child: ListView.builder(
                  // shrinkWrap: true,
                  itemCount: _accountList.length,
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        children: [
                          Expanded(
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: ListTile(
                                leading: Icon(Icons.person),
                                title: TextFormField(
                                  initialValue: _accountList[index].username,
                                  decoration: InputDecoration(
                                    hintText: "Username",
                                  ),
                                  onChanged: (value) {
                                    setState(() {
                                      _accountList[index].username = value;
                                    });
                                  },
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return 'Username cannot be empty';
                                    }
                                  },
                                ),
                              ),
                            ),
                          ),
                          Expanded(
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: ListTile(
                                leading: Icon(Icons.password),
                                title: TextFormField(
                                  initialValue: _accountList[index].password,
                                  obscureText: true,
                                  decoration:
                                      InputDecoration(hintText: "Password"),
                                  onChanged: (value) {
                                    setState(() {
                                      _accountList[index].password = value;
                                    });
                                  },
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return 'Password cannot be empty';
                                    }
                                  },
                                ),
                              ),
                            ),
                          ),
                          IconButton(
                              onPressed: () {
                                setState(() {
                                  print(
                                      "Deleting: ${_accountList[index].username} - ${_accountList[index].password}");
                                  _accountList.removeAt(index);
                                });
                              },
                              icon: Icon(Icons.delete))
                        ],
                      ),
                    );
                  }),
            ),
            TextButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    addLoginData();
                  }
                },
                child: Text("Add"))
          ],
        ),
      )),
    );
  }
}
