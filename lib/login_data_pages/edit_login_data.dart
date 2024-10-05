import 'package:flutter/material.dart';
import 'package:frontend/clients/login_data_client.dart';
import 'package:frontend/clients/system_data_client.dart';
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
    final key = GlobalKey<FormState>();
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
                              "Editing ${_existingAccountList[index].username!} account password"),
                          children: [
                            SizedBox(
                              width: 450,
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 20.0, vertical: 0),
                                child: Column(
                                  children: [
                                    Row(
                                      children: [
                                        Text(
                                          "Old password:",
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold),
                                        ),
                                        Text(snapshot.data)
                                      ],
                                    ),
                                    SizedBox(
                                      height: 20,
                                    ),
                                    Form(
                                      key: key,
                                      child: TextFormField(
                                        enableInteractiveSelection: false,
                                        obscureText: !passwordVisibility,
                                        controller: _passwordController,
                                        decoration: InputDecoration(
                                            hintText: "Enter new password",
                                            label: Text("New password"),
                                            suffixIcon: SizedBox(
                                              width: 150,
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.end,
                                                children: [
                                                  Tooltip(
                                                    message:
                                                        "Click to generate password",
                                                    child: IconButton(
                                                      onPressed: () {
                                                        setState(() {
                                                          passwordVisibility =
                                                              true;
                                                          SystemDataClient()
                                                              .getGeneratedPassword()
                                                              .then((value) {
                                                            if (value != null) {
                                                              _passwordController
                                                                  .text = value;
                                                            }
                                                          });
                                                        });
                                                      },
                                                      icon:
                                                          Icon(Icons.password),
                                                    ),
                                                  ),
                                                  IconButton(
                                                    onPressed: () {
                                                      setState(() {
                                                        passwordVisibility =
                                                            !passwordVisibility;
                                                      });
                                                    },
                                                    icon: passwordVisibility
                                                        ? Icon(Icons
                                                            .visibility_off)
                                                        : Icon(
                                                            Icons.visibility),
                                                  ),
                                                ],
                                              ),
                                            )),
                                        validator: (value) {
                                          if (value == null || value.isEmpty) {
                                            return "New password cannot be empty";
                                          }
                                        },
                                      ),
                                    ),
                                    SizedBox(
                                      height: 20,
                                    ),
                                    SizedBox(
                                      width: double.infinity,
                                      child: ElevatedButton(
                                        onPressed: () {
                                          setState(() {
                                            _existingAccountList[index]
                                                    .password =
                                                _passwordController.text;
                                            if (key.currentState!.validate()) {
                                              saveUpdates();
                                            }
                                          });
                                        },
                                        child: Text(
                                            "Update password".toUpperCase()),
                                      ),
                                    )
                                  ],
                                ),
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
                      leading: IconButton(
                        onPressed: () {
                          setState(() {
                            _isFavourite = !_isFavourite;
                          });
                        },
                        icon: _isFavourite
                            ? Icon(Icons.favorite)
                            : Icon(Icons.favorite_border),
                      ),
                      title: Text("Add to favourites"),
                    ),
                  ),
                  Expanded(
                    child: Tooltip(
                      verticalOffset: 10,
                      message:
                          "Requires master password to view account password, edit and delete data.",
                      child: ListTile(
                          leading: IconButton(
                            onPressed: () {
                              setState(() {
                                _isLocked = !_isLocked;
                              });
                            },
                            icon: _isLocked
                                ? Icon(Icons.lock)
                                : Icon(Icons.lock_outline),
                          ),
                          title: Text("Locked")),
                    ),
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
                      flex: 4,
                      child: Container(
                        decoration: BoxDecoration(
                            border: Border(
                                right: BorderSide(
                                    color: AppColors().primaryColor))),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Existing accounts".toUpperCase(),
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            Flexible(
                              flex: 1,
                              child: ListView.builder(
                                  itemCount: _existingAccountList.length,
                                  itemBuilder: (context, index) {
                                    return Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        Expanded(
                                          flex: 6,
                                          child: Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: TextFormField(
                                              enableInteractiveSelection: false,
                                              initialValue:
                                                  _existingAccountList[index]
                                                      .username!,
                                              enabled: false,
                                              validator: (value) {
                                                if (value == null ||
                                                    value.isEmpty) {
                                                  return "Username cannot be empty";
                                                }
                                                return null;
                                              },
                                              decoration: InputDecoration(
                                                  prefixIcon: Icon(
                                                    Icons.person,
                                                  ),
                                                  label: Text("Username")),
                                            ),
                                          ),
                                        ),
                                        Expanded(
                                          flex: 4,
                                          child: ElevatedButton.icon(
                                            style: ElevatedButton.styleFrom(
                                                backgroundColor:
                                                    AppColors().backgroundColor,
                                                // Background color
                                                foregroundColor:
                                                    AppColors().textColor,
                                                // Text color
                                                side: BorderSide(
                                                  color: AppColors().textColor,
                                                  // Border color
                                                  width: 0.2, // Border width
                                                ),
                                                elevation: 2),
                                            onPressed: () {
                                              editExistingPassword(index);
                                            },
                                            icon: Icon(Icons.edit),
                                            label: Text("password"
                                                .toUpperCase()),
                                          ),
                                        ),
                                        IconButton(
                                            onPressed: () {
                                              setState(() {
                                                deleteExistingAccount(index);
                                              });
                                            },
                                            icon: Icon(Icons.delete))
                                      ],
                                    );
                                  }),
                            )
                          ],
                        ),
                      ),
                    ),
                    Expanded(
                      flex: 6,
                      child: _accountList.length > 0
                          ? ListView.builder(
                              itemCount: _accountList.length,
                              itemBuilder: (context, index) {
                                return Padding(
                                  padding: const EdgeInsets.all(12.0),
                                  child: Row(
                                    children: [
                                      Expanded(
                                        child: TextFormField(
                                          enableInteractiveSelection: false,
                                          maxLength: 25,
                                          controller:
                                              _usernameControllerList[index],
                                          validator: (value) {
                                            if (value == null ||
                                                value.isEmpty) {
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
                                                    color:
                                                        AppColors().textColor),
                                              ),
                                              TextSpan(
                                                  text: "*",
                                                  style: TextStyle(
                                                      color: Colors.red,
                                                      fontWeight:
                                                          FontWeight.bold))
                                            ])),
                                            hintText: "Username",
                                          ),
                                        ),
                                      ),
                                      SizedBox(
                                        width: 10,
                                      ),
                                      Expanded(
                                        child: TextFormField(
                                          enableInteractiveSelection: false,
                                          maxLength: 25,
                                          controller:
                                              _passwordControllerList[index],
                                          validator: (value) {
                                            if (value == null ||
                                                value.isEmpty) {
                                              return "Password cannot be empty";
                                            }
                                            return null;
                                          },
                                          obscureText:
                                              !_passwordVisibility[index],
                                          decoration: InputDecoration(
                                            prefixIcon: Icon(
                                              Icons.lock,
                                            ),
                                            label: RichText(
                                                text: TextSpan(children: [
                                              TextSpan(
                                                text: "Password ",
                                                style: TextStyle(
                                                    color:
                                                        AppColors().textColor,
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
                                            suffixIcon: SizedBox(
                                              width: 100,
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.end,
                                                children: [
                                                  Tooltip(
                                                    message:
                                                        "Click to generate password",
                                                    child: IconButton(
                                                      onPressed: () {
                                                        setState(() {
                                                          _passwordVisibility[
                                                              index] = true;
                                                          SystemDataClient()
                                                              .getGeneratedPassword()
                                                              .then((value) {
                                                            if (value != null) {
                                                              _passwordControllerList[
                                                                      index]
                                                                  .text = value;
                                                            }
                                                          });
                                                        });
                                                      },
                                                      icon:
                                                          Icon(Icons.password),
                                                    ),
                                                  ),
                                                  IconButton(
                                                    onPressed: () {
                                                      setState(() {
                                                        _passwordVisibility[
                                                                index] =
                                                            !_passwordVisibility[
                                                                index];
                                                      });
                                                    },
                                                    icon: _passwordVisibility[
                                                            index]
                                                        ? Icon(Icons
                                                            .visibility_off)
                                                        : Icon(
                                                            Icons.visibility),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
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
                                              _passwordVisibility
                                                  .removeAt(index);
                                            });
                                          },
                                          icon: Icon(
                                            Icons.delete,
                                          ))
                                    ],
                                  ),
                                );
                              })
                          : Container(
                              child: Center(
                                child: Text("New account goes here".toUpperCase()),
                              ),
                            ),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 20,
              ),
              Row(
                children: [
                  Expanded(
                    child: Row(
                      children: [
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors().backgroundColor,
                            // Background color
                            foregroundColor: AppColors().textColor,
                            // Text color
                            side: BorderSide(
                              color: AppColors().textColor, // Border color
                              width: 2, // Border width
                            ),
                          ),
                          onPressed: () {
                            showDialog(
                                context: context,
                                builder: (context) {
                                  return PasswordGenerator();
                                });
                          },
                          child: Text(
                            "Password generator".toUpperCase(),
                          ),
                        ),
                        SizedBox(
                          width: 20,
                        ),
                        ElevatedButton.icon(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors().backgroundColor,
                            // Background color
                            foregroundColor: AppColors().textColor,
                            // Text color
                            side: BorderSide(
                              color: AppColors().textColor, // Border color
                              width: 2, // Border width
                            ),
                          ),
                          onPressed: () {
                            setState(() {
                              _accountList.add(Account.empty());
                              _usernameControllerList
                                  .add(TextEditingController());
                              _passwordControllerList
                                  .add(TextEditingController());
                              _passwordVisibility.add(false);
                            });
                          },
                          label: Text("Add account".toUpperCase()),
                          icon: Icon(Icons.add),
                          iconAlignment: IconAlignment.start,
                        ),
                      ],
                    ),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        saveUpdates();
                      }
                    },
                    child: Text("Save".toUpperCase()),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
