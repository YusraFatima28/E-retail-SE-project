import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_shop/Admin/adminShiftOrders.dart';
import 'package:e_shop/Widgets/loadingWidget.dart';
import 'package:e_shop/main.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:image/image.dart' as ImD;


class UploadPage extends StatefulWidget
{
  @override
  _UploadPageState createState() => _UploadPageState();
}

class _UploadPageState extends State<UploadPage> with AutomaticKeepAliveClientMixin<UploadPage>
{
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    return displayadminhomescreen();
  }
  displayadminhomescreen(){
    return Scaffold(
      appBar: AppBar(
        flexibleSpace: Container(
            decoration: new BoxDecoration(
                gradient: new LinearGradient(
                  colors: [Colors.limeAccent,Colors.lightGreenAccent],
                  begin : const FractionalOffset(0.0,0.0),
                  end : const FractionalOffset(0.0, 0.5),
                  stops: [0,1],
                  tileMode: TileMode.clamp,
                )
            )
        ),
        leading: IconButton( icon: Icon(Icons.border_color,color: Colors.white),onPressed: (){
          Route route=MaterialPageRoute(builder: (c)=> AdminShiftOrders());
          Navigator.pushReplacement(context, route);
        },),
        actions: [
          FlatButton(child: Text('logout',style: TextStyle(color: Colors.pink,fontSize: 16,fontWeight: FontWeight.bold),),
            onPressed:(){
              Route route=MaterialPageRoute(builder: (c)=> SplashScreen());
              Navigator.pushReplacement(context, route);
            },)
        ],
      ),
      body: adminhomescreenbody(),
    );
  }
  adminhomescreenbody(){
    return Container(
        decoration: new BoxDecoration(
            gradient: new LinearGradient(
              colors: [Colors.limeAccent,Colors.lightGreenAccent],
              begin : const FractionalOffset(0.0,0.0),
              end : const FractionalOffset(0.0, 0.5),
              stops: [0,1],
              tileMode: TileMode.clamp,
            ),
        ),child: Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [ Icon(Icons.shop_two,color: Colors.white,size:200),Padding(padding: EdgeInsets.only(top:20,),
        child: RaisedButton(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(9.0),),
          child: Text('add new item',style: TextStyle(fontSize: 20,color: Colors.white),),
          color: Colors.green, onPressed: ()=> print('click'),
        ),)],
      )
    ),
    );
  }
}
