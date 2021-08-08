import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class Feed extends StatefulWidget {
  const Feed({ Key key }) : super(key: key);

  @override
  _FeedState createState() => _FeedState();
}

class _FeedState extends State<Feed> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.red,
        centerTitle: true,
        title: Text("Newsfeed"),
      ),

      body: SingleChildScrollView(
        child: GestureDetector(
          onTap: (){
            showdialogbox(context);
          },
          child: Container(
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey[200]),
              shape: BoxShape.rectangle,
            ),
            padding: EdgeInsets.symmetric(horizontal: 5, vertical: 5),
            height: 310,
            child: Column(
              children: [
                SizedBox(height: 5),
                Container(
                  height: 30,
                  width: MediaQuery.of(context).size.width,
                  child: Center(
                    child: Text(
                      "Dr. Kareena Bade",
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),

                Container(
                  height: 40,
                  width: MediaQuery.of(context).size.width,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(colors: [Colors.red,Colors.redAccent],)
                  ),
                  child: Center(
                    child: Text(
                      "Request For",
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),

                Container(
                  height: 150,
                  width: MediaQuery.of(context).size.width,
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey[200]),
                    shape: BoxShape.rectangle,
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        height: 140,
                        width: MediaQuery.of(context).size.width-20.0,
                        decoration: BoxDecoration(
                          //border: Border.all(color: Colors.grey[500]),
                          borderRadius: BorderRadius.circular(2),
                          color: Colors.white,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey[500],
                              blurRadius: 2.0,
                            )
                          ]
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            SizedBox(width: 5,),
                            Container(
                              decoration: BoxDecoration(
                                border: Border.all(color: Colors.grey[200]),
                                shape: BoxShape.rectangle,
                              ),
                              height: 130,
                              width: 40,
                              child: Center(
                                child: Text(
                                  'A-',
                                  style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.red,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                            ),

                            Container(
                              height: 130,
                              width: MediaQuery.of(context).size.width-65,
                              child: Stack(
                                fit: StackFit.loose,
                                children: [
                                  Positioned(  
                                    top: 0,
                                    left: 10,                     
                                    child: Row(
                                      children: [
                                        Icon(FontAwesomeIcons.mapMarkerAlt, size: 20,),
                                        SizedBox(width: 10,),
                                        Text('Dhaka'),
                                      ],
                                    ),
                                  ),

                                  Positioned(
                                    top: 30,
                                    left: 10,
                                    child: Row(
                                      children: [
                                        Icon(FontAwesomeIcons.arrowCircleRight, size: 20,),
                                        SizedBox(width: 10,),
                                        Text('Dhaka'),
                                      ],
                                    ),
                                  ),

                                  Positioned(
                                    top: 60,
                                    left: 10,
                                    child: Row(
                                      children: [
                                        Icon(FontAwesomeIcons.arrowCircleRight, size: 20),
                                        SizedBox(width: 10,),
                                        Text('Dhaka'),
                                      ],
                                    ),
                                  ),

                                  Positioned(
                                    top: 90,
                                    left: 10,
                                    child: Row(
                                      children: [
                                        Icon(FontAwesomeIcons.phoneAlt,size: 20,),
                                        SizedBox(width: 10,),
                                        Text('Dhaka'),
                                      ],
                                    ),
                                  ),

                                  Positioned(
                                    top: 15,
                                    left: 250,
                                    child: 
                                      Icon(FontAwesomeIcons.edit),                             
                                  ),

                                  Positioned(
                                    bottom: 15,
                                    left: 250,
                                    child: 
                                      Icon(FontAwesomeIcons.phone),                             
                                  ),                                                               
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),              
                ),

                Container(
                  height: 70,
                  width: MediaQuery.of(context).size.width,
                  child: Stack(
                    children: [
                      Positioned(
                        top: 10,
                        left: 5,
                        child: RichText(
                          text: TextSpan(
                            text: 
                              'Status Time: ',
                                style: TextStyle(
                                  color: Colors.grey,
                                  fontSize: 15,
                                ), 
                            children: [
                              TextSpan(
                                text: '',
                              ),
                            ],
                          ),
                        ),
                      ),

                      Positioned(
                        top: 30,
                        left: 5,
                        child: RichText(
                          text: TextSpan(
                            text: 
                              'Center: ',
                                style: TextStyle(
                                  color: Colors.grey,
                                  fontSize: 15,
                                ), 
                            children: [
                              TextSpan(
                                text: '',
                              ),
                            ],
                          ),
                        ),
                      ),

                      Positioned(
                        top: 50,
                        left: 5,
                        child: RichText(
                          text: TextSpan(
                            text: 
                              'Reason: ',
                                style: TextStyle(
                                  color: Colors.grey,
                                  fontSize: 15,
                                ), 
                            children: [
                              TextSpan(
                                text: '',
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  showdialogbox(BuildContext context){
    return showDialog(
      context: context,
      builder: (context){
        return Center(
        child: Container(
          height: 180,
          width: MediaQuery.of(context).size.width-40,
          decoration: BoxDecoration(
            shape: BoxShape.rectangle,
            color: Colors.white70,
            border: Border.all(color: Colors.white70)
          ),
          child: Stack(
            children: [       
              Positioned(
                top: 15,
                left: 15,
                child: GestureDetector(
                  child: Container(                        
                    height: 60,
                    width: 130,
                    decoration: BoxDecoration(
                      shape: BoxShape.rectangle,
                      color: Colors.white,
                      border: Border.all(color: Colors.grey[300]),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey,
                          blurRadius: 5.0
                        )
                      ]
                    ),
                    child: Center(
                      child: Text(
                        'EDIT',
                        style: TextStyle(
                          fontSize: 20,
                          color: Colors.black,
                        ),
                      ),
                    ),
                  ),
                  onTap: (){},
                ),
              ),
                            
              Positioned(
                top: 15,
                left: 170,
                child: GestureDetector(
                  child: Container(
                    height: 60,
                    width: 130,
                    decoration: BoxDecoration(
                      shape: BoxShape.rectangle,
                      color: Colors.white,
                      border: Border.all(color: Colors.grey[300]),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey,
                          blurRadius: 5.0
                        )
                      ]
                    ),
                    child: Center(
                      child: Text(
                        'CALL',
                        style: TextStyle(
                          fontSize: 20,
                          color: Colors.black,
                        ),
                      ),
                    ),
                  ),
                  onTap: (){},
                ),
              ),

              Positioned(
                bottom: 15,
                left: 15,
                child: GestureDetector(
                  child: Container(                        
                    height: 60,
                    width: 130,
                    decoration: BoxDecoration(
                      shape: BoxShape.rectangle,
                      color: Colors.white,
                      border: Border.all(color: Colors.grey[300]),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey,
                          blurRadius: 5.0
                        )
                      ]
                    ),
                    child: Center(
                      child: Text(
                        'SHARE',
                        style: TextStyle(
                          fontSize: 20,
                          color: Colors.black,
                        ),
                      ),
                    ),
                  ),
                  onTap: (){},
                ),
              ),

              Positioned(
                bottom: 15,
                left: 170,
                child: GestureDetector(
                  child: Container(                        
                    height: 60,
                    width: 130,
                    decoration: BoxDecoration(
                      shape: BoxShape.rectangle,
                      color: Colors.white,
                      border: Border.all(color: Colors.grey[300]),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey,
                          blurRadius: 5.0
                        )
                      ]
                    ),
                    child: Center(
                      child: Text(
                        'SMS',
                        style: TextStyle(
                          fontSize: 20,
                          color: Colors.black,
                        ),
                      ),
                    ),
                  ),
                  onTap: (){
                    print('sms tapped');
                  },
                ),
              ),
            ],
          ),
        ),
      );  
      }
    );
  }
}