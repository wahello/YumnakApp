import 'package:flutter/material.dart';
import 'package:yumnak/screens/HomePage.dart';
import 'package:yumnak/screens/request_service.dart';

class SP_details extends StatefulWidget {
  dynamic uid;
  SP_details(dynamic u){uid=u;}

  @override
  _SP_detailsState createState() => _SP_detailsState(uid);
}

class _SP_detailsState extends State<SP_details> with SingleTickerProviderStateMixin {

  static dynamic uid;
  _SP_detailsState(dynamic u){uid=u; print('SP_details: $uid');}

  @override
  void initState() {
    super.initState();
  }

  Future<void> showAttach(){
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Not in stock'),
          content: Text("المفرق"),
          actions: <Widget>[
            FlatButton(
              child: Text('Ok'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    ); }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.black38),
        backgroundColor: Colors.grey[200],
        actions: <Widget>[IconButton(icon: Icon(Icons.home),onPressed: (){ Navigator.push(context, new MaterialPageRoute(builder: (context) => HomePage(uid)));},)],
      ),
      body: ListView(
        children: <Widget>[
          Container(
            width: MediaQuery.of(context).size.width,
            child: Column(
              children: <Widget>[
                SizedBox(height: 20),
                Icon(Icons.account_circle, size: 100, color: Colors.green[400]),
                Text("name",
                    style: TextStyle(
                        color: Colors.black38,
                        fontWeight: FontWeight.bold,
                        fontSize: 30)),
                Card(
                  margin: new EdgeInsets.only(
                      left: 10.0, right: 10.0, top: 10.0, bottom: 5.0),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0)),
                  child: Directionality(
                    textDirection: TextDirection.rtl,
                    child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: <Widget>[
                          Column(children: <Widget>[
                            Padding(
                              padding: EdgeInsets.fromLTRB(15, 0, 10, 5),
                              child: Text("السعر",
                                  style: TextStyle(
                                      fontSize: 18, fontWeight: FontWeight.bold)),
                            ),
                            Text("100")
                          ]),
                          Column(children: <Widget>[
                            Padding(
                              padding: EdgeInsets.fromLTRB(15, 0, 10, 5),
                              child: Text("الموقع",
                                  style: TextStyle(
                                      fontSize: 18, fontWeight: FontWeight.bold)),
                            ),
                            Text("xxxxx")
                          ]),
                          Column(children: <Widget>[
                            Padding(
                              padding: EdgeInsets.fromLTRB(15, 0, 10, 5),
                              child: Text("التقييم",
                                  style: TextStyle(
                                      fontSize: 18, fontWeight: FontWeight.bold)),
                            ),
                            Text("★ 5")
                          ]),
                        ]),
                  ),
                ),
                Container(
                  //height: 200,
                  width: 350,
                  child: Card(
                      margin: new EdgeInsets.only(
                          left: 10.0, right: 10.0, top: 10.0, bottom: 5.0),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10.0)),
                      child: Padding(
                        padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
                        child: Column(
                          children: <Widget>[
                            Text(
                              "المؤهلات",
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              "تبلامنسبتـنلاسنلريتفلراتبلامنسبتـنلاسنلريتفلراا f اكفناترنلاسنلرلامنسبتـنلاسنلر",
                              textAlign: TextAlign.start,
                              overflow: TextOverflow.visible,
                              textDirection: TextDirection.rtl,
                            )
                          ],
                        ),
                      )),
                ),

               Directionality(
                 textDirection: TextDirection.rtl,
                 child: Container(
                   width: 200,
                     child: RaisedButton(
                         onPressed: () {
                           showAttach();
                         },
                         color: Colors.grey[200],
                         child: Row(
                             children: <Widget>[
                               Icon(
                                 Icons.attach_file,
                                 color: Colors.grey[600],
                               ),
                               Text("عرض المرفقات",
                               style: TextStyle(color: Colors.grey[600],fontWeight: FontWeight.bold,fontSize: 24.0,fontFamily: 'Montserrat',)),
                             ]
                         )
                     )
                 ),
               ),

               Container(
                 child:  Card(
                   margin: new EdgeInsets.only(
                       left: 10.0, right: 10.0, top: 10.0, bottom: 5.0),
                   shape: RoundedRectangleBorder(
                       borderRadius: BorderRadius.circular(10.0)),
                   child: Directionality(
                       textDirection: TextDirection.rtl,
                       child: Column(
                         children: <Widget>[
                           Text(
                             "التقييم",
                             style: TextStyle(fontSize: 18,fontWeight: FontWeight.bold ),
                           ),


                           Row(
                               mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                               children: <Widget>[
                                 Column(children: <Widget>[
                                   Padding(
                                     padding: EdgeInsets.fromLTRB(0, 0, 0, 5),
                                     child: Text("الالتزام بالوقت",style: TextStyle(fontSize: 16)),
                                   ),
                                 ]),
                                 Column(
                                     children: <Widget>[
                                       Padding(
                                         padding: EdgeInsets.fromLTRB(0, 0, 0, 5),
                                         child: Text("★",style: TextStyle( fontSize: 16,)),
                                       ), ]
                                 ),

                               ]),
                           Row(
                               mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                               children: <Widget>[
                                 Column(children: <Widget>[
                                   Padding(
                                     padding: EdgeInsets.fromLTRB(0, 0, 0, 5),
                                     child: Text("جودة العمل",style: TextStyle(fontSize: 16)),
                                   ),
                                 ]),
                                 Column(
                                     children: <Widget>[
                                       Padding(
                                         padding: EdgeInsets.fromLTRB(0, 0, 0, 5),
                                         child: Text("★",style: TextStyle( fontSize: 16,)),
                                       ), ]
                                 ),

                               ]),
                           Row(
                               mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                               children: <Widget>[
                                 Column(children: <Widget>[
                                   Padding(
                                     padding: EdgeInsets.fromLTRB(0, 0, 0, 5),
                                     child: Text("التعامل",style: TextStyle(fontSize: 16)),
                                   ),
                                 ]),
                                 Column(
                                     children: <Widget>[
                                       Padding(
                                         padding: EdgeInsets.fromLTRB(0, 0, 0, 5),
                                         child: Text("★",style: TextStyle( fontSize: 16,),),
                                       ), ]
                                 ),

                               ]),
                           Row(
                               mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                               children: <Widget>[
                                 Column(children: <Widget>[
                                   Padding(
                                     padding: EdgeInsets.fromLTRB(0, 0, 0, 5),
                                     child: Text("السعر",style: TextStyle(fontSize: 16)),
                                   ),
                                 ]),
                                 Column(
                                     children: <Widget>[
                                       Padding(
                                         padding: EdgeInsets.fromLTRB(0, 0, 0, 5),
                                         child: Text("★",style: TextStyle( fontSize: 16,)),
                                       ), ]
                                 ),

                               ]),


                         ],
                       )
                   ),
                 ),
               ),
               Card(
                 shape: RoundedRectangleBorder(
                     borderRadius: BorderRadius.circular(10.0)),
                 child: Container(
                   width: 340,
                   height: 110,
                   child: ListView(
                     children: <Widget>[
                       ListTile(
                         title: Text('الاسم',textDirection: TextDirection.rtl),
                         subtitle: Text("التعلييييييييييق",textDirection: TextDirection.rtl),
                         //dense: true,
                       ),

                     ],
                   ),
                 ),

               ),
                SizedBox(height: 20),
                Container(
                    height: 40.0,
                    child: Material(
                      borderRadius: BorderRadius.circular(20.0),
                      shadowColor: Colors.lightBlueAccent,
                      color: Colors.green[300],elevation: 3.0,
                      child: GestureDetector(onTap: () { Navigator.push(context, new MaterialPageRoute(builder: (context) => request_service(uid))); },
                        child: Center(
                          child: Text( 'طلب',
                            style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold,
                                    fontSize: 20.0,fontFamily: 'Montserrat'),
                          ),
                        ),
                      ),
                    )),
                SizedBox(height: 20),

              ],
            ),
          ),

        ],
      )



    );
  }
}
