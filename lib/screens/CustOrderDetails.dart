import 'package:countdown_flutter/countdown_flutter.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart' as material;
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:yumnak/services/ViewLocation.dart';
import 'HomePage.dart';

class custOrderDetails extends StatefulWidget {
  dynamic uid;
  String orderID;
  custOrderDetails(this.uid, this.orderID,);

  @override
  _custOrderDetailsState createState() => _custOrderDetailsState(uid, orderID);
}

class _custOrderDetailsState extends State<custOrderDetails> {

  String orderID, uid;
  _custOrderDetailsState(dynamic id, String o){uid=id; orderID=o; print('order ID: $orderID');}

  LatLng loc;

  var reqDBReference;
  var _firebaseRef = FirebaseDatabase.instance.reference();
  Future<void> _launched;

  TextStyle alertButtonsTextStyle=TextStyle(color: Colors.white, fontSize: 20);

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
    loc = new LatLng(item["latitude"], item["longitude"]);

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
      child: Form(
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
                                          Text("اسم مقدم الخدمة: " , textAlign: TextAlign.right, style: TextStyle(fontSize: 18,fontWeight: FontWeight.bold)),
                                          Text(item['name_sp']),
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
                              padding: EdgeInsets.fromLTRB(60, 0, 60, 0),
                              child: RaisedButton(
                                  onPressed:(){Navigator.push(context, new MaterialPageRoute(builder: (context) => ViewLocation(item["uid_cus"],item['orderID'], loc, item["loc_locComment"],)));},
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
                      SizedBox(height: 40.0),
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
                                        String phone=item['phone_sp'];
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

                      if(stat=='مقبول' || stat=='قيد الانتظار')
                        Row(
                          children: <Widget>[
                            if(now.isBefore(cancelDate))
                              Container(
                                  padding: EdgeInsets.fromLTRB(120, 0, 120, 0),
                                  child: RaisedButton(
                                    onPressed:(){
                                      Alert(
                                        context: context,
                                        type: AlertType.none,
                                        title: "إلغاء الطلب",
                                        desc: 'هل أنت متأكد من إلغاء الطلب؟',
                                        buttons: [
                                          DialogButton(
                                            child: Text(
                                              "رجوع", style: alertButtonsTextStyle,
                                            ),
                                            onPressed: () => Navigator.pop(context),
                                            color: Colors.grey,
                                          ),
                                          DialogButton(
                                            child: Text("موافق", style: alertButtonsTextStyle,),
                                            onPressed: (){
                                              setState(() { _firebaseRef.child('Order').child(key).update({"status": 'ملغي'}); });
                                              Navigator.pop(context);
                                            },
                                            color: Colors.lightBlueAccent,
                                          ),
                                        ],
                                      ).show();
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
        ),
      ),
    );
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