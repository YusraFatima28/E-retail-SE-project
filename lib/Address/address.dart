import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_shop/Colors.dart';
import 'package:e_shop/Config/config.dart';
import 'package:e_shop/Orders//placeOrder.dart';
import 'package:e_shop/Store/MyLocation.dart';
import 'package:e_shop/Widgets/Navigation_drawer/collapsing_navigation_drawer_widget.dart';
import 'package:e_shop/Widgets/customAppBar.dart';
import 'package:e_shop/Widgets/loadingWidget.dart';
import 'package:e_shop/Widgets/newAppBar.dart';
import 'package:e_shop/Widgets/wideButton.dart';
import 'package:e_shop/Models//address1.dart';
import 'package:e_shop/Counters/changeAddresss.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'addAddress.dart';
import 'package:firebase_core/firebase_core.dart';

class Address extends StatefulWidget
{
  final double totalAmount;
  const Address({Key key,this.totalAmount}) : super(key : key);
  @override
  _AddressState createState() => _AddressState();
}
class _AddressState extends State<Address>
{
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: PreferredSize(
            preferredSize: const Size.fromHeight(60),
            child : newAppBar() ),
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(height: 20,),
            Align( alignment: Alignment.center, child: Padding(padding: EdgeInsets.all(8.0),
            child: Text('Select Shipping Address', style: TextStyle(color:  Colors.black,fontWeight: FontWeight.bold,fontSize: 22.0),),),),
            Consumer<AddressChanger>(builder: (context, address , c){
              return Flexible(
              child: StreamBuilder<QuerySnapshot>(
                stream: EcommerceApp.firestore.collection(EcommerceApp.collectionUser).document(
                  EcommerceApp.sharedPreferences.getString(EcommerceApp.userUID)
                ).collection(EcommerceApp.subCollectionAddress).snapshots(),
                builder: (context, snapshot){
                  return !snapshot.hasData ? Center(
                    child: circularProgress(),
                  ) : snapshot.data.documents.length==0 ? noAddressCard() : ListView.builder(
                      itemCount: snapshot.data.documents.length,
                  shrinkWrap: true,
                  itemBuilder: (context,index) {
                        return AddressCard(
                          currentIndex: address.count,
                          value: index,
                          addressID: snapshot.data.documents[index].documentID,
                          totalAmount: widget.totalAmount,
                          model: AddressModel.fromJson(snapshot.data.documents[index].data)
                        );
                  });
                }
              ),
              );
            },)
          ],
        ),drawer: CollapsingNavigationDrawer(),
        floatingActionButton: FloatingActionButton.extended(
          label: Text(' Add new Address '),
          backgroundColor: AppColors.primary,
          icon: Icon(Icons.add_location),
          onPressed: (){
            Route route=MaterialPageRoute(builder: (c)=> MyLocation());
            Navigator.pushReplacement(context, route);
          },
        ),
      ),
    );
  }
  noAddressCard() {
    return Card(
      color: AppColors.dashPurple,
      child: Container(
        height: 100,
        width: MediaQuery.of(context).size.width-40,
        alignment: Alignment.center,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.add_location, color: Colors.white,size: 35,),
            SizedBox(height: 10,),
            Text('No shipment address has been saved ', style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold, color: AppColors.textGrey),),

          ],
        ),
      ),
    );
  }
}
class AddressCard extends StatefulWidget {
  final AddressModel model;
  final int currentIndex;
  final String addressID;
  final double totalAmount;
  final int value;
  AddressCard({
    Key key, this.currentIndex,this.model,this.addressID,this.totalAmount,this.value}) : super(key: key);
  @override
  _AddressCardState createState() => _AddressCardState();
}
class _AddressCardState extends State<AddressCard> {
  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    return InkWell(
      onTap: (){ Provider.of<AddressChanger>(context, listen: false).displayResult(widget.value);},
      child: Card(
        color: AppColors.dashPurple,
        child: Column(
          children: [
            Row(
              children: [
                Radio(
                  groupValue: widget.currentIndex,
                  value: widget.value,
                  activeColor: Colors.pink,
                  onChanged: (val){
                    Provider.of<AddressChanger>(
                      context,listen: false
                    ).displayResult(val);
                  },),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      padding: EdgeInsets.all(10.0),
                      width: screenWidth * 0.8,
                      child: Table(
                        children: [
                          TableRow(
                            children: [
                              KeyText(msg: 'name'),
                              Text(widget.model.name),]),
                          TableRow(
                              children: [
                                KeyText(msg: 'Phone Number'),
                                Text(widget.model.phoneNumber.toString()),]),
                          TableRow(
                              children: [
                                KeyText(msg: 'Home Address'),
                                Text(widget.model.homeAddress),]),
                       /*   TableRow(
                              children: [
                                KeyText(msg: 'City'),
                                Text(widget.model.city),]),*/
                         /* TableRow(
                              children: [
                                KeyText(msg: 'State'),
                                Text(widget.model.state),]),*/
                          TableRow(
                              children: [
                                KeyText(msg: 'Pincode'),
                                //TextInputType.numberWithOptions()
                                Text(widget.model.pinCode.toString()),]),
                        ],
                      ),
                    ),
                  ],
                )
              ],
            ),
            widget.value==Provider.of<AddressChanger>(context).count ? WideButton(
              message: "Proceed",
              onPressed: (){
                Route route =MaterialPageRoute(builder: (c)=>PaymentPage(
                  addressID: widget.addressID, totalAmount : widget.totalAmount,
                ) );  Navigator.push(context, route);
              },
            ) : Container(),
          ],
        ),
      ),
    );
  }
}
class KeyText extends StatelessWidget {
  final String msg;
  KeyText({Key key,this.msg,
}): super(key: key);
  @override
  Widget build(BuildContext context) {
    return Text(msg, style: TextStyle( color: Colors.black, fontWeight: FontWeight.bold),);
  }
}
