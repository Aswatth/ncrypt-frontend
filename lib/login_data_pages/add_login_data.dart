import 'package:flutter/material.dart';
import 'package:frontend/clients/login_data_client.dart';
import 'package:frontend/utils/custom_toast.dart';
import 'package:frontend/general_pages/password_generator.dart';
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
  final _urlController = TextEditingController();
  bool _isFavourite = false;
  bool _requireMasterPassword = false;

  final List<Account> _accountList = [];

  void addLoginData() {
    if (_accountList.isEmpty) {
      if (context.mounted) {
        CustomToast.error(context, "Should have at least 1 account");
      }
      return;
    }
    LoginDataClient client = LoginDataClient();
    client
        .addLoginData(LoginData(
            name: _nameController.text,
            url: _urlController.text,
            attributes: Attributes(
                isFavourite: _isFavourite,
                requireMasterPassword: _requireMasterPassword),
            accounts: _accountList))
        .then((value) {
      if (context.mounted) {
        if (value is String && value.isEmpty) {
          Navigator.of(context).pop();
          CustomToast.success(context, "Successfully added!");
        } else {
          CustomToast.error(context, value);
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: BackButton(),
        title: Text("Add login data"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _nameController,
                decoration:
                    InputDecoration(hintText: "Name", icon: Icon(Icons.person)),
                maxLength: 16,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Name cannot be empty';
                  }
                },
              ),
              TextFormField(
                controller: _urlController,
                decoration:
                    InputDecoration(hintText: "URL", icon: Icon(Icons.link)),
              ),
              Row(
                children: [
                  Expanded(
                    child: ListTile(
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
                  ),
                  Expanded(
                    child: ListTile(
                      leading: _requireMasterPassword
                          ? IconButton(
                              onPressed: () {
                                setState(() {
                                  _requireMasterPassword =
                                      !_requireMasterPassword;
                                });
                              },
                              icon: Icon(
                                Icons.lock_rounded,
                                color: Colors.red,
                              ))
                          : IconButton(
                              onPressed: () {
                                setState(() {
                                  _requireMasterPassword =
                                      !_requireMasterPassword;
                                });
                              },
                              icon: Icon(Icons.key_off)),
                      title: Text("Require master password"),
                    ),
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton(
                      onPressed: () {
                        showDialog(
                          context: context,
                          builder: (context) {
                            return SimpleDialog(
                              children: [PasswordGenerator()],
                            );
                          },
                        );
                      },
                      style: ButtonStyle(
                        backgroundColor: WidgetStatePropertyAll(
                            Theme.of(context).scaffoldBackgroundColor),
                        shape: WidgetStatePropertyAll(
                          RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20.0),
                            // Border radius
                            side: BorderSide(
                                color: Theme.of(context).primaryColor,
                                width: 2.0), // Border color and width
                          ),
                        ),
                      ),
                      child: Text("Password generator")),
                  ElevatedButton(
                    onPressed: () {
                      setState(() {
                        _accountList.add(Account.empty());
                      });
                    },
                    child: Text("Add account"),
                    style: ButtonStyle(
                      backgroundColor: WidgetStatePropertyAll(
                          Theme.of(context).scaffoldBackgroundColor),
                      shape: WidgetStatePropertyAll(
                        RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20.0),
                          // Border radius
                          side: BorderSide(
                              color: Theme.of(context).primaryColor,
                              width: 2.0), // Border color and width
                        ),
                      ),
                    ),
                  )
                ],
              ),
              Flexible(
                child: ListView.builder(
                    shrinkWrap: true,
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
                                    _accountList.removeAt(index);
                                  });
                                },
                                icon: Icon(Icons.delete))
                          ],
                        ),
                      );
                    }),
              ),
              SizedBox(
                width: double.infinity,
                child: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: ElevatedButton(
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          addLoginData();
                        }
                      },
                      child: Text(
                        "Add",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      )),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
