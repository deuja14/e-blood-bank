import 'dart:async';
import 'package:location/location.dart';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MapSample extends StatefulWidget {
  @override
  State<MapSample> createState() => MapSampleState();
}

class MapSampleState extends State<MapSample> {
  Completer<GoogleMapController> _controller = Completer();
  Location _location = Location();
  LatLng userPosition;

  static final CameraPosition home = CameraPosition(
    target: LatLng(27.6643, 85.4232),
    // zoom: 60,
  );

  void _onMapCreated(GoogleMapController controller)
  {
    _controller.complete(controller);
    _location.onLocationChanged.listen((LocationData position) {
      setState(() {
          userPosition = LatLng(position.latitude, position.longitude);
        });
        _positionupdate();
    });
    
  }
  
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      body: GoogleMap(
        compassEnabled: true,
        mapType: MapType.normal,
        myLocationEnabled: true,
        scrollGesturesEnabled: true,
        zoomGesturesEnabled: true,
        initialCameraPosition: home,
        // onCameraIdle: _positionupdate,
        onMapCreated: _onMapCreated,
      ),
      // floatingActionButton: FloatingActionButton.extended(
      //   onPressed: _goToTheLake,
      //   label: Text('To the lake!'),
      //   icon: Icon(Icons.directions_boat),
      // ),
    );
  }

  Future<void> _positionupdate() async {
    final GoogleMapController controller = await _controller.future;
    CameraPosition address;
    if (userPosition == null){
      address = home;
    }
    else{
      address = CameraPosition(target: userPosition, zoom: 14.4746);
    }
    controller.animateCamera(
      CameraUpdate.newCameraPosition(address)
    );
    dispose();
  }
  dispose();
}