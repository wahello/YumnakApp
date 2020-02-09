import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:yumnak/services/auth.dart';

class SignUp_SP extends StatefulWidget {
  @override
  _SignUp_SPState createState() => _SignUp_SPState();
}

class _SignUp_SPState extends State<SignUp_SP> {

  final AuthService  _auth = AuthService();
  final _formKey = GlobalKey<FormState>();
  //final DatabaseReference database= FirebaseDatabase.instance.reference().child("Service Provider");
  String email="";
  String password="";
  String error="";

  var services= ["1","2","3"];
  var type= ["1","2","3"];


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

                          /* Directionality(
                              textDirection: TextDirection.rtl,
                              child:TextFormField(
                                decoration: InputDecoration(
                                    labelText:  'الاسم',
                                    labelStyle: TextStyle( fontFamily: 'Montserrat',fontWeight: FontWeight.bold, color: Colors.grey),
                                    focusedBorder: UnderlineInputBorder(
                                        borderSide: BorderSide(color: Colors.lightBlueAccent))),
                              )

                          ),
                            Row(
                            children: <Widget>[
                              SizedBox(width:100.0),
                              new Text("ذكر"),
                              new Radio(value: 1, groupValue: null, activeColor: Colors.grey, onChanged: null),
                              new Text("أنثى"),
                              new Radio(value: 1, groupValue: null, activeColor: Colors.grey, onChanged: null)
                            ],
                          ),
                         Directionality(
                              textDirection: TextDirection.rtl,
                              child:TextFormField(
                                decoration: InputDecoration(
                                    labelText:  'رقم الجوال',
                                    labelStyle: TextStyle( fontFamily: 'Montserrat',fontWeight: FontWeight.bold, color: Colors.grey),
                                    focusedBorder: UnderlineInputBorder(
                                        borderSide: BorderSide(color: Colors.lightBlueAccent))),
                              )
                          ),*/
                          Directionality(
                              textDirection: TextDirection.rtl,
                              child:TextFormField(
                                validator: (val) => val.isEmpty ? "Enter an email" : null,  //null means valid email
                                onChanged: (val){setState(() => email=val);},
                                decoration: InputDecoration(
                                    labelText:  'البريد الإلكتروني',
                                    labelStyle: TextStyle(fontFamily: 'Montserrat',fontWeight: FontWeight.bold, color: Colors.grey),
                                    focusedBorder: UnderlineInputBorder(
                                        borderSide: BorderSide(color: Colors.lightBlueAccent))),
                              )
                          ),
                          Directionality(
                              textDirection: TextDirection.rtl,
                              child:TextFormField(
                                validator: (val) => val.length < 6 ? "enter a password 6+ chars long" : null,  //null means valid password
                                onChanged: (val){ setState(() => password =val);},
                                decoration: InputDecoration(
                                    labelText: 'كلمة المرور ',
                                    labelStyle: TextStyle(fontFamily: 'Montserrat',fontWeight: FontWeight.bold,color: Colors.grey),
                                    focusedBorder: UnderlineInputBorder(
                                        borderSide: BorderSide(color: Colors.lightBlueAccent))),
                                obscureText: true,
                              )
                          ),

/*
                          Directionality(
                              textDirection: TextDirection.rtl,
                              child:TextFormField(
                                decoration: InputDecoration(
                                    labelText: 'تأكيد كلمة المرور',
                                    labelStyle: TextStyle(fontFamily: 'Montserrat',fontWeight: FontWeight.bold,color: Colors.grey),
                                    focusedBorder: UnderlineInputBorder(borderSide: BorderSide(color: Colors.lightBlueAccent ), )),
                                obscureText: true,
                              )
                          ),

                          Row(
                            children: <Widget>[
                              SizedBox(width:50.0),

                              Container(
                                child: DropdownButton<String>(
                                  items: services.map((String dropDownStringItem){
                                    return DropdownMenuItem<String>(
                                      value: dropDownStringItem ,
                                      child: Text(dropDownStringItem),
                                    );
                                  }).toList(),
                                  onChanged: (String newValueSelected){}, // Your code to execute, when a menu item is selected from drop down
                                ),
                              ),

                              Container(
                                  padding: EdgeInsets.fromLTRB(90.0, 20.0, 0.0, .0),
                                  child: Text('الخدمة المقدمة',
                                    style:
                                    TextStyle(color: Colors.grey[600], fontSize: 20.0, fontWeight: FontWeight.bold, fontFamily: "Montserrat"),
                                  )),
                            ],
                          ),
                          Row(
                            children: <Widget>[
                              SizedBox(width:50.0),
                              Container(
                                child: DropdownButton<String>(
                                  items: type.map((String dropDownStringItem){
                                    return DropdownMenuItem<String>(
                                      value: dropDownStringItem ,
                                      child: Text(dropDownStringItem),
                                    );
                                  }).toList(),
                                  onChanged: (String newValueSelected){}, // Your code to execute, when a menu item is selected from drop down
                                ),
                              ),

                              Container(
                                  padding: EdgeInsets.fromLTRB(170.0, 20.0, 0.0, .0),
                                  child: Text('الفئة',
                                    style:
                                    TextStyle(color: Colors.grey[600], fontSize: 20.0, fontWeight: FontWeight.bold, fontFamily: "Montserrat"),
                                  )),
                            ],
                          ),

                          Directionality(
                              textDirection: TextDirection.rtl,
                              child:TextFormField(
                                decoration: InputDecoration(
                                    labelText:  'المؤهلات',
                                    labelStyle: TextStyle(fontFamily: 'Montserrat',fontWeight: FontWeight.bold, color: Colors.grey),
                                    focusedBorder: UnderlineInputBorder(
                                        borderSide: BorderSide(color: Colors.lightBlueAccent))),
                              )
                          ),
                          SizedBox(height:10.0),
                          ButtonTheme(minWidth: 30.0, height: 10.0,
                              child: RaisedButton(color: Colors.white,
                                  onPressed: () {},
                                  child: Row(children: <Widget>[
                                    Text("   إضافة مرفقات  +            ",textAlign: TextAlign.center,
                                        style: TextStyle(color: Colors.grey[600], fontWeight: FontWeight.bold,fontSize: 24.0, fontFamily: 'Montserrat', )),
                                    Icon(Icons.attach_file),
                                  ]
                                  )
                              )
                          ),

                          Directionality(
                              textDirection: TextDirection.rtl,
                              child: Row(
                                children: <Widget>[
                                  Icon(Icons.attach_money),
                                  Radio(value: 1, groupValue: null, activeColor: Colors.grey, onChanged: null),
                                  Text("الحد الأدني"),
                                  Radio(value: 1, groupValue: null, activeColor: Colors.grey, onChanged: null),
                                  Text("بالساعة"),

                              new Container(
                                  margin: const EdgeInsets.only(right: 120, left: 120),
                                  child: new TextFormField(
                                    decoration: new InputDecoration(hintText: 'السعر'),
                                  )),

                                ],
                              )
                          ),
                          new Directionality(
                              textDirection: TextDirection.rtl,
                              child: new TextFormField(
                                decoration: new InputDecoration(hintText: 'السعر'),
                              )),*/
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
                            if (_formKey.currentState.validate()){
                              dynamic result = await _auth.registerWithEmailAndPassword(email,password);
                              if (result == null ){
                                setState(() => error= 'please supply a valid email');
                              }
                              else{print("signed up"); }
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
