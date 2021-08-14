import 'dart:async';
import 'dart:convert';
// import 'package:Ebloodbank/widgets/Bgroup.dart';
import 'package:flutter/painting.dart';
import 'package:location/location.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';



class ABpositive extends StatefulWidget {

  @override
  State<ABpositive> createState() => ABpositiveState();
}

class ABpositiveState extends State<ABpositive> {
  bool mapToggle;
  GoogleMapController _controller;
  Location location = Location();
  LatLng userPosition;
  LocationData currentPosition;
  var donors = [];
  List<Items> list1=[];
  // List<Items> target=[];
  final TextEditingController msgController = new TextEditingController();
  final Set<Marker> _markers = new Set();
  
  // Set<Marker> markers = Dashboard.markers;

  getLoc() async{
    bool _serviceEnabled;
    PermissionStatus _permissionGranted;

    _serviceEnabled = await location.serviceEnabled();
    if (!_serviceEnabled) {
      _serviceEnabled = await location.requestService();
      if (!_serviceEnabled) {
        print(_serviceEnabled);
        return;
      }
    }

    _permissionGranted = await location.hasPermission();
    if (_permissionGranted == PermissionStatus.denied) {
      _permissionGranted = await location.requestPermission();
      if (_permissionGranted != PermissionStatus.granted) {
        return;
      }
    }

    print(_serviceEnabled);
    print(_permissionGranted);

    if(_serviceEnabled == true && _permissionGranted == PermissionStatus.granted){
      print(mapToggle);
      currentPosition = await location.getLocation();
      userPosition = LatLng(currentPosition.latitude, currentPosition.longitude);
      location.onLocationChanged.listen((LocationData currentLocation) {
        // print("${currentLocation.latitude} : ${currentLocation.longitude}");
        currentPosition = currentLocation;
        userPosition = LatLng(currentPosition.latitude, currentPosition.longitude);
        // _positionupdate();
      });
      sendlocation();
    }    
  }


  sendlocation() async{
    Map data={
      'bGroup':"AB+",
      'Bgroup':"AB +ve",
      'lat':currentPosition.latitude,
      'lng':currentPosition.longitude,
    };
    var response = await http.post(Uri.parse("http://10.0.2.2:5000/distancematrix"),
    headers: {"Content-type":"application/json"},
    body: jsonEncode(data));
    if (response.statusCode==202){
      print("---------------------------sucess--------------------------");
    }
    else{
      print("errorrrrrrrrrrrrrrrrrrrrrrrrrrrrrr");
    }
  }

  @override
  void initState() {
    super.initState();
    fetchdonors();
    mapToggle=true;
    // initMarker();
    getLoc();
    
  }

  BitmapDescriptor pinLocationIcon;

  void setCustomMapPin() async {
    pinLocationIcon = await BitmapDescriptor.fromAssetImage(
      ImageConfiguration(devicePixelRatio: 2.5),
      'assets/AB+.png');
   }

  void setlist(response){
    list1 =[
      for(int i=0;i<response.length;i++)
        Items(title: response[i]['fullName'],
        contact: response[i]['phoneNumber'],
        position: LatLng(response[i]['lat'],response[i]['lng']),
        id: response[i]['userId'],
        )
    ]; 
  }

  fetchdonors() async{
    var jsonResponse;
    jsonResponse = null;
    var response = await http.get(Uri.parse("http://10.0.2.2:5001/abpositive"));
    if(response.statusCode == 200) {

      jsonResponse = json.decode(response.body);
      // print(jsonResponse[0]['Latitude']);
      setlist(jsonResponse);
      print(mapToggle);
      for (int i=0;i<jsonResponse.length;i++){
        // to add icon
        setCustomMapPin();
        var marker=Marker(
        markerId: MarkerId(jsonResponse[i]['bloodGroup']),
        position: LatLng(jsonResponse[i]['lat'],jsonResponse[i]['lng']),
        infoWindow: InfoWindow(
          title: jsonResponse[i]['fullName'],
          snippet: jsonResponse[i]['phoneNumber'],
        ),
        // icon:pinLocationIcon,
        icon: BitmapDescriptor.defaultMarker,
        // icon: BitmapDescriptor.fromAssetImage(ImageConfiguration.empty, icon),
        );
        setState(() {
          _markers.add(marker);
        });
      }
      print(_markers);
    }
    else {
      print("The error message is: ${response.body}");
    }
  }

  // initMarker(){
  //   for (int i=0;i<donors.length;i++){
  //     _markers.add(Marker(
  //       markerId: MarkerId(donors[i]['Blood_type']),
  //       position: LatLng(donors[i]['Latitude'],donors[i]['Longitude']),
  //       infoWindow: InfoWindow(
  //         title: donors[i]['Blood_type'],
  //         snippet: donors[i]['Name'],
  //       ),
  //       icon: BitmapDescriptor.defaultMarker,
  //       ));
  //   }
  // }


  // final CameraPosition home = CameraPosition(
  //   target: LatLng(currentPosition.latitude, currentPosition.longitude),
  //   zoom: 10.0,
  // );

  @override
  void dispose(){
    _controller.dispose();
    super.dispose();
  }
  
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: AppBar(
        title: Text('E-BloodBank'),
        backgroundColor: Colors.red,
      ),
      body: Column(
        children: <Widget>[
          Stack(
            children: [
              Container(
                height: MediaQuery.of(context).size.height-80.0,
                width: double.infinity,
                // if maptoggle is true
                child: mapToggle ?
                GoogleMap(
                  compassEnabled: true,
                  mapType: MapType.normal,
                  myLocationEnabled: true,
                  scrollGesturesEnabled: true,
                  zoomGesturesEnabled: true,
                  initialCameraPosition: CameraPosition(
                    target: LatLng(27.6,85.4),
                    zoom: 10,
                    ),
                  onMapCreated: (controller) => _controller=controller,
                  markers: _markers,
                ):
                // if maptoggle is not true
                Center(
                  child:
                  Text('Loading Please Wait..',
                  style: TextStyle(
                    fontSize: 20.0
                  ),))

              ),
            ],)
        ],
      ),
      floatingActionButton: FloatingActionButton(
        isExtended: true,
        backgroundColor: Colors.red,
        child: Icon(Icons.explore),
        onPressed: (){
          showdialog(context);
        },
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }

  // Future<void> _positionupdate() async {
  //   CameraPosition address = CameraPosition(
  //     target: userPosition,
  //     zoom: 9,
  //   );
  //   if (address!=null){
  //     final GoogleMapController controller = await _controller.future;
  //     controller.moveCamera(CameraUpdate.newCameraPosition(address));
  //     dispose();
  //   }
    
  // }



  showdialog(context){
    // List<Items> mylist = [item1, item2, item3];

    return showDialog(context: context, builder: (context){
      return Center(
        child: Material(
          type: MaterialType.transparency,
          child: Column(
            children: [
              SizedBox(height: 100,),
              Text('AB+ Donors near you',textScaleFactor: 2,style: TextStyle(color: Colors.white),),
              Container(
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  shape: BoxShape.rectangle,
                  borderRadius: BorderRadius.circular(20),
                  color: Colors.red[100],
                  ),
                constraints: BoxConstraints.tightForFinite(height:400),
                margin: EdgeInsets.all(10),
                child: ListView(children: list1.map((data){
                  return Container(
                    decoration: BoxDecoration(
                    shape: BoxShape.rectangle,
                    borderRadius: BorderRadius.circular(20),),
                    child: InkWell(
                      child: Container(
                        margin: EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: Colors.redAccent, borderRadius: BorderRadius.circular(10)
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Text(
                              data.title,
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 22,
                                fontWeight: FontWeight.w600
                              )
                            ),
                          ],
                        ),
                      ),
                    onTap: (){
                      print("button tapped");
                      print(data.contact);
                      print(data.position);
                      _controller.animateCamera(CameraUpdate.newCameraPosition(CameraPosition(target: data.position,zoom: 11)));
                      setState(() {
                        _markers.add(Marker(
                          markerId: MarkerId(data.title.toString()),
                          position: data.position,
                          infoWindow: InfoWindow(
                            title: data.title,
                            snippet: data.contact,
                            onTap:(){
                              sendRequest(data.title,data.contact,data.position,data.id);
                              // target=[Items(position: data.position,title: data.title)];
                              // messagebox(context);
                            } 
                          ),
                          icon:
                              BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueMagenta),
                        ));
                      });
                      // Navigator.pushNamed(context, data.contact);
                    },
                  ),
                  );
                }).toList()
                ),
              )
            ],
          ), 
        ),
      );
    });
  }

  sendRequest (name,number,position,id) async{
    Map data = {
      'name': name,
      'number': number,
      'id':id,
    };
    var response = await http.post(Uri.parse("http://10.0.2.2:5001/notice"), 
    headers: {"Content-type":"application/json"},
    body: jsonEncode(data));
    if (response.statusCode==200){
      print(response.body);
    }

  }


  // messagebox(context){
  //   return showDialog(context: context, builder: (context){
  //     return Center(
  //       child: Material(
  //         type: MaterialType.transparency,
  //         child: Column(
  //           children: [
  //             SizedBox(height: 100,),
  //             Text('Type your message here',textScaleFactor: 2,style: TextStyle(color: Colors.white),),
  //             Container(
  //               alignment: Alignment.center,
  //               decoration: BoxDecoration(
  //                 shape: BoxShape.rectangle,
  //                 borderRadius: BorderRadius.circular(20),
  //                 color: Colors.red[100],
  //                 ),
  //               constraints: BoxConstraints.tightForFinite(height:300),
  //               margin: EdgeInsets.all(10),
  //               child: TextFormField(
  //                       controller: msgController,
  //                       // ignore: missing_return
  //                       validator: (value) {
  //                         if (value.trim().isEmpty){
  //                           return 'Message required';
  //                         }
  //                       },
  //                       decoration: InputDecoration(
  //                         prefixIcon: Icon(Icons.email,color:Colors.red),
  //                           labelText: 'Message',
  //                           labelStyle: TextStyle(
  //                               fontFamily: 'Montserrat',
  //                               fontWeight: FontWeight.bold,
  //                               color: Colors.grey),
  //                           focusedBorder: UnderlineInputBorder(
  //                               borderSide: BorderSide(color: Colors.red))),
  //                     ),
  //             ),
              	
  //             ElevatedButton(
  //               child: Text('submit'),
  //               style: ElevatedButton.styleFrom(
  //                 primary: Colors.purple[200],
  //               ),
  //               onPressed: () {
  //                 print('Pressed');
  //               },
  //             ),
  //           ],
  //         ), 
  //       ),
  //     );
  //   });
  // }

}

class Items {
  String title;
  String contact;
  LatLng position;
  int id;
  Items({this.title, this.contact,this.position,this.id});
}
