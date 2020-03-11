import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:yumnak/services/ModifyLocation.dart';
import 'package:yumnak/services/auth.dart';

class ModifySPInfo extends StatefulWidget {
  @override

  String spID;
  ModifySPInfo(String uid){this.spID=uid;}
  _ModifySPInfoState createState() => _ModifySPInfoState(spID);
}

List<myData> allData = [];

//--------------------------------------------------------------------

class myData {
  String  name,phoneNumber,qualifications,email;
  var price;
  myData(this.email,this.name,this.phoneNumber,this.price,this.qualifications);

}

class _ModifySPInfoState extends State<ModifySPInfo> {

  final  _formKey = GlobalKey<FormState>();
  final AuthService  _auth = AuthService();

  String spID;
  _ModifySPInfoState(String uid){spID=uid;}

  String name;
  String phoneNumber;
  String qualifications;
  var price;
  String email;

  String newName;
  String newPhoneNumber;
  String newQualifications;
  var newPrice;

  //String attachment;
  String  dbName;

  Map<String, dynamic> pickedLoc;
  bool picked;
  LatLng loc;
  LatLng l=new LatLng(24.745532, 46.790632);



  List<myData> SPData = [];
  var keys;

  Future getSP() async{
    myData d;
    print("HI");

    await FirebaseDatabase.instance.reference().child('Service Provider').orderByChild("uid").equalTo(spID).once().then((DataSnapshot snap) async {
      keys = snap.value.keys;
      var data = snap.value;
      print(keys);
      print(data);

      print("HI2");

      SPData.clear();
      for (var key in keys) {
        print("In");
        d = new myData(
           data[key]['email'],
           data[key]['name'],
           data[key]['phoneNumber'],
           data[key]['price'],
           data[key]['qualifications'],
        );
        print(d);
        await SPData.add(d);
      }
      print("HI3");

    });
    if (SPData[0] != null ){
      name=SPData[0].name;
      phoneNumber=SPData[0].phoneNumber;
      qualifications=SPData[0].qualifications;
      price=SPData[0].price;
      email=SPData[0].email;
    }

    return SPData;}




  static int i=1;
  /*String Zft(){

    DatabaseReference ref = FirebaseDatabase.instance.reference();
    ref.child('Service Provider').orderByChild("uid").equalTo(spID).
    once().then((DataSnapshot snap) async{
      var keys = snap.value.keys;
      var data = snap.value;

      allData.clear();
      myData d;
      for (var key1 in keys) {
        d = new myData(
          data[key1]['name'],
          data[key1]['phoneNumber'],
          data[key1]['qualifications'],
          data[key1]['price'],
          data[key1]['email'],

        );
        await allData.add(d);
      }

      for (var i = 0; i < allData.length; i++) {
        dbName=allData[i].name.toString();
       // print(dbName);
      }
    });
  }
  */
  @override
  Widget build(BuildContext context) {
    //String hint=Zft();
   // print(hint);

   /* updateInfo() async{
      var _keys;
      var key;

      DatabaseReference ref = FirebaseDatabase.instance.reference();
      ref.child('Service Provider').orderByChild("uid").equalTo(spID).
      once().then(
              (DataSnapshot snap) async {
                _keys = snap.value.keys;
                key = _keys.toString();
                key=key.substring(1,21);
                ref.child('Service Provider').child(key).update({ "name": name,"phoneNumber": newPhoneNumber,});
          } );
    }*/


      return Scaffold(

        appBar: new AppBar(
          iconTheme: IconThemeData(
            color: Colors.black38, //change your color here
          ),
          title: new Center(child: new Text("إعدادات الحساب", textAlign: TextAlign.center, style: TextStyle(color: Colors.lightBlueAccent, fontSize: 25.0, fontFamily: "Montserrat",fontWeight: FontWeight.bold))),
          backgroundColor: Colors.grey[200],
        ),
        body: FutureBuilder(
            future: getSP(),
            builder: (BuildContext context,AsyncSnapshot snapshot) {
              if (!snapshot.hasData)
                return Container(child: Center(child: Text("Loading.."),));
              else return Container(
                child: Form(
                  key: _formKey,  //for validation
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
                                            labelText:  'رقم الجوال',
                                            hintText: phoneNumber,
                                            labelStyle: TextStyle( fontFamily: 'Montserrat',fontWeight: FontWeight.bold, color: Colors.grey),
                                            focusedBorder: UnderlineInputBorder(
                                                borderSide: BorderSide(color: Colors.lightBlueAccent))),
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
                                                    style: TextStyle(color: Colors.grey[600],fontWeight: FontWeight.bold,
                                                      fontSize: 24.0,fontFamily: 'Montserrat',)),
                                              ]
                                          )
                                      )
                                  ),

                                  Directionality(
                                      textDirection: TextDirection.rtl,
                                      child:TextFormField(
                                        onChanged: (val){setState(() => newQualifications=val);},
                                        decoration: InputDecoration(
                                            hintText: qualifications,
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
                                          onChanged: (val){setState(() => newPrice= double.parse(val));},
                                          decoration: InputDecoration(
                                              icon: Icon(Icons.attach_money),
                                              labelText:  'السعر',
                                              hintText: price.toString(),
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
                                     updateSP();



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
            } )
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

  updateSP() async{
    var _keys;
    var key;

    if (newName == null )
      newName=name;
    if(newPhoneNumber == null)
      newPhoneNumber=phoneNumber;
    if(newQualifications == null)
      newQualifications=qualifications;
      if(newPrice == null)
        newPrice=price;

        DatabaseReference ref = await FirebaseDatabase.instance.reference();
    ref.child('Service Provider').orderByChild("uid").equalTo(spID).
    once().then(
            (DataSnapshot snap) async {
          _keys = snap.value.keys;
          key = _keys.toString();
          key=key.substring(1,21);
          ref.child('Service Provider').child(key).update({ "name": newName,"phoneNumber": newPhoneNumber,"qualifications" : newQualifications, "price" : newPrice});
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
