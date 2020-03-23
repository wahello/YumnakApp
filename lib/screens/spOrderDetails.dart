import 'package:countdown_flutter/countdown_flutter.dart';
import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:intl/intl.dart';
import 'package:flutter/rendering.dart' as material;
import 'package:yumnak/services/ViewLocation.dart';
import 'package:url_launcher/url_launcher.dart';


class spOrderDetails extends StatefulWidget {
      String orderID;
      spOrderDetails(
        this.orderID,
      );

  @override
  _spOrderDetailsState createState() => _spOrderDetailsState(orderID);
}

class _spOrderDetailsState extends State<spOrderDetails> {

  String orderID;
  _spOrderDetailsState(String o){orderID=o; print('order ID: $orderID');}


  static dynamic uid;
  static dynamic spID;
  String dt;
  LatLng loc;

  DateFormat dateFormat = DateFormat("yyyy-MM-dd hh:mm a");
  bool isTimePassed, canCancel;
  Duration difference;
  String stDiff;
  var endDate;

  var reqDBReference;
  var _firebaseRef = FirebaseDatabase.instance.reference();

  Future<void> _launched;


  initState() {
    super.initState();
    reqDBReference = _firebaseRef.child('Order').orderByChild("orderID").equalTo(orderID);
  }

  Future<void> _makePhoneCall(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }
  format(Duration d) => d.toString().split('.').first.padLeft(8, "0");



  Widget _buildWidget(item, key) {

    loc = new LatLng(item["loc_latitude"], item["loc_longitude"]);

    DateTime reqDate = DateTime.parse(item['requestDate']);
    var endDate = reqDate.add(new Duration(hours: item['serviceHours']));
    Duration remaining = Duration(minutes: endDate.difference(DateTime.now()).inMinutes);
    bool isWaiting = endDate.isAfter(DateTime.now());

    var cancelDate = endDate.subtract(new Duration(hours: 1));
     print(cancelDate);

    var now = DateTime.now();
      print(now);


    Widget c = new Countdown(
      duration: remaining,
      builder: (BuildContext context, Duration remaining) {
        return Row(
          children: <Widget>[
            Text("الوقت المتبقي: " , textAlign: TextAlign.right, style: TextStyle(fontSize: 18,fontWeight: FontWeight.bold)),
            Text(format(remaining)),
          ],
        );
      },
    );

    if(!isWaiting && item["status"] == "قيد الانتظار"){
      _firebaseRef.child('Order').child(key).update({"status": 'ملغي'});
    }

    Color col;
    String stat=item['status'];

    if(stat=="قيد الانتظار")
      col=Colors.black;
    else if(stat=="مقبول")
      col=Colors.green[800];
    else if(stat=="ملغي")
      col=Colors.red;
    else if (stat=="مرفوض")
      col=Colors.red[900];
    else if(stat=="مكتمل")
      col=Colors.blue;


    return Container(
        width: MediaQuery.of(context).size.width,
        child:Column(
        children: <Widget>[
          SizedBox(height:20.0),
          Container(
            child: Directionality(
                textDirection: material.TextDirection.rtl,
                child: Column(
                  children: <Widget>[
                    Card(
                      margin: new EdgeInsets.only(left: 20.0, right: 20.0, top: 20.0, bottom: 5.0),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
                      elevation: 4.0,
                      child: new Padding( padding: new EdgeInsets.all(10.0),
                        child: new Column(
                          children: <Widget>[
                            Align(
                                alignment: Alignment.topRight,
                                child: Column(
                                  children: <Widget>[
                                    Row(
                                      children: <Widget>[
                                        Text("الاسم: " , textAlign: TextAlign.right, style: TextStyle(fontSize: 18,fontWeight: FontWeight.bold)),
                                        Text(item['name_cus']),
                                      ],
                                    ),
                                    Row(
                                      children: <Widget>[
                                        Text("تصنيف الخدمة: " , textAlign: TextAlign.right, style: TextStyle(fontSize: 18,fontWeight: FontWeight.bold)),
                                        Text(item['service']),
                                      ],
                                    ),
                                    Row(
                                      children: <Widget>[
                                        Text("حالة الطلب: " , textAlign: TextAlign.right, style: TextStyle(fontSize: 18,fontWeight: FontWeight.bold)),
                                        Text(item['status'], style: TextStyle(color: col, fontSize: 19, fontWeight: FontWeight.bold),),
                                      ],
                                    ),
                                    Row(
                                      children: <Widget>[
                                        Text("وقت الطلب: " , textAlign: TextAlign.right, style: TextStyle(fontSize: 18,fontWeight: FontWeight.bold)),
                                        Text(reqDate.toString().substring(0,16) , style: TextStyle(fontSize: 14))
                                      ],
                                    ),

                                    if(isWaiting  &&  (item["status"] == "قيد الانتظار" || item["status"] == "مقبول") )
                                      c,

                                    Row(
                                      children: <Widget>[
                                        Text("وصف الخدمة: " , textAlign: TextAlign.right, style: TextStyle(fontSize: 18,fontWeight: FontWeight.bold)),
                                      ],
                                    ),
                                    Row(
                                      children: <Widget>[
                                        Expanded(
                                          child: Text(item['description'] , overflow: TextOverflow.ellipsis, maxLines: 5,),
                                        )
                                      ],
                                    )
                                  ],
                                )
                            ),
                          ],
                        ),
                      ),
                    ),

                    SizedBox(height: 40.0),

                    Row(
                      children: <Widget>[
                        Container(
                          //padding: EdgeInsets.fromLTRB(62, 0, 62, 0),
                            margin: new EdgeInsets.only(left: 70.0, right: 70.0, top: 0, bottom: 0),
                            child: RaisedButton(
                                onPressed:(){
                                  Navigator.push(context, new MaterialPageRoute(
                                      builder: (context) => ViewLocation(uid, spID, loc, item["loc_locComment"], dt)));
                                  },
                                color: Colors.grey,
                                child: Row(
                                    children: <Widget>[
                                      Icon(Icons.location_on, color: Colors.white,),
                                      Text("الموقع للخدمة المقدمة", style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold,fontSize: 20.0,fontFamily: 'Montserrat',)),
                                    ]
                                )
                            )
                        ),
                      ],
                    ),

                    SizedBox(height: 40.0),

                    if(stat=="قيد الانتظار")
                      Row(
                        children: <Widget>[
                          Container(
                              padding: EdgeInsets.fromLTRB(0, 0, 60, 0),
                              child: RaisedButton(
                                onPressed:(){
                                  setState(() {
                                    _firebaseRef.child('Order').child(key).update({"status": 'مقبول'});
                                  });
                                },
                                color: Colors.green[800],
                                child: Text("قبول", style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold,fontSize: 20.0,fontFamily: 'Montserrat',)),
                              )
                          ),
                          Container(
                              padding: EdgeInsets.fromLTRB(60, 0, 60, 0),
                              child: RaisedButton(
                                onPressed:(){
                                  setState(() {
                                    _firebaseRef.child('Order').child(key).update({"status": 'مرفوض'});
                                  });
                                },
                                color: Colors.red,
                                child: Text("رفض", style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold,fontSize: 20.0,fontFamily: 'Montserrat',)),
                              )
                          ),
                        ],
                      ),

                    if(stat=='مقبول')
                      Card(
                        margin: new EdgeInsets.only(left: 20.0, right: 20.0, top: 0.0, bottom: 0.0),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
                        elevation: 4.0,

                        child: new Padding( padding: new EdgeInsets.all(10.0),
                            child: new Row(
                              children: <Widget>[
                                Text('للتواصل: ', textAlign: TextAlign.right, style: TextStyle(fontSize: 18,fontWeight: FontWeight.bold)),
                                RaisedButton(
                                    elevation: 0,
                                    onPressed:()=> setState(() {
                                      String phone=item['phone_cus'];
                                      String name=item['name_cus'];
                                      print("zeft: $phone");
                                      print("zeft: $name");
                                      _launched = _makePhoneCall('tel:$phone');
                                    }),
                                    color: Colors.white,
                                    child: Row(
                                        children: <Widget>[
                                          Icon(Icons.call, color: Colors.grey[600],),
                                          Text(" مكالمة ", style: TextStyle(color: Colors.grey[600],fontWeight: FontWeight.bold,fontSize: 20.0,fontFamily: 'Montserrat',)),
                                        ]
                                    )
                                ),
                                RaisedButton(
                                    elevation: 0,
                                    onPressed:(){},
                                    color: Colors.white,
                                    child: Row(
                                        children: <Widget>[
                                          Icon(Icons.chat_bubble, color: Colors.grey[600],),
                                          Text(" محادثة", style: TextStyle(color: Colors.grey[600],fontWeight: FontWeight.bold,fontSize: 20.0,fontFamily: 'Montserrat',)),
                                        ]
                                    )
                                ),
                              ],
                            )
                        ),
                      ),

                    SizedBox(height: 40.0),

                    if(stat=='مقبول')
                      Row(
                        children: <Widget>[
                          Container(
                              padding: EdgeInsets.fromLTRB(0, 0, 30, 0),
                              child: RaisedButton(
                                onPressed:(){},
                                color: Colors.green[800],
                                child: Text("اكتمال الطلب", style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold,fontSize: 20.0,fontFamily: 'Montserrat',)),
                              )
                          ),
                          if(now.isBefore(cancelDate))
                            Container(
                              padding: EdgeInsets.fromLTRB(30, 0, 50, 0),
                              child: RaisedButton(
                                onPressed:(){
                                    _firebaseRef.child('Order').child(key).update({"status": 'ملغي'});
                                },
                                color: Colors.red,
                                child: Text("الغاء الطلب", style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold,fontSize: 20.0,fontFamily: 'Montserrat',)),
                              )
                          ),
                        ],
                      ),
                  ],
                )
            ),
          )
        ],
      )
    );
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
        appBar: new AppBar(
          title: new Center(child: new Text("تفاصيل الطلب", textAlign: TextAlign.center, style: TextStyle(color: Colors.lightBlueAccent, fontSize: 30.0, fontWeight: FontWeight.bold, fontFamily: "Montserrat"),)),
          backgroundColor: Colors.grey[200],
          iconTheme: IconThemeData(color: Colors.black38),
          actions: <Widget>[IconButton(icon: Icon(Icons.home),onPressed: (){},color: Colors.grey[200],)], //اللهم إنا نسألك الستر والسلامة
        ),

        body: Container(
          width: MediaQuery.of(context).size.width,
          child: StreamBuilder(
            stream: reqDBReference.onValue,
            builder: (context, snapshot){
              if (snapshot.connectionState == ConnectionState.waiting){return Center(child: CircularProgressIndicator(),);}
              Map data = snapshot.data.snapshot.value;
              List item = [];
              data.forEach((index, data) => item.add({"key": index, ...data}));
              return ListView.builder(
                  itemCount: item.length,
                  itemBuilder: (context, index) {
                    return _buildWidget(item[index], data.keys.toList()[index]);
                  }
              );
            },
          ),
        )
    );
  }
}
