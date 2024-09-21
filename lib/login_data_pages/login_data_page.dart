import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:frontend/clients/login_data_client.dart';
import 'package:frontend/clients/master_password_client.dart';
import 'package:frontend/models/login_account.dart';
import 'package:frontend/utils/colors.dart';
import 'package:frontend/utils/custom_toast.dart';
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

  TextEditingController _searchController = TextEditingController();
  bool _showFavourites = false;
  bool _showRequireMasterPassword = false;
  LoginData? selectedData;

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
    client.updateLoginData(data.name, data).then((value) {
      if (!(value != null && value is String && value.isEmpty)) {
        if (context.mounted) {
          CustomToast.error(context, "Unable to update favourites");
        }
      }
    });
  }

  void delete(LoginData data) {
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

                                  if (context.mounted) {
                                    Navigator.of(context).pop();
                                    CustomToast.success(
                                        context, "Successfully deleted!");
                                  }
                                } else {
                                  if (context.mounted) {
                                    CustomToast.error(context, value);
                                  }
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

  void _filterLoginData() {
    setState(() {
      _filteredDataList = _loginDataList;

      if (_searchController.text.isNotEmpty) {
        _filteredDataList = _filteredDataList
            .where((m) => m.name.startsWith(_searchController.text))
            .toList();
      }

      if (_showFavourites) {
        _filteredDataList =
            _filteredDataList.where((m) => m.attributes.isFavourite).toList();
      }

      if (_showRequireMasterPassword) {
        _filteredDataList = _filteredDataList
            .where((m) => m.attributes.requireMasterPassword)
            .toList();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        children: [
          Flexible(
              flex: 4,
              child: Column(
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: TextFormField(
                          controller: _searchController,
                          decoration: InputDecoration(
                              prefixIcon: Icon(Icons.search),
                              filled: true,
                              suffixIcon: SizedBox(
                                width: 80,
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    IconButton(
                                      onPressed: () {
                                        setState(() {
                                          _showFavourites = !_showFavourites;
                                          _filterLoginData();
                                        });
                                      },
                                      icon: _showFavourites
                                          ? Icon(Icons.favorite)
                                          : Icon(Icons.favorite_border),
                                    ),
                                    IconButton(
                                      onPressed: () {
                                        setState(() {
                                          _showRequireMasterPassword =
                                              !_showRequireMasterPassword;
                                          _filterLoginData();
                                        });
                                      },
                                      icon: _showRequireMasterPassword
                                          ? Icon(Icons.lock)
                                          : Icon(Icons.lock_outline),
                                    )
                                  ],
                                ),
                              )),
                          onChanged: (value) {
                            _filterLoginData();
                          },
                        ),
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      ElevatedButton.icon(
                        onPressed: () {
                          Navigator.of(context)
                              .push(MaterialPageRoute(
                                  builder: (context) => AddLoginData()))
                              .then((_) {
                            setState(() {
                              selectedData = null;
                              getAllLoginData();
                            });
                          });
                        },
                        icon: Icon(Icons.add),
                        label: Text("Add"),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Expanded(
                    child: SingleChildScrollView(
                      scrollDirection: Axis.vertical,
                      child: SizedBox(
                        width: double.infinity,
                        child: DataTable(
                            showCheckboxColumn: false,
                            columns: [
                              DataColumn(label: Text("Favourite")),
                              DataColumn(label: Text("Name")),
                              DataColumn(label: Text("URL")),
                              DataColumn(label: Text("Lock status")),
                              DataColumn(label: Text("Actions"))
                            ],
                            rows: _filteredDataList.map((m) {
                              return DataRow(
                                  selected:
                                      selectedData != null && selectedData == m
                                          ? true
                                          : false,
                                  onSelectChanged: (value) {
                                    setState(() {
                                      selectedData = m;
                                    });
                                  },
                                  cells: [
                                    DataCell(IconButton(
                                      onPressed: () {
                                        setState(() {
                                          m.attributes.isFavourite =
                                              !m.attributes.isFavourite;
                                          updateFavourite(m);
                                        });
                                      },
                                      icon: m.attributes.isFavourite
                                          ? Icon(
                                              Icons.favorite,
                                            )
                                          : Icon(Icons.favorite_border),
                                    )),
                                    DataCell(Text(m.name)),
                                    DataCell(Text(m.url)),
                                    DataCell(m.attributes.requireMasterPassword
                                        ? Row(
                                            children: [
                                              Icon(
                                                Icons.lock,
                                              ),
                                              Text(
                                                "LOCKED",
                                                style: TextStyle(
                                                  letterSpacing: 2,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              )
                                            ],
                                          )
                                        : Container()),
                                    DataCell(Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceEvenly,
                                      children: [
                                        IconButton(
                                          onPressed: () {
                                            Navigator.of(context)
                                                .push(MaterialPageRoute(
                                                    builder: (context) =>
                                                        EditLoginDataPage(
                                                          dataToEdit: m,
                                                        )))
                                                .then((_) {
                                              setState(() {
                                                selectedData = null;
                                                getAllLoginData();
                                              });
                                            });
                                          },
                                          icon: Icon(Icons.edit),
                                        ),
                                        IconButton(
                                          onPressed: () {
                                            delete(m);
                                          },
                                          icon: Icon(Icons.delete),
                                        )
                                      ],
                                    ))
                                  ]);
                            }).toList()),
                      ),
                    ),
                  )
                ],
              )),
          LoginAccountData(selectedData: selectedData)
        ],
      ),
    );
  }
}

class LoginAccountData extends StatefulWidget {
  LoginData? selectedData;

  LoginAccountData({super.key, required this.selectedData});

  @override
  State<LoginAccountData> createState() => _LoginAccountDataState();
}

class _LoginAccountDataState extends State<LoginAccountData> {
  List<String> passwordList = [];
  final String hiddenPasswordString = "*****";

  void buildPasswordViewer() {
    if (widget.selectedData != null) {
      setState(() {
        int accountLength = widget.selectedData!.accounts.length;
        passwordList =
            List.generate(accountLength, (int index) => hiddenPasswordString);
      });
    }
  }

  @override
  void didUpdateWidget(covariant LoginAccountData oldWidget) {
    // TODO: implement didUpdateWidget
    super.didUpdateWidget(oldWidget);
    buildPasswordViewer();
  }

  Future<String> decryptPassword(String username) async {
    dynamic value = await LoginDataClient()
        .getDecryptedPassword(widget.selectedData!.name, username);

    if (value != null && value is String && value.isNotEmpty) {
      return value;
    }
    return "";
  }

  void copyPasswordToClipboard(String username) {
    decryptPassword(username).then((value) {
      Clipboard.setData(ClipboardData(text: value)).then((_) {
        if (context.mounted) {
          CustomToast.info(context, "Copied password to clipboard");
        }
      });
    });
  }

  void getMasterPassword(String username) {
    String enteredPassword = "";
    bool visibility = false;
    showDialog(
        context: context,
        builder: (context) {
          return StatefulBuilder(builder: (context, setState) {
            return SimpleDialog(
              contentPadding: EdgeInsets.all(12),
              children: [
                TextFormField(
                  enableInteractiveSelection: false,
                  obscureText: !visibility,
                  onChanged: (value) {
                    setState(() {
                      enteredPassword = value;
                    });
                  },
                  decoration: InputDecoration(
                      hintText: "Enter master password",
                      label: Text("Master Password"),
                      suffixIcon: IconButton(
                          onPressed: () {
                            setState(() {
                              visibility = !visibility;
                            });
                          },
                          icon: visibility
                              ? Icon(Icons.visibility)
                              : Icon(Icons.visibility_off))),
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
                          copyPasswordToClipboard(username);
                          Navigator.of(context).pop();
                        } else {
                          if (context.mounted) {
                            CustomToast.error(context, value);
                          }
                        }
                      });
                    },
                    child: Text("Validate".toUpperCase()))
              ],
            );
          });
        });
  }

  @override
  Widget build(BuildContext context) {
    return widget.selectedData != null
        ? Flexible(
            flex: 2,
            child: Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 20.0, vertical: 8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          "${widget.selectedData!.name} accounts",
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                      IconButton(
                        onPressed: () {
                          setState(() {
                            widget.selectedData = null;
                          });
                        },
                        icon: Icon(Icons.close, color: AppColors().textColor,),
                      )
                    ],
                  ),
                  Divider(),
                  Expanded(
                    child: ListView.builder(
                        itemCount: widget.selectedData!.accounts.length,
                        itemBuilder: (context, index) {
                          Account account =
                              widget.selectedData!.accounts[index];
                          return Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(children: [
                                Expanded(
                                  child: RichText(
                                    text: TextSpan(children: [
                                      TextSpan(
                                          text: "Username: ",
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              color: AppColors().textColor)),
                                      TextSpan(
                                          text: account.username!,
                                          style: TextStyle(
                                              color: AppColors().textColor))
                                    ]),
                                  ),
                                ),
                                IconButton(
                                  onPressed: () {
                                    Clipboard.setData(ClipboardData(
                                            text: account.username!))
                                        .then((_) {
                                      if (context.mounted) {
                                        CustomToast.info(context,
                                            "Copied username to clipboard");
                                      }
                                    });
                                  },
                                  icon: Icon(
                                    Icons.copy,
                                    color: AppColors().textColor,
                                  ),
                                ),
                              ]),
                              Row(
                                children: [
                                  Expanded(
                                    child: RichText(
                                      text: TextSpan(children: [
                                        TextSpan(
                                            text: "Password: ",
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                color: AppColors().textColor)),
                                        TextSpan(
                                            text: passwordList[index],
                                            style: TextStyle(
                                                color: AppColors().textColor))
                                      ]),
                                    ),
                                  ),
                                  passwordList[index] == hiddenPasswordString ? IconButton(
                                    onPressed: () {
                                      decryptPassword(account.username!)
                                          .then((value) {
                                        if (value.isNotEmpty) {
                                          setState(() {
                                            passwordList[index] = value;
                                          });
                                        }
                                      });
                                      Future.delayed(Duration(seconds: 5), () {
                                        setState(() {
                                          passwordList[index] =
                                              hiddenPasswordString;
                                        });
                                      });
                                    },
                                    icon: Icon(Icons.visibility),
                                  ) : Container(),
                                  IconButton(
                                    onPressed: () {
                                      if (widget.selectedData!.attributes
                                          .requireMasterPassword) {
                                        getMasterPassword(account.username!);
                                      } else {
                                        copyPasswordToClipboard(
                                            account.username!);
                                      }
                                    },
                                    icon: Icon(
                                      Icons.copy,
                                      color: AppColors().textColor,
                                    ),
                                  ),
                                ],
                              ),
                              Divider(
                                color: AppColors().primaryColor,
                                thickness: 0.5,
                              )
                            ],
                          );
                        }),
                  )
                ],
              ),
            ),
          )
        : Container();
  }
}
