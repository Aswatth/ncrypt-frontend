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
  bool _showRequireMasterPasswordData = false;
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
                                Theme
                                    .of(context)
                                    .colorScheme
                                    .primary,
                                iconColor:
                                Theme
                                    .of(context)
                                    .colorScheme
                                    .surface,
                                foregroundColor:
                                Theme
                                    .of(context)
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
  }

  void copyPasswordToClipboard(LoginData data, String username) {
    client.getDecryptedPassword(data.name, username).then((value) {
      if (value is String && value.isNotEmpty) {
        Clipboard.setData(ClipboardData(text: value)).then((_) {
          if (context.mounted) {
            CustomToast.info(context, "Copied password to clipboard");
          }
        });
      }
    });
  }

  void getMasterPassword(LoginData data, String username) {
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
                          copyPasswordToClipboard(data, username);
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
                        ),
                        onChanged: (value) {
                          setState(() {
                            _filteredDataList = _loginDataList.where((m) =>
                                m.name.startsWith(_searchController.text))
                                .toList();
                          });
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
                                selected: selectedData != null && selectedData == m
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
            )
          ),
          selectedData != null
              ? Flexible(
            flex: 2,
            child: Padding(
              padding: const EdgeInsets.symmetric(
                  horizontal: 20.0, vertical: 8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          "${selectedData!.name} accounts",
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                      IconButton(
                        onPressed: () {
                          setState(() {
                            selectedData = null;
                          });
                        },
                        icon: Icon(Icons.close),
                      )
                    ],
                  ),
                  Divider(),
                  Expanded(
                    child: ListView.builder(
                        itemCount: selectedData!.accounts.length,
                        itemBuilder: (context, index) {
                          Account account = selectedData!.accounts[index];
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
                                              color:
                                              AppColors().textColor)),
                                      TextSpan(
                                          text: account.username!,
                                          style: TextStyle(
                                              color:
                                              AppColors().textColor))
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
                                                fontWeight:
                                                FontWeight.bold,
                                                color: AppColors()
                                                    .textColor)),
                                        TextSpan(
                                            text: "*****",
                                            style: TextStyle(
                                                color: AppColors()
                                                    .textColor))
                                      ]),
                                    ),
                                  ),
                                  IconButton(
                                    onPressed: () {
                                      if (selectedData!.attributes
                                          .requireMasterPassword) {
                                        getMasterPassword(selectedData!,
                                            account.username!);
                                      } else {
                                        copyPasswordToClipboard(
                                            selectedData!,
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
              : Container()
        ],
      ),
    );
  }
}
