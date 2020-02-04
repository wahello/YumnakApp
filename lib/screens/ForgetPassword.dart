import 'package:flutter/material.dart';

class ForgetPassword extends StatefulWidget {
  @override
  _ForgetPasswordState createState() => _ForgetPasswordState();
}

class _ForgetPasswordState extends State<ForgetPassword> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: new AppBar(
          title: new Center(child: new Text("نسيت كلمة المرور", textAlign: TextAlign.center, style: TextStyle(color: Colors.grey[600], fontSize: 25.0, fontFamily: "Montserrat"))),
          backgroundColor: Colors.grey[200],
        ),
        resizeToAvoidBottomPadding: false,
        body: Column(crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[

              Container(
                padding: EdgeInsets.fromLTRB(0.0, 100.0, 0.0, 0.0),
                child: Text(
                  'فضلاً أدخل رقم الجوال',textAlign: TextAlign.center,
                  style:
                  TextStyle(color: Colors.lightBlueAccent, fontSize: 20.0, fontWeight: FontWeight.bold, fontFamily: "Montserrat"),
                ),
              ),
              Container(
                padding: EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 10.0),
                child: Text(
                  'ثم أدخل رمز الأمان المرسل إليك',textAlign: TextAlign.center,
                  style:
                  TextStyle(color: Colors.grey[600], fontSize: 15.0, fontFamily: "Montserrat"),
                ),
              ),

              Directionality(
                textDirection: TextDirection.rtl,
                child: ListTile(
                  leading: Icon(Icons.phone),
                  title: TextField(
                    decoration: InputDecoration(hintText: "رقم الجوال"),
                    keyboardType: TextInputType.phone,
                    // onChanged: (value) => phoneNumber = value,
                  ),
                ),
              ),

              Row(
                children: <Widget>[
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.only(left: 20.0, right: 20.0, top: 10.0),
                      child: RaisedButton(
                        //onPressed: ,
                        child: Text("إرسال", style: TextStyle(fontSize: 15.0, color: Colors.white),),elevation: 7.0,
                      ),
                    ),
                  ),
                ],
              )


            ]));
  }
}
