import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_shop/Widgets/Navigation_drawer/collapsing_navigation_drawer_widget.dart';
import 'package:e_shop/Widgets/customAppBar.dart';
import 'package:e_shop/Widgets/newAppBar.dart';
import 'package:flutter/material.dart';
import 'package:e_shop/Config/config.dart';
import 'package:flutter/services.dart';
import '../Widgets/loadingWidget.dart';
import '../Widgets/orderCard.dart';
import 'package:firebase_core/firebase_core.dart';

class MyOrders extends StatefulWidget {
  @override
  _MyOrdersState createState() => _MyOrdersState();
}
class _MyOrdersState extends State<MyOrders> {

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: PreferredSize(
      preferredSize: const Size.fromHeight(60),
        child : newAppBar() ),
        /*AppBar(
          iconTheme: IconThemeData(color: Colors.white),
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
          ), centerTitle: true, title: Text('My Orders', style: TextStyle(color: Colors.white),),
          actions: [
            IconButton(
              icon: Icon(Icons.arrow_drop_down_circle, color: Colors.white,),
              onPressed: (){SystemNavigator.pop();},
            )
          ],
        ),*/
        drawer: CollapsingNavigationDrawer(),
        body:
       /* ListView(
            children: [*/
        StreamBuilder<QuerySnapshot> (
        stream: EcommerceApp.firestore.collection(EcommerceApp.collectionUser).document(
            EcommerceApp.sharedPreferences.getString(EcommerceApp.userUID)
        ).collection(EcommerceApp.collectionOrders).snapshots(),
        builder: (c,snapshot){
          return snapshot.hasData ? ListView.builder(
            itemCount: snapshot.data.documents.length,
            itemBuilder: (c,index){
              return FutureBuilder<QuerySnapshot>(
                future: Firestore.instance.collection('items').
                where('shortInfo',whereIn: snapshot.data.documents[index].data[EcommerceApp.productID]).getDocuments() ,
                builder: (c,snap){
                  print(' agr hai dataa ');
                  print(snapshot.data.documents[index].data[EcommerceApp.orderTime]);
                  print(snap.hasData );
                  print(snapshot.data.documents);
                  //print(snap.data.documents);
                  print(snapshot.data.documents[index].data[EcommerceApp.productID] );
                  print(EcommerceApp.productID );
                  //print(snap.data.documents.length);
                  print(' hahahahh ');
                  print( index);
                  print(snapshot.data.documents.length);
                  //print(snap.data.documents.length  );
                  return snap.hasData?
                  OrderCard(
                    itemCount : snap.data.documents.length, data: snap.data.documents,orderID: EcommerceApp.sharedPreferences.getString(EcommerceApp.userUID) + snapshot.data.documents[index].data[EcommerceApp.orderTime]
                  //snap.data.documents[index].documentID,
                  ): Center(child: circularProgress(),);
                },
              );
            },
          ) : Center(child: circularProgress(),);
        },
      ),//]),
      ),
    );
  }
}