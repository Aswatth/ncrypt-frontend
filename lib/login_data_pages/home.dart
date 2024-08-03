import 'package:flutter/material.dart';
import 'package:frontend/login_data_pages/login_data_page.dart';


class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          SizedBox(
            // color: Colors.deepPurple,
            width: MediaQuery.sizeOf(context).width * 0.25 > 400 ? MediaQuery.sizeOf(context).width * 0.25 : 400,
            // color: Colors.deepPurple,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Container(
                    width: double.infinity,
                    color: Colors.black,
                    child: Padding(
                      padding: EdgeInsets.all(50.0),
                      child: Center(child: Text("Ncrypt", style: TextStyle(color: Colors.greenAccent, fontSize: 50),)),
                    )),
                ListTile(
                  leading: Icon(Icons.star),
                  title: Text("Favourites"),
                ),
                ListTile(
                  leading: Icon(Icons.lock),
                  title: Text("Login"),
                ),
                ListTile(
                  leading: Icon(Icons.note),
                  title: Text("Note"),
                ),
                ListTile(
                  leading: Icon(Icons.logout),
                  title: Text("Logout"),
                ),
              ],
            ),
          ),
          Expanded(child: LoginDataPage())
        ],
      ),
    );
  }
}
