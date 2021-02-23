
// import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
// import 'package:location/location.dart';



class Maphome extends StatefulWidget {
  @override
  _MaphomeState createState() => _MaphomeState();
}

class _MaphomeState extends State<Maphome> {
  // Completer <GoogleMapController> _controller= Completer(); 
  LatLng _initialcameraposition = LatLng(20.5937, 78.9629);
  // GoogleMapController _controller;
  // Location _location = Location();

  void _onMapCreated(GoogleMapController _cntlr)
  {
    // _controller = _cntlr;
    // _location.onLocationChanged.listen((l) { 
    //   _controller.animateCamera(
    //     CameraUpdate.newCameraPosition(
    //       CameraPosition(target: LatLng(l.latitude, l.longitude),zoom: 15),
    //       ),
    //   );
    // });
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Doners near you"),
      ),
      body: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        child: Stack(
          children: [
            
            GoogleMap(
              initialCameraPosition: CameraPosition(target: _initialcameraposition),
              mapType: MapType.normal,
              onMapCreated: _onMapCreated,
              myLocationEnabled: true,
              scrollGesturesEnabled: true,
              zoomGesturesEnabled: true,
            ),
            Container(
              height: 100,
              width: 100,
              color:Colors.red),
          ],
        ),
      ),
    );
  }

  
}
