import 'package:flutter/material.dart';
import 'package:frontend/clients/login_data_client.dart';
import 'package:frontend/clients/system_data_client.dart';
import 'package:frontend/utils/colors.dart';
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
  bool _isLocked = false;
  final List<Account> _accountList = [];
  final List<TextEditingController> _usernameControllerList = [];
  final List<TextEditingController> _passwordControllerList = [];
  final List<bool> _passwordVisibility = [];

  void addLoginData() {
    if (_accountList.isEmpty) {
      if (context.mounted) {
        CustomToast.error(context, "Should have at least 1 account");
      }
      return;
    }
    for (int i = 0; i < _accountList.length; ++i) {
      _accountList[i].username = _usernameControllerList[i].text;
      _accountList[i].password = _passwordControllerList[i].text;
    }

    LoginDataClient()
        .addLoginData(LoginData(
            name: _nameController.text,
            url: _urlController.text,
            attributes: Attributes(
                isFavourite: _isFavourite, requireMasterPassword: _isLocked),
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
        title: Text("Add login data"),
        elevation: 1.5,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              SizedBox(
                width: double.infinity,
                child: TextFormField(
                  controller: _nameController,
                  maxLength: 16,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Name cannot be empty";
                    }
                    return null;
                  },
                  decoration: InputDecoration(
                    prefixIcon: Icon(Icons.account_box_outlined),
                    filled: true,
                    label: RichText(
                        text: TextSpan(children: [
                      TextSpan(
                        text: "Name ",
                        style: TextStyle(
                            color: AppColors().textColor, fontSize: 16),
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
                  Flexible(
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
                  Flexible(
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
                      title: Tooltip(
                        message:
                            "Requires master password to view account password, edit and delete data.",
                        child: Text("Locked"),
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 20,
              ),
              _accountList.length > 0
                  ? Align(
                      alignment: Alignment.topLeft,
                      child: Text(
                        "Accounts:".toUpperCase(),
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    )
                  : Container(),
              Flexible(
                child: ListView.builder(
                    shrinkWrap: true,
                    itemCount: _accountList.length,
                    itemBuilder: (context, index) {
                      return Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              child: TextFormField(
                                enableInteractiveSelection: false,
                                controller: _usernameControllerList[index],
                                maxLength: 25,
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
                                            color: AppColors().textColor)),
                                    TextSpan(
                                        text: "*",
                                        style: TextStyle(
                                            color: Colors.red,
                                            fontWeight: FontWeight.bold))
                                  ])),
                                  hintText: "Username for the account",
                                ),
                              ),
                            ),
                            SizedBox(
                              width: 20,
                            ),
                            Expanded(
                              child: TextFormField(
                                enableInteractiveSelection: false,
                                maxLength: 25,
                                controller: _passwordControllerList[index],
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
                                              color: AppColors().textColor)),
                                      TextSpan(
                                          text: "*",
                                          style: TextStyle(
                                              color: Colors.red,
                                              fontWeight: FontWeight.bold))
                                    ])),
                                    hintText: "Password for the account",
                                    hintStyle: TextStyle(color: Colors.grey),
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
                                                  _passwordVisibility[index] =
                                                      true;
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
                                              icon: Icon(Icons.password),
                                            ),
                                          ),
                                          IconButton(
                                            onPressed: () {
                                              setState(() {
                                                _passwordVisibility[index] =
                                                    !_passwordVisibility[index];
                                              });
                                            },
                                            icon: _passwordVisibility[index]
                                                ? Icon(Icons.visibility_off)
                                                : Icon(Icons.visibility),
                                          ),
                                        ],
                                      ),
                                    )),
                              ),
                            ),
                            SizedBox(
                              width: 10,
                            ),
                            Align(
                              alignment: Alignment.center,
                              child: IconButton(
                                  onPressed: () {
                                    setState(() {
                                      _accountList.removeAt(index);
                                      _usernameControllerList.removeAt(index);
                                      _passwordControllerList.removeAt(index);
                                      _passwordVisibility.removeAt(index);
                                    });
                                  },
                                  icon: Icon(
                                    Icons.delete,
                                  )),
                            )
                          ],
                        ),
                      );
                    }),
              ),
              SizedBox(
                height: 20,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
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
                        addLoginData();
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
