import 'package:Ebloodbank/screens/request.dart';
import 'package:flutter/material.dart';
import 'map.dart';
import 'package:Ebloodbank/screens/sliderpage.dart';
import 'login.dart';
// import 'signup.dart';
// import 'screens/dashboard.dart';
// import 'screens/griddashboard.dart';

Map<String, Function> routes = <String, Function>{
  '/map': () => PageRouteBuilder(
    pageBuilder: (context, animation, secondaryAnimation){
      return MapSample();
    },),

  '/donors': () => PageRouteBuilder(
    pageBuilder: (context, animation, secondaryAnimation){
      return Requests();
    },),

  '/settings': () => PageRouteBuilder(
    pageBuilder: (context, animation, secondaryAnimation){
      return Requests();
    },),

  '/slider':() => PageRouteBuilder(
    pageBuilder: (context, animation, secondaryAnimation){
      return SliderPage();
    }),

  '/login':() => PageRouteBuilder(
    pageBuilder: (context, animation, secondaryAnimation){
      return LoginPage();
    }),  

    '/request':() => PageRouteBuilder(
    pageBuilder: (context, animation, secondaryAnimation){
      return Requests();
    }) 
};

