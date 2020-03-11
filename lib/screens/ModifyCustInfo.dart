import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:yumnak/screens/HomePage.dart';
import 'package:yumnak/services/auth.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:yumnak/services/ModifyLocation.dart';

class ModifyCustInfo extends StatefulWidget {
  dynamic uid;
  ModifyCustInfo(dynamic u){uid=u;}

  @override
  _ModifyCustInfoState createState() => _ModifyCustInfoState(uid);
}

class myData {
  String name;
  String phoneNumber;
  String email;
  var latitude,longitude;
  String locComment;
  LatLng getLocation;

  myData(this.name,this.phoneNumber,this.email,this.latitude, this.longitude, this.locComment);
}

class _ModifyCustInfoState extends State<ModifyCustInfo> {

  static dynamic uid;
  _ModifyCustInfoState(dynamic u){uid=u; print('ModifyCustInfo: $uid');}

  final AuthService  _auth = AuthService();
  final  _formKey = GlobalKey<FormState>();

  String name;
  String phoneNumber;
  String email;

  String newName;
  String newPhoneNumber;

  Map<String, dynamic> pickedLoc;
  bool picked;
  var lat,lng;
  String locCom;

  List<myData> allData = [];
  var keys;

  Future getCust() async{
    myData d;

    await FirebaseDatabase.instance.reference()
    .child('Customer').orderByChild("uid").equalTo(uid).once().then((DataSnapshot snap) async {
      keys = snap.value.keys;
      var data = snap.value;

      allData.clear();

      for (var key in keys) {
        d = new myData(
          data[key]['name'],
          data[key]['phoneNumber'],
          data[key]['email'],
          data[key]['latitude'],
          data[key]['longitude'],
          data[key]['locComment'],
        );
        await allData.add(d);
      }
    });
    if (allData[0] != null ){
    name=allData[0].name;
    phoneNumber=allData[0].phoneNumber;
    email=allData[0].email;
    allData[0].getLocation=new LatLng(allData[0].latitude, allData[0].longitude);
    }
    return allData;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: new AppBar(
        title: new Center(child: new Text("        إعدادات الحساب", textAlign: TextAlign.center, style: TextStyle(color: Colors.lightBlueAccent, fontSize: 25.0, fontFamily: "Montserrat",fontWeight: FontWeight.bold))),
        backgroundColor: Colors.grey[200],
        automaticallyImplyLeading: false,
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.arrow_forward),
            color: Colors.grey,
            onPressed: () {
              Navigator.push(context, new MaterialPageRoute(
                  builder: (context) => HomePage(uid)
              ));},
          ),],

      ),
      body: FutureBuilder(
        future: getCust(),
        builder: (BuildContext context,AsyncSnapshot snapshot){
          if(!snapshot.hasData)
            return Container(child: Center(child: Text("Loading.."),));
          else
            return Container(
              child: Form(
                key: _formKey,
                child: CustomScrollView(
                  slivers: <Widget>[

                    SliverList(

                      delegate: SliverChildListDelegate([
                        Container(
                            padding: EdgeInsets.fromLTRB(30.0, 0.0, 30.0, 0.0),
                            child: Column(
                              children: <Widget>[
                                Directionality(
                                    textDirection: TextDirection.rtl,
                                    child:TextFormField(
                                      onChanged: (val){setState(() => newName=val);},
                                      decoration: InputDecoration(
                                          hintText: name,
                                          labelText:  'الاسم',
                                          labelStyle: TextStyle( fontFamily: 'Montserrat',fontWeight: FontWeight.bold, color: Colors.grey),
                                          focusedBorder: UnderlineInputBorder(
                                              borderSide: BorderSide(color: Colors.lightBlueAccent))),
                                    )
                                ),
                                Directionality(
                                    textDirection: TextDirection.rtl,
                                    child:TextFormField(
                                        validator: (String v){
                                          if (newPhoneNumber!=null && v.length!=10)
                                            return'أدخل رقم الجوال الصحيح';
                                          return null;
                                        },
                                        onChanged: (val){setState(() => newPhoneNumber=val);},
                                        decoration: InputDecoration(
                                            hintText: phoneNumber,
                                            labelText:  'رقم الجوال',
                                            labelStyle: TextStyle( fontFamily: 'Montserrat',fontWeight: FontWeight.bold, color: Colors.grey),
                                            focusedBorder: UnderlineInputBorder(
                                                borderSide: BorderSide(color: Colors.lightBlueAccent)))

                                    )
                                ),

                                SizedBox(height:20.0),

                                ButtonTheme(
                                    minWidth: 30.0,
                                    height: 10.0,
                                    child: RaisedButton(
                                        onPressed: () {  _auth.sendPasswordResetEmail(email); },
                                        color: Colors.green[300],
                                        child: Row(
                                            children: <Widget>[
                                              Text(" تغيير كلمة المرور              ",
                                                  textAlign: TextAlign.center,
                                                  style: TextStyle(
                                                    color: Colors.grey[600],
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 24.0,fontFamily: 'Montserrat',)),
                                            ]
                                        )
                                    )
                                ),

                                SizedBox(height:40.0),

                                Directionality(
                                  textDirection: TextDirection.rtl,

                                  child: Row(
                                    children: <Widget>[
                                      SizedBox(width:20.0),
                                      Text('الموقع',
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
                              ],
                            )
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
                                    update();
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
              ),
            );
        },
      ),
    );
  }

  _pickLocation() async {

    pickedLoc = await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (ctx) => ModifyLocation(allData[0].getLocation, allData[0].locComment),
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
      locCom=pickedLoc['comments'];
      picked=pickedLoc['prickedLocation'];

      print("Zeft: PickLocation latitude: $lat");
      print("Zeft: PickLocation longitude: $lng");
      print("Zeft: PickLocation comments: $locCom");
      print("Zeft: PickLocation comments: $picked");

      allData[0].getLocation=new LatLng(lat, lng);
      allData[0].locComment=locCom;
      LatLng zzz=allData[0].getLocation;
      print("Zeft: PickLocation LatLng: $zzz");
    }
  }


  update() async{
    var _keys;
    var key;

    if (newName == null )
      newName=name;
    if(newPhoneNumber == null)
      newPhoneNumber=phoneNumber;

    DatabaseReference ref = FirebaseDatabase.instance.reference();
    ref.child('Customer').orderByChild("uid").equalTo(uid).
    once().then(
            (DataSnapshot snap) async {
          _keys = snap.value.keys;
          key = _keys.toString();
          key=key.substring(1,21);
          ref.child('Customer').child(key).update({ "name": newName,"phoneNumber": newPhoneNumber,"latitude": lat, "longitude": lng, "locComment": locCom});
        } );

    Fluttertoast.showToast(
        msg: ("تم تحديث البيانات بنجاح"),
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.CENTER,
        timeInSecForIos: 20,
        backgroundColor: Colors.red[100],
        textColor: Colors.red[800]
    );
  }


}
