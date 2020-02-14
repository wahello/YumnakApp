import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:yumnak/services/auth.dart';
import 'package:fluttertoast/fluttertoast.dart';


class SignUp_SP extends StatefulWidget {
  @override
  _SignUp_SPState createState() => _SignUp_SPState();
}

class _SignUp_SPState extends State<SignUp_SP> {

  final AuthService  _auth = AuthService();
  final _formKey = GlobalKey<FormState>();
  final DatabaseReference database= FirebaseDatabase.instance.reference().child("Service Provider");

  sendData(){
    database.push().set({
      'name' : name,
      'email': email,
      //'password': password,
      'uid': uid,
      'phoneNumber': phoneNumber,
      'gender': gender,
      'service': service,
      'subService':subService,
       'subService1':subService1,
      'qualifications':qualifications
    });
  }
  String name;
  String email="";
  String password="";
  String Vpassword="";
  String error="";
  var uid;
  //bool Female;
  String phoneNumber="";
  bool pass=false;
  int group=1;
  var gender=null;
  String service;
  String subService;
  String subService1;
  bool enable=false;
  String qualifications;

 // var services= ["1","3","3"];
  //var type= ["1","2","3"];


  static const List<String> longItems = const [
    'مجالسة',
    'إصلاح أجهزة ذكية',
    'تجميل',
    'تصوير',
    'تعليم و تدريب',
    "تنظيم مناسبات"
  ];


  static List<String> longItems2=[""];
  static List<String> longItems3=[""];


  String longSpinnerValue = longItems[0];
  String longSpinnerValue2;
  String longSpinnerValue3;



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
                                  child:TextFormField(onChanged: (val){setState(() => name=val);},
                                    decoration: InputDecoration(icon: Icon(Icons.person),
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
                                  new Radio(value: 2,
                                      groupValue: group ,
                                      activeColor: Colors.lightBlueAccent,  onChanged: (T){
                                        gender="ذكر";
                                        setState(() {
                                          group=T;
                                        });

                                      }),
                                  new Text("أنثى"),
                                  new Radio(value: 1, groupValue: group, activeColor: Colors.lightBlueAccent, onChanged: (T){
                                    gender="أنثي";
                                    setState(() {
                                      group=T;
                                    });

                                  })
                                ],
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
                                    onChanged: (val){setState(() => phoneNumber=val);},
                                    decoration: InputDecoration(icon: Icon(Icons.phone),
                                        labelText:  'رقم الجوال',
                                        labelStyle: TextStyle( fontFamily: 'Montserrat',fontWeight: FontWeight.bold, color: Colors.grey),
                                        focusedBorder: UnderlineInputBorder(
                                            borderSide: BorderSide(color: Colors.lightBlueAccent))),
                                  )
                              ),
                              Directionality(
                                  textDirection: TextDirection.rtl,
                                  child:TextFormField(
                                    validator: (val) => val.isEmpty ? "Enter an email" : null,  //null means valid email
                                    onChanged: (val){setState(() => email=val);},
                                    decoration: InputDecoration(icon: Icon(Icons.email),
                                        labelText:  'البريد الإلكتروني',
                                        labelStyle: TextStyle(fontFamily: 'Montserrat',fontWeight: FontWeight.bold, color: Colors.grey),
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

                              Directionality(
                                  textDirection: TextDirection.rtl,
                                  child: Column(
                                  children: <Widget>[
                                    SizedBox(width:50.0),

                                    Container(
                                        padding: EdgeInsets.fromLTRB(95.0, 20.0, 0.0, .0),
                                        child: Text('الخدمة المقدمة',
                                          style:
                                          TextStyle(color: Colors.grey[600], fontSize: 20.0, fontWeight: FontWeight.normal, fontFamily: "Montserrat"),
                                        )),


                                    Column(
                                      children: <Widget>[
                                        SizedBox(height: 32),
                                        DropdownButton<String>(
                                          isExpanded: true,
                                          value: longSpinnerValue,
                                          onChanged: (String text) {
                                            setState(() { longSpinnerValue = text;
                                            service=text;
                                            services();});
                                          },
                                          selectedItemBuilder: (BuildContext context) {
                                            return longItems.map<Widget>((String text) {
                                              return Text(text, overflow: TextOverflow.ellipsis);
                                            }).toList();
                                          },
                                          items: longItems.map<DropdownMenuItem<String>>((String text) {
                                            return DropdownMenuItem<String>(
                                              value: text,
                                              child: Text(text, maxLines: 1, overflow: TextOverflow.ellipsis),
                                            );
                                          }).toList(),
                                        ),

                                      ],
                                    ),

                                  ],
                                ),
                              ),




                                Directionality(
                                  textDirection: TextDirection.rtl,

                                  child: Column(
                                    children: <Widget>[
                                      SizedBox(width: 50.0),

                                      Container(
                                          padding: EdgeInsets.fromLTRB(
                                              170.0, 20.0, 0.0, .0),
                                          child: Text('الفئة',
                                            style:
                                            TextStyle(color: Colors.grey[600],
                                                fontSize: 20.0,
                                                fontWeight: FontWeight.bold,
                                                fontFamily: "Montserrat"),
                                          )),
                                      Column(
                                        children: <Widget>[
                                          //SizedBox(height: 32),
                                          DropdownButton<String>(
                                            isExpanded: true,
                                            value: longSpinnerValue2,
                                            onChanged: (String text) {
                                              setState(() {
                                                longSpinnerValue2 = text;
                                                subService=text;
                                                services1();
                                              });
                                            },
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





                              Directionality(
                                textDirection: TextDirection.rtl,

                                child: Column(
                                  children: <Widget>[
                                    SizedBox(width: 50.0),

                                    Container(
                                        padding: EdgeInsets.fromLTRB(
                                            170.0, 20.0, 0.0, .0),
                                        child: Text('الفئة١',
                                          style:
                                          TextStyle(color: Colors.grey[600],
                                              fontSize: 20.0,
                                              fontWeight: FontWeight.bold,
                                              fontFamily: "Montserrat"),
                                        )),
                                    Column(
                                      children: <Widget>[
                                        //SizedBox(height: 32),
                                        DropdownButton<String>(
                                          isExpanded: true,
                                          value: longSpinnerValue3,
                                          onChanged: (String text) {
                                            setState(() {
                                              longSpinnerValue3 = text;
                                              subService1=text;
                                            });
                                          },
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






                              Directionality(
                                  textDirection: TextDirection.rtl,
                                  child:TextFormField(onChanged: (val){setState(() => qualifications=val);},
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

                              /*Directionality(
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


  void services(){
   // longSpinnerValue2= longItems2 [0];

    if(service=="تعليم و تدريب") {
      longItems2=[ 'تدريب قيادة', 'تحفيظ قرآن' , 'دروس خصوصية' , 'تدريب رياضي' , 'رقص' , 'موسيقي' ];
      longSpinnerValue2= longItems2 [0];

    }
    else if ( service=="تنظيم مناسبات"){
      longItems2=['صبابات', 'تنسيق حفلات' , 'تجهيز طعام' ];
      longSpinnerValue2= longItems2 [0];
    }

    else if(service=="تجميل"){
      longItems2=['عناية واسترخاء', 'شعر' , 'مكياج' ];
      longSpinnerValue2= longItems2 [0];
      }

    else if(service=="تجميل"){
      longItems2=['عناية واسترخاء', 'شعر' , 'مكياج' ];
      longSpinnerValue2= longItems2 [0];}

    else if(service=="مجالسة"){
      longItems2=['مربية أطفال', 'كبار السن' ];
      longSpinnerValue2= longItems2 [0];}

else{
      longItems2=["لا يوجد فئة"];
      longItems3=["لا يوجد فئة"];
      longSpinnerValue2= longItems2 [0];
      longSpinnerValue3= longItems3 [0];

    }
  }//end method


  void services1(){
    // longSpinnerValue2= longItems2 [0];

    if(subService=="دروس خصوصية") {
      longItems3=[ 'كيمياء' , 'فيزياء' , 'رياضيات' , 'اللغة الأنجليزبة' , 'اللغة العربية' ,'المرحلة الأبتدائية'];
      longSpinnerValue3= longItems3 [0];

    }
    else{
     // longItems2=["لا يوجد فئة"];
      longItems3=["لا يوجد فئة"];
     // longSpinnerValue2= longItems2 [0];
      longSpinnerValue3= longItems3 [0];


    }

  }//end method

}//end class








