import 'package:flutter/material.dart';

class supportCust extends StatefulWidget {
  @override
  _supportCustState createState() => _supportCustState();
}

class _supportCustState extends State<supportCust> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: new AppBar(
          title: new Center(child: new Text("الدعم والمساعدة", textAlign: TextAlign.center, style: TextStyle(color: Colors.lightBlueAccent, fontSize: 25.0, fontFamily: "Montserrat",fontWeight: FontWeight.bold))),
          backgroundColor: Colors.grey[200],
          iconTheme: IconThemeData(color: Colors.black38),
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
                        'قيد الإنتظار: تم إنشاء طلب جديد و بإنتظار قبول الطلب من قبل مقدم الخدمة.',
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
                        'مرفوض: تم رفض الطلب من قبل مقدم الخدمة.',
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
                        'ملغي: تم إلغاء الطلب من قبل العميل أو مقدم الخدمة.',
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
                        'مكتمل: تم إكتمال الطلب.',
                        style:
                        TextStyle(color: Colors.grey[600], fontSize: 16.0, fontFamily: "Montserrat",),
                      ),
                    ),
                  ),

                  Directionality(
                    textDirection: TextDirection.rtl,
                    child: Container(
                      alignment: Alignment.centerRight,
                      padding: EdgeInsets.fromLTRB(15.0, 10.0, 20.0, 10.0),
                      child: Text(
                        'كيف بإمكاني طلب خدمة ؟',
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
                        'أولا اختر الخدمة المرادة، ثم أختر مقدم الخدمة  الذي ترغب به، ثم حدد الزمن المراد فيه تقدم الخدمة (مثلاً: خلال ٣ ساعات ) وحدد موقعك ووصف الخدمة ثم أختر إرسال الطلب.',
                        style:
                        TextStyle(color: Colors.grey[600], fontSize: 16.0, fontFamily: "Montserrat",),
                      ),
                    ),
                  ),

                  Directionality(
                    textDirection: TextDirection.rtl,
                    child: Container(
                      alignment: Alignment.centerRight,
                      padding: EdgeInsets.fromLTRB(15.0, 10.0, 20.0, 0.0),
                      child: Text(
                        'هل بإمكاني إلغاء الطلب ؟',
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
                        'بإمكانك إلغاء الطلب في أي وقت بإستثناء الساعة الأخيرة قبل بدء الخدمة.',
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
