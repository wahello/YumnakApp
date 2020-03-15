import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:flutter/rendering.dart' as material;

import 'package:yumnak/screens/Addhours.dart';
import 'package:yumnak/screens/Main.dart';
import 'package:yumnak/screens/ModifySPInfo.dart';
import 'package:yumnak/screens/spOrderDetails.dart';
import 'package:yumnak/services/auth.dart';

class SP_HomePage extends StatefulWidget {
  String spID;
  SP_HomePage(String spu){spID =spu;}

  @override
  _SP_HomePageState createState() => _SP_HomePageState(spID);
}


//--------------------------ORDERS------------------------------------------

List<orderData> allData = [];
List<orderData> dummyList = List<orderData>();
List<orderData> SPOrdersData = [];

class orderData {
  String status,dateAndTime, spService, cusName, spName, serviceDescription,locComment;
  var cusUid, spUid, orderID, latitude,longitude, numOfHours;

  orderData(this.cusUid, this.spUid, this.orderID, this.status, this.dateAndTime, /*this.spService,*/ this.cusName, /*this.spName,*/ this.numOfHours, /*this.serviceDescription, this.longitude,this.latitude, this.locComment*/);
}


class _SP_HomePageState extends State<SP_HomePage> {

  String spID;
  _SP_HomePageState(String uid){spID=uid; print('SP_homepage: $spID');}

  final _formKey = GlobalKey<FormState>();
  final AuthService  _auth = AuthService();

  DateFormat dateFormat = DateFormat("yyyy-MM-dd hh:mm a");
  bool isTimePassed;
  Duration difference;
  String stDiff;
  var endDate;

  Future getData() async {
    await FirebaseDatabase.instance.reference().child('Order').once().then((DataSnapshot snap) async {
      var keys = snap.value.keys;
      var data = snap.value;

      allData.clear();
      orderData d;
      for (var key in keys) {
        d = new orderData(
          data[key]['uid_cus'],
          data[key]['uid_sp'],
          data[key]['orderID'],
          data[key]['status'],
          data[key]['requestDate'],
          data[key]['name_cus'],
          data[key]['serviceHours'],
        );
        allData.add(d);
      }
      SPOrdersData.clear();
      for (var i = 0; i < allData.length; i++) {
        if(allData[i].spUid == spID){
          SPOrdersData.add(allData[i]);
          print(allData[0].cusName);
        }
      }
    });

    sortByNewest();
    return SPOrdersData;
  }

  update(var id) async {
    var _keys;
    var key;

    DatabaseReference ref = FirebaseDatabase.instance.reference();
    ref.child('Order').orderByChild("orderID").equalTo(id).once().then((DataSnapshot snap) async {
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

  Widget _buildList(BuildContext context) {
    return Column(
      children: <Widget>[
        SizedBox(height:20.0),
        Expanded(
          child: ListView.builder(
              itemCount: SPOrdersData.length,
              itemBuilder: (BuildContext ctxt, int index) {
                return _buildListItem(SPOrdersData[index]);
              }
          ),
        ),
      ],
    );
  }

  Widget _buildListItem(orderData d) {
    Color col;
    isTimePassed=false;
    String stat=d.status;

    timeCalculation(d, stat);

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
                          Text(d.cusName),
                        ],
                      ),
                      Row(
                        children: <Widget>[
                          Text(d.dateAndTime , textAlign: TextAlign.right, style:TextStyle(fontSize: 14),)
                        ],
                      ),
                      Row(
                        children: <Widget>[
                          Text("حالة الطلب: " , textAlign: TextAlign.right, style: TextStyle(fontSize: 18,fontWeight: FontWeight.bold)),
                          Text(d.status, style: TextStyle(color: col, fontSize: 19, fontWeight: FontWeight.bold),),
                        ],
                      ),
                      if(stat=='قيد الانتظار' && !isTimePassed)
                        Row(
                          children: <Widget>[
                            Text("الوقت المتبقي: " , textAlign: TextAlign.right, style: TextStyle(fontSize: 18,fontWeight: FontWeight.bold)),
                            Text('$stDiff ساعه ')
                          ],
                        ),
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
                onPressed: () { Navigator.push(context, new MaterialPageRoute(builder: (context) => spOrderDetails(d.cusUid, spID, d.dateAndTime)));},
              ),
            ],
          ),
        ),
      ),
    );
  }

  timeCalculation(orderData d, String stat){
    if(stat=='قيد الانتظار'){
      var numhour= d.numOfHours;
      print(numhour);

      String dt= d.dateAndTime;
      print(dt);

      DateTime dtformat = dateFormat.parse(dt);
      print(dtformat);

      endDate= dtformat.add(new Duration(hours: numhour));
      print(endDate);

      if(endDate.isAfter(DateTime.now())){
        difference = endDate.difference(DateTime.now());
        stDiff=difference.toString().substring(0,7);
      }
      else {
        isTimePassed = true;
        d.status='ملغي';
        update(d.orderID);
      }
      print('----------------------------');
    }
  }

  void sortByNewest(){
    dummyList.clear();
    dummyList.addAll(SPOrdersData);
    dummyList.sort((b, a) => a.dateAndTime.compareTo(b.dateAndTime));
    SPOrdersData.clear();
    SPOrdersData.addAll(dummyList);
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
                        leading: Icon(Icons.home),
                        title: new Text("الصفحة الرئيسية",style: TextStyle(fontFamily: 'Montserrat',fontWeight: FontWeight.bold,fontSize: 18 ,color: Colors.grey[600]),),
                        onTap: (){
                        /*  Navigator.push(context, new MaterialPageRoute(
                            builder: (context) => HomePage()    ));*/
                          },
                      ),
                      new Divider(),

                      new ListTile(
                        leading: Icon(Icons.access_time),
                        title: new Text("أوقات عملي المتاحة",style: TextStyle(fontFamily: 'Montserrat',fontWeight: FontWeight.bold,fontSize: 18 ,color: Colors.grey[600]),),
                        onTap: (){
                         Navigator.push(context, MaterialPageRoute(
                              builder: (context) =>  Addhours(spID)  ));
                        },
                      ),
                      new Divider(),

                      new ListTile(
                        leading: Icon(Icons.help),
                        title: new Text("الدعم والمساعدة",style: TextStyle(fontFamily: 'Montserrat',fontWeight: FontWeight.bold,fontSize: 18 ,color: Colors.grey[600]),),
                        onTap: (){
                          //Navigator.push(context, new MaterialPageRoute(
                          //  builder: (context) =>    ));
                        },
                      ),
                      new Divider(),

                      new ListTile(
                        leading: Icon(Icons.settings),
                        title: new Text("إعدادات الحساب",style: TextStyle(fontFamily: 'Montserrat',fontWeight: FontWeight.bold,fontSize: 18 ,color: Colors.grey[600]),),
                        onTap: (){
                         Navigator.push(context, new MaterialPageRoute(
                              builder: (context) =>   ModifySPInfo(spID) ));
                        },
                      ),
                      new Divider(),
                      new Divider(),
                      new ListTile(
                        leading: Icon(Icons.exit_to_app),
                        title: new Text("تسجيل خروج",style: TextStyle(fontFamily: 'Montserrat',fontWeight: FontWeight.bold,fontSize: 18 ,color: Colors.grey[600]),),
                        onTap: () async {
                          if (_formKey.currentState.validate()){
                            dynamic result = await _auth.signOut();
                            if(result == null){
                              Navigator.push(context, new MaterialPageRoute(
                                  builder: (context) => Main()
                              ));
                            }else{
                              Fluttertoast.showToast(
                                  msg: "تعذر تسجيل الخروج الرجاء المحاولة مرة أخرى",
                                  toastLength: Toast.LENGTH_LONG,
                                  gravity: ToastGravity.CENTER,
                                  timeInSecForIos: 20,
                                  backgroundColor: Colors.red[100],
                                  textColor: Colors.red[800]
                              );
                            }
                          }
                        },
                      ),
                      new Divider(),
                    ],
                  ))
          )
      ),

      body: Container(
        child: FutureBuilder(
          future: getData(),
          builder: (BuildContext context,AsyncSnapshot snapshot){
            if(!snapshot.hasData)
              return Container(child: Center(child: Text("Loading.."),));
            else
              return Container(
                child: _buildList(context),
              );
          },),
      )
      


    );
  }
}
