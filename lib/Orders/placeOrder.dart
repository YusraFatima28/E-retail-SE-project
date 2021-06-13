

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_shop/Colors.dart';
import 'package:e_shop/Config/config.dart';
import 'package:e_shop/Store/storehome.dart';
import 'package:e_shop/Counters/cartitemcounter.dart';
import 'package:e_shop/main.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:intl/intl.dart';


class PaymentPage extends StatefulWidget {
  final String addressID;
  final double totalAmount;
  PaymentPage({Key key,this.addressID,this.totalAmount}) : super(key: key);

  @override
  _PaymentPageState createState() => _PaymentPageState();
}
class _PaymentPageState extends State<PaymentPage> {

  String time = DateFormat("yyyy-MM-dd HH:mm:ss").format(DateTime.now());

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Container(
        decoration: new BoxDecoration(
         color: AppColors.primary
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(padding: EdgeInsets.all(8.0),
              child: Image.asset('images/cash.png'),),
              SizedBox(height: 10.0,),
              FlatButton(
                color: Colors.pinkAccent,
                textColor: Colors.white,
                padding: EdgeInsets.all(8.0),
                splashColor: Colors.deepOrange,
                onPressed: ()=> addOrderDetails(),
                child: Text('Place order ', style: TextStyle(fontSize: 30.0),),
              )
            ],
          ),
        ),
      ),
    );
  }
  addOrderDetails(){
    writeOrderDetailsForUser({

      EcommerceApp.addressID: widget.addressID,
      EcommerceApp.totalAmount: widget.totalAmount,
      "orderBy": EcommerceApp.sharedPreferences.getString(EcommerceApp.userUID),
    EcommerceApp.productID: EcommerceApp.sharedPreferences.getStringList(EcommerceApp.userCartList),
      EcommerceApp.paymentDetails: "Cash on delivery ",
      EcommerceApp.orderTime: DateTime.now().microsecondsSinceEpoch.toString(),
      EcommerceApp.isSuccess: true,
    });
      writeOrderDetailsForAdmin({
        EcommerceApp.addressID: widget.addressID,
        EcommerceApp.totalAmount: widget.totalAmount,
        "orderBy": EcommerceApp.sharedPreferences.getString(EcommerceApp.userUID),
        EcommerceApp.productID: EcommerceApp.sharedPreferences.getStringList(EcommerceApp.userCartList),
        EcommerceApp.paymentDetails: "Cash on delivery ",
        EcommerceApp.orderTime: DateTime.now().microsecondsSinceEpoch.toString(),
        EcommerceApp.isSuccess: true,
      }).whenComplete(() => {
        emptyCartNow()
      });
  }
  emptyCartNow() {
    EcommerceApp.sharedPreferences.setStringList(EcommerceApp.userCartList,['garbageValue']);
    List tempList= EcommerceApp.sharedPreferences.getStringList(EcommerceApp.userCartList);
    Firestore.instance.collection('users').document(EcommerceApp.sharedPreferences.getString(EcommerceApp.userUID)).updateData({
      EcommerceApp.userCartList: tempList
    }).then((value) => {
    EcommerceApp.sharedPreferences.setStringList(EcommerceApp.userCartList, tempList),
    Provider.of<CartItemCounter>(context, listen: false).displayResult()
    });
    Fluttertoast.showToast(msg: "Congratulations your order has been placed successfully ");
    Route route=MaterialPageRoute(builder: (c)=> SplashScreen());
    Navigator.pushReplacement(context, route);
  }
  Future writeOrderDetailsForUser (Map<String, dynamic> data)async {
    await EcommerceApp.firestore.collection(EcommerceApp.collectionUser).document(
      EcommerceApp.sharedPreferences.getString(EcommerceApp.userUID)).collection(EcommerceApp.collectionOrders).
    document(EcommerceApp.sharedPreferences.getString(EcommerceApp.userUID)+ data['orderTime' ]).setData(data);

  }
  Future writeOrderDetailsForAdmin (Map<String, dynamic> data)async {
    await EcommerceApp.firestore.collection(EcommerceApp.collectionOrders).
    document(EcommerceApp.sharedPreferences.getString(EcommerceApp.userUID)+ data['orderTime' ]).setData(data);

  }

}
