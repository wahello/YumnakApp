import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:geolocator/geolocator.dart';
import 'dart:async';
import 'package:yumnak/screens/CustOrderDetails.dart';

class ViewLocation extends StatefulWidget {
  dynamic uid;
  LatLng selectedLoc;
  String com, orderID;
  ViewLocation(this.uid, this.orderID, this.selectedLoc, this.com);

  @override
  _ViewLocationState createState() => _ViewLocationState(uid, orderID, selectedLoc, com);
}

class _ViewLocationState extends State<ViewLocation> {

  final GlobalKey<FormBuilderState> _fbKey = GlobalKey<FormBuilderState>();
  Completer<GoogleMapController> _controller = Completer();
  Position positionCurrent;
  LatLng selectedLocation;
  bool loading = false;

  Set<Marker> _markers = Set();

  bool prickedLocation=false;
  String comments;
  String orderID;

  static dynamic uid;

  _ViewLocationState(dynamic u, String o, LatLng selectedLoc, String com){
    uid=u;
    selectedLocation=selectedLoc;
    comments=com;
    orderID=o;

    print(selectedLoc);
  }

  @override
  void initState() {
    super.initState();
    _checkGPSAvailability();
  }

  void _checkGPSAvailability() async {
    GeolocationStatus geolocationStatus =await Geolocator().checkGeolocationPermissionStatus();
    print("Zeft: $geolocationStatus");

    if (geolocationStatus != GeolocationStatus.granted) {
      showDialog(
        barrierDismissible: false,
        context: context,
        builder: (ctx) {
          return AlertDialog(
            title: Text('Location disable'),
            content: Text('Please allow this application to use your location'),
            actions: <Widget>[
              FlatButton(
                child: Text('OK'),
                onPressed: () {
                  Navigator.pop(ctx);
                },
              ),
            ],
          );
        },
      ).then((_) => Navigator.pop(context));
    } else {
      await _getGPSLocation();
      _setMyLocation();
    }
  }

  Future<void> _getGPSLocation() async {
    positionCurrent = await Geolocator().getCurrentPosition();
    print('Zeft: Get GPS Location Method: latitude: ${positionCurrent.latitude}, longitude: ${positionCurrent.longitude}');
  }

  void _setMyLocation() {
    setState(() {
      _markers.add(Marker(
        markerId: MarkerId('myInitialPostion'),
        position: LatLng(positionCurrent.latitude, positionCurrent.longitude),
      ));
    });
  }

  _selectLocation(LatLng loc) async {
    setState(() => loading = true);
    print("Zeft: SelectLocation");
    setState(() {
      loading = false;
      selectedLocation = loc;
    });

    prickedLocation=true;

    double lat=selectedLocation.latitude;
    double lng=selectedLocation.longitude;
    print("Zeft: Select Location Method: $lat, $lng");
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: new Center(child: new Text("الموقع", textAlign: TextAlign.center, style: TextStyle(color: Colors.lightBlueAccent, fontSize: 25.0, fontFamily: "Montserrat"))),
        backgroundColor: Colors.grey[200],
        iconTheme: IconThemeData(color: Colors.black38),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.check),
            onPressed: () => Navigator.push(context, new MaterialPageRoute(builder: (context) => custOrderDetails(uid, orderID))),
          )
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            FormBuilder(
              key: _fbKey,
              child: Column(
                children: <Widget>[
                  SizedBox(height: 20.0),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 25.0),
                    child: FormBuilderTextField(
                      onChanged: (val){setState(() => comments=val);},
                      attribute: 'comment',
                      readOnly: true,
                      decoration: InputDecoration(
                        labelText: comments,
                        //filled: true,
                        border: OutlineInputBorder(),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 20),
            Container(
                height: 500,
                width: double.infinity,
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey),
                ),
                child: GoogleMap(
                  mapType: MapType.normal,
                  initialCameraPosition: CameraPosition(
                    target: LatLng(24.7269912, 46.7097429) ,
                    zoom: 10,
                  ),
                  minMaxZoomPreference: MinMaxZoomPreference(10, 18),
                  myLocationEnabled: true,
                  onMapCreated: (GoogleMapController controller) {
                    _controller.complete(controller);
                  },
                  markers: selectedLocation == null? null: {
                    Marker(
                      markerId: MarkerId('selectedLocation'),
                      position: selectedLocation,
                      infoWindow: InfoWindow(title: 'موقع الخدمة',
                      ),
                    ),
                  },
                  cameraTargetBounds: new CameraTargetBounds(new LatLngBounds(
                      northeast: LatLng(25.023232, 46.802768),
                      southwest: LatLng(24.504956, 46.547460)),
                  ),
                )
            ),
            SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
