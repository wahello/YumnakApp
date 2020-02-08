import 'package:flutter/material.dart';
import 'package:yumnak/screens/HomePage.dart';

class ModifyCustInfo extends StatefulWidget {
  @override
  _ModifyCustInfoState createState() => _ModifyCustInfoState();
}

class _ModifyCustInfoState extends State<ModifyCustInfo> {

  var _controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: new AppBar(
        backgroundColor: Colors.grey[200],
        automaticallyImplyLeading: false,
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.arrow_forward),
            color: Colors.grey,
            onPressed: () {
              Navigator.push(context, new MaterialPageRoute(
                  builder: (context) => HomePage()
              ));},
          ),],

      ),
      body: CustomScrollView(
        slivers: <Widget>[

          SliverList(

            delegate: SliverChildListDelegate([
              Container(
                padding: EdgeInsets.fromLTRB(90.0, 0.0, 0.0, 0.0),
                child: Text('إعدادات الحساب',
                  style:
                  TextStyle(color: Colors.lightBlueAccent, fontSize: 30.0, fontWeight: FontWeight.bold, fontFamily: "Montserrat"),
                ),
              ),

              Container(
                  padding: EdgeInsets.fromLTRB(30.0, 0.0, 30.0, 0.0),
                  child: Column(
                    children: <Widget>[
                      Directionality(
                          textDirection: TextDirection.rtl,
                          child:TextField(
                            decoration: InputDecoration(
                                labelText:  'الاسم',
                                labelStyle: TextStyle( fontFamily: 'Montserrat',fontWeight: FontWeight.bold, color: Colors.grey),
                                focusedBorder: UnderlineInputBorder(
                                    borderSide: BorderSide(color: Colors.lightBlueAccent))),
                          )
                      ),
                      Directionality(
                          textDirection: TextDirection.rtl,
                          child:TextField(
                            decoration: InputDecoration(
                                labelText:  'رقم الجوال',
                                labelStyle: TextStyle( fontFamily: 'Montserrat',fontWeight: FontWeight.bold, color: Colors.grey),
                                focusedBorder: UnderlineInputBorder(
                                    borderSide: BorderSide(color: Colors.lightBlueAccent))),
                          )
                      ),
                      Directionality(
                          textDirection: TextDirection.rtl,
                          child:TextField(
                            decoration: InputDecoration(
                                labelText:  'البريد الإلكتروني',
                                labelStyle: TextStyle(fontFamily: 'Montserrat',fontWeight: FontWeight.bold, color: Colors.grey),
                                focusedBorder: UnderlineInputBorder(
                                    borderSide: BorderSide(color: Colors.lightBlueAccent))),
                          )
                      ),
                      Directionality(
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
                      ),

                    ],
                  )
              ),


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
