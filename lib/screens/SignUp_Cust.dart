import 'package:flutter/material.dart';
import 'package:yumnak/models/Customer.dart';
import 'package:yumnak/services/auth.dart';
import "package:firebase_database/firebase_database.dart";
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fluttertoast/fluttertoast.dart';
class SignUp_Cust extends StatefulWidget {
  @override
  _SignUp_CustState createState() => _SignUp_CustState();
}

class _SignUp_CustState extends State<SignUp_Cust> {

  Customer _customer = Customer();

  final AuthService  _auth = AuthService();
  final _formKey = GlobalKey<FormState>();


  final DatabaseReference database= FirebaseDatabase.instance.reference().child("Customer");

  sendData(){
    database.push().set({
      'name' : name,
      'email': email,
      //'password': password,
      'uid': uid,
      'phoneNumber': phoneNumber,
    });
  }

  String name="";
  String email="";
  String password="";
  String Vpassword="";
  var uid;
  String error="";
  String phoneNumber="";
  bool pass=false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(


      body: Container(
        child: Form(
          key: _formKey,  //for validation
          child: CustomScrollView(
            slivers: <Widget>[

              SliverList(

                delegate: SliverChildListDelegate([
                  Container(
                    padding: EdgeInsets.fromLTRB(60.0, 60.0, 0.0, 0.0),
                    child: Text(
                      'تسجيل مستخدم جديد',
                      style:
                      TextStyle(color: Colors.lightBlueAccent, fontSize: 30.0, fontWeight: FontWeight.bold, fontFamily: "Montserrat"),
                    ),
                  ),

                  Container(
                      padding: EdgeInsets.fromLTRB(30.0, 0.0, 30.0, 0.0),
                      child: Column(
                        children: <Widget>[
                          Directionality(
                              textDirection: TextDirection.rtl,
                              child:TextFormField(
                                onChanged: (val){setState(() => name=val);},
                                decoration: InputDecoration(
                                    icon: Icon(Icons.person),
                                    labelText:  'الاسم',
                                    labelStyle: TextStyle( fontFamily: 'Montserrat',fontWeight: FontWeight.bold, color: Colors.grey),
                                    focusedBorder: UnderlineInputBorder(
                                        borderSide: BorderSide(color: Colors.lightBlueAccent))),
                              )
                          ),
                          Directionality(
                              textDirection: TextDirection.rtl,
                              child:TextFormField(
                                validator: (val) => val.isEmpty ? "أدخل البريد الألكتروني" : null,  //null means valid email
                                onChanged: (val){setState(() => email=val);},
                                decoration: InputDecoration(
                                    icon: Icon(Icons.email),
                                    labelText:  'البريد الإلكتروني',
                                    labelStyle: TextStyle(fontFamily: 'Montserrat',fontWeight: FontWeight.bold, color: Colors.grey),
                                    focusedBorder: UnderlineInputBorder(
                                        borderSide: BorderSide(color: Colors.lightBlueAccent))),
                              )
                          ),
                          Directionality(
                              textDirection: TextDirection.rtl,
                              child:TextFormField(
                                validator: (String v){
                                  if (v.isEmpty) {
                                    return  "أدخل رقم الجوال";
                                  }
                                  if (v.length!=10) {
                                    return'أدخل رقم الجوال الصحيح';
                                  }
                                  return null;

                                },

                               // validator:(val) => val.isEmpty ? "أدخل رقم الجوال" : null,//null means valid phone
                                onChanged: (val){setState(() => phoneNumber=val);},
                                decoration: InputDecoration(
                                    icon: Icon(Icons.phone),
                                    labelText:  'رقم الجوال',
                                    labelStyle: TextStyle( fontFamily: 'Montserrat',fontWeight: FontWeight.bold, color: Colors.grey),
                                    focusedBorder: UnderlineInputBorder(
                                        borderSide: BorderSide(color: Colors.lightBlueAccent))),
                              )
                          ),

                          Directionality(
                              textDirection: TextDirection.rtl,
                              child:TextFormField(
                                validator: (val) => val.length < 6 ? "يجب أن تكون كلمة المرور أكثر من ستة خانات" : null,  //null means valid password
                                onChanged: (val){ setState(() => password =val);},
                                decoration: InputDecoration(
                                    icon: Icon(Icons.lock_outline),
                                    labelText: 'كلمة المرور ',
                                    labelStyle: TextStyle(fontFamily: 'Montserrat',fontWeight: FontWeight.bold,color: Colors.grey),
                                    focusedBorder: UnderlineInputBorder(
                                        borderSide: BorderSide(color: Colors.lightBlueAccent))),
                                obscureText: true,
                              )
                          ),

                          Directionality(
                            //padding: EdgeInsets.only(top: 10.0, left: 20.0, right: 20.0),
                              textDirection: TextDirection.rtl,
                              child:TextFormField(

                                validator: (val) => password.toString()!= Vpassword.toString()? "كلمة المرور غير متطابقة " : null,  //null means valid password
                                onChanged: (val){ setState(() => Vpassword =val);},
                                decoration: InputDecoration(
                                    icon: Icon(Icons.lock_outline),
                                    labelText: 'تأكيد كلمة المرور',
                                    labelStyle: TextStyle(fontFamily: 'Montserrat',fontWeight: FontWeight.bold,color: Colors.grey),
                                    focusedBorder: UnderlineInputBorder(borderSide: BorderSide(color: Colors.lightBlueAccent ), )),
                               obscureText: true,
                              )
                          ),
                        ],
                      )
                  ),


                  Container(
                      padding: EdgeInsets.fromLTRB(300.0, 20.0, 0.0, .0),
                      child: Text('موقعك',
                        style:
                        TextStyle(color: Colors.grey[600], fontSize: 20.0, fontWeight: FontWeight.bold, fontFamily: "Montserrat"),
                      )),
                  Container(
                      padding: EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 20.0),
                      child: Image(
                        image:  AssetImage("assets/map.png"),
                        width: 40.0,
                        height: 200.0,
                      )
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
                            if (_formKey.currentState.validate()) {
                              dynamic result = await _auth
                                  .registerWithEmailAndPassword(
                                  email, password);
                              if (result == null) {
                                setState(() =>
                                error = 'البريد الألكتروني غير صحيح');
                                Fluttertoast.showToast(
                                msg: "البريد الألكتروني مستخدم",
                                toastLength: Toast.LENGTH_LONG,
                                gravity: ToastGravity.TOP,
                                timeInSecForIos: 5
                                );
                              }//if result=null
                              else {
                                uid = result;
                                // print(result);
                                if (password.toString() == Vpassword.toString())
                                  pass = true;
                                if (pass)
                                  sendData();
                              }
                            }

                          },
                          child: Center(
                            child: Text( 'تسجيل ',
                              style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 20.0,
                                  fontFamily: 'Montserrat'), ),
                          ),
                        ),
                      )
                  ),

                  SizedBox(height:20.0),


                ]),
              ),

            ],
          ),
        )
    )


    );
  }


}

