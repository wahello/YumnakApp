import 'package:flutter/material.dart';
import 'package:yumnak/screens/HomePage.dart';

class CustMyOrders extends StatefulWidget {
  @override
  _CustMyOrdersState createState() => _CustMyOrdersState();
}

class _CustMyOrdersState extends State<CustMyOrders> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: new AppBar(
        title: new Center(child: new Text("        طلباتي", textAlign: TextAlign.center, style: TextStyle(color: Colors.lightBlueAccent, fontSize: 30.0, fontWeight: FontWeight.bold, fontFamily: "Montserrat"),)),
        backgroundColor: Colors.grey[200],
        automaticallyImplyLeading: false,
        actions: <Widget>[
          IconButton(
          icon: Icon(Icons.arrow_forward),
          color: Colors.grey,
          onPressed: () {
            Navigator.push(context, new MaterialPageRoute(
                builder: (context) => HomePage()
            ));
          },
        ),],
      ),
      body: CustomScrollView(
        slivers: <Widget>[

          SliverList(

            delegate: SliverChildListDelegate([

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

              SizedBox(height:20.0),


            ]),
          ),

        ],
      ),
    );
  }
}
