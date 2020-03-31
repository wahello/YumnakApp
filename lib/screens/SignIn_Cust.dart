import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:yumnak/screens/ForgetPassword.dart';
import 'package:yumnak/screens/HomePage.dart';
import 'package:yumnak/screens/SignUp_Cust.dart';
import 'package:yumnak/services/auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:fluttertoast/fluttertoast.dart';



class SignIn_Cust extends StatefulWidget {
  @override
  _SignIn_CustState createState() => _SignIn_CustState();
}


class myData {
  String email;

  myData(this.email);
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

  List<myData> allData = [];
  var keys;
  bool found= false;

  @override
  void initState() {
    myData d;

    DatabaseReference ref = FirebaseDatabase.instance.reference();
    ref.child('Customer').once().then((DataSnapshot snap) async {
      keys = snap.value.keys;
      var data = snap.value;

      allData.clear();

      for (var key in keys) {
        d = new myData(
            data[key]['email']
        );
        await allData.add(d);
      }
    });
    super.initState();
  }

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
                                validator: (val) => val.isEmpty ? "أدخل البريد الإلكتروني" : null,  //null means valid email
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
                                validator: (val) => val.isEmpty ? "أدخل كلمة المرور" : null,  //null means valid password
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

                                    for (int i=0; i<allData.length; i++) {
                                      if(allData[i].email==email){
                                        found=true;
                                      }
                                    }

                                    if(found){
                                      if (_formKey.currentState.validate()){
                                        result = await _auth.signInWithEmailAndPassword(email, password);
                                        if (result == null ){
                                          setState(() => error = "");
                                        }
                                        else{
                                          print("This is uid "+result);
                                          final user = await FirebaseAuth.instance.currentUser();
                                          Navigator.of(context).pop();
                                          Navigator.pushReplacement(context, new MaterialPageRoute(
                                              builder: (context) => HomePage(result)
                                          ));
                                        }
                                      }
                                    }
                                    else{
                                      Fluttertoast.showToast(
                                          msg: ("خطأ بالدخول"),
                                          toastLength: Toast.LENGTH_LONG,
                                          gravity: ToastGravity.CENTER,
                                          timeInSecForIos: 20,
                                          backgroundColor: Colors.red[100],
                                          textColor: Colors.red[800]
                                      );
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
