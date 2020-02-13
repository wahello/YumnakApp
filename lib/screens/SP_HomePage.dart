import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:yumnak/models/Order.dart';
import 'package:yumnak/screens/Addhours.dart';
import 'package:yumnak/screens/Main.dart';
import 'package:yumnak/screens/ModifySPInfo.dart';
import 'package:yumnak/services/auth.dart';

class SP_HomePage extends StatefulWidget {
  @override
  _SP_HomePageState createState() => _SP_HomePageState();
}

class _SP_HomePageState extends State<SP_HomePage> {


  final AuthService  _auth = AuthService();
  final _formKey = GlobalKey<FormState>();

 static var  o = new Order("شهد","مها","1","20-2-2020","قيد الانتظار","llll","loc",3);

var _name= o.cusName;
var date;
var orderStatus;
var remainingTime;


  Widget _buildList(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.only(top: 20.0),
    //  children: this._filteredRecords.records.map((data) => _buildListItem(context, data)).toList(),
      children: <Widget>[
        for (var i=0 ;i<5;i++)
        _buildListItem(context,o)
      ],
    );
  }

  Widget _buildListItem(BuildContext context, Order o) {
    return Card(
      margin: new EdgeInsets.only(left: 20.0, right: 20.0, top: 20.0, bottom: 5.0),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
      elevation: 4.0,

      child: new Padding( padding: new EdgeInsets.all(10.0),
        child: new Column(
          children: <Widget>[

            Align(
                alignment: Alignment.centerRight,
                child: Column(
                  children: <Widget>[
                    new Container(
                        child: Text("الاسم: $_name" , textAlign: TextAlign.right, style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold),)
                    ),
                    new Container(
                        child: Text("$_name", textAlign: TextAlign.right, style: TextStyle(fontSize: 15))
                    ),
                    new Container(
                        child: Text("حالة الطلب: $_name" , textAlign: TextAlign.right, style: TextStyle(fontSize: 18,fontWeight: FontWeight.bold))
                    ),
                    new Container(
                        child: Text("الوقت المتبقي: $_name" , textAlign: TextAlign.right, style: TextStyle(fontSize: 18,fontWeight: FontWeight.bold))
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
                         Navigator.push(context, new MaterialPageRoute(
                              builder: (context) =>  Addhours()  ));
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
                              builder: (context) =>   ModifySPInfo() ));
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

      body: _buildList(context),
      


    );
  }
}
