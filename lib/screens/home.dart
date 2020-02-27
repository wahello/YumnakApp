import 'package:flutter/material.dart';
import 'package:yumnak/services/auth.dart';


class Home extends StatelessWidget {

  final AuthService  _auth = AuthService();
// مساء السكر
  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: Text("Home Page"),
        elevation: 0.0,
        actions: <Widget>[
          FlatButton.icon(
              icon: Icon(Icons.person), label: Text("Logout")
               ,onPressed: () async {
                await _auth.signOut();
          })
        ],
      ),

    );
  }
}
