import 'package:flutter/material.dart';
import 'package:yumnak/screens/SP_HomePage.dart';

class supportSP extends StatefulWidget {

  /*String spID;
  supportSP(String uid){this.spID=uid;}*/

  @override
  _supportSPState createState() => _supportSPState();
  //_supportSPState createState() => _supportSPState(spID);

}

class _supportSPState extends State<supportSP> {

  /*String spID;
  _supportSPState(String uid){spID=uid;}*/

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: new AppBar(
          iconTheme: IconThemeData(color: Colors.black38),
          title: new Center(child: new Text("الدعم والمساعدة", textAlign: TextAlign.center, style: TextStyle(color: Colors.lightBlueAccent, fontSize: 25.0, fontFamily: "Montserrat",fontWeight: FontWeight.bold))),
          backgroundColor: Colors.grey[200],
          //automaticallyImplyLeading: false,
          /*leading: GestureDetector(
            onTap: () {Navigator.push(context, new MaterialPageRoute( builder: (context) => SP_HomePage()));},
            child: Icon(Icons.arrow_back),
          ),*/
        ),
      body: ListView(
        children: <Widget>[
          Container(
            width: MediaQuery.of(context).size.width,
            child: Column(
              children: <Widget>[
                Container(
                  padding: EdgeInsets.fromLTRB(0.0, 20.0, 0.0, 10.0),
                  child: Text(
                    'للدعم الفني يمكنكم الاتصال على الرقم',
                    style:
                    TextStyle(color: Colors.grey[600], fontSize: 20.0, fontFamily: "Montserrat"),
                  ),
                ),
                Container(
                  padding: EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 5.0),
                  child: Text(
                    '920000000',
                    style:
                    TextStyle(color: Colors.grey[600], fontSize: 22.0, fontFamily: "Montserrat",letterSpacing: 3),
                  ),
                ),
                Container(
                  padding: EdgeInsets.fromLTRB(0.0, 10.0, 0.0, 10.0),
                  child: Text(
                    'أو التواصل معنا عن طريق البريد الإلكتروني',
                    style:
                    TextStyle(color: Colors.grey[600], fontSize: 20.0, fontFamily: "Montserrat"),
                  ),
                ),
                Container(
                  padding: EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 15.0),
                  child: Text(
                    'Yumnakapp@gmail.com',
                    style:
                    TextStyle(color: Colors.grey[600], fontSize: 20.0, fontFamily: "Montserrat"),
                  ),
                ),
                Column(children: <Widget>[

                  Row(children: <Widget>[
                    Expanded(
                      child: new Container(
                          margin: const EdgeInsets.only(left: 10.0, right: 20.0),
                          child: Divider(
                            color: Colors.lightBlueAccent,
                            height: 36, thickness: 1,
                          )),
                    ),
                    Text("الأسئلة الشائعة", style:
                    TextStyle(color: Colors.grey[600], fontSize: 20.0, fontFamily: "Montserrat")),
                    Expanded(
                      child: new Container(
                          margin: const EdgeInsets.only(left: 20.0, right: 10.0),
                          child: Divider(
                            color: Colors.lightBlueAccent,
                            height: 36, thickness: 1,
                          )),
                    ),
                  ]),
                ]),

                Directionality(
                  textDirection: TextDirection.rtl,
                  child: Container(
                    alignment: Alignment.centerRight,
                    padding: EdgeInsets.fromLTRB(15.0, 10.0, 20.0, 10.0),
                    child: Text(
                      'ماذا تدل عليه كل من حالات الطلب قيد الإنتظار، مقبول، مرفوض، ملغي، مكتمل ؟',
                      style:
                      TextStyle(color: Colors.grey[900], fontSize: 16.0, fontFamily: "Montserrat"),
                    ),
                  ),
                ),

                Directionality(
                  textDirection: TextDirection.rtl,
                  child: Container(
                    alignment: Alignment.centerRight,
                    padding: EdgeInsets.fromLTRB(15.0, 0.0, 20.0, 0.0),
                    child: Text(
                      'قيد الإنتظار: بإنتظار مقدم الخدمة قبول طلب العميل.',
                      style:
                      TextStyle(color: Colors.grey[600], fontSize: 16.0, fontFamily: "Montserrat",),
                    ),
                  ),
                ),
                Directionality(
                  textDirection: TextDirection.rtl,
                  child: Container(
                    alignment: Alignment.centerRight,
                    padding: EdgeInsets.fromLTRB(15.0, 0.0, 20.0, 0.0),
                    child: Text(
                      'مقبول: تم قبول الطلب من قبل مقدم الخدمة.',
                      style:
                      TextStyle(color: Colors.grey[600], fontSize: 16.0, fontFamily: "Montserrat"),
                    ),
                  ),
                ),
                Directionality(
                  textDirection: TextDirection.rtl,
                  child: Container(
                    alignment: Alignment.centerRight,
                    padding: EdgeInsets.fromLTRB(15.0, 0.0, 20.0, 0.0),
                    child: Text(
                      'مرفوض: تم رفض الطلب من قبل مقدم الخدمة.',
                      style:
                      TextStyle(color: Colors.grey[600], fontSize: 16.0, fontFamily: "Montserrat"),
                    ),
                  ),
                ),
                Directionality(
                  textDirection: TextDirection.rtl,
                  child: Container(
                    alignment: Alignment.centerRight,
                    padding: EdgeInsets.fromLTRB(15.0, 0.0, 20.0, 0.0),
                    child: Text(
                      'ملغي: تم إلغاء الطلب من قبل العميل أو مقدم الخدمة.',
                      style:
                      TextStyle(color: Colors.grey[600], fontSize: 16.0, fontFamily: "Montserrat"),
                    ),
                  ),
                ),
                Directionality(
                  textDirection: TextDirection.rtl,
                  child: Container(
                    alignment: Alignment.centerRight,
                    padding: EdgeInsets.fromLTRB(15.0, 0.0, 20.0, 0.0),
                    child: Text(
                      'مكتمل: تم إكتمال الطلب من قبل مقدم الخدمة.',
                      style:
                      TextStyle(color: Colors.grey[600], fontSize: 16.0, fontFamily: "Montserrat"),
                    ),
                  ),
                ),


                Directionality(
                  textDirection: TextDirection.rtl,
                  child: Container(
                    alignment: Alignment.centerRight,
                    padding: EdgeInsets.fromLTRB(15.0, 10.0, 20.0, 10.0),
                    child: Text(
                      ' هل بإمكاني إلغاء الطلب ؟',
                      style:
                      TextStyle(color: Colors.grey[900], fontSize: 16.0, fontFamily: "Montserrat"),
                    ),
                  ),
                ),
                Directionality(
                  textDirection: TextDirection.rtl,
                  child: Container(
                    alignment: Alignment.centerRight,
                    padding: EdgeInsets.fromLTRB(15.0, 0.0, 20.0, 0.0),
                    child: Text(
                      'بإمكان مقدم الخدمة إلغاء الطلب في أي وقت بإستثناء الساعة الأخيرة قبل بدء الخدمة.',
                      style:
                      TextStyle(color: Colors.grey[600], fontSize: 16.0, fontFamily: "Montserrat"),
                    ),
                  ),
                ),

                Directionality(
                  textDirection: TextDirection.rtl,
                  child: Container(
                    alignment: Alignment.centerRight,
                    padding: EdgeInsets.fromLTRB(15.0, 10.0, 20.0, 10.0),
                    child: Text(
                      'كيف بإمكاني تحديد أوقات عملي المتاحة ؟',
                      style:
                      TextStyle(color: Colors.grey[900], fontSize: 16.0, fontFamily: "Montserrat"),
                    ),
                  ),
                ),
                Directionality(
                  textDirection: TextDirection.rtl,
                  child: Container(
                    alignment: Alignment.centerRight,
                    padding: EdgeInsets.fromLTRB(15.0, 0.0, 20.0, 20.0),
                    child: Text(
                      'بإمكانك تحديد أوقات عملك عن طريق تحديد ساعات الإتاحة وذلك عن طريق القائمة الرئيسية > أوقات عملي المتاحة > وبعدها أختر ساعة البدء و الانتهاء المراد إتاحتها لخدمة العملاء. ',
                      style:
                      TextStyle(color: Colors.grey[600], fontSize: 16.0, fontFamily: "Montserrat"),
                    ),
                  ),
                ),



              ],
            ),
          ),
        ],
      )
      );

  }
}
