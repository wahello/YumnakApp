import 'dart:io';

import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:yumnak/services/auth.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:file_picker/file_picker.dart';
import 'package:path/path.dart' as p;
import 'dart:math';



class SignUp_SP extends StatefulWidget {
  @override
  _SignUp_SPState createState() => _SignUp_SPState();
}

class _SignUp_SPState extends State<SignUp_SP> {

  final AuthService _auth = AuthService();
  final _formKey = GlobalKey<FormState>();
  final DatabaseReference database = FirebaseDatabase.instance.reference()
      .child("Service Provider");

  sendData() {
    database.push().set({
      'name': name,
      'email': email,
      //'password': password,
      'uid': uid,
      'phoneNumber': phoneNumber,
      'gender': gender,
      'service': service,
      'qualifications': qualifications,
      'available':available,
      'fileName': fileName,
      'price': price

    });
  }

  String name;
  String email = "";
  String password = "";
  String Vpassword = "";
  String error = "";
  var uid;

  //bool Female;
  String phoneNumber = "";
  bool pass = false;
  int group = 1;
  var gender = null;
  String service;
  String subService;
  String subService1;
  bool enable = false;
  String qualifications;
  File sampleImage;
  String available="false";
  // var services= ["1","3","3"];
  //var type= ["1","2","3"];

  String fileType = '';
  File file;
  String fileName = '';
  String operationText = '';
  bool isUploaded = true;
  String result = '';
  String price;


  static const List<String> longItems = const [
    'مجالسة',
    'إصلاح أجهزة ذكية',
    'تجميل',
    'تصوير',
    'تعليم و تدريب',
    "تنظيم مناسبات"
  ];


  static List<String> longItems2 = [""];
  static List<String> longItems3 = [""];


  String longSpinnerValue;
  String longSpinnerValue2;
  String longSpinnerValue3;


  @override
  Widget build(BuildContext context) {
    return Scaffold(

        body: Container(
            child: Form(
              key: _formKey, //for validation
              child: CustomScrollView(
                slivers: <Widget>[
                  SliverList(

                    delegate: SliverChildListDelegate([
                      Container(
                        padding: EdgeInsets.fromLTRB(60.0, 60.0, 0.0, 0.0),
                        child: Text(
                          'تسجيل مستخدم جديد',
                          style:
                          TextStyle(color: Colors.lightBlueAccent,
                              fontSize: 30.0,
                              fontWeight: FontWeight.bold,
                              fontFamily: "Montserrat"),
                        ),
                      ),

                      Container(
                          padding: EdgeInsets.fromLTRB(30.0, 0.0, 30.0, 0.0),
                          child: Column(
                            children: <Widget>[

                              Directionality(
                                  textDirection: TextDirection.rtl,
                                  child: TextFormField(onChanged: (val) {
                                    setState(() => name = val);
                                  },
                                    decoration: InputDecoration(
                                        icon: Icon(Icons.person),
                                        labelText: 'الاسم',
                                        labelStyle: TextStyle(
                                            fontFamily: 'Montserrat',
                                            fontWeight: FontWeight.bold,
                                            color: Colors.grey),
                                        focusedBorder: UnderlineInputBorder(
                                            borderSide: BorderSide(color: Colors
                                                .lightBlueAccent))),
                                  )

                              ),
                              Row(
                                children: <Widget>[
                                  SizedBox(width: 100.0),
                                  new Text("ذكر"),
                                  new Radio(value: 2,
                                      groupValue: group,
                                      activeColor: Colors.lightBlueAccent,
                                      onChanged: (T) {
                                        gender = "ذكر";
                                        setState(() {
                                          group = T;
                                        });
                                      }),
                                  new Text("أنثى"),
                                  new Radio(value: 1,
                                      groupValue: group,
                                      activeColor: Colors.lightBlueAccent,
                                      onChanged: (T) {
                                        gender = "أنثي";
                                        setState(() {
                                          group = T;
                                        });
                                      })
                                ],
                              ),
                              Directionality(
                                  textDirection: TextDirection.rtl,
                                  child: TextFormField(
                                    validator: (String v) {
                                      if (v.isEmpty) {
                                        return "أدخل رقم الجوال";
                                      }
                                      if (v.length != 10) {
                                        return 'أدخل رقم الجوال الصحيح';
                                      }
                                      return null;
                                    },
                                    onChanged: (val) {
                                      setState(() => phoneNumber = val);
                                    },
                                    decoration: InputDecoration(
                                        icon: Icon(Icons.phone),
                                        labelText: 'رقم الجوال',
                                        labelStyle: TextStyle(
                                            fontFamily: 'Montserrat',
                                            fontWeight: FontWeight.bold,
                                            color: Colors.grey),
                                        focusedBorder: UnderlineInputBorder(
                                            borderSide: BorderSide(color: Colors
                                                .lightBlueAccent))),
                                  )
                              ),
                              Directionality(
                                  textDirection: TextDirection.rtl,
                                  child: TextFormField(
                                    validator: (val) =>
                                    val.isEmpty
                                        ? "ادخل البريد الألكتروني"
                                        : null, //null means valid email
                                    onChanged: (val) {
                                      setState(() => email = val);
                                    },
                                    decoration: InputDecoration(
                                        icon: Icon(Icons.email),
                                        labelText: 'البريد الإلكتروني',
                                        labelStyle: TextStyle(
                                            fontFamily: 'Montserrat',
                                            fontWeight: FontWeight.bold,
                                            color: Colors.grey),
                                        focusedBorder: UnderlineInputBorder(
                                            borderSide: BorderSide(color: Colors
                                                .lightBlueAccent))),
                                  )
                              ),


                              Directionality(
                                  textDirection: TextDirection.rtl,
                                  child: TextFormField(
                                    validator: (val) =>
                                    val.length < 6
                                        ? "يجب أن تكون كلمة المرور أكثر من ستة خانات"
                                        : null, //null means valid password
                                    onChanged: (val) {
                                      setState(() => password = val);
                                    },
                                    decoration: InputDecoration(
                                        icon: Icon(Icons.lock_outline),
                                        labelText: 'كلمة المرور ',
                                        labelStyle: TextStyle(
                                            fontFamily: 'Montserrat',
                                            fontWeight: FontWeight.bold,
                                            color: Colors.grey),
                                        focusedBorder: UnderlineInputBorder(
                                            borderSide: BorderSide(color: Colors
                                                .lightBlueAccent))),
                                    obscureText: true,
                                  )
                              ),


                              Directionality(
                                  textDirection: TextDirection.rtl,
                                  child: TextFormField(

                                    validator: (val) =>
                                    password.toString() != Vpassword.toString()
                                        ? "كلمة المرور غير متطابقة "
                                        : null, //null means valid password
                                    onChanged: (val) {
                                      setState(() => Vpassword = val);
                                    },
                                    decoration: InputDecoration(
                                        icon: Icon(Icons.lock_outline),
                                        labelText: 'تأكيد كلمة المرور',
                                        labelStyle: TextStyle(
                                            fontFamily: 'Montserrat',
                                            fontWeight: FontWeight.bold,
                                            color: Colors.grey),
                                        focusedBorder: UnderlineInputBorder(
                                          borderSide: BorderSide(
                                              color: Colors.lightBlueAccent),)),
                                    obscureText: true,
                                  )
                              ),

                              Directionality(
                                textDirection: TextDirection.rtl,
                                child:Column(
                                   crossAxisAlignment: CrossAxisAlignment.end,


                                      children: <Widget>[
                                        SizedBox(height: 32),
                                        DropdownButton<String>(
                                          /*validator: (value) =>
                                          value == null? "يجب اختيار الخدمة المقدمة" : null,*/
                                          isExpanded: true,
                                          onChanged: (String text) {
                                            setState(() {
                                              longSpinnerValue = text;
                                              service = text;
                                              services();

                                            });
                                          },

                                          hint: new Text('أختر الخدمة'),
                                          value: longSpinnerValue,
                                          selectedItemBuilder: (
                                              BuildContext context) {
                                            return longItems.map<Widget>((
                                                String text) {
                                              return Text(text,
                                                  overflow: TextOverflow
                                                      .ellipsis);
                                            }).toList();
                                          },
                                          items: longItems.map<
                                              DropdownMenuItem<String>>((
                                              String text) {
                                            return DropdownMenuItem<String>(
                                              value: text,
                                              child: Text(text, maxLines: 1,
                                                  overflow: TextOverflow
                                                      .ellipsis),
                                            );
                                          }).toList(),
                                        ),

                                      ],
                                    ),



                              ),

                             // if(service == "تعليم و تدريب" ||service == "مجالسة" || service == "تجميل" || service == "تنظيم مناسبات" )
                              Directionality(
                                textDirection: TextDirection.rtl,

                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: <Widget>[
                                    SizedBox(width: 50.0),

                                    Column(
                                      children: <Widget>[
                                        //SizedBox(height: 32),
                                        DropdownButton<String>(
                                          isExpanded: true,
                                          value: longSpinnerValue2,
                                          onChanged: (String text) {
                                            setState(() {
                                              if (text=='-أختر -'){
                                                error = 'يجب أختيار الخدمة';}
                                              else
                                              longSpinnerValue2 = text;
                                              service=text;
                                              subService = text;
                                              services1();

                                            });

                                          },
                                          hint: new Text('- أختر -'),
                                          selectedItemBuilder: (
                                              BuildContext context) {
                                            return longItems2.map<Widget>((
                                                String text) {
                                              return Text(text,
                                                  overflow: TextOverflow
                                                      .ellipsis);
                                            }).toList();
                                          },
                                          items: longItems2.map<
                                              DropdownMenuItem<String>>((
                                              String text) {
                                            return DropdownMenuItem<String>(
                                              value: text,
                                              child: Text(text, maxLines: 1,
                                                  overflow: TextOverflow
                                                      .ellipsis),
                                            );
                                          }).toList(),
                                        ),

                                      ],
                                    ),

                                  ],
                                ),
                              ),

                              if (service== "دروس خصوصية" || service=='فيزياء' || service=='رياضيات' || service=='اللغة الأنجليزية'||service=='اللغة العربية'||service=='المرحلة الابتدائية')
                              Directionality(
                                textDirection: TextDirection.rtl,

                                child: Column(
                                  children: <Widget>[
                                    SizedBox(width: 50.0),


                                    Column(
                                      children: <Widget>[
                                        //SizedBox(height: 32),
                                        DropdownButton<String>(
                                          isExpanded: true,
                                          value: longSpinnerValue3,
                                          onChanged: (String text) {
                                            setState(() {
                                              if (text=='-أختر -'){
                                                error = 'يجب أختيار الخدمة';}
                                              else
                                              longSpinnerValue3 = text;
                                              service=text;
                                              subService1 = text;
                                            });
                                          },
                                          hint: new Text('-أختر -'),
                                          selectedItemBuilder: (
                                              BuildContext context) {
                                            return longItems3.map<Widget>((
                                                String text) {
                                              return Text(text,
                                                  overflow: TextOverflow
                                                      .ellipsis);
                                            }).toList();
                                          },
                                          items: longItems3.map<
                                              DropdownMenuItem<String>>((
                                              String text) {
                                            return DropdownMenuItem<String>(
                                              value: text,
                                              child: Text(text, maxLines: 1,
                                                  overflow: TextOverflow
                                                      .ellipsis),
                                            );
                                          }).toList(),
                                        ),

                                      ],
                                    ),

                                  ],
                                ),
                              ),


                               if(service=='رياضيات' || service=='مجالسة' ||service=='فيزياء' || service=='رياضيات' || service=='اللغة الأنجليزية'||service=='اللغة العربية'||service=='المرحلة الابتدائية' )
                              Directionality(
                                  textDirection: TextDirection.rtl,
                                  child: TextFormField(
                                    onChanged: (val) {
                                      setState(() => price = val);
                                    },
                                    decoration: InputDecoration(
                                        icon: Icon(Icons.monetization_on),
                                        labelText: 'السعر بالساعة',
                                        labelStyle: TextStyle(
                                            fontFamily: 'Montserrat',
                                            fontWeight: FontWeight.bold,
                                            color: Colors.grey),
                                        focusedBorder: UnderlineInputBorder(
                                            borderSide: BorderSide(color: Colors
                                                .lightBlueAccent))),
                                  )
                               ),

                             if(service=='تنظيم مناسبات' || service=="تجميل " || service=='تصوير' || service=='إصلاح أجهزة ذكية')
                                Directionality(
                                    textDirection: TextDirection.rtl,
                                    child: TextFormField(
                                      onChanged: (val) {
                                        setState(() => price = val);
                                      },
                                      decoration: InputDecoration(
                                          icon: Icon(Icons.monetization_on),
                                          labelText: 'السعر بالحد الأدنى',
                                          labelStyle: TextStyle(
                                              fontFamily: 'Montserrat',
                                              fontWeight: FontWeight.bold,
                                              color: Colors.grey),
                                          focusedBorder: UnderlineInputBorder(
                                              borderSide: BorderSide(color: Colors
                                                  .lightBlueAccent))),
                                    )
                                ),
                              Directionality(
                                  textDirection: TextDirection.rtl,
                                  child: TextFormField(onChanged: (val) {
                                    setState(() => qualifications = val);
                                  },
                                    decoration: InputDecoration(
                                        icon: Icon(Icons.subject),
                                        labelText: 'المؤهلات',
                                        labelStyle: TextStyle(
                                            fontFamily: 'Montserrat',
                                            fontWeight: FontWeight.bold,
                                            color: Colors.grey),
                                        focusedBorder: UnderlineInputBorder(
                                            borderSide: BorderSide(color: Colors
                                                .lightBlueAccent))),
                                  )
                              ),
                            ],
                          )
                      ),




                              SizedBox(height: 10.0),
                              ButtonTheme(minWidth: 30.0, height: 10.0,
                                  child: RaisedButton(onPressed:filePicker ,
                                      color: Colors.white,

                                      child: Row(children: <Widget>[
                                        Text("   إضافة مرفقات  +            ",
                                            textAlign: TextAlign.center,
                                            style: TextStyle(
                                              color: Colors.grey[600],
                                              fontWeight: FontWeight.bold,
                                              fontSize: 24.0,
                                              fontFamily: 'Montserrat',)),
                                        Icon(Icons.attach_file),

                                      ]
                                      )
                                  )
                              ),

                              /*Directionality(
                              textDirection: TextDirection.rtl,
                              child:Row(
                                children: <Widget>[
                                  SizedBox(width: 100.0),
                                  new Text("الحد الأدنى"),
                                  new Radio(value: 2,
                                      groupValue: group,
                                      activeColor: Colors.lightBlueAccent,
                                      onChanged: (T) {}),


                                  new Text("بالساعة"),
                                  new Radio(value: 1,
                                      groupValue: group,
                                      activeColor: Colors.lightBlueAccent,
                                      onChanged: (T) { })


                                ],
                              ),
                          ),*/


                      Container(
                          padding: EdgeInsets.fromLTRB(300.0, 20.0, 0.0, .0),
                          child: Text('موقعك',
                            style:
                            TextStyle(color: Colors.grey[600],
                                fontSize: 20.0,
                                fontWeight: FontWeight.bold,
                                fontFamily: "Montserrat"),
                          )),
                      Container(
                          padding: EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 20.0),
                          child: Image(
                            image: AssetImage("assets/map.png"),
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
                                    error = '  البريد الألكتروني غير صحيح');
                                    Fluttertoast.showToast(
                                        msg: " البريد الألكتروني غير صحيح أو مستخدم",
                                        toastLength: Toast.LENGTH_LONG,
                                        gravity: ToastGravity.CENTER,
                                        timeInSecForIos: 5,
                                        backgroundColor: Colors.red[100],
                                        textColor: Colors.red[800]
                                    );
                                  }
                                  else {
                                    uid = result;

                                    if (password.toString() ==
                                        Vpassword.toString())
                                      pass = true;
                                    if (pass){
                                      sendData();
                                      Fluttertoast.showToast(
                                          msg: ("الرجاء تفعيل الحساب عن طريق البريد الإلكتروني"),
                                          toastLength: Toast.LENGTH_LONG,
                                          gravity: ToastGravity.CENTER,
                                          timeInSecForIos: 20,
                                          backgroundColor: Colors.red[100],
                                          textColor: Colors.red[800]
                                      );}
                                  }
                                }
                              },
                              child: Center(
                                child: Text('تسجيل ',
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 20.0,
                                      fontFamily: 'Montserrat'),),
                              ),
                            ),
                          )
                      ),

                      SizedBox(height: 20.0),

                    ]),
                  ),

                ],
              ),
            )
        )
    );
  }


  void services() {
    // longSpinnerValue2= longItems2 [0];

    if (service == "تعليم و تدريب") {
      longItems2 = ['-أختر -',
        'تدريب قيادة',
        'تحفيظ قرآن',
        'دروس خصوصية',
        'تدريب رياضي',
        'رقص',
        'موسيقي'
      ];
      longSpinnerValue2 = longItems2 [0];
    }
    else if (service == "تنظيم مناسبات") {
      longItems2 = ['-أختر -','صبابات', 'تنسيق حفلات', 'تجهيز طعام'];
      longSpinnerValue2 = longItems2 [0];
      longItems3 = ["لا يوجد فئة"];
      longSpinnerValue3 = longItems3 [0];
    }

    else if (service == "تجميل") {
      longItems2 = ['-أختر -','عناية واسترخاء', 'شعر', 'مكياج'];
      longSpinnerValue2 = longItems2 [0];
      longItems3 = ["لا يوجد فئة"];
      longSpinnerValue3 = longItems3 [0];
    }


    else if (service == "مجالسة") {
      longItems2 = ['-أختر -','مربية أطفال', 'كبار السن'];
      longSpinnerValue2 = longItems2 [0];
      longItems3 = ["لا يوجد فئة"];
      longSpinnerValue3 = longItems3 [0];
    }

    else {
      longItems2 = ["لا يوجد فئة"];
      longItems3 = ["لا يوجد فئة"];
      longSpinnerValue2 = longItems2 [0];
      longSpinnerValue3 = longItems3 [0];
    }
  } //end method


  void services1() {
    // longSpinnerValue2= longItems2 [0];

    if (subService == "دروس خصوصية") {
      longItems3 = ['-أختر -'
        'كيمياء',
        'فيزياء',
        'رياضيات',
        'اللغة الأنجليزية',
        'اللغة العربية',
        'المرحلة الابتدائية'
      ];
      longSpinnerValue3 = longItems3 [0];
    }
    else {
      // longItems2=["لا يوجد فئة"];
      longItems3 = ["لا يوجد فئة"];
      // longSpinnerValue2= longItems2 [0];
      longSpinnerValue3 = longItems3 [0];
    }
  } //end method



  Future<void> _uploadFile(File file, String filename) async {
    StorageReference storageReference;
      storageReference =
          FirebaseStorage.instance.ref().child("images/$filename");


    final StorageUploadTask uploadTask = storageReference.putFile(file);
    final StorageTaskSnapshot downloadUrl = (await uploadTask.onComplete);
    final String url = (await downloadUrl.ref.getDownloadURL());
   // print("URL is $url");
  }


  Future filePicker() async {

    Random random = new Random();
    //int randomNumber = random.nextInt(100000000000) + 10;
    int randomNumber = random.nextInt(10000000);
    String randm=randomNumber.toString();
    try {
        file = await FilePicker.getFile(type: FileType.IMAGE);
        setState(() {
          //fileName = p.basename(file.path);

          fileName=randm;

        });
        //print(fileName);
        _uploadFile(file,randm);


    } on Exception catch (e) {
      showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text('Sorry...'),
              content: Text('Unsupported exception: $e'),
              actions: <Widget>[
                FlatButton(
                  child: Text('OK'),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                )
              ],
            );
          }
      );
    }}


}//class
