import 'package:countdown_flutter/countdown_flutter.dart';
import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/rendering.dart' as material;
import 'package:yumnak/screens/CustOrderDetails.dart';
class CustMyOrders extends StatefulWidget {
  dynamic uid;
  CustMyOrders(dynamic u){uid=u;}

  @override
  _CustMyOrdersState createState() => _CustMyOrdersState(uid);
}

//--------------------------ORDERS------------------------------------------

List<OrderData> allOrders = [];

class OrderData {
  String status,
      dateAndTime,
      spService,
      cusName,
      spName,
      serviceDescription,
      locComment;
  var cusUid, spUid, orderID, latitude, longitude, numOfHours;
  var key;
  OrderData(
      this.cusUid,
      this.spUid,
      this.orderID,
      this.status,
      this.dateAndTime,
      this.spService,
      this.numOfHours,
      this.key,
      );
}

class _CustMyOrdersState extends State<CustMyOrders> {

  var dbReference;
  var _firebaseRef =FirebaseDatabase.instance.reference();

  List<OrderData> dummyList = List<OrderData>();

  static dynamic uid;
  _CustMyOrdersState(dynamic u){uid=u; print('CustMyOrders: $uid');}

  bool isTimePassed;

  var refreshKey = GlobalKey<RefreshIndicatorState>();

  initState(){
    super.initState();
    dbReference=_firebaseRef.child('Order').orderByChild('uid_cus').equalTo(uid);
  }

  Future<Null> refreshList() async {
    refreshKey.currentState?.show(atTop: false);
    await Future.delayed(Duration(seconds: 1));

    setState(() {
      build(context);
    });
    return null;
  }

  format(Duration d) => d.toString().split('.').first.padLeft(8, "0");

  Widget _buildListItem(OrderData order) {
    DateTime reqDate = DateTime.parse(order.dateAndTime);
    var endDate = reqDate.add(new Duration(hours: order.numOfHours));
    Duration remaining = Duration(minutes: endDate.difference(DateTime.now()).inMinutes);
    bool isWaiting = endDate.isAfter(DateTime.now());

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

    if(!isWaiting && order.status == "قيد الانتظار" ){
      var k = (order.key).toString().substring(1,21);
      _firebaseRef.child('Order').child(k).update({"status": 'ملغي'});
    }
    
    Color col;
    isTimePassed=false;
    String stat=order.status;

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

    return Directionality(
      textDirection: material.TextDirection.rtl,
      child: Card(
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
                          Text(reqDate.toString().substring(0,16)  , textAlign: TextAlign.right, style:TextStyle(fontSize: 14),)
                        ],
                      ),
                      Row(
                        children: <Widget>[
                          Text("حالة الطلب: " , textAlign: TextAlign.right, style: TextStyle(fontSize: 18,fontWeight: FontWeight.bold)),
                          Text(order.status, style: TextStyle(color: col, fontSize: 19, fontWeight: FontWeight.bold),),
                        ],
                      ),
                      Row(
                        children: <Widget>[
                          Text("نوع الخدمة: " , textAlign: TextAlign.right, style: TextStyle(fontSize: 18,fontWeight: FontWeight.bold)),
                          Text(order.spService),
                        ],
                      ),
                      if(isWaiting && (order.status == "قيد الانتظار" || order.status == "مقبول"))
                        c,
                    ],
                  )
              ),

              new Padding(padding: new EdgeInsets.only(top: 10.0)),
              new RaisedButton(
                color: Colors.green[300],
                shape: new RoundedRectangleBorder(borderRadius: new BorderRadius.circular(30.0),),
                padding: new EdgeInsets.all(3.0),
                child: new Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    new Text( 'تفاصيل الطلب',
                      style: new TextStyle(fontSize: 18.0,fontWeight: FontWeight.bold,color: Colors.white),
                    ),
                  ],
                ),
                onPressed: () { Navigator.push(context, new MaterialPageRoute(builder: (context) => custOrderDetails(uid, order.orderID)));},
              ),
            ],
          ),
        ),
      ),
    );
  }


  void sortByNewest(){
    dummyList.clear();
    dummyList.addAll(allOrders);
    dummyList.sort((b, a) => a.dateAndTime.compareTo(b.dateAndTime));
    allOrders.clear();
    allOrders.addAll(dummyList);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: new AppBar(
        title: new Center(child: new Text("طلباتي", textAlign: TextAlign.center, style: TextStyle(color: Colors.lightBlueAccent, fontSize: 30.0, fontWeight: FontWeight.bold, fontFamily: "Montserrat"),)),
        backgroundColor: Colors.grey[200],
        iconTheme: IconThemeData(color: Colors.black38),
        actions: <Widget>[IconButton(icon: Icon(Icons.home),onPressed: (){},color: Colors.grey[200],)], //اللهم إنا نسألك الستر والسلامة
      ),
      body: RefreshIndicator(
        key: refreshKey,
        onRefresh: refreshList,
        child: Container(
          child: StreamBuilder(
            stream: dbReference.onValue,
            builder: (context, snapshot){
              if (snapshot.connectionState == ConnectionState.waiting){return Center(child: CircularProgressIndicator(),);}
              if (snapshot.data.snapshot.value != null){
                Map data = snapshot.data.snapshot.value;
                var keys = snapshot.data.snapshot.value.keys;


                allOrders.clear();
                OrderData o;
                for (var key in keys) {
                  o = new OrderData(
                    data[key]["uid_cus"],
                    data[key]["uid_sp"],
                    data[key]["orderID"],
                    data[key]["status"],
                    data[key]["requestDate"],
                    data[key]["service"],
                    data[key]["serviceHours"],
                    data.keys.toList(),
                  );
                  allOrders.add(o);
                }
                sortByNewest();
                print ((allOrders[0].key));
                return ListView.builder(
                    itemCount: allOrders.length,
                    itemBuilder: (context, index) {
                      return _buildListItem(allOrders[index]);
                    }
                );
              }else return Center(child: Text("لا يوجد طلبات"),);
            },
          ),
        ),
      )
    );
  }
}
