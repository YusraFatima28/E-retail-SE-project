import 'package:e_shop/Config/config.dart';
import 'package:e_shop/Store/cart.dart';
import 'package:e_shop/Counters/cartitemcounter.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:firebase_core/firebase_core.dart';

import '../Colors.dart';


class newAppBar extends StatelessWidget with PreferredSizeWidget
{
  final PreferredSizeWidget bottom;
  newAppBar({this.bottom});
  //final PreferredSizeWidget bottom;
  //_newAppBarState({this.bottom});
  @override
  Widget build(BuildContext context) {
    return AppBar(
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
      bottom: bottom,
      actions: [
        Stack(
          children: [
            IconButton(
                icon: Icon(Icons.shopping_cart,color:Colors.black ,),
                onPressed: (){
                  Route route=MaterialPageRoute(builder: (c)=> CartPage());
                  Navigator.pushReplacement(context, route);}),
            Positioned(
              child: Stack(
                children: [
                  Icon(Icons.brightness_1,size:20,color: Colors.pink,),
                  Positioned(top:3,bottom: 4, left:4.0,
                    child: Consumer<CartItemCounter>(
                        builder: (context,counter,_){
                          return Text((EcommerceApp.sharedPreferences.getStringList(EcommerceApp.userCartList).length-1).toString(),style: TextStyle(color: Colors.white,
                              fontSize: 12,fontWeight: FontWeight.bold),); }
                    ),)
                ],
              ),
            )
          ],
        )


      ],
    );
  }
  Size get preferredSize => bottom==null?Size(56,AppBar().preferredSize.height):Size(56,80+AppBar().preferredSize.height);
  //Size get preferredSize => bottom==null?Size(56,AppBar().preferredSize.height):Size(56,80+AppBar().preferredSize.height);
}
