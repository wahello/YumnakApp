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
  String spID;
  ModifySPInfo(String uid){this.spID=uid;}

  @override
  _ModifySPInfoState createState() => _ModifySPInfoState(spID);
}

class _ModifySPInfoState extends State<ModifySPInfo> {
  DatabaseReference ref = FirebaseDatabase.instance.reference();
  var dbReference;
  var _firebaseRef =FirebaseDatabase.instance.reference();


  final  _formKey = GlobalKey<FormState>();
  final AuthService  _auth = AuthService();

  String spID;
  _ModifySPInfoState(String uid){spID=uid;}


  TextEditingController _nameCtrl = TextEditingController();
  TextEditingController _phoneCtrl = TextEditingController();
  TextEditingController _qualCtrl = TextEditingController();
  TextEditingController _priceCtrl = TextEditingController();
  //TextEditingController _fileName = TextEditingController();

  String available, file, name, phoneNumber, qualifications, email;
  var price, fileName, latitude,longitude;

  String newName, newPhoneNumber, newQualifications;
  var newPrice, newFileName, newLatitude,newLongitude;

  File _image;
  String _uploadedFileURL;
  bool isLoading = false;
  //String attachment;
  String  dbName;

  Map<String, dynamic> pickedLoc;
  LatLng location;
  bool picked;

  @override
  initState(){
    super.initState();
    dbReference=_firebaseRef.child('Service Provider').orderByChild('uid').equalTo(spID);
    _nameCtrl.addListener(_setNewName);
    _phoneCtrl.addListener(_setNewPhone);
    _qualCtrl.addListener(_setNewQual);
    _priceCtrl.addListener(_setNewPrice);
   // _fileName..addListener(_setNewFileName);
  }

  _setNewName() {newName=_nameCtrl.text;print("Hi");print(newName);}
  _setNewPhone(){newPhoneNumber=_phoneCtrl.text;print(newPhoneNumber);}
  _setNewQual(){newQualifications=_qualCtrl.text;print(newQualifications);}
  _setNewPrice(){newPrice=_priceCtrl.text;print(newPrice);}
  //_setNewFileName(){newFileName=_fileName.text;print(newFileName);}

  @override
  Widget build(BuildContext context) {
      return Scaffold(

        appBar: new AppBar(
          iconTheme: IconThemeData(color: Colors.black38,),
          title: new Center(child: new Text("إعدادات الحساب", textAlign: TextAlign.center, style: TextStyle(color: Colors.lightBlueAccent, fontSize: 25.0, fontFamily: "Montserrat",fontWeight: FontWeight.bold))),
          backgroundColor: Colors.grey[200],
        ),
        body: Container(
          child: StreamBuilder(
            stream: dbReference.onValue,
            builder: (context, snapshot){
              if (snapshot.connectionState == ConnectionState.waiting){return Center(child: CircularProgressIndicator(),);}
              Map data = snapshot.data.snapshot.value;
              List item = [];
              data.forEach((index, data) => item.add({"key": index, ...data}));
              fileName=item[0]['fileName'];
              name=item[0]['name'];
              phoneNumber=item[0]['phoneNumber'];
              price=item[0]['price'];
              qualifications=item[0]['qualifications'];
              latitude=item[0]['latitude'];
              longitude=item[0]['longitude'];
              fileName=item[0]['fielName'];

              return Container(
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
                                          controller: _nameCtrl,
                                       // onChanged: (val){ setState(() => newName=val);},
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
                                          if (v!="" && v.length!=10)
                                            return'أدخل رقم الجوال الصحيح';
                                          return null;
                                        },
                                          controller: _phoneCtrl,
                                       // onChanged: (val){setState(() => newPhoneNumber=val);},
                                        decoration: InputDecoration(
                                            labelText:  'رقم الجوال',
                                            hintText: phoneNumber,
                                            labelStyle: TextStyle( fontFamily: 'Montserrat',fontWeight: FontWeight.bold, color: Colors.grey),
                                            focusedBorder: UnderlineInputBorder(
                                                borderSide: BorderSide(color: Colors.lightBlueAccent))),
                                      )
                                  ),

                                  SizedBox(height:25.0),

                                  ButtonTheme(
                                    padding: EdgeInsets.fromLTRB(55.0, 0.0, 55.0, 0.0) ,
                                      minWidth: 30.0,
                                      height: 10.0,
                                      child: RaisedButton(
                                          onPressed: () {  _auth.sendPasswordResetEmail(email); },
                                          color: Colors.green[300],
                                          child: Row(
                                              children: <Widget>[
                                                Text(" تغيير كلمة المرور",
                                                    textAlign: TextAlign.center,
                                                    style: TextStyle(color: Colors.grey[600],fontWeight: FontWeight.bold, fontSize: 24.0,fontFamily: 'Montserrat',)
                                                ),
                                              ]
                                          )
                                      )
                                  ),


                                  Directionality(
                                      textDirection: TextDirection.rtl,
                                      child:TextFormField(
                                        controller: _qualCtrl,
                                        maxLines: 6,
                                        minLines: 2,
                                        //onChanged: (val){setState(() => newQualifications=val);},
                                        decoration: InputDecoration(
                                            hintText: qualifications,
                                            labelText:  'المؤهلات',
                                            labelStyle: TextStyle(fontFamily: 'Montserrat',fontWeight: FontWeight.bold, color: Colors.grey),
                                            focusedBorder: UnderlineInputBorder(borderSide: BorderSide(color: Colors.lightBlueAccent))
                                        ),
                                      )
                                  ),

                                  SizedBox(height:10.0),

                                  Directionality(
                                      textDirection: TextDirection.rtl,
                                      child: Column(
                                        children: <Widget>[
                                          TextFormField(
                                          controller: _priceCtrl,
                                          // onChanged: (val){setState(() => newPrice= double.parse(val));},
                                          decoration: InputDecoration(
                                              icon: Icon(Icons.attach_money),
                                              labelText:  'السعر',
                                              hintText: price.toString(),
                                              labelStyle: TextStyle( fontFamily: 'Montserrat',fontWeight: FontWeight.bold, color: Colors.grey),
                                              focusedBorder: UnderlineInputBorder(borderSide: BorderSide(color: Colors.lightBlueAccent))),
                                        )
                                       ],
                                      )
                                  ),

                                  SizedBox(height:25.0),
                                  if (fileName != "")
                                  Directionality(
                                      textDirection: TextDirection.rtl,
                                      child: Row(
                                        children: <Widget>[

                                          Text('المرفقات',
                                            style:TextStyle( color: Colors.grey[600], fontSize: 20.0, fontWeight: FontWeight.bold, fontFamily: "Montserrat"),
                                          ),

                                          SizedBox(width:20.0),


                                            ButtonTheme(
                                                //controller:newFileName,
                                                minWidth: 30.0,
                                                height: 10.0,
                                                child: RaisedButton(
                                                    color: Colors.grey[200],
                                                    onPressed: () { chooseFile(); },

                                                    child: Row(
                                                        children: <Widget>[
                                                          Icon(Icons.attach_file),
                                                          Text("  تعديل ",
                                                              textAlign: TextAlign.center,
                                                              style: TextStyle(color: Colors.grey[600], fontWeight: FontWeight.bold,fontSize: 24.0, fontFamily: 'Montserrat', )
                                                          ),
                                                        ]
                                                    )
                                                )
                                            ),


                                          SizedBox(height:20.0),
                                        ],
                                      )
                                  ),
                                  if (fileName=="")
                                  Directionality(
                                      textDirection: TextDirection.rtl,
                                      child: Row(
                                        children: <Widget>[

                                          Text('المرفقات',
                                            style:TextStyle( color: Colors.grey[600], fontSize: 20.0, fontWeight: FontWeight.bold, fontFamily: "Montserrat"),
                                          ),

                                          SizedBox(width:20.0),


                                            ButtonTheme(
                                              //controller:newFileName,
                                                minWidth: 30.0,
                                                height: 10.0,
                                                child: RaisedButton(
                                                    color: Colors.grey[200],
                                                    onPressed: () { chooseFile(); },

                                                    child: Row(
                                                        children: <Widget>[
                                                          Icon(Icons.attach_file),
                                                          Text("  إرفاق ",
                                                              textAlign: TextAlign.center,
                                                              style: TextStyle(color: Colors.grey[600], fontWeight: FontWeight.bold,fontSize: 24.0, fontFamily: 'Montserrat', )
                                                          ),
                                                        ]
                                                    )
                                                )
                                            ),


                                          SizedBox(height:20.0),
                                        ],
                                      )
                                  ),

                        //  if (fileName != "")

                               /* Align(
                                  alignment: Alignment.center,

                                  child: FadeInImage(
                                    height: 180,
                                    width: 180,
                                    fit: BoxFit.cover,
                                    placeholder: AssetImage("assets/loading.gif"),
                                    image: NetworkImage(fileName),
                                  )


                                  ClipPath(
                                    child: new SizedBox(
                                        width: 180.0,
                                        height: 180.0,
                                        child:Image.network(fileName , fit: BoxFit.fill,)

                                    ),
                                  ),
                                ),*/
                              ],
                            ),
                          ),

                          SizedBox(height:15.0),

                          Directionality(
                            textDirection: TextDirection.rtl,

                            child: Row(
                              children: <Widget>[

                                SizedBox(width:30.0),

                                Text('موقعك  ',
                                  style:TextStyle(color: Colors.grey[600], fontSize: 20.0, fontWeight: FontWeight.bold, fontFamily: "Montserrat"),
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
                                              Text("  تعديل ",
                                                  textDirection: TextDirection.rtl,
                                                  textAlign: TextAlign.justify,
                                                  style: TextStyle( color: Colors.grey[600], fontWeight: FontWeight.bold, fontSize: 24.0, fontFamily: 'Montserrat',)
                                              ),
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
                                    if (_formKey.currentState.validate()){
                                      if(_image != null){
                                       await uploadFile();}
                                      updateSP();}



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

            },),
        )

      );
    }

  _pickLocation() async {
    location= new LatLng(latitude, longitude);

    pickedLoc = await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (ctx) => ModifyLocation(location, "SP"),
        fullscreenDialog: true,
      ),
    );

    if (pickedLoc == null) {
      return;
    }

    else {
      newLatitude=pickedLoc['latitude'];
      newLongitude=pickedLoc['longitude'];
      picked=pickedLoc['prickedLocation'];
      location=new LatLng(newLatitude, newLongitude);
    }
  }

  updateSP() async{
    print("Update Method");
    if (newName == null &&_image==null && newQualifications==null && newPhoneNumber=="" && newPrice=="" )
      Fluttertoast.showToast(
          msg: ("لم تقم بتعديل"),
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.CENTER,
          timeInSecForIos: 20,
          backgroundColor: Colors.red[100],
          textColor: Colors.red[800]
      );

    else{
      print('before variables update');

     /* if(_image != null)
        uploadFile();*/

      // await uploadFile();
      //print("after update");

      var _keys;
      var key;

      if (newName == "" || newName==null)
        newName=name;
      if(newPhoneNumber == "" || newPhoneNumber == null)
        newPhoneNumber=phoneNumber;
      if(newQualifications == "" || newQualifications==null)
        newQualifications=qualifications;
      if(newPrice == "" || newPrice == null)
        newPrice=price;
      if(fileName==null || fileName=="" )
        newFileName="";
      if(location==null){
        newLatitude= latitude;
        newLongitude= longitude;
      }

      print("before db update");

     // DatabaseReference ref = await FirebaseDatabase.instance.reference();
      await ref.child('Service Provider').orderByChild("uid").equalTo(spID).
      once().then((DataSnapshot snap) async {
            _keys = snap.value.keys;
            key = _keys.toString();

            key=key.substring(1,21);

            ref.child('Service Provider').child(key).update({"name":newName});
            ref.child('Service Provider').child(key).update({"phoneNumber":newPhoneNumber});
            ref.child('Service Provider').child(key).update({"qualifications":newQualifications});
            ref.child('Service Provider').child(key).update({"price":newPrice});

           // if(_image != null )
            //ref.child('Service Provider').child(key).update({"fileName":newFileName});

            ref.child('Service Provider').child(key).update({"latitude":newLatitude});
            ref.child('Service Provider').child(key).update({"longitude":newLongitude});

            //ref.child('Service Provider').child(key).update({ "name": newName,"phoneNumber": newPhoneNumber,"qualifications" : newQualifications, "price" : newPrice, "latitude": lat, "longitude": lng, "locComment": locCom, "fileName": fileName});

      });
      print("after db update");

      Fluttertoast.showToast(
          msg: ("تم تحديث البيانات بنجاح"),
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.CENTER,
          timeInSecForIos: 20,
          backgroundColor: Colors.green[100],
          textColor: Colors.green[800]
      );
    }
  }

  Future chooseFile() async {
    await ImagePicker.pickImage(source: ImageSource.gallery).then((image) {
      setState(() {
        _image = image;
        print(_image);
      });
    });
   // uploadFile();
  }

   Future uploadFile() async {
     setState(() {
       isLoading = true;
     });
     StorageReference storageReference = await FirebaseStorage.instance.ref()
         .child('images/${Path.basename(_image.path)}}');
     StorageUploadTask uploadTask = await storageReference.putFile(_image);
     await uploadTask.onComplete;
     print('File Uploaded');
     storageReference.getDownloadURL().then((fileURL) async {
       setState(()  {
         _uploadedFileURL = fileURL;
         newFileName = fileURL;
         isLoading = false;
         print(newFileName);
       });//end set

         var _key1;
         var key2;
         await ref.child('Service Provider').orderByChild("uid").equalTo(spID).
         once().then((DataSnapshot snap) {
           _key1 = snap.value.keys;
           key2 = _key1.toString();

           key2 = key2.substring(1, 21);
           ref.child('Service Provider').child(key2).update(
               {"fileName": newFileName});
         });

     });
   }}
