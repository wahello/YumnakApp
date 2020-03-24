import 'package:flutter/material.dart';

class supportSP extends StatefulWidget {
  @override
  _supportSPState createState() => _supportSPState();
}

class _supportSPState extends State<supportSP> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: new AppBar(
          title: new Center(child: new Text("الدعم والمساعدة", textAlign: TextAlign.center, style: TextStyle(color: Colors.lightBlueAccent, fontSize: 25.0, fontFamily: "Montserrat",fontWeight: FontWeight.bold))),
          backgroundColor: Colors.grey[200],
          iconTheme: IconThemeData(color: Colors.black38),
        ),
      body: Container(
        width: MediaQuery.of(context).size.width,
          child: Column(
            children: <Widget>[
            Container(
              padding: EdgeInsets.fromLTRB(0.0, 20.0, 0.0, 10.0),
              child: Text(
                'للدعم الفني يمكنكم الاتصال على الرقم',
                style:
                TextStyle(color: Colors.grey[600], fontSize: 20.0, fontFamily: "Montserrat"),
              ),
            ),
              Container(
                padding: EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 10.0),
                child: Text(
                  '920000001',
                  style:
                  TextStyle(color: Colors.grey[600], fontSize: 22.0, fontFamily: "Montserrat",letterSpacing: 3),
                ),
              ),
              Container(
                padding: EdgeInsets.fromLTRB(0.0, 10.0, 0.0, 10.0),
                child: Text(
                  'أو التواصل معنا عن طريق البريد الإلكتروني',
                  style:
                  TextStyle(color: Colors.grey[600], fontSize: 20.0, fontFamily: "Montserrat"),
                ),
              ),
              Container(
                padding: EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 10.0),
                child: Text(
                  'Yumnakapp@gmail.com',
                  style:
                  TextStyle(color: Colors.grey[600], fontSize: 20.0, fontFamily: "Montserrat"),
                ),
              ),
          ],
      ),
          ),
      );

  }
}
