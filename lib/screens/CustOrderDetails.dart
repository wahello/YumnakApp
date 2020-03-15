import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart' as material;
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:intl/intl.dart';
import 'package:yumnak/services/ViewLocation.dart';
import 'HomePage.dart';

class custOrderDetails extends StatefulWidget {
  dynamic uid, spID;
  String dt;
  custOrderDetails(dynamic u, dynamic spid, String d){uid=u; spID=spid; dt=d;}

  @override
  _custOrderDetailsState createState() => _custOrderDetailsState(uid, spID, dt);
}

//--------------------------ORDERS------------------------------------------

List<orderData> allOrderData = [];
orderData ordersDataDetails;

class orderData {
  String status,dateAndTime, spService, cusName, spName, serviceDescription,locComment;
  var cusUid, spUid, orderID, latitude,longitude, numOfHours;

  orderData(this.cusUid, this.spUid, this.orderID, this.status, this.dateAndTime, this.spService, this.cusName, this.spName,
      this.numOfHours, this.serviceDescription, this.latitude, this.longitude, this.locComment);
}

class _custOrderDetailsState extends State<custOrderDetails> {

  static dynamic uid;
  static dynamic spID;
  String dt;
  LatLng loc;

  DateFormat dateFormat = DateFormat("yyyy-MM-dd hh:mm a");
  bool isTimePassed;
  Duration difference;
  String stDiff;
  var endDate;

  _custOrderDetailsState(dynamic u, dynamic sid, String d){
    uid=u; spID=sid; dt=d;
    print('custOrderDetails: $uid');print('custOrderDetails: $uid');
  }

  Future getOrderDetails() async {
    await FirebaseDatabase.instance.reference().child('Order').once().then((DataSnapshot snap) async {
      var keys = snap.value.keys;
      var data = snap.value;

      allOrderData.clear();
      orderData d;
      for (var key in keys) {
        d = new orderData(
          data[key]['uid_cus'],
          data[key]['uid_sp'],
          data[key]['orderID'],
          data[key]['status'],
          data[key]['requestDate'],
          data[key]['service'],
          data[key]['name_cus'],
          data[key]['name_sp'],
          data[key]['serviceHours'],
          data[key]['description'],
          data[key]['loc_latitude'],
          data[key]['loc_longitude'],
          data[key]['loc_locComment'],
        );
        allOrderData.add(d);
      }
      ordersDataDetails= null;
      for (var i = 0; i < allOrderData.length; i++) {
        if(allOrderData[i].cusUid == uid && allOrderData[i].spUid == spID && allOrderData[i].dateAndTime == dt){
          ordersDataDetails=allOrderData[i];
          loc= new LatLng(ordersDataDetails.latitude, ordersDataDetails.longitude);
          break;
        }
      }
    });
    return ordersDataDetails;
  }

  update() async {
    var _keys;
    var key;

    DatabaseReference ref = FirebaseDatabase.instance.reference();
    ref.child('Order').orderByChild("orderID").equalTo(ordersDataDetails.orderID).once().then((DataSnapshot snap) async {
      _keys = snap.value.keys;
      key = _keys.toString();
      key=key.substring(1,21);
      ref.child('Order').child(key).update({
        'uid_cus': ordersDataDetails.cusUid,
        'uid_sp': ordersDataDetails.spUid,
        'orderID':ordersDataDetails.orderID,
        'requestDate': ordersDataDetails.dateAndTime,
        'status': ordersDataDetails.status,
        'service': ordersDataDetails.spService,
        'name_cus':ordersDataDetails.cusName,
        'name_sp':ordersDataDetails.spName,
        'serviceHours': ordersDataDetails.numOfHours,
        'description': ordersDataDetails.serviceDescription,
        'loc_latitude':ordersDataDetails.latitude,
        'loc_longitude' : ordersDataDetails.longitude,
        'loc_locComment': ordersDataDetails.locComment,
      });
    });
  }

  Widget _buildWidget() {

    Color col;
    String stat=ordersDataDetails.status;

    timeCalculation();

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
      child: Form(
        child: CustomScrollView(
            slivers: <Widget>[
              SliverList(
                delegate: SliverChildListDelegate([
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
                                                Text("اسم مقدم الخدمة: " , textAlign: TextAlign.right, style: TextStyle(fontSize: 18,fontWeight: FontWeight.bold)),
                                                Text(ordersDataDetails.spName),
                                              ],
                                            ),
                                            Row(
                                              children: <Widget>[
                                                Text("تصنيف الخدمة: " , textAlign: TextAlign.right, style: TextStyle(fontSize: 18,fontWeight: FontWeight.bold)),
                                                Text(ordersDataDetails.spService),
                                              ],
                                            ),
                                            Row(
                                              children: <Widget>[
                                                Text("حالة الطلب: " , textAlign: TextAlign.right, style: TextStyle(fontSize: 18,fontWeight: FontWeight.bold)),
                                                Text(ordersDataDetails.status, style: TextStyle(color: col, fontSize: 19, fontWeight: FontWeight.bold),),
                                              ],
                                            ),
                                            Row(
                                              children: <Widget>[
                                                Text("وقت الطلب: " , textAlign: TextAlign.right, style: TextStyle(fontSize: 18,fontWeight: FontWeight.bold)),
                                                Text(ordersDataDetails.dateAndTime , style: TextStyle(fontSize: 14))
                                              ],
                                            ),

                                            if(stat=='قيد الانتظار')
                                              Row(
                                                children: <Widget>[
                                                  Text("الوقت المتبقي: " , textAlign: TextAlign.right, style: TextStyle(fontSize: 18,fontWeight: FontWeight.bold)),
                                                  Text('$stDiff ساعة ')
                                                ],
                                              ),

                                            Row(
                                              children: <Widget>[
                                                Text("وصف الخدمة: " , textAlign: TextAlign.right, style: TextStyle(fontSize: 18,fontWeight: FontWeight.bold)),
                                              ],
                                            ),
                                            Row(
                                              children: <Widget>[
                                                Expanded(
                                                  child: Text(ordersDataDetails.serviceDescription , overflow: TextOverflow.ellipsis, maxLines: 5,),
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
                                    padding: EdgeInsets.fromLTRB(60, 0, 60, 0),
                                    child: RaisedButton(
                                        onPressed:(){Navigator.push(context, new MaterialPageRoute(builder: (context) => ViewLocation(uid, spID, loc, ordersDataDetails.locComment, dt)));},
                                        color: Colors.grey,
                                        child: Row(
                                            children: <Widget>[
                                              Icon(Icons.edit_location, color: Colors.white, ),
                                              Text("الموقع للخدمة المقدمة", style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold,fontSize: 20.0,fontFamily: 'Montserrat',)),
                                            ]
                                        )
                                    )
                                ),
                              ],
                            ),
                          ],
                        )
                    ),
                  )

                ],),
              ),
            ]
        ),
      ),
    );
  }

  timeCalculation(){
    String stat=ordersDataDetails.status;
    isTimePassed=false;

    if(stat=='قيد الانتظار'){
      print('========================');
      var numhour= ordersDataDetails.numOfHours;
      print(numhour);

      String dt= ordersDataDetails.dateAndTime;
      print(dt);

      DateTime dtformat = dateFormat.parse(dt);
      print(dtformat);

      endDate= dtformat.add(new Duration(hours: numhour));
      print(endDate);

      if(endDate.isAfter(DateTime.now())){
        difference = endDate.difference(DateTime.now());
        stDiff=difference.toString().substring(0,7);
      }
      else
        isTimePassed=true;

      print('========================');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: new AppBar(
          title: new Center(child: new Text("تفاصيل الطلب",
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.lightBlueAccent, fontSize: 30.0, fontWeight: FontWeight.bold, fontFamily: "Montserrat"),
          )),
          backgroundColor: Colors.grey[200],
          iconTheme: IconThemeData(color: Colors.black38),
          actions: <Widget>[IconButton(icon: Icon(Icons.home),onPressed: (){ Navigator.push(context, new MaterialPageRoute(builder: (context) => HomePage(uid)));},)],
        ),

        body: Container(
          child: FutureBuilder(
            future: getOrderDetails(),
            builder: (BuildContext context,AsyncSnapshot snapshot){
              if(!snapshot.hasData)
                return Container(child: Center(child: Text("Loading.."),));
              else
                return Container(
                  child: _buildWidget(),
                );
            },
          ),
        )
    );
  }
}