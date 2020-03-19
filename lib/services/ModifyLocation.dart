import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:geolocator/geolocator.dart';
import 'dart:async';

class ModifyLocation extends StatefulWidget {
  LatLng selectedLoc;
  String com;
  ModifyLocation(this.selectedLoc, this.com);

  @override
  _ModifyLocationState createState() => _ModifyLocationState(selectedLoc, com);
}

class _ModifyLocationState extends State<ModifyLocation> {

  final GlobalKey<FormBuilderState> _fbKey = GlobalKey<FormBuilderState>();
  Completer<GoogleMapController> _controller = Completer();
  Position positionCurrent;
  LatLng selectedLocation;
  bool loading = false;

  bool prickedLocation=false;
  String comments;

  Set<Marker> _markers = Set();

  _ModifyLocationState(LatLng selectedLoc, String com){
    selectedLocation=selectedLoc;
    comments=com;
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

  void _submit () async
  {

    if(prickedLocation){
      if(comments!="SP") {
        _fbKey.currentState.save();

        Navigator.of(context).pop({
          'latitude': selectedLocation.latitude,
          'longitude': selectedLocation.longitude,
          'comments': comments,
          'prickedLocation': prickedLocation
        });
      }

      if(comments=="SP") {
        Navigator.of(context).pop({
          'latitude': selectedLocation.latitude,
          'longitude': selectedLocation.longitude,
          'prickedLocation': prickedLocation
        });
      }
      double lat=selectedLocation.latitude;
      double lng=selectedLocation.longitude;
      print("Zeft: Submit Method: $lat, $lng");
    }
    else{
      Fluttertoast.showToast(
          msg: ("لم تقم بالتعديل على الموقع"),
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.CENTER,
          timeInSecForIos: 20,
          backgroundColor: Colors.blue[100],
          textColor: Colors.blue[800]
      );
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: new Center(child: new Text("الموقع", textAlign: TextAlign.center, style: TextStyle(color: Colors.lightBlueAccent, fontSize: 25.0, fontFamily: "Montserrat"))),
        backgroundColor: Colors.grey[200],
        iconTheme: IconThemeData(color: Colors.black38),
        actions: <Widget>[
          IconButton(icon: Icon(Icons.check), onPressed: _submit,)
        ],
      ),

      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            if(comments!="SP")
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
            if(comments=="SP")
              SizedBox(height: 40),

            SizedBox(height: 20),

            Container(
                height: 500,
                width: double.infinity,
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey),
                ),
                child: GoogleMap(
                  onTap: _selectLocation,
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
                      infoWindow: InfoWindow(title: 'الموقع المُختار',
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