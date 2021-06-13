import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_shop/Admin/Navigation_drawer/collapsing_navigation_drawer_widget.dart';
import 'package:e_shop/Admin/adminOrderCard.dart';
import 'package:e_shop/Admin/uploadItems.dart';
import 'package:e_shop/Config/config.dart';
import 'package:e_shop/Widgets/Navigation_drawer/collapsing_navigation_drawer_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../Colors.dart';
import '../Widgets/loadingWidget.dart';
import '../Widgets/orderCard.dart';
import 'package:firebase_core/firebase_core.dart';

import '../style.dart';

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
          iconTheme: IconThemeData(
            color: Colors.white,
          ),
          backgroundColor: AppColors.primary,
          centerTitle: true,
          elevation: 0,
          title: Text(
            'E-Retail',
            style: TextStyle(
              fontSize: 55,
              color: Colors.white,
              fontFamily: "Signatra",
            ),
          ),
        ), drawer: CollapsingNavigationDrawerAdmin(),
          body:
        StreamBuilder<QuerySnapshot> (
          stream: Firestore.instance.collection('orders').snapshots(),
          builder: (c,snapshot){
            print( ' hahahahh ');
            return snapshot.hasData ? ListView.builder(
              itemCount: snapshot.data.documents.length,
              itemBuilder: (c,index){
                return FutureBuilder<QuerySnapshot>(
                  future: Firestore.instance.collection('items').
                  where('shortInfo',whereIn: snapshot.data.documents[index].data[EcommerceApp.productID]).getDocuments(),
                  builder: (c,snap){
                    return snap.hasData?
                    AdminOrderCard(
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
