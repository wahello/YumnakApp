import 'dart:io';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:yumnak/services/auth.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:file_picker/file_picker.dart';
import 'dart:math';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:yumnak/services/CurrentLocation.dart';
import 'Main.dart';
import 'package:path/path.dart' as Path;


class SignUp_SP extends StatefulWidget {
  @override
  _SignUp_SPState createState() => _SignUp_SPState();
}

class _SignUp_SPState extends State<SignUp_SP> {

  final AuthService _auth = AuthService();
  final _formKey = GlobalKey<FormState>();
  final DatabaseReference database = FirebaseDatabase.instance.reference().child("Service Provider");

  sendData() {
    database.push().set({
      'name': name,
      'email': email,
      'uid': uid,
      'phoneNumber': phoneNumber,
      'gender': gender,
      'service': service,
      'qualifications': qualifications,
      'available':available,
      'fileName': fileName,
      'price': price,
      'latitude':lat,
      'longitude' : lng,
      'locComment': comment,
    });
  }

  String name;
  String email = "";
  String phoneNumber = "";
  String service;
  String qualifications;
  String available="false";
  var uid;
  var gender = null;
  double price;

  String password = "";
  String Vpassword = "";
  String error = "";
  bool pass = false;
  int group = 1;
  String subService;
  String subService1;

  String fileType = '';
  File file;
  String fileName = '';
  String operationText = '';
  bool isUploaded = true;
  String result = '';
  File _image;
  String _uploadedFileURL;
  bool isLoading = false;


  Map<String, dynamic> pickedLoc;
  var lat;
  var lng;
  String comment='';
  bool picked=false;
  LatLng loc;

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
                                            borderSide: BorderSide(color: Colors.lightBlueAccent))),
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
                                            borderSide: BorderSide(color: Colors.lightBlueAccent))),
                                  )
                              ),

                              Directionality(
                                  textDirection: TextDirection.rtl,
                                  child: TextFormField(
                                    validator: (val) => val.isEmpty ? "ادخل البريد الألكتروني" : null,
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
                                            borderSide: BorderSide(color: Colors.lightBlueAccent))),
                                  )
                              ),

                              Directionality(
                                  textDirection: TextDirection.rtl,
                                  child: TextFormField(
                                    validator: (val) =>
                                    val.length < 6 ? "يجب أن تكون كلمة المرور أكثر من ستة خانات" : null,
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
                                            borderSide: BorderSide(color: Colors.lightBlueAccent))),
                                    obscureText: true,
                                  )
                              ),

                              Directionality(
                                  textDirection: TextDirection.rtl,
                                  child: TextFormField(
                                    validator: (val) => password.toString() != Vpassword.toString() ?
                                    "كلمة المرور غير متطابقة " : null,
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
                                    DropdownButtonFormField<String>(
                                      validator: (value) => value == null ? 'يجب اختيار الخدمة المقدمة' : null,
                                      isExpanded: true,
                                      onChanged: (String text) {
                                        setState(() {
                                          if (text.isEmpty) {
                                            error = 'يجب أختيار الخدمة';}
                                          else
                                            longSpinnerValue = text;

                                          service = text;
                                          services();
                                        });
                                      },
                                      hint: new Text('أختر الخدمة'),
                                      value: longSpinnerValue,
                                      selectedItemBuilder: (BuildContext context) {
                                        return longItems.map<Widget>((String text) {
                                          return Text(text,
                                              overflow: TextOverflow.ellipsis);
                                        }).toList();
                                      },
                                      items: longItems.map<DropdownMenuItem<String>>((String text) {
                                        return DropdownMenuItem<String>(
                                          value: text,
                                          child: Text(text, maxLines: 1,
                                              overflow: TextOverflow.ellipsis),
                                        );
                                      }).toList(),
                                    ),
                                  ],
                                ),
                              ),

                              if(service == "تعليم و تدريب" ||service == "مجالسة" || service == "تجميل" || service == "تنظيم مناسبات" || service== "دروس خصوصية" || service=='فيزياء' || service=='رياضيات' || service=='اللغة الأنجليزية'
                                  ||service=='اللغة العربية'||service=='المرحلة الابتدائية'|| service=='كيمياء' ||service=='-أختر -' ||service=='مربية أطفال'||service=='كبار السن'|| service=='عناية واسترخاء'|| service== 'شعر'||service== 'مكياج'
                                  || service=='صبابات'|| service=='تنسيق حفلات'|| service=='تجهيز طعام' || service=='تدريب قيادة'||service=='تحفيظ قرآن'||service=='دروس بدية' || service=='رقص'|| service=='موسيقى')
                                Directionality(
                                  textDirection: TextDirection.rtl,
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    children: <Widget>[
                                      SizedBox(width: 50.0),
                                      Column(
                                        children: <Widget>[
                                          DropdownButtonFormField<String>(
                                            validator: (value) => value == null ? 'يجب اختيار الخدمة' : null,
                                            isExpanded: true,
                                            value: longSpinnerValue2,
                                            onChanged: (String text) {
                                              setState(() {
                                                if (text=='-أختر -' ||  text.isEmpty)
                                                  error = 'يجب أختيار الخدمة';
                                                else
                                                  longSpinnerValue2 = text;

                                                service=text;
                                                subService = text;
                                                services1();
                                              });
                                            },
                                            hint: new Text('- أختر -'),
                                            selectedItemBuilder: (BuildContext context) {
                                              return longItems2.map<Widget>((String text) {
                                                return Text(text,
                                                    overflow: TextOverflow.ellipsis);
                                              }).toList();
                                            },
                                            items: longItems2.map<DropdownMenuItem<String>>((String text) {
                                              return DropdownMenuItem<String>(
                                                value: text,
                                                child: Text(text, maxLines: 1,
                                                    overflow: TextOverflow.ellipsis),
                                              );
                                            }).toList(),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),

                              if (service== "دروس خصوصية" || service=='فيزياء' || service=='رياضيات' || service=='اللغة الأنجليزية'||service=='اللغة العربية'||service=='المرحلة الابتدائية'|| service=='كيمياء')
                                Directionality(
                                  textDirection: TextDirection.rtl,
                                  child: Column(
                                    children: <Widget>[
                                      SizedBox(width: 50.0),
                                      Column(
                                        children: <Widget>[
                                          DropdownButtonFormField<String>(
                                            validator: (value) => value == null ? 'يجب اختيار الخدمة' : null,
                                            isExpanded: true,
                                            value: longSpinnerValue3,
                                            onChanged: (String text) {
                                              setState(() {
                                                if (text=='-أختر -')
                                                  error = 'يجب أختيار الخدمة';
                                                else
                                                  longSpinnerValue3 = text;

                                                service=text;
                                                subService1 = text;
                                              });
                                            },
                                            hint: new Text('-أختر -'),
                                            selectedItemBuilder: (BuildContext context) {
                                              return longItems3.map<Widget>((String text) {
                                                return Text(text,
                                                    overflow: TextOverflow.ellipsis);
                                              }).toList();
                                            },
                                            items: longItems3.map<DropdownMenuItem<String>>((String text) {
                                              return DropdownMenuItem<String>(
                                                value: text,
                                                child: Text(text, maxLines: 1,
                                                    overflow: TextOverflow.ellipsis),
                                              );
                                            }).toList(),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),

                              if(service=='كيمياء' || service=='مجالسة' ||service=='فيزياء' || service=='رياضيات' || service=='اللغة الأنجليزية'||service=='اللغة العربية'||service=='المرحلة الابتدائية'||service=='مربية أطفال'||service=='كبار السن'
                                  || service=='تدريب قيادة'||service=='تحفيظ قرآن' ||service=='دروس بدنية' || service=='رقص'|| service=='موسيقى' || service=='تعليم و تدريب' || service=='دروس خصوصية' )
                                Directionality(
                                    textDirection: TextDirection.rtl,
                                    child: TextFormField(
                                      validator: (val) =>
                                      val.isEmpty ? "يجب تحديد السعر" : null,
                                      onChanged: (val) {
                                        setState(() {
                                          double p= double.parse(val);
                                          return price = p;
                                        });
                                      },
                                      decoration: InputDecoration(
                                          icon: Icon(Icons.monetization_on),
                                          labelText: 'السعر بالساعة',
                                          labelStyle: TextStyle(
                                              fontFamily: 'Montserrat',
                                              fontWeight: FontWeight.bold,
                                              color: Colors.grey),
                                          focusedBorder: UnderlineInputBorder(
                                              borderSide: BorderSide(color: Colors.lightBlueAccent))),
                                    )
                                ),

                              if(service=='تنظيم مناسبات' || service=="تجميل " || service=='تصوير' || service=='إصلاح أجهزة ذكية' || service=='عناية واسترخاء'|| service== 'شعر'||service== 'مكياج'|| service=='صبابات'|| service=='تنسيق حفلات'|| service=='تجهيز طعام')
                                Directionality(
                                    textDirection: TextDirection.rtl,
                                    child: TextFormField(
                                      validator: (val) => val.isEmpty ? "يجب تحديد السعر" : null,
                                      onChanged: (val) {
                                        setState(() {
                                          double p= double.parse(val);
                                          return price = p;
                                        });
                                      },
                                      decoration: InputDecoration(
                                          icon: Icon(Icons.monetization_on),
                                          labelText: 'السعر بالحد الأدنى',
                                          labelStyle: TextStyle(
                                              fontFamily: 'Montserrat',
                                              fontWeight: FontWeight.bold,
                                              color: Colors.grey),
                                          focusedBorder: UnderlineInputBorder(
                                              borderSide: BorderSide(color: Colors.lightBlueAccent))),
                                    )
                                ),

                              Directionality(
                                  textDirection: TextDirection.rtl,
                                  child: TextFormField(onChanged: (val) {
                                    setState(() => qualifications = val);
                                  },
                                    maxLines: 6,
                                    minLines: 2,
                                    decoration: InputDecoration(
                                        icon: Icon(Icons.subject),
                                        labelText: 'المؤهلات',
                                        labelStyle: TextStyle(
                                            fontFamily: 'Montserrat',
                                            fontWeight: FontWeight.bold,
                                            color: Colors.grey),
                                        focusedBorder: UnderlineInputBorder(
                                            borderSide: BorderSide(color: Colors.lightBlueAccent))),
                                  )
                              ),
                            ],
                          )
                      ),

                      SizedBox(height: 20.0),

                      Directionality(
                        textDirection: TextDirection.rtl,
                        child: Row(
                          children: <Widget>[
                            SizedBox(width:75.0),
                            ButtonTheme(
                                minWidth: 30.0,
                                height: 10.0,
                                child: RaisedButton(
                                    onPressed: chooseFile,
                                    color: Colors.grey[200],
                                    child: Row(
                                        children: <Widget>[
                                          Icon(
                                            Icons.attach_file,
                                            color: Colors.grey[600],
                                          ),
                                          Text("  إضافة المرفقات     ",
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
                      SizedBox(height: 20.0),

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

                      SizedBox(height:40.0),

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
                                if(picked){
                                  if (_formKey.currentState.validate()) {
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
    if (service == "تعليم و تدريب") {
      longItems2 = ['-أختر -',
        'تدريب قيادة',
        'تحفيظ قرآن',
        'دروس خصوصية',
        'دروس بدنية',
        'رقص',
        'موسيقى'
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
    if (subService == "دروس خصوصية") {
      longItems3 = ['-أختر -',
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
      longItems3 = ["لا يوجد فئة"];
      longSpinnerValue3 = longItems3 [0];
    }
  } //end method



  Future chooseFile() async {
    await ImagePicker.pickImage(source: ImageSource.gallery).then((image) {
      setState(() {
        _image = image;
      });
    });
    uploadFile();
  }

  Future uploadFile() async {
    setState(() {
      isLoading = true;
    });
    StorageReference storageReference = FirebaseStorage.instance
        .ref()
        .child('images/${Path.basename(_image.path)}}');
    StorageUploadTask uploadTask = storageReference.putFile(_image);
    await uploadTask.onComplete;
    print('File Uploaded');
    storageReference.getDownloadURL().then((fileURL) {
      setState(() {
        _uploadedFileURL = fileURL;
        fileName=fileURL;
        isLoading = false;
      });
    });
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
        builder: (ctx) => CurrentLocation(),
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

      loc=new LatLng(lat, lng);
      print("Zeft: PickLocation LatLng: $loc");
    }
  }
}