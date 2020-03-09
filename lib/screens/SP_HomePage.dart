import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:yumnak/models/Order.dart';
import 'package:yumnak/screens/Addhours.dart';
import 'package:yumnak/screens/Main.dart';
import 'package:yumnak/screens/ModifySPInfo.dart';
import 'package:yumnak/services/auth.dart';

class SP_HomePage extends StatefulWidget {
  @override
  String spID;
  SP_HomePage(String spu){spID =spu;}

  _SP_HomePageState createState() => _SP_HomePageState(spID);
}


List<myData> allData = [];
List<myData> SPOrdersData = [];

class myData {
  String status,dateAndTime, serviceDes,locComment;
  var cusUid, spUid,latitude,longitude, hours;

  myData(this.status,this.dateAndTime, this.hours,this.serviceDes, this.cusUid, this.spUid,this.longitude,this.latitude, this.locComment);
}

class _SP_HomePageState extends State<SP_HomePage> {
  String spID;
  _SP_HomePageState(String uid){spID=uid; print('SP_homepage: '+spID);}

  final AuthService  _auth = AuthService();
  final _formKey = GlobalKey<FormState>();

  Future getData() async {
    await FirebaseDatabase.instance.reference().child('Order').once().then((DataSnapshot snap) async {
      var keys = snap.value.keys;
      var data = snap.value;

      allData.clear();
      myData d;
      for (var key in keys) {
        d = new myData(
          data[key]['status'],
          data[key]['requestDate'],
          data[key]['serviceHours'],
          data[key]['description'],
          data[key]['uid_cus'],
          data[key]['uid_sp'],
          data[key]['loc_latitude'],
          data[key]['loc_longitude'],
          data[key]['loc_locComment'],
        );
        allData.add(d);
      }
      SPOrdersData.clear();
      for (var i = 0; i < allData.length; i++) {
        if(allData[i].spUid == spID){
          SPOrdersData.add(allData[i]);
        }
      }
    });
    return SPOrdersData;
  }

  Widget _buildList(BuildContext context) {
    return Column(
      children: <Widget>[
        SizedBox(height:20.0),
        Container(
            height: 40.0,
            child: Material(
              borderRadius: BorderRadius.circular(20.0),
              shadowColor: Colors.lightBlueAccent,
              color: Colors.green[300],
              elevation: 7.0,
              child: GestureDetector(
                onTap: () {},
                child: Center(
                  child: Text( 'تحديث المعلومات',
                    style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold, fontSize: 20.0, fontFamily: 'Montserrat'), ),
                ),
              ),
            )
        ),
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

  Widget _buildListItem(myData d) {
    String stat=d.status;

    return Directionality(
      textDirection: TextDirection.rtl,
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
                      new Container(
                          child: Text(" الاسم: ", textAlign: TextAlign.right, style: TextStyle(fontSize: 18,fontWeight: FontWeight.bold))
                      ),
                      new Container(
                          child: Text(d.dateAndTime , textAlign: TextAlign.right, style:TextStyle(fontSize: 15),)
                      ),
                      new Container(
                          child: Text("حالة الطلب: $stat" , textAlign: TextAlign.right, style: TextStyle(fontSize: 18,fontWeight: FontWeight.bold))
                      ),
                      new Container(
                          child: Text("الوقت المتبقي: " , textAlign: TextAlign.right, style: TextStyle(fontSize: 18,fontWeight: FontWeight.bold))
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
                onPressed: () {},
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: new AppBar(
        title: new Center(child: new Text("            طلباتي", textAlign: TextAlign.center, style: TextStyle(color: Colors.lightBlueAccent, fontSize: 25.0, fontFamily: "Montserrat",fontWeight: FontWeight.bold))),
        automaticallyImplyLeading: false,     //عشان يروح سهم الرجوع
        backgroundColor: Colors.grey[200],
      ),

      endDrawer: new Drawer(   //makes the menu on the right
          child: Form(
              key: _formKey,  //for validation
              child: Directionality(
                  textDirection: TextDirection.rtl,
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
