import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:yumnak/services/auth.dart';

class ForgetPassword extends StatefulWidget {
  @override
  _ForgetPasswordState createState() => _ForgetPasswordState();
}

class _ForgetPasswordState extends State<ForgetPassword> {

  final AuthService  _auth = AuthService();
  final _formKey = GlobalKey<FormState>();

  String email="";
String erorr;
bool isExit=false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: new AppBar(
          title: new Center(child: new Text("نسيت كلمة المرور", textAlign: TextAlign.center, style: TextStyle(color: Colors.grey[600], fontSize: 25.0, fontFamily: "Montserrat"))),
          backgroundColor: Colors.grey[200],

        ),
        resizeToAvoidBottomPadding: false,
        body: Container(
          child: Form(
              key: _formKey,  //for validation
              child: Column(crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[

                  Container(
                    padding: EdgeInsets.fromLTRB(0.0, 100.0, 0.0, 0.0),
                    child: Text(
                      'فضلاً أدخل البريد الإلكتروني',textAlign: TextAlign.center,
                      style:
                      TextStyle(color: Colors.lightBlueAccent, fontSize: 20.0, fontWeight: FontWeight.bold, fontFamily: "Montserrat"),
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 10.0),
                    child: Text(
                      'سيتم إرسال رابط إعادة تعيين كلمة المرور إلى بريدك الألكتروني',textAlign: TextAlign.center,
                      style:
                      TextStyle(color: Colors.grey[600], fontSize: 15.0, fontFamily: "Montserrat"),
                    ),
                  ),

                  Directionality(
                      textDirection: TextDirection.rtl,
                      child:TextFormField(
                        validator: (val) => val.isEmpty ? "فضلاً أدخل البريد الإلكتروني" : null,  //null means valid email
                        decoration: InputDecoration(
                            labelText:  'البريد الإلكتروني',
                            labelStyle: TextStyle( fontFamily: 'Montserrat',fontWeight: FontWeight.bold, color: Colors.grey),
                            focusedBorder: UnderlineInputBorder(
                                borderSide: BorderSide(color: Colors.lightBlueAccent))),
                                onChanged: (val){setState(() => email=val);},
                      )
                  ),

                  Row(
                    children: <Widget>[
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.only(left: 20.0, right: 20.0, top: 10.0),
                          child: RaisedButton(
                            //onPressed: ,

                            child: Text("إرسال", style: TextStyle(fontSize: 15.0, color: Colors.white),),elevation: 7.0,color: Colors.green[300],

                            onPressed: ()async {
                              if (_formKey.currentState.validate()){
                         dynamic result = _auth.sendPasswordResetEmail(email);
                                Fluttertoast.showToast(
                                    msg: "تم إرسال رابط تغير كلمة المرور إليك",
                                    toastLength: Toast.LENGTH_LONG,
                                    gravity: ToastGravity.BOTTOM,
                                    timeInSecForIos: 5,
                                    backgroundColor: Colors.lightBlueAccent,
                                    textColor: Colors.white
                                );
                              }
                            },
                          ),
                        ),
                      ),
                    ],
                  )


                ])

          )
        )


    );
  }
}
