import 'package:flutter/material.dart';
import 'package:yumnak/screens/ForgetPassword.dart';


class SignIn_SP extends StatefulWidget {
  @override
  _SignIn_SPState createState() => _SignIn_SPState();
}

class _SignIn_SPState extends State<SignIn_SP> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomPadding: false,
        body: Column(crossAxisAlignment: CrossAxisAlignment.center, children: <
            Widget>[
          Container(
            child: Stack(
              children: <Widget>[
                Container(
                  padding: EdgeInsets.fromLTRB(11.0, 60.0, 0.0, 30.0),
                  child: Text(
                    'تسجيل دخول',
                    style:
                    TextStyle(color: Colors.lightBlueAccent, fontSize: 40.0, fontWeight: FontWeight.bold, fontFamily: "Montserrat"),
                  ),
                ),
              ],
            ),
          ),

          Container(
            padding: EdgeInsets.fromLTRB(160.0, 00.0, 0.0, 0.0),
            child: Text(
              '..أهلا بعودتك',
              style:
              TextStyle(color: Colors.grey[600], fontSize: 20.0, fontWeight: FontWeight.bold, fontFamily: "Montserrat"),
            ),
          ),
          Container(
            padding: EdgeInsets.fromLTRB(90.0, 00.0, 0.0, 0.0),
            child: Text(
              'فضلاً أدخل معلومات الدخول',
              style:
              TextStyle(color: Colors.grey[600], fontSize: 15.0, fontFamily: "Montserrat"),
            ),
          ),

          Container(
              padding: EdgeInsets.only(top: 20.0, left: 20.0, right: 20.0),
              child: Column(
                children: <Widget>[
                  Directionality(
                      textDirection: TextDirection.rtl,
                      child:TextField(
                        decoration: InputDecoration(
                            labelText:  'رقم الجوال',
                            labelStyle: TextStyle( fontFamily: 'Montserrat',fontWeight: FontWeight.bold, color: Colors.grey),
                            focusedBorder: UnderlineInputBorder(
                                borderSide: BorderSide(color: Colors.lightBlueAccent))),
                      )
                  ),
                  SizedBox(height: 10.0),
                  Directionality(
                      textDirection: TextDirection.rtl,
                      child:TextField(
                        decoration: InputDecoration(
                            labelText: 'كلمة المرور ',
                            labelStyle: TextStyle(fontFamily: 'Montserrat',fontWeight: FontWeight.bold,color: Colors.grey),
                            focusedBorder: UnderlineInputBorder(
                                borderSide: BorderSide(color: Colors.lightBlueAccent))),
                        obscureText: true,
                      )
                  ),
                  SizedBox(height: 10.0),

                  Container(
                    padding: EdgeInsets.fromLTRB(0.0, 00.0, 200.0, 50.0),
                    child: GestureDetector(
                        child: Text('نسيت كلمة المرور ؟', style:
                        TextStyle(color: Colors.grey[600], fontSize: 15.0, fontFamily: "Montserrat"),),
                        onTap: () {
                          Navigator.push(context, new MaterialPageRoute(
                              builder: (context) => ForgetPassword()
                          ));
                        }

                    ),
                  ),

                  Container(
                      height: 40.0,
                      child: Material(
                        borderRadius: BorderRadius.circular(20.0),
                        shadowColor: Colors.lightBlueAccent,
                        color: Colors.green[300],
                        elevation: 7.0,
                        child: GestureDetector(
                          onTap: () {},
                          child: Center(
                            child: Text( 'تسجيل الدخول',
                              style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 20.0,
                                  fontFamily: 'Montserrat'),
                            ),
                          ),
                        ),
                      )),
                  SizedBox(height: 20.0),
                  Container(
                      height: 40.0,
                      child: Material(
                        borderRadius: BorderRadius.circular(20.0),
                        shadowColor: Colors.lightBlueAccent,
                        color: Colors.green[300],
                        elevation: 7.0,
                        child: GestureDetector(
                          onTap: () {
                           /* Navigator.push(context, new MaterialPageRoute(
                                builder: (context) => signUp()
                            ));*/
                          },
                          child: Center(
                            child: Text( 'تسجيل مستخدم جديد',
                              style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 20.0,
                                  fontFamily: 'Montserrat'),
                            ),
                          ),
                        ),
                      )),

                ],
              )),
        ]));
  }
}
