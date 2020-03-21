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


class _ModifyCustInfoState extends State<ModifyCustInfo> {

  static dynamic uid;
  _ModifyCustInfoState(dynamic u){uid=u; print('ModifyCustInfo: $uid');}

  final AuthService  _auth = AuthService();
  final  _formKey = GlobalKey<FormState>();

  String name;
  String phoneNumber;
  var lat,lng;
  String locCom;
  String email;


  String newName;
  String newPhoneNumber;
  var newLat,newLng;
  String newLocCom;


  TextEditingController _nameCtrl = TextEditingController();
  TextEditingController _phoneCtrl = TextEditingController();


  Map<String, dynamic> pickedLoc;
  LatLng location;
  bool picked;

  var dbReference;
  var _firebaseRef =FirebaseDatabase.instance.reference();

  @override
  initState(){
    super.initState();
    dbReference=_firebaseRef.child('Customer').orderByChild("uid").equalTo(uid);
    _nameCtrl.addListener(_setNewName);
    _phoneCtrl.addListener(_setNewPhone);

  }

  _setNewName() {newName=_nameCtrl.text;print("Hi");print(newName);}
  _setNewPhone(){newPhoneNumber=_phoneCtrl.text;print(newPhoneNumber);}


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
      body: Container(
        child: StreamBuilder(
          stream: dbReference.onValue,
          builder: (context , snapshot){
            if(snapshot.connectionState == ConnectionState.waiting){return Center(child: CircularProgressIndicator(),);}
            Map data = snapshot.data.snapshot.value;
            List item = [];
            data.forEach( (index,data) => item.add({"key": index, ...data}));
            name=item[0]['name'];
            phoneNumber=item[0]['phoneNumber'];
            lat=item[0]['latitude'];
            lng=item[0]['longitude'];
            locCom=item[0]['locComment'];
            email=item[0]['email'];

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
                                      controller: _nameCtrl,
                                      //onChanged: (val){setState(() => newName=val);},
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
                                          if ( v!=""  && v.length!=10 )
                                            return'أدخل رقم الجوال الصحيح';
                                          return null;
                                        },
                                       // onChanged: (val){setState(() => newPhoneNumber=val);},
                                        controller: _phoneCtrl,
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
                                                    Text("  تعديل  ",
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
      )
    );
  }

  _pickLocation() async {
    location= new LatLng(lat, lng);


    pickedLoc = await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (ctx) => ModifyLocation(location, locCom),
        fullscreenDialog: true,
      ),
    );

    print("Zeft: $pickedLoc");

    if (pickedLoc == null) {
      return;
    }
    else{
      newLat=pickedLoc['latitude'];
      newLng=pickedLoc['longitude'];
      newLocCom=pickedLoc['comments'];
      picked=pickedLoc['prickedLocation'];
      location=new LatLng(newLat, newLng);
    }
  }


  update() async{
    var _keys;
    var key;

    if ((newName == null || newName == "") && (newPhoneNumber == null || newPhoneNumber == "") && newLng == null && newLat == null &&newLocCom == null)
      Fluttertoast.showToast(
          msg: ("لم تقم بتعديل"),
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.CENTER,
          timeInSecForIos: 20,
          backgroundColor: Colors.red[100],
          textColor: Colors.red[800]
      );

   else{
      if (newName == null || newName == "")
        newName=name;
      if(newPhoneNumber == null || newPhoneNumber == "")
        newPhoneNumber=phoneNumber;
      if(newLat==null)
        newLat= lat;
      if(newLng==null)
        newLng= lng;
      if(newLocCom==null)
        newLocCom=locCom;

      print("before db update");


      DatabaseReference ref = FirebaseDatabase.instance.reference();
      ref.child('Customer').orderByChild("uid").equalTo(uid).
      once().then(
              (DataSnapshot snap) async {
            _keys = snap.value.keys;
            key = _keys.toString();
            key=key.substring(1,21);

            ref.child('Customer').child(key).update({ "name": newName});
            ref.child('Customer').child(key).update({ "phoneNumber": newPhoneNumber});
            ref.child('Customer').child(key).update({ "latitude": newLat});
            ref.child('Customer').child(key).update({ "longitude": newLng});
            ref.child('Customer').child(key).update({ "locComment": newLocCom});
          } );

      print("after db update");


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

}
