import 'package:Ebloodbank/screens/Bgroups/a_neg.dart';
import 'package:Ebloodbank/screens/Bgroups/a_pos.dart';
import 'package:Ebloodbank/screens/Bgroups/ab_neg.dart';
import 'package:Ebloodbank/screens/Bgroups/b_pos.dart';
import 'package:Ebloodbank/screens/Bgroups/b_neg.dart';
import 'package:Ebloodbank/screens/Bgroups/ab_pos.dart';
import 'package:Ebloodbank/screens/Bgroups/o_neg.dart';
import 'package:Ebloodbank/screens/Bgroups/o_pos.dart';
import 'package:Ebloodbank/screens/donors.dart';
import 'package:Ebloodbank/screens/feed.dart';
import 'package:Ebloodbank/screens/settings.dart';
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
      return Bloodbank();
    },),

  '/settings': () => PageRouteBuilder(
    pageBuilder: (context, animation, secondaryAnimation){
      return Settings();
    },),

  '/slider':() => PageRouteBuilder(
    pageBuilder: (context, animation, secondaryAnimation){
      return SliderPage();
    }),

  '/login':() => PageRouteBuilder(
    pageBuilder: (context, animation, secondaryAnimation){
      return LoginPage();
    }),  

  '/requests':() => PageRouteBuilder(
    pageBuilder: (context, animation, secondaryAnimation){
      return Feed();
    }),

  '/bgroup/a+':() => PageRouteBuilder(
    pageBuilder: (context, animation, secondaryAnimation){
      return Apositive();
    }),  

  '/bgroup/b+':() => PageRouteBuilder(
    pageBuilder: (context, animation, secondaryAnimation){
      return Bpositive();
    }),  

  '/bgroup/ab+':() => PageRouteBuilder(
    pageBuilder: (context, animation, secondaryAnimation){
      return ABpositive();
    }),  

  '/bgroup/o+':() => PageRouteBuilder(
    pageBuilder: (context, animation, secondaryAnimation){
      return Opositive();
    }),  

  '/bgroup/a-':() => PageRouteBuilder(
    pageBuilder: (context, animation, secondaryAnimation){
      return Anegative();
    }),  

  '/bgroup/ab-':() => PageRouteBuilder(
    pageBuilder: (context, animation, secondaryAnimation){
      return ABnegative();
    }),  

  '/bgroup/b-':() => PageRouteBuilder(
    pageBuilder: (context, animation, secondaryAnimation){
      return Bnegative();
    }),  

  '/bgroup/o-':() => PageRouteBuilder(
    pageBuilder: (context, animation, secondaryAnimation){
      return Onegative();
    }),  



};

