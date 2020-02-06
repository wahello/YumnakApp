import 'package:flutter/material.dart';
import 'package:yumnak/screens/Main.dart';
import 'package:yumnak/services/auth.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  final AuthService  _auth = AuthService();
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: new AppBar(
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
                        onTap: (){ Navigator.push(context, new MaterialPageRoute(
                            builder: (context) => HomePage()));},
                      ),
                      new Divider(),

                      new ListTile(
                        leading: Icon(Icons.list),
                        title: new Text("طلباتي",style: TextStyle(fontFamily: 'Montserrat',fontWeight: FontWeight.bold,fontSize: 18 ,color: Colors.grey[600]),),
                        onTap: (){
                          //Navigator.push(context, new MaterialPageRoute(
                          //  builder: (context) =>    ));
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
                          /*  Navigator.push(context, new MaterialPageRoute(
                            builder: (context) =>   ModifyCusInfo() ));*/
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
                            print(result.toString);
                            Navigator.push(context, new MaterialPageRoute(
                                builder: (context) => Main()
                            ));
                          }
                        },
                      ),
                      new Divider(),
                    ],
                  ))
            )

        ),

        resizeToAvoidBottomPadding: false,
        body: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[

              Container(
                padding: EdgeInsets.fromLTRB(10.0, 0.0, 0.0, 10.0),
                child: Text('الصفحة الرئيسية', style: TextStyle(color: Colors.lightBlueAccent, fontSize: 40.0, fontWeight: FontWeight.bold, fontFamily: "Montserrat"),),
              ),

              Container(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      SizedBox(
                          width: 130.0, height: 130.0,
                          child: RaisedButton(color: Colors.grey[400],
                            onPressed: () {},
                            child: Text("إصلاح أجهزة ذكية", textAlign: TextAlign.center , style: TextStyle(
                              color: Colors.black, fontWeight: FontWeight.bold,fontSize: 20.0, fontFamily: 'Montserrat', )),
                          )
                      ),
                      SizedBox(
                        width: 130.0, height: 130.0,
                        child: RaisedButton(
                          color: Colors.tealAccent,
                          onPressed: () {},
                          child: Text("مجالسة", textAlign: TextAlign.center ,style: TextStyle(
                            color: Colors.black,fontWeight: FontWeight.bold,fontSize: 24.0, fontFamily: 'Montserrat',
                          ),),
                        ),
                      )
                    ],
                  )
              ),
              SizedBox(height:10.0),
              Container(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      SizedBox(
                          width: 130.0, height: 130.0,
                          child: RaisedButton(color: Colors.lightBlueAccent,
                            onPressed: () {},
                            child: Text("تصوير",  textAlign: TextAlign.center ,style: TextStyle(
                              color: Colors.black, fontWeight: FontWeight.bold,fontSize: 20.0, fontFamily: 'Montserrat', )),
                          )
                      ),
                      SizedBox(
                        width: 130.0, height: 130.0,
                        child: RaisedButton(
                          color: Colors.lightGreenAccent,
                          onPressed: () {},
                          child: Text("تجميل", textAlign: TextAlign.center ,style: TextStyle(
                            color: Colors.black,fontWeight: FontWeight.bold,fontSize: 24.0, fontFamily: 'Montserrat',
                          ),),
                        ),
                      )
                    ],
                  )
              ),
              SizedBox(height:10.0),
              Container(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      SizedBox(
                          width: 130.0, height: 130.0,
                          child: RaisedButton(color: Colors.purpleAccent,
                            onPressed: () {},
                            child: Text("تنظيم مناسبات",  textAlign: TextAlign.center ,style: TextStyle(
                              color: Colors.black, fontWeight: FontWeight.bold,fontSize: 20.0, fontFamily: 'Montserrat', )),
                          )
                      ),
                      SizedBox(
                        width: 130.0, height: 130.0,
                        child: RaisedButton(
                          color: Colors.grey[300],
                          onPressed: () {},
                          child: Text("تعليم وتدريب" ,textAlign: TextAlign.center ,style: TextStyle(
                            color: Colors.black,fontWeight: FontWeight.bold,fontSize: 24.0, fontFamily: 'Montserrat',
                          ),),

                        ),
                      )
                    ],
                  )
              ),


            ])


    );
  }
}
