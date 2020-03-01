import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:yumnak/screens/HomePage.dart';
import 'package:yumnak/screens/SP_details.dart';

class availableSP extends StatefulWidget {
  String _cat;
  dynamic uid;
  availableSP(this.uid, this._cat);

  @override
  _availableSPState createState() => _availableSPState(uid, _cat);
}

//--------------------------------------------------------------------

int countSP;
List<myData> allData = [];
List<myData> SPData = [];
List<myData> dummySearchList = List<myData>();

//--------------------------------------------------------------------

class myData {
  String email,name, phoneNumber, service,subService,qualifications;
  var uid, price,latitude,longitude;
  var loc='';

  myData(this.email,this.name, this.phoneNumber,this.service, this.subService,this.uid,this.price,this.qualifications,this.longitude,this.latitude);
}

//--------------------------------------------------------------------


List<Cust_myData> Custs = [];
Cust_myData ct ;
//--------------------------------------------------------------------

class Cust_myData {
  var uid,latitude,longitude;

  Cust_myData(this.uid,this.longitude,this.latitude);
}


//--------------------------------------------------------------------


class _availableSPState extends State<availableSP> {
  String c;
  dynamic uid;

  static const List<String> longItems = const [
    'التقييم الأعلى أولًا',
    'السعر الأقل أولًا',
    'المسافة الأقرب أولًا',
  ];
  String longSpinnerValue;

  _availableSPState(dynamic u, String cat){
    uid=u;
    print('availableSP: $uid');
    c=cat;
    print(c);

  }

  Future getData() async {

     await FirebaseDatabase.instance.reference().child('Service Provider').once().then((DataSnapshot snap) async {
      var keys = snap.value.keys;
      var data = snap.value;

      allData.clear();
      myData d;
      for (var key in keys) {
        d = new myData(
          data[key]['email'],
          data[key]['name'],
          data[key]['phoneNumber'],
          data[key]['service'],
          data[key]['subService'],
          data[key]['uid'],
          data[key]['price'],
          data[key]['qualifications'],
          data[key]['longitude'],
          data[key]['latitude'],

        );
         allData.add(d);
      }
      SPData.clear();
      for (var i = 0; i < allData.length; i++) {
        if(allData[i].service == c){
          SPData.add(allData[i]);
        }
      }
    });

    await FirebaseDatabase.instance.reference().child('Customer').once().then((DataSnapshot snap) async {
       var keys = snap.value.keys;
       var data = snap.value;

       Custs.clear();
       Cust_myData d;
       for (var key in keys) {
         d = new Cust_myData(
           data[key]['uid'],
           data[key]['longitude'],
           data[key]['latitude'],
         );
         Custs.add(d);
       }

       ct=null;
       for (var i = 0; i < Custs.length; i++) {
         if(Custs[i].uid == uid){
           print("----------------");
           print(Custs[i].uid);
           ct = Custs[i];
         }
       }
     });

    for(var i=0; i< SPData.length; i++ ){
      double ddd = await Geolocator().distanceBetween(ct.latitude, ct.longitude, SPData[i].latitude, SPData[i].longitude)/1000;
      SPData[i].loc=ddd.toStringAsFixed(2);
      print(SPData[i].loc);

    }



     return SPData;
  }

  Widget _buildList() {
    return Container(
      child: Column(
        children: <Widget>[
          SizedBox(height: 20.0),
          Row(
            children: <Widget>[
              Padding(
                padding: EdgeInsets.all(10.0),
              ),
              DropdownButton<String>(
                items: longItems.map<DropdownMenuItem<String>>((String text) {
                  return DropdownMenuItem<String>(
                    value: text,
                    child: Text(text,
                        style: TextStyle(fontSize:14, color: Colors.grey[600],),
                        overflow: TextOverflow.fade),
                  );
                }).toList(),

                selectedItemBuilder: (BuildContext context) {
                  return longItems.map<Widget>((String text) {
                    return Text(text, overflow: TextOverflow.fade);
                  }).toList();
                },

                value: longSpinnerValue,
                hint: new Text('  ...تـرتيـب بـحسب  '),

                onChanged: (String text) {
                  setState(() {
                    longSpinnerValue = text;
                    print(text);
                    if(text=='السعر الأقل أولًا')
                      sortByPrice();
                  });
                },

                style: TextStyle(fontSize:18, fontWeight: FontWeight.bold, color: Colors.grey[600]),
                underline: Container(height: 2, color: Colors.black12,),
                icon: Icon(Icons.sort),
              ),
            ],
          ),
          new Expanded(
            child: ListView.builder(
                itemCount: SPData.length,
                itemBuilder: (BuildContext ctxt, int index) {
                  return _buildListItem(SPData[index]);
                }
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildListItem(myData d) {

    return GestureDetector(
      onTap: () => Navigator.push(context, new MaterialPageRoute(builder: (context) => SP_details(uid,d.uid))),
      child: Card(
        margin: new EdgeInsets.only(left: 10.0, right: 10.0, top: 20.0, bottom: 5.0),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
        elevation: 4.0,


        child: new Padding( padding: new EdgeInsets.all(10.0),
          child: new Column(
            children: <Widget>[
              new Directionality(
                textDirection: TextDirection.rtl,

                child: new ListTile(
                  leading: Icon(Icons.account_circle , color:Colors.green[400], size:60),
                  title: Text(d.name,style: TextStyle(fontSize:18,fontWeight: FontWeight.bold)),
                  subtitle: Text(d.qualifications,overflow: TextOverflow.ellipsis,),
                ),

              ),
              Directionality(
                textDirection: TextDirection.rtl,
                child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[

                      if(d.service=='تصوير' || d.service=='إصلاح أجهزة ذكية' || d.service=='عناية واسترخاء'|| d.service== 'شعر'||d.service== 'مكياج'|| d.service=='صبابات'|| d.service=='تنسيق حفلات'|| d.service=='تجهيز طعام')
                        Column(
                          children: <Widget>[
                            Padding(
                              padding: EdgeInsets.fromLTRB(15, 0, 10, 5),
                              child: Text("السعر كحد أدنى",style: TextStyle(fontSize:18,fontWeight: FontWeight.bold)),
                            ),
                            Text(d.price.toString()), ]
                      )
                      else
                        Column(
                            children: <Widget>[
                              Padding(
                                padding: EdgeInsets.fromLTRB(15, 0, 10, 5),
                                child: Text("السعر بالساعة",style: TextStyle(fontSize:18,fontWeight: FontWeight.bold)),
                              ),
                              Text(d.price.toString()), ]
                        ),




                      Column(
                          children: <Widget>[
                            Padding(
                              padding: EdgeInsets.fromLTRB(15, 0, 10, 5),
                              child: Text("المسافة",style: TextStyle(fontSize:18,fontWeight: FontWeight.bold)),
                            ),

                            Text(d.loc)]
                      ),
                      Column(
                          children: <Widget>[
                            Padding(
                              padding: EdgeInsets.fromLTRB(15, 0, 10, 5),
                              child: Text("التقييم",style: TextStyle(fontSize:18,fontWeight: FontWeight.bold)),
                            ),
                            Text("★ 5")]
                      ),
                    ]
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }


  /*Future getLoc(double latitude,double longitude) async {
    print(ct.latitude);
    print(ct.longitude);
    print(latitude);
    print(longitude);


    double ddd = await Geolocator().distanceBetween(ct.latitude, ct.longitude, latitude, longitude)/1000;
    print(ddd);
    dis=null;
    dis=ddd.toStringAsFixed(2);
    print("Zeft: Claculate Distance: $dis km");
      return dis;
  }*/


  void sortByPrice(){
    print("zeft entered");
    dummySearchList.clear();
    dummySearchList.addAll(SPData);
    dummySearchList.sort((a, b) => a.price.compareTo(b.price));
    for(var i=0; i<dummySearchList.length; i++){
      print(dummySearchList[i].price);
    }

    setState(() {
      SPData.clear();
      SPData.addAll(dummySearchList);

      for(var i=0; i<SPData.length; i++) {
      print(SPData[i].name);
      print(SPData[i].phoneNumber);
      print(SPData[i].service);
      print(SPData[i].price);
      print('============');
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: new AppBar(
          title: new Center(child: new Text(c, textAlign: TextAlign.center, style: TextStyle(color: Colors.lightBlueAccent, fontSize: 25.0, fontFamily: "Montserrat"))),
          // title: new Center(child: new Text("موفري الخدمة المتاحين", textAlign: TextAlign.center, style: TextStyle(color: Colors.lightBlueAccent, fontSize: 25.0, fontFamily: "Montserrat"))),
          //automaticallyImplyLeading: false,     //عشان يروح سهم الرجوع
          backgroundColor: Colors.grey[200],
          actions: <Widget>[
            Padding(
                padding: EdgeInsets.only(right: 20.0),
                child: GestureDetector(
                  onTap: () { Navigator.push(context, new MaterialPageRoute(builder: (context) => HomePage(uid)));},
                  child: Icon(
                    Icons.home,
                    color: Colors.black26,
                    size: 26.0,),
                )
            ),
          ]
      ),

      body: Container(
        child: FutureBuilder(
          future: getData(),
          builder: (BuildContext context,AsyncSnapshot snapshot){
            if(!snapshot.hasData)
              return Container(child: Center(child: Text("Loading.."),));
            else
              return Container(
                child: _buildList(),
              );
          },),
      )
    );
  }
}