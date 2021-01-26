import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_shop/Admin/adminOrderCard.dart';
import 'package:e_shop/Admin/uploadItems.dart';
import 'package:e_shop/Config/config.dart';
import 'package:e_shop/Widgets/myDrawer.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../Widgets/loadingWidget.dart';
import '../Widgets/orderCard.dart';
import 'package:firebase_core/firebase_core.dart';

class AdminShiftOrders extends StatefulWidget {
  @override
  _MyOrdersState createState() => _MyOrdersState();
}
class _MyOrdersState extends State<AdminShiftOrders> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          iconTheme: IconThemeData(color: Colors.lightGreenAccent),

          flexibleSpace: Container(
            decoration: new BoxDecoration(
              gradient: new LinearGradient(
                colors: [Colors.limeAccent,Colors.lightGreenAccent],
                begin : const FractionalOffset(0.0,0.0),
                end : const FractionalOffset(0.0, 0.5),
                stops: [0,1],
                tileMode: TileMode.clamp,
              ),
            ),
          ), centerTitle: true, title: Text('My Orders', style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold,fontSize: 28),),
          actions: [
            IconButton(
              icon: Icon(Icons.arrow_back, color: Colors.white,),
              onPressed: (){Route route=MaterialPageRoute(builder: (c)=> UploadPage());
              Navigator.pushReplacement(context, route);}, //SystemNavigator.pop()
            )
          ],
        ),  body: StreamBuilder<QuerySnapshot> (
        stream: Firestore.instance.collection('orders').snapshots(),
        builder: (c,snapshot){
          return snapshot.hasData ? ListView.builder(
            itemCount: snapshot.data.documents.length,
            itemBuilder: (c,index){
              return FutureBuilder<QuerySnapshot>(
                future: Firestore.instance.collection('items').
                where('shortInfo',whereIn: snapshot.data.documents[index].data[EcommerceApp.productID]).getDocuments(),
                builder: (c,snap){
                  return snap.hasData? AdminOrderCard(
                    itemCount : snap.data.documents.length, data: snap.data.documents,orderID: snapshot.data.documents[index].documentID,
                    orderBy: snapshot.data.documents[index].data['orderBy'],
                    addressID: snapshot.data.documents[index].data['addressID'],
                  ): Center( child: circularProgress(),);
                },
              );
            },
          ) : Center(child: circularProgress(),);
        },
      ),
      ),
    );
  }
}
