import 'package:flutter/material.dart';
import 'package:frontend/master_password_pages/main.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late List<String> _optionList;
  late List<Icon> _optionIconList;

  @override
  void initState() {
    super.initState();
    _optionList = ["Login", "Import", "Export"];
    _optionIconList = [
      Icon(Icons.login),
      Icon(Icons.upload),
      Icon(Icons.download)
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Row(
          crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        SizedBox(
          // color: Colors.deepPurple,
          width: MediaQuery.sizeOf(context).width * 0.25 > 400
              ? MediaQuery.sizeOf(context).width * 0.25
              : 400,
          // color: Colors.deepPurple,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Container(
                width: double.infinity,
                color: Colors.black,
                child: Padding(
                  padding: EdgeInsets.all(50.0),
                  child: Center(
                      child: Text(
                    "Ncrypt",
                    style: TextStyle(color: Colors.greenAccent, fontSize: 50),
                  )),
                ),
              ),
              ListView.builder(
                shrinkWrap: true,
                  itemCount: _optionList.length,
                  itemBuilder: (context, index) {
                    return ListTile(
                      leading: _optionIconList[index],
                      title: Text(_optionList[index]),
                    );
                  })
            ],
          ),
        ),
        Expanded(
            child: Container(
          child: MasterPasswordPage(),
        ))
      ],
    ));
  }
}
