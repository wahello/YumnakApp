import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:flutter/material.dart';
import 'package:yumnak/screens/ForgetPassword.dart';
import 'package:yumnak/screens/HomePage.dart';
import 'package:yumnak/screens/SignUp_Cust.dart';
import 'package:yumnak/services/auth.dart';
import 'package:firebase_database/firebase_database.dart';



class SignIn_Cust extends StatefulWidget {
  @override
  _SignIn_CustState createState() => _SignIn_CustState();
}



class _SignIn_CustState extends State<SignIn_Cust> {

  final AuthService  _auth = AuthService();
  final  _formKey = GlobalKey<FormState>();

  String email="";
  String password="";
  var uid;
  String error="";
  dynamic result;
  var db;



  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomPadding: false,
        body: Container(
            child: Form(
                key: _formKey,  //for validation
                child: Column(crossAxisAlignment: CrossAxisAlignment.center, children: <
                    Widget>[
                  Container(
                    child: Stack(
                      children: <Widget>[
                        Container(
                          padding: EdgeInsets.fromLTRB(11.0, 40.0, 0.0, 30.0),
                          child: Text('تسجيل دخول',
                            style:
                            TextStyle(color: Colors.lightBlueAccent, fontSize: 40.0, fontWeight: FontWeight.bold, fontFamily: "Montserrat"),
                          ),
                        ),
                      ],
                    ),
                  ),

                  Container(
                    padding: EdgeInsets.fromLTRB(160.0, 00.0, 0.0, 0.0),
                    child: Text( '..أهلا بعودتك',
                      style:
                      TextStyle(color: Colors.grey[600], fontSize: 20.0, fontWeight: FontWeight.bold, fontFamily: "Montserrat"),
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.fromLTRB(90.0, 00.0, 0.0, 0.0),
                    child: Text('فضلاً أدخل معلومات الدخول',
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
                              child:TextFormField(
                                validator: (val) => val.isEmpty ? "Enter an email" : null,  //null means valid email
                                decoration: InputDecoration(
                                    labelText:  'البريد الإلكتروني',
                                    labelStyle: TextStyle( fontFamily: 'Montserrat',fontWeight: FontWeight.bold, color: Colors.grey),
                                    focusedBorder: UnderlineInputBorder(
                                        borderSide: BorderSide(color: Colors.lightBlueAccent))),
                                onChanged: (val){setState(() => email=val);},
                              )
                          ),
                          SizedBox(height: 10.0),
                          Directionality(
                              textDirection: TextDirection.rtl,
                              child:TextFormField(
                                validator: (val) => val.length < 6 ? "enter a password 6+ chars long" : null,  //null means valid password
                                decoration: InputDecoration(
                                    labelText: 'كلمة المرور ',
                                    labelStyle: TextStyle(fontFamily: 'Montserrat',fontWeight: FontWeight.bold,color: Colors.grey),
                                    focusedBorder: UnderlineInputBorder(
                                        borderSide: BorderSide(color: Colors.lightBlueAccent))),
                                obscureText: true,
                                onChanged: (val){ setState(() => password =val);},
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
                                  onTap: () async {
                                    if (_formKey.currentState.validate()){
                                       result = await _auth.signInWithEmailAndPassword(email, password);
                                      if (result == null ){
                                        setState(() => error= 'البريد الإلكتروني أو كلمة المرور غير صحيحة');
                                      }
                                    else{
                                      print("signed in");

                                     db=  FirebaseDatabase.instance.reference().child("Customer").child("-M-Tcn7P9yohEGmOEwlM");
                                      db.once().then((DataSnapshot snapshot){
                                        Map<dynamic, dynamic> values=snapshot.value;
                                        print(values["name"]);
                                      } );

                                      print("This is uid "+result);
                                      Navigator.push(context, new MaterialPageRoute(
                                          builder: (context) => HomePage()
                                    ));
                                    }
                                    }
                                  },
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
                                    Navigator.push(context, new MaterialPageRoute(
                                    builder: (context) => SignUp_Cust()
                                    ));
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
                ])
            )
        )


    );
  }
}
