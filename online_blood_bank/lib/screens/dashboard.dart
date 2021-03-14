import 'package:flutter/material.dart';
import 'package:online_blood_bank/screens/appbar.dart';

import 'griddashboard.dart';

class Dashboard extends StatefulWidget {
  @override
  _DashboardState createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {

  int _currentIndex = 0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        
        preferredSize: Size.fromHeight(200),
        child: ClipPath(clipper: CustomAppBar(),
          child: 
            Container(color: Colors.red, child: Center(child: 
              Column(mainAxisAlignment: MainAxisAlignment.center, children: <Widget>[
                Text("GIVE THE GIFT OF LIFE", style: TextStyle(fontSize: 20, color: Colors.white,),),
                Text("DONATE BLOOD", style: TextStyle(fontSize: 30, color: Colors.white, fontWeight: FontWeight.bold,),),
              ],)),   
            ),
        ),
      ),

      body: Column(
        children: <Widget>[
          GridDashboard()
        ],
                  
      ),

      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        type: BottomNavigationBarType.fixed,
        selectedFontSize: 10,
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.more),
            // ignore: deprecated_member_use
            title: Text('More'),
            backgroundColor: Colors.grey,
          ),

          BottomNavigationBarItem(
            icon: Icon(Icons.search),
            // ignore: deprecated_member_use
            title: Text('Search'),
            backgroundColor: Colors.grey,
          ),

          BottomNavigationBarItem(
            icon: Icon(Icons.add),
            // ignore: deprecated_member_use
            title: Text('Add'),
            backgroundColor: Colors.grey,
          ),

          BottomNavigationBarItem(
            icon: Icon(Icons.person_outline),
            // ignore: deprecated_member_use
            title: Text('Profile'),
            backgroundColor: Colors.grey,
          ),

          BottomNavigationBarItem(
            icon: Icon(Icons.notifications_outlined),
            // ignore: deprecated_member_use
            title: Text('Notification'),
            backgroundColor: Colors.grey,
          ),
        ],
        onTap: (index){
          setState(() {
            _currentIndex = index;
          });
        },
      ),
    );
  }
}