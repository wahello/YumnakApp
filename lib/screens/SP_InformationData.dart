import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:rating_bar/rating_bar.dart';

class sp_InformationData extends StatefulWidget {
  dynamic SPuid;
  sp_InformationData(dynamic SPu){ SPuid=SPu; }

  @override
  _sp_InformationDataState createState() => _sp_InformationDataState(SPuid);
}

class _sp_InformationDataState extends State<sp_InformationData> {

  var dbReference;
  var _firebaseRef =FirebaseDatabase.instance.reference();

  String spID;
  _sp_InformationDataState(String uid){spID=uid;}

  String available, file, name, phoneNumber, qualifications, email, service;
  var price, fileName;
  double rAvg, rTime, rWork, rCoop, rPrice;
  int ratingCount;

  @override
  void initState() {
    super.initState();
    dbReference=_firebaseRef.child('Service Provider').orderByChild('uid').equalTo(spID);
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: new AppBar(
        iconTheme: IconThemeData(color: Colors.black38,),
        title: new Center(child: new Text("بياناتي", textAlign: TextAlign.center, style: TextStyle(color: Colors.lightBlueAccent, fontSize: 25.0, fontFamily: "Montserrat",fontWeight: FontWeight.bold))),
        backgroundColor: Colors.grey[200],
        actions: <Widget>[IconButton(icon: Icon(Icons.home),onPressed: (){},color: Colors.grey[200],)], //اللهم إنا نسألك الستر والسلامة
      ),
      body: Container(
        child: StreamBuilder(
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
                        /*if(fileName!="")
                          Directionality(
                            textDirection: TextDirection.rtl,
                            child: Container(
                              width: 200,
                              //child: RaisedButton(
                              //onPressed:(){ print('https://firebasestorage.googleapis.com/v0/b/yumnak-3df66.appspot.com/o/images%2FIMG_20200315_201117.jpg%7D?alt=media&token=effeba4b-2962-41fb-bcbd-cb480388f4cb',);
                              // Image.network('https://wallpapercave.com/wp/wp4769141.jpg');
                              // },
                              color: Colors.grey[200],
                              child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: <Widget>[
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
                                  ] ),
                            ),
                          ),*/



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

                        /*SizedBox(height: 20),
                        Container(
                            height: 40.0,
                            child: Material(
                              borderRadius: BorderRadius.circular(20.0),
                              shadowColor: Colors.lightBlueAccent,
                              color: Colors.green[300],elevation: 3.0,
                              child: GestureDetector(
                                // onTap: () {
                                //  Navigator.push(context, new MaterialPageRoute(builder: (context) =>
                                //     requestService(uid, SPuid, sp.name, sp.service, cust.name, cust.latitude, cust.longitude)));
                                // },
                                child: Center(
                                  child: Text( 'طلب',
                                    style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold,
                                        fontSize: 20.0,fontFamily: 'Montserrat'),
                                  ),
                                ),
                              ),
                            )),*/
                        SizedBox(height: 20),
                      ],
                    ),
                  ),
                ],
              );
            }
        ),
      ),
    );
  }
}
