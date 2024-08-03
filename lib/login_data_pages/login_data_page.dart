import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:frontend/models/attribute.dart';
import 'package:frontend/models/login.dart';
import 'package:frontend/models/login_account.go.dart';

class LoginDataPage extends StatefulWidget {
  const LoginDataPage({super.key});

  @override
  State<LoginDataPage> createState() => _LoginDataPageState();
}

class _LoginDataPageState extends State<LoginDataPage> {
  final List<LoginData> _login_data_list = [
    LoginData("github", "http://github.com", Attribute(false, false),
        [Account("abc", "123"), Account("pqr", "123")]),
    LoginData("gmail", "http://gmail.com", Attribute(true, true),
        [Account("abc", "123")]),
  ];

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
        itemCount: _login_data_list.length,
        itemBuilder: (BuildContext context, int index) {
          LoginData data = _login_data_list[index];
          return ExpansionTile(
            leading: data.attribute.isFavourite
                ? Icon(
                    Icons.star,
                    color: Colors.amber,
                  )
                : Icon(Icons.star_border),
            title: Text(data.name),
            subtitle: GestureDetector(child: Text(data.url), onTap: () {
              print("URL: ${data.url}");
            },),
            children: data.accounts.map((m) {
              return Column(
                children: [
                  ListTile(
                    leading: IconButton(icon: Icon(Icons.copy), onPressed: () async {
                      await Clipboard.setData(ClipboardData(text: m.username));
                    },),
                    title: Text("Username:"+ m.username),
                  ),
                  ListTile(
                    leading: IconButton(icon: Icon(Icons.copy), onPressed: () async {
                      await Clipboard.setData(ClipboardData(text: m.password));
                    },),
                    title: Text("Password: "+m.password),
                  ),
                  Divider()
                ],
              );
            }).toList(),
          );
        });
  }
}
