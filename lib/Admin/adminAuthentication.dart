import 'package:e_shop/Colors.dart';
import 'package:flutter/material.dart';
import 'adminLogin.dart';
import 'adminRegisteration.dart';
import 'package:e_shop/Config/config.dart';
import 'package:firebase_core/firebase_core.dart';
class adminAuthentication extends StatefulWidget {
  @override
  adminAuthenticationState createState() => adminAuthenticationState();
}
class adminAuthenticationState extends State<adminAuthentication> {
  @override
  Widget build(BuildContext context) {
    return  DefaultTabController(length: 2, child:
    Scaffold(
      appBar: AppBar(
        flexibleSpace: Container(
            decoration: new BoxDecoration(
                gradient: new LinearGradient(
                  colors: [Colors.yellow,Colors.pinkAccent],
                  //begin : Alignment.
                  begin : const FractionalOffset(0.0,0.95),
                  end : const FractionalOffset(0.95, 0.4),
                  stops: [0.0,1.0],
                  tileMode: TileMode.clamp,
                )
            )
        ),
        title: Text(
          'E-Retail',style: TextStyle(
          fontSize: 55,
          color: Colors.white,
          fontFamily: "Signatra",
        ),
        ),
        centerTitle: true,
        bottom: TabBar(
          tabs:[
            Tab(icon: Icon(Icons.lock,color: Colors.white,),
                text: 'Admin Login'),
            Tab(icon: Icon(Icons.perm_contact_calendar,color: Colors.white,),
              text: 'Admin Register',),
          ],
          indicatorColor: Colors.grey,
          indicatorWeight: 5,

        ),
      ),
      body:Container(
        decoration: new BoxDecoration(
            gradient: new LinearGradient(
              colors: [ Colors.pinkAccent, //Colors.lightGreenAccent
                Colors.yellow], //Colors.lightGreenAccent
              begin : Alignment.topRight,
              end : Alignment.bottomLeft,
            )
        ),
        child: TabBarView(
          children: [
            AdminSignInPage(),adminRegisteration(),
          ],
        ),
      ),
    ) );

  }
}
