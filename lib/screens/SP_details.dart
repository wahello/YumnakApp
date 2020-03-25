import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:rating_bar/rating_bar.dart';
import 'package:yumnak/screens/HomePage.dart';
import 'package:yumnak/screens/requestService.dart';

class SP_details extends StatefulWidget {
  dynamic uid;
  dynamic SPuid;
  String loc;
  SP_details(this.uid, this.SPuid, this.loc);

  @override
  _SP_detailsState createState() => _SP_detailsState(uid, SPuid, loc);
}

//--------------------------------------------------------------------

class _SP_detailsState extends State<SP_details> {

  static dynamic uid;
  static dynamic SPuid;

  double distanceInMeters;
  String s;

  var dbReference;
  var _firebaseRef =FirebaseDatabase.instance.reference();
  var dbReferenceCust;
  var _firebaseRefCust =FirebaseDatabase.instance.reference();


  String available, file, name, phoneNumber, qualifications, email, service;
  var price, fileName;
  double rAvg, rTime, rWork, rCoop, rPrice, lat,lng;
  int ratingCount;

  String cusUid, cusName;
  var cusLatitude , cusLongitude;

  _SP_detailsState(dynamic u,dynamic SPu, String loc){
    uid=u; SPuid=SPu;
    s=loc;
  }

  @override
  void initState() {
    super.initState();
    dbReference=_firebaseRef.child('Service Provider').orderByChild('uid').equalTo(SPuid);
    dbReferenceCust=_firebaseRefCust.child('Customer').orderByChild('uid').equalTo(uid);
    print('SP_details: $uid');print('SP_details SPUID: $SPuid');

  }

/*  Future<void> showAttach(){
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Not in stock'),
          content: Text("المفرق"),
          actions: <Widget>[
            FlatButton(
              child: Text('Ok'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }*/

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.black38),
        backgroundColor: Colors.grey[200],
        actions: <Widget>[IconButton(icon: Icon(Icons.home),onPressed: (){ Navigator.push(context, new MaterialPageRoute(builder: (context) => HomePage(uid)));},)],
      ),

      body:StreamBuilder(
          stream: dbReferenceCust.onValue,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting){return Center(child: CircularProgressIndicator(),);}
            Map custData = snapshot.data.snapshot.value;
            List Custitem = [];
            custData.forEach((index, data) => Custitem.add({"key": index, ...data}));
            cusUid = Custitem[0]['uid'];
            cusName= Custitem[0]['name'];
            cusLatitude = Custitem[0]['latitude'];
            cusLongitude = Custitem[0]['longitude'];

            return StreamBuilder(
                stream: dbReference.onValue,
                builder: (context, snapshot){
                  if (snapshot.connectionState == ConnectionState.waiting){return Center(child: CircularProgressIndicator(),);}
                  Map data = snapshot.data.snapshot.value;
                  List item = [];
                  data.forEach((index, data) => item.add({"key": index, ...data}));
                  name=item[0]['name'];
                  price=item[0]['price'];
                  qualifications=item[0]['qualifications'];
                  service=item[0]['service'];
                  rAvg=item[0]['ratingAvg'];
                  rTime=item[0]['ratingTime'];
                  rWork=item[0]['ratingWork'];
                  rCoop=item[0]['ratingCooperation'];
                  rPrice=item[0]['raringPrice'];
                  ratingCount=item[0]['ratingCounter'];
                  fileName=item[0]['fileName'];
                  lat=item[0]['latitude:'];
                  lng=item[0]['longitude'];

                  return spDetails();
                }
            );
          }
      ),
    );
  }

  Widget spDetails(){
    return ListView(
      children: <Widget>[
        Container(
          width: MediaQuery.of(context).size.width,
          child: Column(
            children: <Widget>[
              SizedBox(height: 20),
              Icon(Icons.account_circle, size: 100, color: Colors.green[400]),
              Text(name, style: TextStyle( color: Colors.black38,fontWeight: FontWeight.bold,fontSize: 30)),

              Card(
                margin: new EdgeInsets.only(left: 10.0, right: 10.0, top: 10.0, bottom: 5.0),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
                child: Directionality(
                  textDirection: TextDirection.rtl,
                  child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: <Widget>[

                        if(service=='تصوير' || service=='إصلاح أجهزة ذكية' || service=='عناية واسترخاء'|| service== 'شعر'|| service== 'مكياج'|| service=='صبابات'|| service=='تنسيق حفلات'|| service=='تجهيز طعام')
                          Column(children: <Widget>[
                            Padding(
                              padding: EdgeInsets.fromLTRB(15, 0, 10, 5),
                              child:
                              Text("السعر كحد أدنى",style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                            ),
                            Text(price.toString())
                          ])

                        else
                          Column(children: <Widget>[
                            Padding(
                              padding: EdgeInsets.fromLTRB(15, 0, 10, 5),
                              child:
                              Text("السعر بالساعة",style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                            ),
                            Text(price.toString())
                          ]),

                        Column(children: <Widget>[
                          Padding(
                            padding: EdgeInsets.fromLTRB(15, 0, 10, 5),
                            child: Text("الموقع",
                                style: TextStyle(
                                    fontSize: 18, fontWeight: FontWeight.bold)),
                          ),
                          Text('$s كم')
                        ]),

                        Column(children: <Widget>[
                          Padding(
                            padding: EdgeInsets.fromLTRB(15, 0, 10, 5),
                            child: Text("التقييم",style: TextStyle(
                                fontSize: 18, fontWeight: FontWeight.bold)),
                          ),
                          RatingBar.readOnly(
                            initialRating: rAvg,
                            isHalfAllowed: true,
                            halfFilledIcon: Icons.star_half,
                            filledIcon: Icons.star,
                            emptyIcon: Icons.star_border,
                            filledColor: Colors.amber,
                            size: 20,
                          ),
                        ]),
                      ]),
                ),
              ),
              Container(
                //height: 200,
                width: 350,
                child: Card(
                    margin: new EdgeInsets.only(
                        left: 10.0, right: 10.0, top: 10.0, bottom: 5.0),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.0)),
                    child: Padding(
                      padding: EdgeInsets.fromLTRB(10, 10, 10, 10),
                      child: Column(
                        children: <Widget>[
                          Text(
                            "المؤهلات",
                            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold,),
                          ),
                          Text(qualifications,
                            textAlign: TextAlign.right,
                            overflow: TextOverflow.visible,
                            textDirection: TextDirection.rtl,
                          )
                        ],
                      ),
                    )
                ),
              ),
              if(fileName!="")
                Directionality(
                  textDirection: TextDirection.rtl,
                  child: Container(
                    width: 200,
                    color: Colors.grey[200],
                    child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Align(
                              alignment: Alignment.center,

                              child: FadeInImage(
                                height: 180,
                                width: 180,
                                fit: BoxFit.cover,
                                placeholder: AssetImage("assets/load.gif"),
                                image: NetworkImage(fileName),
                              )
                          ),
                        ] ),
                  ),
                ),

              Container(
                child:  Card(
                  margin: new EdgeInsets.only(
                      left: 10.0, right: 10.0, top: 10.0, bottom: 5.0),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0)),
                  child: Directionality(
                      textDirection: TextDirection.rtl,
                      child: Column(
                        children: <Widget>[
                          Row(
                            children: <Widget>[
                              Text("التقييم", style: TextStyle(fontSize: 18,fontWeight: FontWeight.bold ),),
                              Text(" ($ratingCount تقييمات )")
                            ],
                          ),
                          Row(
                              children: <Widget>[
                                Column(children: <Widget>[
                                  Padding(
                                    padding: EdgeInsets.fromLTRB(70, 0, 40, 5),
                                    child: Text("الالتزام بالوقت",style: TextStyle(fontSize: 16)),
                                  ),
                                ]),
                                Column(
                                    children: <Widget>[
                                      Padding(
                                        padding: EdgeInsets.fromLTRB(0, 0, 0, 5),
                                        child: RatingBar.readOnly(
                                          initialRating: rTime,
                                          isHalfAllowed: true,
                                          halfFilledIcon: Icons.star_half,
                                          filledIcon: Icons.star,
                                          emptyIcon: Icons.star_border,
                                          filledColor: Colors.amber,
                                          size: 20,
                                        ),
                                      ), ]
                                ),
                              ]),
                          Row(
                              children: <Widget>[
                                Column(children: <Widget>[
                                  Padding(
                                    padding: EdgeInsets.fromLTRB(88, 0, 40, 5),
                                    child: Text("جودة العمل",style: TextStyle(fontSize: 16)),
                                  ),
                                ]),
                                Column(
                                    children: <Widget>[
                                      Padding(
                                        padding: EdgeInsets.fromLTRB(0, 0, 0, 5),
                                        child: RatingBar.readOnly(
                                          initialRating: rWork,
                                          isHalfAllowed: true,
                                          halfFilledIcon: Icons.star_half,
                                          filledIcon: Icons.star,
                                          emptyIcon: Icons.star_border,
                                          filledColor: Colors.amber,
                                          size: 20,
                                        ),
                                      ), ]
                                ),
                              ]
                          ),
                          Row(
                              children: <Widget>[
                                Column(children: <Widget>[
                                  Padding(
                                    padding: EdgeInsets.fromLTRB(112, 0, 40, 5),
                                    child: Text("التعامل",style: TextStyle(fontSize: 16)),
                                  ),
                                ]),
                                Column(
                                    children: <Widget>[
                                      Padding(
                                        padding: EdgeInsets.fromLTRB(0, 0, 0, 5),
                                        child: RatingBar.readOnly(
                                          initialRating: rCoop,
                                          isHalfAllowed: true,
                                          halfFilledIcon: Icons.star_half,
                                          filledIcon: Icons.star,
                                          emptyIcon: Icons.star_border,
                                          filledColor: Colors.amber,
                                          size: 20,
                                        ),
                                      ), ]
                                ),
                              ]),
                          Row(
                              children: <Widget>[
                                Column(children: <Widget>[
                                  Padding(
                                    padding: EdgeInsets.fromLTRB(122, 0, 40, 5),
                                    child: Text("السعر",style: TextStyle(fontSize: 16)),
                                  ),
                                ]),
                                Column(
                                    children: <Widget>[
                                      Padding(
                                        padding: EdgeInsets.fromLTRB(0, 0, 0, 5),
                                        child: RatingBar.readOnly(
                                          initialRating: rPrice,
                                          isHalfAllowed: true,
                                          halfFilledIcon: Icons.star_half,
                                          filledIcon: Icons.star,
                                          emptyIcon: Icons.star_border,
                                          filledColor: Colors.amber,
                                          size: 20,
                                        ),
                                      ), ]
                                ),
                              ]),
                        ],
                      )
                  ),
                ),
              ),
              Card(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0)),
                child: Container(
                  width: 340,
                  height: 110,
                  child: ListView(
                    children: <Widget>[
                      ListTile(
                        title: Text('الاسم',textDirection: TextDirection.rtl),
                        subtitle: Text("التعلييييييييييق",textDirection: TextDirection.rtl),
                        //dense: true,
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 20),
              Container(
                  height: 40.0,
                  child: Material(
                    borderRadius: BorderRadius.circular(20.0),
                    shadowColor: Colors.lightBlueAccent,
                    color: Colors.green[300],elevation: 3.0,
                    child: GestureDetector(
                      onTap: () {
                        Navigator.push(context, new MaterialPageRoute(builder: (context) =>
                                    requestService(uid, SPuid)));
                      },
                      child: Center(
                        child: Text( 'طلب',
                          style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold,
                              fontSize: 20.0,fontFamily: 'Montserrat'),
                        ),
                      ),
                    ),
                  )),
              SizedBox(height: 30),
            ],
          ),
        ),
      ],
    );
  }

}
