import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_shop/Admin/adminOrderDetails.dart';
import 'package:e_shop/Models/item.dart';
import 'package:e_shop/Widgets/orderCard.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';

import '../Colors.dart';



int counter=0;
class AdminOrderCard extends StatelessWidget
{
  final int itemCount;
  final List<DocumentSnapshot> data;
  final String orderID;
  final String addressID;
  final String orderBy;
   //int counter=0;
  AdminOrderCard({Key key, this.itemCount,this.orderID,this.addressID,this.data,this.orderBy
}) : super(key: key);
  @override
  Widget build(BuildContext context)
  {
    return  InkWell(
      //Route route=MaterialPageRoute(builder: (c)=> StoreHome());
      //         Navigator.pushReplacement(context, route);
      onTap: (){
        Route route;
        if (counter==0){
          //counter=counter+1;
          route=MaterialPageRoute(builder: (c)=> AdminOrderDetails(orderID: orderID, orderBy: orderBy, addressID: addressID));
          //Navigator.pushReplacement(context,route);
        }
        Navigator.push(context,route);
      },child: Container(
      decoration: new BoxDecoration(
       color: AppColors.primary,
      ),padding: EdgeInsets.all(13.0),
      margin: EdgeInsets.all(13.0),
      height: itemCount * 190.0,
      child: ListView.builder(
        itemCount: itemCount,
        physics: NeverScrollableScrollPhysics(),
        itemBuilder: (c,index){
          ItemModel model=ItemModel.fromJson(data[index].data);
          return sourceOrderInfo(model, context);
        },
      ),
    ),
    );
  }
}


