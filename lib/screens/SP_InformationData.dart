import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:rating_bar/rating_bar.dart';
import 'package:yumnak/screens/SP_HomePage.dart';

class sp_InformationData extends StatefulWidget {
  dynamic SPuid;
  sp_InformationData(dynamic SPu){ SPuid=SPu; }

  @override
  _sp_InformationDataState createState() => _sp_InformationDataState(SPuid);
}

class _sp_InformationDataState extends State<sp_InformationData> {

  var dbReference;
  var _firebaseRef =FirebaseDatabase.instance.reference();
  var dbReferenceReview;
  var _firebaseRefReview =FirebaseDatabase.instance.reference();

  String spID;
  _sp_InformationDataState(String uid){spID=uid; print(spID);}

  String available, file, name, phoneNumber, qualifications, email, service, flieName;
  var price, fileName;
  double rAvg, rTime, rWork, rCoop, rPrice;
  int ratingCount;

  List reviewsItem=[];

  @override
  void initState() {
    super.initState();
    dbReference=_firebaseRef.child('Service Provider').orderByChild('uid').equalTo(spID);
    dbReferenceReview=_firebaseRefReview.child('Reviews').orderByChild('uid_sp').equalTo(spID);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: new AppBar(
        iconTheme: IconThemeData(color: Colors.black38,),
        title: new Center(child: new Text("بياناتي", textAlign: TextAlign.center, style: TextStyle(color: Colors.lightBlueAccent, fontSize: 25.0, fontFamily: "Montserrat",fontWeight: FontWeight.bold))),
        backgroundColor: Colors.grey[200],
        leading: GestureDetector(onTap: () {Navigator.push(context, new MaterialPageRoute( builder: (context) => SP_HomePage(spID)));},child: Icon(Icons.arrow_back),),
        automaticallyImplyLeading: false,//اللهم إنا نسألك الستر والسلامة
      ),
      body: Container(
        child: StreamBuilder(
            stream: dbReferenceReview.onValue,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting){return Center(child: CircularProgressIndicator(),);}
              reviewsItem = [];
              if (snapshot.data.snapshot.value != null){
                Map reviewsData = snapshot.data.snapshot.value;
                reviewsData.forEach((index, data) => reviewsItem.add({"key": index, ...data}));
              }

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
                              if (reviewsItem.length !=0)
                                Card(
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10.0)),
                                  child: Container(
                                    width: 340,
                                    height: 110,
                                    child: ListView.separated(
                                      itemCount: reviewsItem.length,
                                      itemBuilder: (context, index) {
                                        return writeReviews(index);
                                      },
                                      separatorBuilder: (BuildContext context, int index) => const Divider(),
                                    ),
                                  ),
                                ),
                              if (reviewsItem.length == 0)
                                Card(
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10.0)),
                                  child: Container(
                                    width: 340,
                                    height: 110,
                                    child: ListView(
                                      children: <Widget>[
                                        ListTile(
                                          title: Text('لا يوجد طلبات', textAlign: TextAlign.center,),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              SizedBox(height: 20),
                            ],
                          ),
                        ),
                      ],
                    );
                  }
              );
            }
        ),
      ),
    );
  }
  Widget writeReviews(int i){
    String dt=reviewsItem[i]['dateTime'];
    dt=dt.substring(0,10);
    return ListTile(
      title: Text(reviewsItem[i]['name_cus'] ,textDirection: TextDirection.rtl),
      subtitle: Text(dt +"  \n  "+ reviewsItem[i]['review'],textDirection: TextDirection.rtl),
    );
  }
}
