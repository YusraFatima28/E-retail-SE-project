import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_shop/Colors.dart';
import 'package:e_shop/Orders/OrderDetailsPage.dart';
import 'package:e_shop/Models/item.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';


import 'package:firebase_core/firebase_core.dart';
double width;
int counter= 0;
class OrderCard extends StatelessWidget {
  final int itemCount;
  final List<DocumentSnapshot> data;
  final String orderID;
  OrderCard({Key key, this.data,this.itemCount,this.orderID}): super(key: key);
  @override
  Widget build(BuildContext context) {
    print(' yahan se shru ');
    print(itemCount);
    print(data);
    print(orderID);
    return  InkWell(
      onTap: (){
        Route route;
        if (counter==0){
          //counter=counter+1;
          route=MaterialPageRoute(builder: (c)=> OrderDetails(orderID: orderID));
          //Navigator.pushReplacement(context,route);
        }
        Navigator.push(context,route);
      },child: Container(
      decoration: new BoxDecoration(
       color: AppColors.primary
      ),padding: EdgeInsets.all(13.0),
      margin: EdgeInsets.all(10.0),
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
Widget sourceOrderInfo(ItemModel model, BuildContext context,
    {Color background})
{
  width =  MediaQuery.of(context).size.width;
  return  Container(
    color:AppColors.primaryWhiteSmoke, // Colors.grey[100],
    height: 170.0,
    width: width,
    child: Row(
      children: [
        Image.network(model.thumbnailUrl,width : 180.0,),
        SizedBox(width : 10.0),
        Expanded(child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 15.0,),
            Container(
              child: Row(
                mainAxisSize: MainAxisSize.max,
                children: [
                  Expanded(child: Text(model.title,style: TextStyle(color: Colors.black, fontSize: 18.0, fontWeight: FontWeight.bold),
                  ))
                ],
              ),
            ),
            SizedBox(height: 5.0,),
            Container(
              child: Row(
                mainAxisSize: MainAxisSize.max,
                children: [
                  Expanded(child: Text(model.shortInfo,style: TextStyle(color: Colors.black, fontSize: 16.0),
                  ))
                ],
              ),
            ),
            SizedBox(height: 20.0,),
            Row(
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(padding: EdgeInsets.only(top: 5.0),
                      child: Row(
                        children: [
                          Text(
                            r"Price: ",style: TextStyle(fontSize: 16.0, color: Colors.black),
                          ),Text(r'Rs '  , style: TextStyle(color: Colors.pinkAccent,fontSize: 18.0,  fontWeight: FontWeight.bold)),
                          Text(
                            (model.price ).toString() ,style: TextStyle(fontSize: 18.0, color: Colors.pinkAccent, fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),),
                  ],
                )
              ],
            ),
            Flexible(child: Container(
            )),
            Divider(height: 5.0,color: Colors.pink,),
            // to implement the cart remove item feature
          ],
        ))
      ],
    ),
  );
}