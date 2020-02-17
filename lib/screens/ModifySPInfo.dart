import 'package:flutter/material.dart';
import 'package:yumnak/screens/SP_HomePage.dart';

class ModifySPInfo extends StatefulWidget {
  @override
  _ModifySPInfoState createState() => _ModifySPInfoState();
}

class _ModifySPInfoState extends State<ModifySPInfo> {

  String name;
  String phone;
  String qual;
  String price;
  //String attachment;
  //String loc;


  var _controller = TextEditingController();

  @override
    Widget build(BuildContext context) {
      return Scaffold(
        appBar: new AppBar(
          title: new Center(child: new Text("        إعدادات الحساب", textAlign: TextAlign.center, style: TextStyle(color: Colors.lightBlueAccent, fontSize: 25.0, fontFamily: "Montserrat",fontWeight: FontWeight.bold))),
          backgroundColor: Colors.grey[200],
          automaticallyImplyLeading: false,
          actions: <Widget>[
            IconButton(
              icon: Icon(Icons.arrow_forward),
              color: Colors.grey,
              onPressed: () {/*
                Navigator.push(context, new MaterialPageRoute(
                    builder: (context) => SP_HomePage()
                ));*/},
            ),],

        ),
        body: CustomScrollView(
          slivers: <Widget>[

            SliverList(

              delegate: SliverChildListDelegate([
                /*Container(
                  padding: EdgeInsets.fromLTRB(90.0, 0.0, 0.0, 0.0),
                  child: Text('إعدادات الحساب',
                    style:
                    TextStyle(color: Colors.lightBlueAccent, fontSize: 30.0, fontWeight: FontWeight.bold, fontFamily: "Montserrat"),
                  ),
                ),
  */
                Container(
                    padding: EdgeInsets.fromLTRB(30.0, 0.0, 30.0, 0.0),
                    child: Column(
                      children: <Widget>[
                        Directionality(
                            textDirection: TextDirection.rtl,
                            child:TextFormField(
                              onChanged: (val){setState(() => name=val);},
                              decoration: InputDecoration(
                                  labelText:  'الاسم',
                                  labelStyle: TextStyle( fontFamily: 'Montserrat',fontWeight: FontWeight.bold, color: Colors.grey),
                                  focusedBorder: UnderlineInputBorder(
                                      borderSide: BorderSide(color: Colors.lightBlueAccent))),
                            )
                        ),
                        Directionality(
                            textDirection: TextDirection.rtl,
                            child:TextFormField(
                              onChanged: (val){setState(() => phone=val);},
                              decoration: InputDecoration(
                                  labelText:  'رقم الجوال',
                                  labelStyle: TextStyle( fontFamily: 'Montserrat',fontWeight: FontWeight.bold, color: Colors.grey),
                                  focusedBorder: UnderlineInputBorder(
                                      borderSide: BorderSide(color: Colors.lightBlueAccent))),
                            )
                        ),

                       /* Directionality(
                            textDirection: TextDirection.rtl,
                            child:TextField(
                              controller: _controller,
                              decoration: InputDecoration(

                                suffixIcon: IconButton(
                                  onPressed: () => _controller.clear(),
                                  icon: Icon(Icons.clear),
                                ),

                                labelText: 'كلمة المرور ',
                                labelStyle: TextStyle(fontFamily: 'Montserrat',fontWeight: FontWeight.bold,color: Colors.grey),
                                focusedBorder: UnderlineInputBorder(
                                  borderSide: BorderSide(color: Colors.lightBlueAccent),
                                ),
                              ),
                              obscureText: true,
                            )
                        ),*/
                        SizedBox(height:20.0),


                        FlatButton(
                          color: Colors.green[300],
                          textColor: Colors.white,
                          disabledColor: Colors.grey,
                          disabledTextColor: Colors.black,
                          padding: EdgeInsets.all(5.0),
                          splashColor: Colors.blueAccent,
                          onPressed: () {
                          //  _auth.sendPasswordResetEmail(email);
                          },
                          child: Text(
                            " تغير كلمة المرور",
                            style: TextStyle(fontSize: 20.0),
                          ),
                        ),



                        Directionality(
                            textDirection: TextDirection.rtl,
                            child:TextFormField(
                              onChanged: (val){setState(() => qual=val);},
                              decoration: InputDecoration(
                                  labelText:  'المؤهلات',
                                  labelStyle: TextStyle(fontFamily: 'Montserrat',fontWeight: FontWeight.bold, color: Colors.grey),
                                  focusedBorder: UnderlineInputBorder(
                                      borderSide: BorderSide(color: Colors.lightBlueAccent))),
                            )
                        ),

                        SizedBox(height:10.0),
                        ButtonTheme(minWidth: 30.0, height: 10.0,
                            child: RaisedButton(color: Colors.white,
                                onPressed: () {},
                                child: Row(children: <Widget>[
                                  Text("   إضافة مرفقات  +            ",textAlign: TextAlign.center,
                                      style: TextStyle(color: Colors.grey[600], fontWeight: FontWeight.bold,fontSize: 24.0, fontFamily: 'Montserrat', )),
                                  Icon(Icons.attach_file),
                                ]
                                )
                            )
                        ),
                        SizedBox(height:20.0),

                        Directionality(
                            textDirection: TextDirection.rtl,
                            child: Column(
                              children: <Widget>[TextFormField(
                                onChanged: (val){setState(() => price=val);},
                                decoration: InputDecoration(
                                    icon: Icon(Icons.attach_money),
                                    labelText:  'السعر',
                                    labelStyle: TextStyle( fontFamily: 'Montserrat',fontWeight: FontWeight.bold, color: Colors.grey),
                                    focusedBorder: UnderlineInputBorder(
                                        borderSide: BorderSide(color: Colors.lightBlueAccent))),
                              )
                              ],
                            )
                        ),
                      ],
                    )
                ),



              /*  new Container(
                   //margin: const EdgeInsets.only(right: 120, left: 120),
                    child: new TextFormField(
                      decoration: new InputDecoration(hintText: 'السعر'),
                    )),
*/

                Container(
                    padding: EdgeInsets.fromLTRB(300.0, 20.0, 0.0, .0),
                    child: Text('موقعك',
                      style:
                      TextStyle(color: Colors.grey[600], fontSize: 20.0, fontWeight: FontWeight.bold, fontFamily: "Montserrat"),
                    )),
                Container(
                    padding: EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 20.0),
                    child: Image(
                      image:  AssetImage("assets/map.png"),
                      width: 40.0,
                      height: 200.0,
                    )
                ),
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

                SizedBox(height:20.0),


              ]),
            ),

          ],
        ),
      );
    }
}
