import 'package:flutter/material.dart';

import 'map.dart';
import 'package:ebloodbank/screens/sliderpage.dart';
import 'login.dart';
// import 'signup.dart';
// import 'screens/dashboard.dart';
// import 'screens/griddashboard.dart';

Map<String, Function> routes = <String, Function>{
  '/map': () => PageRouteBuilder(
    pageBuilder: (context, animation, secondaryAnimation){
      return MapSample();
    },),

  '/slider':() => PageRouteBuilder(
    pageBuilder: (context, animation, secondaryAnimation){
      return SliderPage();
    }),

  '/login':() => PageRouteBuilder(
    pageBuilder: (context, animation, secondaryAnimation){
      return LoginPage();
    })  
};

