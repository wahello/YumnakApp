import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:yumnak/services/ModifyLocation.dart';

class ModifySPInfo extends StatefulWidget {
  @override

  String spID;
  ModifySPInfo(String uid){this.spID=uid;}
  _ModifySPInfoState createState() => _ModifySPInfoState(spID);
}

List<myData> allData = [];

//--------------------------------------------------------------------

class myData {
  String  name,phone,qualifications,price;
  myData(this.name);
}

class _ModifySPInfoState extends State<ModifySPInfo> {

  final  _formKey = GlobalKey<FormState>();

  String spID;
  _ModifySPInfoState(String uid){spID=uid;}

  String name;
  String phone;
  String qual;
  String price;
  //String attachment;
  String  dbName;

  Map<String, dynamic> pickedLoc;
  bool picked;
  LatLng loc;
  LatLng l=new LatLng(24.745532, 46.790632);

  static int i=1;

  String Zft(){

    DatabaseReference ref = FirebaseDatabase.instance.reference();
    ref.child('Service Provider').orderByChild("uid").equalTo(spID).
    once().then((DataSnapshot snap) async{
      var keys = snap.value.keys;
      var data = snap.value;

      allData.clear();
      myData d;
      for (var key1 in keys) {
        d = new myData(data[key1]['name']);
        await allData.add(d);
      }

      for (var i = 0; i < allData.length; i++) {
        dbName=allData[i].name.toString();
       // print(dbName);
      }
    });
  }
  
  @override
  Widget build(BuildContext context) {
    String hint=Zft();
    print(hint);

    updateInfo() async{
      var _keys;
      var key;

      DatabaseReference ref = FirebaseDatabase.instance.reference();
      ref.child('Service Provider').orderByChild("uid").equalTo(spID).
      once().then(
              (DataSnapshot snap) async {
                _keys = snap.value.keys;
                key = _keys.toString();
                key=key.substring(1,21);
                ref.child('Service Provider').child(key).update({ "name": name,"phoneNumber": phone,});
          } );
    }
      return Scaffold(

        appBar: new AppBar(
          iconTheme: IconThemeData(
            color: Colors.black38, //change your color here
          ),
          title: new Center(child: new Text("إعدادات الحساب", textAlign: TextAlign.center, style: TextStyle(color: Colors.lightBlueAccent, fontSize: 25.0, fontFamily: "Montserrat",fontWeight: FontWeight.bold))),
          backgroundColor: Colors.grey[200],
          //automaticallyImplyLeading: false,
          /*actions: <Widget>[
            IconButton(
              icon: Icon(Icons.arrow_forward),
              color: Colors.grey,
              onPressed: () {*//*
                Navigator.push(context, new MaterialPageRoute(
                    builder: (context) => SP_HomePage()
                ));*//*},
            ),],*/
        ),
        body: Form(
          key: _formKey,  //for validation
          child: CustomScrollView(
            slivers: <Widget>[
              SliverList(
                delegate: SliverChildListDelegate([
                  /*Container(
                  padding: EdgeInsets.fromLTRB(90.0, 0.0, 0.0, 0.0),
                  child: Text('إعدادات الحساب',
                    style:
                    TextStyle(color: Colors.lightBlueAccent, fontSize: 30.0, fontWeight: FontWeight.bold, fontFamily: "Montserrat"),
                  ),
                ),*/
                  Container(
                      padding: EdgeInsets.fromLTRB(30.0, 0.0, 30.0, 0.0),
                      child: Column(
                        children: <Widget>[
                          Directionality(
                              textDirection: TextDirection.rtl,
                              child:TextFormField(
                                onChanged: (val){setState(() => name=val);},
                                decoration: InputDecoration(
                                    labelText:  'الاسم',
                                    hintText: "$hint",
                                    labelStyle: TextStyle( fontFamily: 'Montserrat',fontWeight: FontWeight.bold, color: Colors.grey),
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
                                onChanged: (val){setState(() => phone=val);},
                                decoration: InputDecoration(
                                    labelText:  'رقم الجوال',

                                    labelStyle: TextStyle( fontFamily: 'Montserrat',fontWeight: FontWeight.bold, color: Colors.grey),
                                    focusedBorder: UnderlineInputBorder(
                                        borderSide: BorderSide(color: Colors.lightBlueAccent))),
                              )
                          ),

                          /* Directionality(
                            textDirection: TextDirection.rtl,
                            child:TextField(
                              controller: _controller,
                              decoration: InputDecoration(

                                suffixIcon: IconButton(
                                  onPressed: () => _controller.clear(),
                                  icon: Icon(Icons.clear),
                                ),

                                labelText: 'كلمة المرور ',
                                labelStyle: TextStyle(fontFamily: 'Montserrat',fontWeight: FontWeight.bold,color: Colors.grey),
                                focusedBorder: UnderlineInputBorder(
                                  borderSide: BorderSide(color: Colors.lightBlueAccent),
                                ),
                              ),
                              obscureText: true,
                            )
                        ),*/
                          SizedBox(height:20.0),


                          FlatButton(
                            color: Colors.green[300],
                            textColor: Colors.white,
                            disabledColor: Colors.grey,
                            disabledTextColor: Colors.black,
                            padding: EdgeInsets.all(5.0),
                            splashColor: Colors.blueAccent,
                            onPressed: () {
                              //  _auth.sendPasswordResetEmail(email);
                            },
                            child: Text(
                              " تغير كلمة المرور",
                              style: TextStyle(fontSize: 20.0),
                            ),
                          ),

                          Directionality(
                              textDirection: TextDirection.rtl,
                              child:TextFormField(
                                onChanged: (val){setState(() => qual=val);},
                                decoration: InputDecoration(
                                    labelText:  'المؤهلات',
                                    labelStyle: TextStyle(fontFamily: 'Montserrat',fontWeight: FontWeight.bold, color: Colors.grey),
                                    focusedBorder: UnderlineInputBorder(
                                        borderSide: BorderSide(color: Colors.lightBlueAccent))),
                              )
                          ),

                          SizedBox(height:10.0),

                          Directionality(
                              textDirection: TextDirection.rtl,
                              child: Column(
                                children: <Widget>[TextFormField(
                                  onChanged: (val){setState(() => price=val);},
                                  decoration: InputDecoration(
                                      icon: Icon(Icons.attach_money),
                                      labelText:  'السعر',
                                      labelStyle: TextStyle( fontFamily: 'Montserrat',fontWeight: FontWeight.bold, color: Colors.grey),
                                      focusedBorder: UnderlineInputBorder(
                                          borderSide: BorderSide(color: Colors.lightBlueAccent))),
                                )
                                ],
                              )
                          ),

                          SizedBox(height:20.0),

                          ButtonTheme(
                              minWidth: 30.0,
                              height: 10.0,
                              child: RaisedButton(
                                  color: Colors.grey[200],
                                  onPressed: () {},
                                  child: Row(children: <Widget>[
                                    Text("   تعديل المرفقات              ",
                                        textAlign: TextAlign.center,
                                        style: TextStyle(color: Colors.grey[600], fontWeight: FontWeight.bold,fontSize: 24.0, fontFamily: 'Montserrat', )),
                                    Icon(Icons.attach_file),
                                  ]
                                  )
                              )
                          ),
                          SizedBox(height:20.0),
                        ],
                      )
                  ),

                  /*  new Container(
                   //margin: const EdgeInsets.only(right: 120, left: 120),
                    child: new TextFormField(
                      decoration: new InputDecoration(hintText: 'السعر'),
                    )),*/

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
                                      Text("  تعديل الموقع     ",
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
                          onTap: () {
                            if (_formKey.currentState.validate())
                            updateInfo();



                          },
                          child: Center(
                            child: Text( 'تحديث المعلومات',
                              style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold, fontSize: 20.0, fontFamily: 'Montserrat'), ),
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
      );
    }

  _pickLocation() async {

    loc=l;
    pickedLoc = await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (ctx) => ModifyLocation(loc),
        fullscreenDialog: true,
      ),
    );

    print("Zeft: $pickedLoc");

    if (pickedLoc == null) {
      return;
    }
    else{

      var lat=pickedLoc['latitude'];
      var lng=pickedLoc['longitude'];
      String com=pickedLoc['comments'];
      picked=pickedLoc['prickedLocation'];

      print("Zeft: PickLocation latitude: $lat");
      print("Zeft: PickLocation longitude: $lng");
      print("Zeft: PickLocation comments: $com");
      print("Zeft: PickLocation comments: $picked");


      loc=new LatLng(lat, lng);
      l=loc;
      print("Zeft: PickLocation LatLng: $l");
    }
  }

}
