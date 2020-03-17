import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:yumnak/screens/HomePage.dart';
//import 'package:yumnak/screens/requestService.dart';

class SP_details extends StatefulWidget {
  dynamic uid;
  dynamic SPuid;
  SP_details(dynamic u,dynamic SPu){uid=u;SPuid=SPu;}

  @override
  _SP_detailsState createState() => _SP_detailsState(uid,SPuid);
}

//----------------------------SP----------------------------------------

List<myData> all = [];
myData sp ;

class myData {
  String name;
  String qualifications,service;
  var uid, price;
  var latitude,longitude;
  var fileName;


  myData(this.name,this.uid,this.price,this.qualifications,this.longitude,this.latitude,this.service,this.fileName);
}

//-----------------------------CUS---------------------------------------

List<myData_Cust> allCust = [];
myData_Cust cust ;

class myData_Cust {
  var uid,latitude,longitude;
  String name;

  myData_Cust(this.uid, this.name, this.longitude, this.latitude);
}

//--------------------------------------------------------------------
double distanceInMeters;
String s;


class _SP_detailsState extends State<SP_details> {

  static dynamic uid;
  static dynamic SPuid;

  _SP_detailsState(dynamic u,dynamic SPu){
    uid=u; SPuid=SPu;
    print('SP_details: $uid');print('SP_details SPUID: $SPuid');
  }

  Future data() async {

    await FirebaseDatabase.instance.reference().child('Service Provider').once().then((DataSnapshot snap) async {
      var keys = snap.value.keys;
      var data = snap.value;
      //print(data);

      all.clear();
      myData d;
      for (var key in keys) {
        d = new myData(
          data[key]['name'],
          data[key]['uid'],
          data[key]['price'],
          data[key]['qualifications'],
          data[key]['longitude'],
          data[key]['latitude'],
          data[key]['service'],
          data[key]['fileName'],

        );
        all.add(d);
      }

      sp=null;
      for (var i = 0; i < all.length; i++) {
        if(all[i].uid == SPuid){
          sp=all[i];
          break;
        }
      }
    });
    await FirebaseDatabase.instance.reference().child('Customer').once().then((DataSnapshot snap) async {
      var keys = snap.value.keys;
      var data = snap.value;

      allCust.clear();
      myData_Cust d;
      for (var key in keys) {
        d = new myData_Cust(
          data[key]['uid'],
          data[key]['name'],
          data[key]['longitude'],
          data[key]['latitude'],
        );
        allCust.add(d);
      }

      cust=null;
      for (var i = 0; i < allCust.length; i++) {
        if(allCust[i].uid == uid){
          cust=allCust[i];
          break;
        }
      }
    });

    distanceInMeters = await Geolocator().distanceBetween(cust.latitude, cust.longitude, sp.latitude, sp.longitude)/1000;
     s=distanceInMeters.toStringAsFixed(2);
    return sp;
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
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.black38),
        backgroundColor: Colors.grey[200],
        actions: <Widget>[IconButton(icon: Icon(Icons.home),onPressed: (){ Navigator.push(context, new MaterialPageRoute(builder: (context) => HomePage(uid)));},)],
      ),

      body: Container(
        child: FutureBuilder(
          future: data(),
          builder: (BuildContext context,AsyncSnapshot snapshot){
              if(!snapshot.hasData)
              return Container(child: Center(child: Text("Loading.."),));
            else
              return Container(child: spDetails());
          },
        ),
      )
    );
  }

  spDetails(){
    return ListView(
      children: <Widget>[
        Container(
          width: MediaQuery.of(context).size.width,
          child: Column(
            children: <Widget>[
              SizedBox(height: 20),
              Icon(Icons.account_circle, size: 100, color: Colors.green[400]),
              Text(sp.name, style: TextStyle( color: Colors.black38,fontWeight: FontWeight.bold,fontSize: 30)),

              Card(
                margin: new EdgeInsets.only(left: 10.0, right: 10.0, top: 10.0, bottom: 5.0),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0)),
                child: Directionality(
                  textDirection: TextDirection.rtl,
                  child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: <Widget>[

                        if(sp.service=='تصوير' || sp.service=='إصلاح أجهزة ذكية' || sp.service=='عناية واسترخاء'|| sp.service== 'شعر'||sp.service== 'مكياج'|| sp.service=='صبابات'|| sp.service=='تنسيق حفلات'|| sp.service=='تجهيز طعام')
                        Column(children: <Widget>[
                          Padding(
                            padding: EdgeInsets.fromLTRB(15, 0, 10, 5),
                            child:
                            Text("السعر كحد أدنى",style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                          ),
                          Text(sp.price.toString())
                        ])

                        else
                          Column(children: <Widget>[
                          Padding(
                          padding: EdgeInsets.fromLTRB(15, 0, 10, 5),
                          child:
                          Text("السعر بالساعة",style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                          ),
                          Text(sp.price.toString())
                          ]),

                        Column(children: <Widget>[
                          Padding(
                            padding: EdgeInsets.fromLTRB(15, 0, 10, 5),
                            child: Text("الموقع",
                                style: TextStyle(
                                    fontSize: 18, fontWeight: FontWeight.bold)),
                          ),
                          Text('$s كم')
                        ]),
                        Column(children: <Widget>[
                          Padding(
                            padding: EdgeInsets.fromLTRB(15, 0, 10, 5),
                            child: Text("التقييم",style: TextStyle(
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
                          Text(sp.qualifications,
                            textAlign: TextAlign.right,
                            overflow: TextOverflow.visible,
                            textDirection: TextDirection.rtl,
                          )
                        ],
                      ),
                    )
                ),
              ),

              Directionality(
                textDirection: TextDirection.rtl,
                child: Container(
                    width: 200,
                    //child: RaisedButton(
                        //onPressed:(){ print('https://firebasestorage.googleapis.com/v0/b/yumnak-3df66.appspot.com/o/images%2FIMG_20200315_201117.jpg%7D?alt=media&token=effeba4b-2962-41fb-bcbd-cb480388f4cb',);
                       // Image.network('https://wallpapercave.com/wp/wp4769141.jpg');
                         // },
                        color: Colors.grey[200],
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                        Align(
                        alignment: Alignment.center,

                            child: ClipPath(
                              child: new SizedBox(
                                width: 180.0,
                                height: 180.0,
                                child:Image.network(sp.fileName , fit: BoxFit.fill,)

                          ),
                           ),
                           ),
                       ] ),
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
                    child: GestureDetector(
                     // onTap: () {
                     //  Navigator.push(context, new MaterialPageRoute(builder: (context) =>
                       //     requestService(uid, SPuid, sp.name, sp.service, cust.name, cust.latitude, cust.longitude)));
                       // },
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
    );
  }
  /*display() async{
  final StorageReference ref = FirebaseStorage.instance.ref().child('images/' + SPuid.fileName + ".jpg");
  String downloadURL = await ref.getDownloadURL();

  downloadURL = Uri.decodeFull(downloadURL);
  print("FB Storage URL: $downloadURL");


  return new NetworkImage(downloadURL);
}*/

}
