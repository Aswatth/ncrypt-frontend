import 'package:flutter/material.dart';
import 'package:frontend/clients/login_data_client.dart';
import 'package:frontend/utils/custom_toast.dart';
import 'package:frontend/models/attributes.dart';
import 'package:frontend/models/login_account.dart';

import '../models/login.dart';

class EditLoginDataPage extends StatefulWidget {
  LoginData dataToEdit;

  EditLoginDataPage({super.key, required this.dataToEdit});

  @override
  State<EditLoginDataPage> createState() => _EditLoginDataPageState();
}

class _EditLoginDataPageState extends State<EditLoginDataPage> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _urlController = TextEditingController();
  bool _isFavourite = false;
  bool _requireMasterPassword = false;
  List<Account> _existingAccountList = [];

  List<TextEditingController> _usernameController = [];
  List<TextEditingController> _passwordController = [];
  List<Account> _accountList = [];
  List<bool> _passwordVisibility = [];

  @override
  void initState() {
    super.initState();
    _nameController.text = widget.dataToEdit.name;
    _urlController.text = widget.dataToEdit.url;
    _isFavourite = widget.dataToEdit.attributes.isFavourite;
    _requireMasterPassword = widget.dataToEdit.attributes.requireMasterPassword;
    _existingAccountList = widget.dataToEdit.accounts;
  }

  void editExistingPassword(int index) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return FutureBuilder(
              future: LoginDataClient().getDecryptedPassword(
                  widget.dataToEdit.name,
                  _existingAccountList[index].username!),
              builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
                if (!snapshot.hasData) {
                  return SimpleDialog(
                    children: [Center(child: CircularProgressIndicator())],
                  );
                } else {
                  if (snapshot.data is String &&
                      snapshot.data != "account username not found") {
                    TextEditingController _passwordController =
                        TextEditingController();
                    return SimpleDialog(
                      title: Text(
                          "Editing ${_existingAccountList[index].username!} password"),
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            children: [
                              ListTile(
                                leading: Text("Old password"),
                                title: Text(snapshot.data),
                              ),
                              TextFormField(
                                obscureText: true,
                                obscuringCharacter: "#",
                                controller: _passwordController,
                                decoration: InputDecoration(
                                    hintText: "Enter new password",
                                    label: Text("New password")),
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return "New password cannot be empty";
                                  }
                                },
                              ),
                              SizedBox(
                                height: 20,
                              ),
                              SizedBox(
                                width: double.infinity,
                                child: ElevatedButton(
                                  onPressed: () {
                                    setState(() {
                                      _existingAccountList[index].password =
                                          _passwordController.text;

                                      Navigator.of(context).pop();
                                      // CustomToast.success(context, "${_existingAccountList[index].username!} password updated");
                                    });
                                  },
                                  child: Text("Update password"),
                                ),
                              )
                            ],
                          ),
                        )
                      ],
                    );
                  } else {
                    return SimpleDialog(
                      title: Text("Edit password"),
                      children: [Text("Error: ${snapshot.data}")],
                    );
                  }
                }
              });
        });
  }

  void saveUpdates() {
    LoginDataClient()
        .updateLoginData(
            widget.dataToEdit.name,
            LoginData(
                name: _nameController.text,
                url: _urlController.text,
                attributes: Attributes(
                    isFavourite: _isFavourite,
                    requireMasterPassword: _requireMasterPassword),
                accounts: _accountList + _existingAccountList))
        .then((value) {
      if (context.mounted) {
        if (value is String && value.isEmpty) {
          Navigator.of(context).pop();
          CustomToast.success(context, "Successfully updated");
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
          title: Text("Edit ${widget.dataToEdit.name} data"),
        ),
        body: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                TextFormField(
                  controller: _nameController,
                  decoration: InputDecoration(
                      hintText: "Name", icon: Icon(Icons.person)),
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
                Align(
                  alignment: Alignment.centerRight,
                  child: TextButton(
                    onPressed: () {
                      setState(() {
                        _accountList.add(Account.empty());
                        _usernameController
                            .add(TextEditingController(text: ""));
                        _passwordController
                            .add(TextEditingController(text: ""));
                        _passwordVisibility.add(false);
                      });
                    },
                    child: Text("Add account"),
                  ),
                ),
                Flexible(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text("Existing accounts:"),
                      Flexible(
                        child: ListView.builder(
                            shrinkWrap: true,
                            itemCount: _existingAccountList.length,
                            itemBuilder: (context, index) {
                              return Row(
                                children: [
                                  Expanded(
                                    child: ListTile(
                                      leading: Icon(Icons.person),
                                      title: Text(_existingAccountList[index]
                                          .username!),
                                    ),
                                  ),
                                  Expanded(
                                    child: ListTile(
                                      leading: Icon(Icons.password),
                                      title: TextFormField(
                                        initialValue:
                                            _existingAccountList[index]
                                                .password!,
                                        obscureText: true,
                                        readOnly: true,
                                      ),
                                      trailing: IconButton(
                                        onPressed: () {
                                          editExistingPassword(index);
                                        },
                                        icon: Icon(Icons.edit),
                                      ),
                                    ),
                                  ),
                                  IconButton(
                                    onPressed: () {
                                      setState(() {
                                        showDialog(
                                            context: context,
                                            builder: (BuildContext context) {
                                              return SimpleDialog(
                                                title: Text("Are you sure?"),
                                                children: [
                                                  Column(
                                                    children: [
                                                      Text.rich(
                                                          TextSpan(children: [
                                                        TextSpan(
                                                            text:
                                                                "Do you want to delete "),
                                                        TextSpan(
                                                            text:
                                                                _existingAccountList[
                                                                        index]
                                                                    .username!,
                                                            style: TextStyle(
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold)),
                                                        TextSpan(
                                                            text:
                                                                " account entirely?")
                                                      ])),
                                                      Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .all(8.0),
                                                        child: Row(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .spaceEvenly,
                                                          children: [
                                                            ElevatedButton.icon(
                                                              onPressed: () {
                                                                Navigator.of(
                                                                        context)
                                                                    .pop();
                                                              },
                                                              label: Text("No"),
                                                              // icon: Icon(Icons.close),
                                                            ),
                                                            ElevatedButton.icon(
                                                                onPressed: () {
                                                                  setState(() {
                                                                    _existingAccountList
                                                                        .removeAt(
                                                                            index);
                                                                  });
                                                                  Navigator.of(
                                                                          context)
                                                                      .pop();
                                                                },
                                                                label:
                                                                    Text("Yes"),
                                                                // icon: Icon(Icons.check),
                                                                style: ElevatedButton.styleFrom(
                                                                    backgroundColor: Theme.of(
                                                                            context)
                                                                        .colorScheme
                                                                        .primary,
                                                                    iconColor: Theme.of(
                                                                            context)
                                                                        .colorScheme
                                                                        .surface,
                                                                    foregroundColor: Theme.of(
                                                                            context)
                                                                        .colorScheme
                                                                        .surface)),
                                                          ],
                                                        ),
                                                      )
                                                    ],
                                                  )
                                                ],
                                              );
                                            });
                                      });
                                    },
                                    icon: Icon(Icons.delete),
                                  ),
                                ],
                              );
                            }),
                      )
                    ],
                  ),
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
                                      decoration: InputDecoration(
                                        hintText: "Username",
                                      ),
                                      controller: _usernameController[index],
                                      validator: (value) {
                                        if (value == null || _usernameController[index].text.isEmpty) {
                                          return 'Username cannot be empty';
                                        }
                                        return null;
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
                                      controller: _passwordController[index],
                                      validator: (value) {
                                        if (value == null || _passwordController[index].text.isEmpty) {
                                          return 'Password cannot be empty';
                                        }
                                        return null;
                                      },
                                      obscureText: !_passwordVisibility[index],
                                      decoration: InputDecoration(
                                        hintText: "Password",
                                        suffixIcon: IconButton(
                                          onPressed: () {
                                            setState(() {
                                              _passwordVisibility[index] =
                                                  !_passwordVisibility[index];
                                            });
                                          },
                                          icon: _passwordVisibility[index]
                                              ? Icon(Icons.visibility)
                                              : Icon(Icons.visibility_off),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              IconButton(
                                  onPressed: () {
                                    setState(() {
                                      _accountList.removeAt(index);
                                      _usernameController.removeAt(index);
                                      _passwordController.removeAt(index);
                                      _passwordVisibility.removeAt(index);
                                    });
                                  },
                                  icon: Icon(Icons.delete))
                            ],
                          ),
                        );
                      }),
                ),
                SizedBox(
                  height: 20,
                ),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        for (int i = 0; i < _accountList.length; ++i) {
                          _accountList[i].username =
                              _usernameController[i].text;
                          _accountList[i].password =
                              _passwordController[i].text;
                        }
                        saveUpdates();
                      }
                    },
                    child: Text("Save"),
                  ),
                )
              ],
            ),
          ),
        ));
  }
}
