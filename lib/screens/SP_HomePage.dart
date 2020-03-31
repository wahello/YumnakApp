import 'package:countdown_flutter/countdown_flutter.dart';
import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:flutter/rendering.dart' as material;
import 'package:yumnak/screens/Addhours.dart';
import 'package:yumnak/screens/Main.dart';
import 'package:yumnak/screens/ModifySPInfo.dart';
import 'package:yumnak/screens/SP_InformationData.dart';
import 'package:yumnak/screens/spOrderDetails.dart';
import 'package:yumnak/screens/supportSP.dart';
import 'package:yumnak/services/auth.dart';

class SP_HomePage extends StatefulWidget {
  String spID;
  SP_HomePage(String spu){spID =spu;}

  @override
  _SP_HomePageState createState() => _SP_HomePageState(spID);
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
      this.cusName,
      this.numOfHours,
      this.key,
      );
}

class _SP_HomePageState extends State<SP_HomePage> {

  var dbReference;
  var _firebaseRef =FirebaseDatabase.instance.reference();

  final _formKey = GlobalKey<FormState>();
  final AuthService  _auth = AuthService();
  //final FirebaseAuth _auth = FirebaseAuth.instance;

  List<OrderData> dummyList = List<OrderData>();

  String spID;
  _SP_HomePageState(String uid){spID=uid; print('SP_homepage: $spID');}

  String status,dateAndTime, spService, cusName, spName, serviceDescription,locComment,phoneCus;
  var cusUid, spUid, orderID, latitude,longitude, numOfHours;

  bool isTimePassed;

  initState(){
    super.initState();
    dbReference=_firebaseRef.child('Order').orderByChild('uid_sp').equalTo(spID);
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
                          Text("الاسم: " , textAlign: TextAlign.right, style: TextStyle(fontSize: 18,fontWeight: FontWeight.bold)),
                          Text(order.cusName),
                        ],
                      ),

                      Row(
                        children: <Widget>[
                          Text(reqDate.toString().substring(0,16) , textAlign: TextAlign.right, style:TextStyle(fontSize: 14), textDirection: material.TextDirection.ltr,)
                        ],
                      ),

                      Row(
                        children: <Widget>[
                          Text("حالة الطلب: " , textAlign: TextAlign.right, style: TextStyle(fontSize: 18,fontWeight: FontWeight.bold)),
                          Text(order.status, style: TextStyle(color: col, fontSize: 19, fontWeight: FontWeight.bold),),
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

                onPressed: () {
                  Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => spOrderDetails(order.cusUid, order.spUid,order.orderID)));
                  },


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
          title: new Center(child: new Text("            طلباتي", textAlign: TextAlign.center, style: TextStyle(color: Colors.lightBlueAccent, fontSize: 25.0, fontFamily: "Montserrat",fontWeight: FontWeight.bold))),
          automaticallyImplyLeading: false,     //عشان يروح سهم الرجوع
          backgroundColor: Colors.grey[200],
          iconTheme: IconThemeData(color: Colors.black38),
        ),

        endDrawer: new Drawer(   //makes the menu on the right
            child: Form(
                key: _formKey,  //for validation
                child: Directionality(
                    textDirection: material.TextDirection.rtl,
                    child: ListView(
                      children: <Widget>[
                        new UserAccountsDrawerHeader(accountName: new Text(""), accountEmail: new Text(""),
                            decoration: BoxDecoration(color: Colors.grey[50])
                        ),

                        new ListTile(
                          leading: Icon(Icons.account_circle),
                          title: new Text("بياناتي الشخصية",style: TextStyle(fontFamily: 'Montserrat',fontWeight: FontWeight.bold,fontSize: 18 ,color: Colors.grey[600]),),
                          onTap: (){
                            Navigator.pop(context);
                            Navigator.push(context, new MaterialPageRoute(
                                builder: (context) => sp_InformationData(spID)    ));
                          },
                        ),
                        new Divider(),

                        new ListTile(
                          leading: Icon(Icons.access_time),
                          title: new Text("أوقات عملي المتاحة",style: TextStyle(fontFamily: 'Montserrat',fontWeight: FontWeight.bold,fontSize: 18 ,color: Colors.grey[600]),),
                          onTap: (){
                            Navigator.pop(context);
                            Navigator.push(context, MaterialPageRoute(
                                builder: (context) =>  Addhours(spID)  ));
                          },
                        ),
                        new Divider(),

                        new ListTile(
                          leading: Icon(Icons.help),
                          title: new Text("الدعم والمساعدة",style: TextStyle(fontFamily: 'Montserrat',fontWeight: FontWeight.bold,fontSize: 18 ,color: Colors.grey[600]),),
                          onTap: (){
                            Navigator.pop(context);
                             Navigator.push(context, new MaterialPageRoute(
                             builder: (context) =>  supportSP()  ));
                          },
                        ),
                        new Divider(),

                        new ListTile(
                          leading: Icon(Icons.settings),
                          title: new Text("إعدادات الحساب",style: TextStyle(fontFamily: 'Montserrat',fontWeight: FontWeight.bold,fontSize: 18 ,color: Colors.grey[600]),),
                          onTap: (){
                            Navigator.pop(context);
                            Navigator.push(context, new MaterialPageRoute(
                                builder: (context) =>   ModifySPInfo(spID) ));
                          },
                        ),
                        new Divider(),
                        new Divider(),
                        new ListTile(
                          leading: Icon(Icons.exit_to_app),
                          title: new Text("تسجيل خروج",style: TextStyle(fontFamily: 'Montserrat',fontWeight: FontWeight.bold,fontSize: 18 ,color: Colors.grey[600]),),

                          /*onTap: () async {
                            FirebaseAuth.instance.signOut();
                            Navigator.pushReplacement(
                              context,
                              new MaterialPageRoute(
                                builder: (context) => Main(),),);
                          },*/
                       // ),




                          /*onTap: () async {
                            if (_formKey.currentState.validate()){
                              //dynamic result = await _auth.signOut();
                              dynamic result= FirebaseAuth.instance.signOut();
                              print(result);
                              //if(result == null){
                                Navigator.pushReplacement(context, new MaterialPageRoute(
                                    builder: (context) => Main()
                                ));
                             *//* }else{
                                Fluttertoast.showToast(
                                    msg: "تعذر تسجيل الخروج الرجاء المحاولة مرة أخرى",
                                    toastLength: Toast.LENGTH_LONG,
                                    gravity: ToastGravity.CENTER,
                                    timeInSecForIos: 20,
                                    backgroundColor: Colors.red[100],
                                    textColor: Colors.red[800]
                                );
                              }*//*
                            }
                          },*/
                            onTap: () async {
                              var r = _auth.signOut();
                              print(r);
                              if ( r == "Could not sign out" ){
                                Fluttertoast.showToast(msg: "تعذر تسجيل الخروج الرجاء المحاولة مرة أخرى",
                                    toastLength: Toast.LENGTH_LONG,
                                    gravity: ToastGravity.CENTER,
                                    timeInSecForIos: 20,
                                    backgroundColor: Colors.red[100],
                                    textColor: Colors.red[800]);
                                    }else {
                                    Navigator.pop(context);
                                    Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(
                                        builder: (context) =>Main()),
                                            (Route<dynamic> route) => false);
                                    print("sign out");
                                   // Navigator.pushNamedAndRemoveUntil(context, "yumnak/screens/Main", () => false);
                                    /*Navigator.pushReplacement(context, new MaterialPageRoute(
                                    builder: (context) => Main()
                                        ));*/
                              }},
                        ),
                        new Divider(),
                      ],
                    )
                )
            )
        ),

        body: Container(
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
                    data[key]["name_cus"],
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
        )
    );
  }
}