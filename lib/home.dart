import 'package:flutter/material.dart';
import 'package:frontend/general_pages/settings.dart';
import 'package:frontend/login_data_pages/login_data_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late List<Widget> _optionList;

  @override
  void initState() {
    super.initState();
    _optionList = [
      ListTile(leading: Icon(Icons.security), title: Text("Login Credentials"), tileColor: Colors.grey,),
      ListTile(leading: Icon(Icons.note), title: Text("Notes")),
      ListTile(leading: Icon(Icons.upload), title: Text("Import")),
      ListTile(leading: Icon(Icons.download), title: Text("Export")),
      ListTile(leading: Icon(Icons.settings), title: Text("Settings"), onTap: (){
        Navigator.of(context).push(MaterialPageRoute(builder: (context) => SettingsPage()));
      },),
      ListTile(
        leading: Icon(Icons.logout),
        title: Text("Log out"),
        onTap: () {
          Navigator.of(context).pop();
        },
      ),
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
                        style:
                            TextStyle(color: Colors.greenAccent, fontSize: 50),
                      )),
                    )),
                ListView.builder(
                    shrinkWrap: true,
                    itemCount: _optionList.length,
                    itemBuilder: (context, index) {
                      return _optionList[index];
                    })
              ],
            ),
          ),
          Expanded(child: LoginDataPage())
        ],
      ),
    );
  }
}
