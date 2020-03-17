import 'dart:io';

import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:yumnak/services/ModifyLocation.dart';
import 'package:yumnak/services/auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:path/path.dart' as Path;
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
  var latitude,longitude;
  LatLng getLocation;
  var fileName;
  myData(this.email,this.name,this.phoneNumber,this.price,this.qualifications, this.latitude, this.longitude,this.fileName);

}

class _ModifySPInfoState extends State<ModifySPInfo> {

  final  _formKey = GlobalKey<FormState>();
  final AuthService  _auth = AuthService();

  String spID;
  _ModifySPInfoState(String uid){spID=uid;}

  String file;
  String name;
  String phoneNumber;
  String qualifications;
  var price;
  String email;
  var fileName;
  String newName;
  String newPhoneNumber;
  String newQualifications;
  var newPrice;
  var newFileName;
  File _image;
  String _uploadedFileURL;
  bool isLoading = false;
  //String attachment;
  String  dbName;

  Map<String, dynamic> pickedLoc;
  bool picked;
  var lat,lng;
  String locCom;

  List<myData> SPData = [];
  var keys;

  Future getSP() async{
    myData d;

    await FirebaseDatabase.instance.reference().child('Service Provider').orderByChild("uid").equalTo(spID).once().then((DataSnapshot snap) async {
      keys = snap.value.keys;
      var data = snap.value;
      print(keys);
      print(data);


      SPData.clear();
      for (var key in keys) {
        print("In");
        d = new myData(
           data[key]['email'],
           data[key]['name'],
           data[key]['phoneNumber'],
           data[key]['price'],
           data[key]['qualifications'],
          data[key]['latitude'],
          data[key]['longitude'],
          data[key]['fileName'],
        );
        print(d);
        await SPData.add(d);
      }

    });
    if (SPData[0] != null ){
      name=SPData[0].name;
      phoneNumber=SPData[0].phoneNumber;
      qualifications=SPData[0].qualifications;
      price=SPData[0].price;
      email=SPData[0].email;
      fileName=SPData[0].fileName;
      //SPData[0].getLocation=new LatLng(allData[0].latitude, allData[0].longitude);
    }

    return SPData;
  }

  @override
  Widget build(BuildContext context) {
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
                                      minWidth: 20.0,
                                      height: 10.0,
                                      child: RaisedButton(
                                          color: Colors.grey[200],
                                          onPressed: () {
                                            chooseFile();
                                          },
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
                                Text('المرفقات',
                                  style:TextStyle(
                                      color: Colors.grey[600],
                                      fontSize: 20.0,
                                      fontWeight: FontWeight.bold,
                                      fontFamily: "Montserrat"
                                  ),
                                ),

                                SizedBox(width:20.0),

                                Align(
                                  alignment: Alignment.center,

                                  child: ClipPath(
                                    child: new SizedBox(
                                        width: 180.0,
                                        height: 180.0,
                                        child:Image.network(fileName , fit: BoxFit.fill,)

                                    ),
                                  ),
                                ),
                              ],
                            ),
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
    SPData[0].getLocation=new LatLng(SPData[0].latitude, SPData[0].longitude);

    pickedLoc = await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (ctx) => ModifyLocation(SPData[0].getLocation, "zeft"),
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
      LatLng zzz=allData[0].getLocation;
      print("Zeft: PickLocation LatLng: $zzz");
    }
  }

  updateSP() async{
    uploadFile();
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
//      if(fileName==null)
//        newFileName=fileName;

        DatabaseReference ref = await FirebaseDatabase.instance.reference();
    ref.child('Service Provider').orderByChild("uid").equalTo(spID).
    once().then(
            (DataSnapshot snap) async {
          _keys = snap.value.keys;
          key = _keys.toString();
          key=key.substring(1,21);
          ref.child('Service Provider').child(key).update({ "name": newName,"phoneNumber": newPhoneNumber,"qualifications" : newQualifications, "price" : newPrice, "latitude": lat, "longitude": lng, "locComment": locCom, "fileName": fileName});
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



  Future chooseFile() async {
    await ImagePicker.pickImage(source: ImageSource.gallery).then((image) {
      setState(() {
        _image = image;
      });
    });
   // uploadFile();
  }

  Future uploadFile() async {
    setState(() {
      isLoading = true;
    });
    StorageReference storageReference = FirebaseStorage.instance.ref().child('images/${Path.basename(_image.path)}}');
    StorageUploadTask uploadTask = storageReference.putFile(_image);
    await uploadTask.onComplete;
    print('File Uploaded');
    storageReference.getDownloadURL().then((fileURL) {
      setState(() {
        _uploadedFileURL = fileURL;
        //newFileName=fileURL;
        fileName=fileURL;
        isLoading = false;
        print(fileName);
      });
    });
  }

}
