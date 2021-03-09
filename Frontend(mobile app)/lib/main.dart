
import 'package:flutter/material.dart';
// import 'package:google_maps_flutter/google_maps_flutter.dart';
// import 'package:location/location.dart';
import 'package:ebloodbank/map.dart';
import 'login.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  
  @override 
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        height: MediaQuery.of(context).size.height,
        // height: double.infinity,
        width: MediaQuery.of(context).size.width,
        child: Column(
          children: [
            RaisedButton(
              child: Text("sanam map"),
              textColor: Colors.white,
              color: Colors.red,
              onPressed:(){
                // Navigator.pushAndRemoveUntil(context,MaterialPageRoute(builder: (_)=>Sanam()),(route)=>false);
                Navigator.of(context).push(MaterialPageRoute(builder: (_)=>MapSample()));
            }),
            RaisedButton(
              child: Text("login"),
              onPressed: (){
                Navigator.of(context).push(MaterialPageRoute(builder: (_)=>LoginPage()));
              })
            
          ],
        ),
      ),
    );
  }

  
}
