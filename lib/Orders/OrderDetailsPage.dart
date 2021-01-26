import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_shop/Address/address.dart';
import 'package:e_shop/Config/config.dart';
import 'package:e_shop/Store/storehome.dart';
import 'package:e_shop/Widgets/loadingWidget.dart';
import 'package:e_shop/Widgets/orderCard.dart';
import 'package:e_shop/Models/address1.dart';
import 'package:e_shop/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:e_shop/Admin/adminOrderDetails.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_shop/Address/address.dart';
import 'package:e_shop/Admin/uploadItems.dart';
import 'package:e_shop/Config/config.dart';
import 'package:e_shop/Widgets/loadingWidget.dart';
import 'package:e_shop/Widgets/orderCard.dart';
import 'package:e_shop/Models/address1.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';

String getOrderId="";
class OrderDetails extends StatelessWidget {
  final String orderID;
  final String orderBy;
  final String addressID;
  //final
  OrderDetails({Key key, this.orderID, this.orderBy, this.addressID,}): super(key: key);
  @override
  Widget build(BuildContext context){
    getOrderId= orderID;
    return SafeArea(
      child: Scaffold(
        body: SingleChildScrollView(
          child: FutureBuilder<DocumentSnapshot>  (
              //future: getdoc(),
             future : EcommerceApp.firestore
                .collection(EcommerceApp.collectionOrders).document(EcommerceApp.sharedPreferences.getString(EcommerceApp.userUID))
                .collection(EcommerceApp.collectionOrders).document(orderID).get(),
                builder: (BuildContext context, AsyncSnapshot snapshot){
                Map< String,dynamic> dataMap;
                /*if (snapshot.connectionState == ConnectionState.done) {
                  if (snapshot.data == null) {
                    return Text('no data');
                  } else {
                    return Text('data present');
                  }
                } else if (snapshot.connectionState == ConnectionState.error) {
                  return Text('Error'); // error
                } else {
                  return CircularProgressIndicator(); // loading
                }; */
                if (snapshot.connectionState== ConnectionState.done){
                  print(' has connection ');
                  print(snapshot);
                  dataMap= snapshot.data.data;
                  if (dataMap==null){
                    print('no data');
        }else {return Text('we have data'); }}
                else{ return CircularProgressIndicator(); }
                  /*print('ture');
                  print(snapshot);
                  print(snapshot.data.data);
                   dataMap= snapshot.data.data;
                  //dataMap = snapshot.data.data;
                  print(dataMap);
                  print('phhr');
                  print(snapshot);
                  print(snapshot);
                  print('yahan pr');
                } else if (snapshot== null){
                  print(' has null ');
                }*/
                  //print(EcommerceApp.collectionOrders);
                  //print(EcommerceApp.orderTime);
                  //print(EcommerceApp.firestore
                      //.collection(EcommerceApp.collectionOrders).document(EcommerceApp.sharedPreferences.getString(EcommerceApp.userUID))
                      //.collection(EcommerceApp.collectionOrders).document(orderID).get());
                  //print('yess');
                //}
                return snapshot.hasData?
                Container(
                  child: Container(
                  child: Column(
                    children: [
                      StatusBanner(status: true),//dataMap[EcommerceApp.isSuccess]
                      SizedBox(height: 10.0,),
                      Padding(padding: EdgeInsets.all(4.0),
                       child: Align(
                      alignment: Alignment.centerLeft,
                      child: Text('\$' + dataMap[EcommerceApp.totalAmount].toString(),
                          style: TextStyle(fontSize: 20.0,fontWeight: FontWeight.bold),),
                    ),),
                      Padding(padding: EdgeInsets.all(4.0),
                        child: Text('Order ID: '+ getOrderId),),
                      Padding(padding: EdgeInsets.all(4.0),
                      child: Text('Ordered at :  '+ DateFormat('dd MMMM, yyyy - hh:mm aa').format(
                        DateTime.fromMillisecondsSinceEpoch(int.parse(dataMap['orderTime']
                      ))),style: TextStyle(fontSize: 16.0, color: Colors.grey),),),
                    Divider(height: 2.0,),
                      FutureBuilder<QuerySnapshot>(
                      future: EcommerceApp.firestore.collection('items').where('shortInfo', whereIn: dataMap[EcommerceApp.productID],
                    ).getDocuments(),
                      builder: (c, dataSnapshot){
                        print('hhhhh');
                        return dataSnapshot.hasData ? OrderCard(
                          itemCount: dataSnapshot.data.documents.length,
                          data: dataSnapshot.data.documents
                        ) : Center(child: circularProgress(),);
                      },),
                      Divider(height: 2.0,),
                      FutureBuilder<DocumentSnapshot>(
                        future: EcommerceApp.firestore.collection(EcommerceApp.collectionUser).document(
                            EcommerceApp.sharedPreferences.getString(EcommerceApp.userUID)).collection(EcommerceApp.subCollectionAddress).
                        document(dataMap[EcommerceApp.addressID]).get(),
                        builder: (c,snap){
                          print('hhhh');
                          return snap.hasData ? ShippingDetails(
                            model: AddressModel.fromJson(snap.data.data),
                          ) : Center(child: circularProgress(),);
                        },
                      ),
                    ],
                  ),),
                ): Center(child: circularProgress(),);}
          ),
        ),
      ),
    );
  }
}
/*Future<DocumentSnapshot> getdoc()async {
  Future<DocumentSnapshot> result = (await EcommerceApp.firestore
      .collection(EcommerceApp.collectionOrders).document(EcommerceApp.sharedPreferences.getString(EcommerceApp.userUID))
      .collection(EcommerceApp.collectionOrders).document(OrderDetails().orderID).get()) as Future<DocumentSnapshot>
  print(result);
  return result;*/

class StatusBanner extends StatelessWidget {
  final bool status;
  StatusBanner({ Key key, this.status,}): super(key: key);
  @override
  Widget build(BuildContext context) {
    String msg;
    IconData iconData;
    status ? iconData = Icons.done : iconData= Icons.cancel;
    status ? msg = 'Successful' : msg= 'Unsuccessful';
    return Container(
      decoration: new BoxDecoration(
        gradient: new LinearGradient(
          colors: [Colors.limeAccent,Colors.lightGreenAccent],
          begin : const FractionalOffset(0.0,0.0),
          end : const FractionalOffset(0.0, 0.5),
          stops: [0,1],
          tileMode: TileMode.clamp,
        ),
      ),
      height: 40,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          GestureDetector(
            onTap: (){SystemNavigator.pop();},
            child: Container(child: Icon(Icons.arrow_drop_down_circle, color: Colors.white,),),
          ), SizedBox(width: 20.0,), Text('Order placed '+ msg, style: TextStyle(color: Colors.white),),
          SizedBox(width: 5.0,),
          CircleAvatar(
            radius: 8.0,
            backgroundColor: Colors.grey,
            child: Center(child: Icon(
              iconData, color: Colors.white,
              size: 14.0,
            ),),
          )
        ],
      ),
    );
  }
}
class ShippingDetails extends StatelessWidget {
  final AddressModel model;
  ShippingDetails({
    Key key,this.model
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(height: 20.0,),
        Padding(padding: EdgeInsets.symmetric(horizontal: 90.0,vertical: 5.0),
          child: Text('Shipment details ', style: TextStyle(color: Colors.black,fontWeight: FontWeight.bold),),),
        Container(
          padding: EdgeInsets.symmetric(horizontal: 10.0),
          width: screenWidth,
          child: Table(
            children: [
              TableRow(
                  children: [
                    KeyText(msg: 'Name'),
                    Text(model.name),]),
              TableRow(
                  children: [
                    KeyText(msg: 'Phone Number'),
                    Text(model.phoneNumber),]),
              TableRow(
                  children: [
                    KeyText(msg: 'Flat Number'),
                    Text(model.flatNumber),]),
              TableRow(
                  children: [
                    KeyText(msg: 'City'),
                    Text(model.city),]),
              TableRow(
                  children: [
                    KeyText(msg: 'State'),
                    Text(model.state),]),
              TableRow(
                  children: [
                    KeyText(msg: 'Pin Code'),
                    Text(model.pincode),]),
            ],
          ),
        ),
        Padding(padding: EdgeInsets.all(10.0),
          child: Center(
            child: InkWell(
              onTap: (){
                confirmUserOrderReceived(
                    context,getOrderId
                );
              },
              child: Container(
                decoration: new BoxDecoration(
                  gradient: new LinearGradient(
                    colors: [Colors.limeAccent,Colors.lightGreenAccent],
                    begin : const FractionalOffset(0.0,0.0),
                    end : const FractionalOffset(0.0, 0.5),
                    stops: [0,1],
                    tileMode: TileMode.clamp,
                  ),
                ),width: MediaQuery.of(context).size.width-40,
                height: 50.0,
                child: Center(child: Text('Confirmed || Items received ', style: TextStyle(color: Colors.white,fontSize: 15.0),),),
              ),
            ),
          ),)
      ],
    );
  }
  confirmUserOrderReceived(BuildContext context, String mOrderId) {
    EcommerceApp.firestore.collection(EcommerceApp.collectionUser).document(
        EcommerceApp.sharedPreferences.getString(EcommerceApp.userUID)).collection(EcommerceApp.collectionOrders).document(mOrderId).delete();
    getOrderId= '';
    Route route=MaterialPageRoute(builder: (c)=> SplashScreen());
    Navigator.pushReplacement(context, route);
    Fluttertoast.showToast(msg: 'Order has been received. Confirmed  ');
  }
}