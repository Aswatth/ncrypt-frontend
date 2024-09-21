import 'package:flutter/material.dart';
import 'package:frontend/clients/login_data_client.dart';
import 'package:frontend/general_pages/password_generator.dart';
import 'package:frontend/master_password_pages/update_password.dart';
import 'package:frontend/utils/colors.dart';
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
  bool _isLocked = false;
  List<Account> _existingAccountList = [];

  List<Account> _accountList = [];
  List<TextEditingController> _usernameControllerList = [];
  List<TextEditingController> _passwordControllerList = [];
  List<bool> _passwordVisibility = [];

  @override
  void initState() {
    super.initState();
    _nameController.text = widget.dataToEdit.name;
    _urlController.text = widget.dataToEdit.url;
    _isFavourite = widget.dataToEdit.attributes.isFavourite;
    _isLocked = widget.dataToEdit.attributes.requireMasterPassword;
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
                    bool passwordVisibility = false;
                    return StatefulBuilder(
                      builder: (context, setState) {
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
                                    enableInteractiveSelection: false,
                                    obscureText: !passwordVisibility,
                                    controller: _passwordController,
                                    decoration: InputDecoration(
                                        hintText: "Enter new password",
                                        label: Text("New password"),
                                        suffixIcon: IconButton(
                                            onPressed: () {
                                              setState(() {
                                                passwordVisibility =
                                                    !passwordVisibility;
                                              });
                                            },
                                            icon: passwordVisibility
                                                ? Icon(Icons.visibility)
                                                : Icon(Icons.visibility_off))),
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
                      },
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

  void deleteExistingAccount(int index) {
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
                        text: _existingAccountList[index].username!,
                        style: TextStyle(fontWeight: FontWeight.bold)),
                    TextSpan(text: " account entirely?")
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
                        ),
                        ElevatedButton.icon(
                          onPressed: () {
                            setState(() {
                              _existingAccountList.removeAt(index);
                              Navigator.of(context).pop();
                            });
                          },
                          label: Text("Yes"),
                        ),
                      ],
                    ),
                  )
                ],
              )
            ],
          );
        });
  }

  void saveUpdates() {
    if (_accountList.isEmpty && _existingAccountList.isEmpty) {
      CustomToast.error(context, "Should have at least 1 account");
      return;
    }
    for (int i = 0; i < _accountList.length; ++i) {
      _accountList[i].username = _usernameControllerList[i].text;
      _accountList[i].password = _passwordControllerList[i].text;
    }
    LoginDataClient()
        .updateLoginData(
            widget.dataToEdit.name,
            LoginData(
                name: _nameController.text,
                url: _urlController.text,
                attributes: Attributes(
                    isFavourite: _isFavourite,
                    requireMasterPassword: _isLocked),
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
        title: Text("Edit github data"),
        elevation: 1.5,
      ),
      body: Form(
        key: _formKey,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12.0),
          child: Column(
            children: [
              SizedBox(
                width: double.infinity,
                child: TextFormField(
                  controller: _nameController,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Name cannot be empty";
                    }
                    return null;
                  },
                  decoration: InputDecoration(
                    prefixIcon: Icon(Icons.account_box_outlined),
                    label: RichText(
                        text: TextSpan(children: [
                      TextSpan(
                        text: "Name ",
                        style: TextStyle(color: AppColors().textColor),
                      ),
                      TextSpan(
                          text: "*",
                          style: TextStyle(
                              color: Colors.red, fontWeight: FontWeight.bold))
                    ])),
                    hintText: "Enter a name for the login data",
                  ),
                ),
              ),
              SizedBox(
                height: 20,
              ),
              SizedBox(
                width: double.infinity,
                child: TextFormField(
                  controller: _urlController,
                  decoration: InputDecoration(
                    prefixIcon: Icon(Icons.link),
                    label: Text("URL"),
                    hintText: "Enter a url for the login data",
                  ),
                ),
              ),
              SizedBox(
                height: 20,
              ),
              Row(
                children: [
                  Expanded(
                    child: ListTile(
                      leading: Checkbox(
                          value: _isFavourite,
                          onChanged: (_) {
                            setState(() {
                              _isFavourite = !_isFavourite;
                            });
                          }),
                      title: Text("Add to favourites"),
                    ),
                  ),
                  Expanded(
                    child: ListTile(
                      leading: Checkbox(
                          value: _isLocked,
                          onChanged: (_) {
                            setState(() {
                              _isLocked = !_isLocked;
                            });
                          }),
                      title: RichText(
                        text: TextSpan(
                          children: [
                            TextSpan(
                                text: "Locked",
                                style: TextStyle(color: AppColors().textColor)),
                            TextSpan(
                              text:
                                  "\nWill require master password to view account password",
                              style: TextStyle(
                                  color: AppColors().textColor.withAlpha(180),
                                  fontStyle: FontStyle.italic),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 20,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton(
                      onPressed: () {
                        showDialog(
                            context: context,
                            builder: (context) {
                              return PasswordGenerator();
                            });
                      },
                      child: Text("Password generator")),
                  ElevatedButton.icon(
                    onPressed: () {
                      setState(() {
                        _accountList.add(Account.empty());
                        _usernameControllerList.add(TextEditingController());
                        _passwordControllerList.add(TextEditingController());
                        _passwordVisibility.add(false);
                      });
                    },
                    label: Text("Add account"),
                    icon: Icon(Icons.add),
                    iconAlignment: IconAlignment.start,
                  ),
                ],
              ),
              SizedBox(
                height: 20,
              ),
              Flexible(
                child: Row(
                  children: <Widget>[
                    // First ListView
                    Expanded(
                      child: Container(
                        decoration: BoxDecoration(
                            border: Border(
                                right: BorderSide(
                                    color: AppColors().primaryColor))),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Existing accounts",
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            Flexible(
                              flex: 1,
                              child: ListView.builder(
                                  itemCount: _existingAccountList.length,
                                  itemBuilder: (context, index) {
                                    return Row(
                                      children: [
                                        Expanded(
                                          child: RichText(
                                            text: TextSpan(
                                              children: [
                                                TextSpan(
                                                  text: "Username:\t",
                                                  style: TextStyle(
                                                      color:
                                                          AppColors().textColor,
                                                      fontWeight:
                                                          FontWeight.bold),
                                                ),
                                                TextSpan(
                                                    text: _existingAccountList[
                                                            index]
                                                        .username!,
                                                    style: TextStyle(
                                                      color:
                                                          AppColors().textColor,
                                                    ))
                                              ],
                                            ),
                                          ),
                                        ),
                                        Row(
                                          children: [
                                            ElevatedButton(
                                              style: ElevatedButton.styleFrom(
                                                  backgroundColor: AppColors()
                                                      .backgroundColor,
                                                  elevation: 2),
                                              onPressed: () {
                                                editExistingPassword(index);
                                              },
                                              child: Text("Update password"
                                                  .toUpperCase()),
                                            ),
                                            IconButton(
                                                onPressed: () {
                                                  setState(() {
                                                    deleteExistingAccount(
                                                        index);
                                                  });
                                                },
                                                icon: Icon(Icons.delete))
                                          ],
                                        )
                                      ],
                                    );
                                  }),
                            )
                          ],
                        ),
                      ),
                    ),
                    Expanded(
                      flex: 1,
                      child: ListView.builder(
                          itemCount: _accountList.length,
                          itemBuilder: (context, index) {
                            return Padding(
                              padding: const EdgeInsets.all(12.0),
                              child: Row(
                                children: [
                                  Expanded(
                                    child: TextFormField(
                                      controller:
                                          _usernameControllerList[index],
                                      validator: (value) {
                                        if (value == null || value.isEmpty) {
                                          return "Username cannot be empty";
                                        }
                                        return null;
                                      },
                                      decoration: InputDecoration(
                                        prefixIcon: Icon(
                                          Icons.person,
                                        ),
                                        label: RichText(
                                            text: TextSpan(children: [
                                          TextSpan(
                                            text: "Username ",
                                            style: TextStyle(
                                                color: AppColors().textColor),
                                          ),
                                          TextSpan(
                                              text: "*",
                                              style: TextStyle(
                                                  color: Colors.red,
                                                  fontWeight: FontWeight.bold))
                                        ])),
                                        hintText: "Username",
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    width: 20,
                                  ),
                                  Expanded(
                                    child: TextFormField(
                                      controller:
                                          _passwordControllerList[index],
                                      validator: (value) {
                                        if (value == null || value.isEmpty) {
                                          return "Password cannot be empty";
                                        }
                                        return null;
                                      },
                                      obscureText: !_passwordVisibility[index],
                                      decoration: InputDecoration(
                                          prefixIcon: Icon(
                                            Icons.lock,
                                          ),
                                          label: RichText(
                                              text: TextSpan(children: [
                                            TextSpan(
                                              text: "Password ",
                                              style: TextStyle(
                                                  color: AppColors().textColor,
                                                  fontSize: 16),
                                            ),
                                            TextSpan(
                                                text: "*",
                                                style: TextStyle(
                                                    color: Colors.red,
                                                    fontWeight:
                                                        FontWeight.bold))
                                          ])),
                                          hintText: "Password",
                                          suffixIcon: IconButton(
                                              onPressed: () {
                                                setState(() {
                                                  _passwordVisibility[index] =
                                                      !_passwordVisibility[
                                                          index];
                                                });
                                              },
                                              icon: _passwordVisibility[index]
                                                  ? Icon(Icons.visibility)
                                                  : Icon(
                                                      Icons.visibility_off))),
                                    ),
                                  ),
                                  IconButton(
                                      onPressed: () {
                                        setState(() {
                                          _accountList.removeAt(index);
                                          _usernameControllerList
                                              .removeAt(index);
                                          _passwordControllerList
                                              .removeAt(index);
                                          _passwordVisibility.removeAt(index);
                                        });
                                      },
                                      icon: Icon(
                                        Icons.delete,
                                      ))
                                ],
                              ),
                            );
                          }),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 20,
              ),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      saveUpdates();
                    }
                  },
                  child: Text("Save"),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
