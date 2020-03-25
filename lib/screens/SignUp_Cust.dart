import 'package:flutter/material.dart';
import 'package:yumnak/screens/Main.dart';
import 'package:yumnak/services/CurrentLocation.dart';
import 'package:yumnak/services/auth.dart';
import "package:firebase_database/firebase_database.dart";
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:fluttertoast/fluttertoast.dart';

class SignUp_Cust extends StatefulWidget {
  @override
  _SignUp_CustState createState() => _SignUp_CustState();
}

class _SignUp_CustState extends State<SignUp_Cust> {

//
  final AuthService  _auth = AuthService();
  final _formKey = GlobalKey<FormState>();

  final DatabaseReference database= FirebaseDatabase.instance.reference().child("Customer");

  sendData(){
    database.push().set({
      'name' : name,
      'email': email,
      'uid': uid,
      'phoneNumber': phoneNumber,
      'latitude':lat,
      'longitude' : lng,
      'locComment': comment,
      'ratingAvg':ratingAvg,
      'ratingCounter': ratingCounter,
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

  Map<String, dynamic> pickedLoc;
  var lat;
  var lng;
  String comment=" ";
  bool picked=false;
  LatLng loc;

  double ratingAvg=0.01;
  int ratingCounter=0;

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
                                validator:(val)=> validateName(val),
                                //(val) => val.isEmpty ? "أدخل الاسم" : null,
                                onChanged: (val){setState(() => name=val);},
                                decoration: InputDecoration(
                                    helperText :"05xxxxxxx",
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
                                validator: (val) => val.isEmpty ? "الرجاء إدخال البريد الألكتروني" : null,  //null means valid email
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
                                validator: (String v)=>validateMobile(v),
                                /*{
                                  if (v.isEmpty) {return  "أدخل رقم الجوال";}
                                  if (v.length!=10) {return'أدخل رقم الجوال الصحيح';}
                                  return null;
                                }*/

                               // validator:(val) => val.isEmpty ? "أدخل رقم الجوال" : null,//null means valid phone
                                onChanged: (val){setState(() => phoneNumber=val);},
                                decoration: InputDecoration(
                                    icon: Icon(Icons.phone),
                                    labelText:  'رقم الجوال',
                                    hintText: "05xxxxxxxx",
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

                  SizedBox(height: 30.0),
                  Directionality(
                    textDirection: TextDirection.rtl,

                    child: Row(
                      children: <Widget>[
                        SizedBox(width:20.0),
                        Text('موقعك',
                          style:TextStyle(
                              color: Colors.grey[600],
                              fontSize: 20.0,
                              fontWeight: FontWeight.bold,
                              fontFamily: "Montserrat"
                          ),
                        ),

                        SizedBox(width:20.0),
                        ButtonTheme(
                            minWidth: 30.0,
                            height: 10.0,
                            child: RaisedButton(
                                onPressed: _pickLocation,
                                color: Colors.grey[200],
                                child: Row(
                                    children: <Widget>[
                                      Icon(
                                        Icons.add_location,
                                        color: Colors.grey[600],
                                      ),
                                      Text("  إضافة الموقع     ",
                                          textDirection: TextDirection.rtl,
                                          textAlign: TextAlign.justify,
                                          style: TextStyle(
                                            color: Colors.grey[600],
                                            fontWeight: FontWeight.bold,
                                            fontSize: 24.0,
                                            fontFamily: 'Montserrat',)),
                                    ]
                                )
                            )
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height:20.0),
                  Container(
                      height: 40.0,
                      child: Material(
                        borderRadius: BorderRadius.circular(20.0),
                        shadowColor: Colors.lightBlueAccent,
                        color: Colors.green[300],
                        elevation: 7.0,
                        child: GestureDetector(
                          onTap: () async {
                            print("ZEFT Picked: $picked");
                            if (_formKey.currentState.validate()){
                              if(picked) {
                                dynamic result = await _auth.registerWithEmailAndPassword(email, password);

                                if (result == null) {
                                  setState(() => error = '  البريد الإلكتروني مستخدم');
                                }
                                else {
                                  uid = result;
                                  if (password.toString() == Vpassword.toString())
                                    pass = true;
                                  if (pass){
                                    sendData();
                                    _showDialog();
                                  }
                                }
                                print("ZEFT Picked: $picked");
                              }
                            }
                            else{
                              Fluttertoast.showToast(
                                  msg: ("الرجاء إضافة الموقع"),
                                  toastLength: Toast.LENGTH_LONG,
                                  gravity: ToastGravity.CENTER,
                                  timeInSecForIos: 20,
                                  backgroundColor: Colors.red[100],
                                  textColor: Colors.red[800]
                              );
                              print("ZEFT Picked: $picked");
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

  void _showDialog() {
    // flutter defined function
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return Directionality(
          textDirection: TextDirection.rtl,

          child: new AlertDialog(
            title: new Text("تفعيل الحساب",style:TextStyle( )),
            content: new Text("الرجاء تفعيل الحساب عن طريق البريد الإلكتروني المرسل إليك لتتمكن من تسجيل الدخول واستخدام البرنامج"),
            actions: <Widget>[
              // usually buttons at the bottom of the dialog
              new FlatButton(
                child: new Text("موافق"),
                onPressed: () {
                  Navigator.push(context, new MaterialPageRoute(
                      builder: (context) => Main()
                  ));
                },
              ),
            ],
          ),
        );
      },
    );
  }

  _pickLocation() async {
    pickedLoc = await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (ctx) => CurrentLocation("Cus"),
        fullscreenDialog: true,
      ),
    );

    print("Zeft: $pickedLoc");

    if (pickedLoc == null) {
      return;
    }
    else{

      lat=pickedLoc['latitude'];
      lng=pickedLoc['longitude'];
      comment=pickedLoc['comments'];
      picked=pickedLoc['prickedLocation'];

      print("Zeft: PickLocation latitude: $lat");
      print("Zeft: PickLocation longitude: $lng");
      print("Zeft: PickLocation comments: $comment");
      print("Zeft: PickLocation comments: $picked");

      if(comment==null)
        comment=" ";

      loc=new LatLng(lat, lng);
      print("Zeft: PickLocation LatLng: $loc");
    }
  }

  String validateName(String value) {
    String patttern = r'(^[a-zA-Z ]*$)';
    RegExp regExp = new RegExp(patttern);
    if (value.length == 0) {
      return "الرجاء إدخال الاسم";
    } else if (!regExp.hasMatch(value)) {
      return "يجب أن يحتوي الاسم على أحرف فقط";
    }
    return null;
  }
  String validateMobile(String value) {
    String patttern = r'(^[0-9]*$)';
    RegExp regExp = new RegExp(patttern);
    if (value.length == 0) {
      return "الرجاء إدخال رقم الجوال";
    } else if(value.length != 10){
      return "أدخل رقم الجوال الصحيح";
    }else if (!regExp.hasMatch(value)) {
      return "يجب ان يحتوي رقم الجوال على أرقام فقط";
    }
    return null;
  }
}