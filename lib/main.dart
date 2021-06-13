import 'dart:async';
import 'dart:ui';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_shop/Authentication/welcome.dart';
import 'package:e_shop/Colors.dart';
import 'package:e_shop/Counters/ItemQuantity.dart';
import 'package:e_shop/Store/Search.dart';
import 'package:e_shop/Store/storehome.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'Authentication/authenication.dart';
import 'package:e_shop/Config/config.dart';
import 'Counters/WishListItemCounter.dart';
import 'Counters/cartitemcounter.dart';
import 'Counters/changeAddresss.dart';
import 'Counters/totalMoney.dart';
import 'package:firebase_core/firebase_core.dart';
Future<void> main() async
{
  WidgetsFlutterBinding.ensureInitialized();
  EcommerceApp.auth=FirebaseAuth.instance;
  EcommerceApp.sharedPreferences= await SharedPreferences.getInstance();
  EcommerceApp.firestore = Firestore.instance;
  runApp(MyApp());
}
class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(providers: [
      ChangeNotifierProvider(create: (c)=> CartItemCounter(),),
      ChangeNotifierProvider(create: (c)=> WishListItemCounter(),),
      ChangeNotifierProvider(create: (c)=> ItemQuantity(),),
      ChangeNotifierProvider(create: (c)=> AddressChanger(),),
      ChangeNotifierProvider(create: (c)=> TotalAmount(),),
    ],
      child: MaterialApp(
        title: 'E-retail',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primaryColor: AppColors.primary,
        ),home: SplashScreen(),
      ),
    );
  }
}
class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}
class _SplashScreenState extends State<SplashScreen>
{
  int addressCounter = 0;
  @override
  void initState() {
    super.initState();
    displaySplash();
  }
  displaySplash(){
    Timer(Duration(seconds: 1),() async {
      if(await EcommerceApp.auth.currentUser() !=null){
        Route route=MaterialPageRoute(builder: (_)=> StoreHome());
        Navigator.pushReplacement(context, route);}

      else{
        Route route=MaterialPageRoute(builder: (_)=> WelcomeScreen());
        Navigator.pushReplacement(context, route);
      }
    } );
  }
  @override
  Widget build(BuildContext context) {
    return Material(
        child: Container(
          decoration: new BoxDecoration(
              gradient: new LinearGradient(
                colors: [Colors.pink,AppColors.primary],
                begin : const FractionalOffset(0.0, 0.0),
                end : const FractionalOffset(1.0, 0.0),
                stops: [0.0,1.0],
                tileMode: TileMode.clamp,
              )
          ),
          child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [ Image.asset('images/welcome.png'),
                  SizedBox(height: 20,),
                  Text('A Place Where You Can Buy Anything ',
                    style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold, fontSize: 18),)
                ],
              )
          ),
        )
    );
  }
}
