import 'package:e_shop/Store/cart.dart';
import 'package:e_shop/Counters/cartitemcounter.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';


class MyAppBar extends StatelessWidget with PreferredSizeWidget
{
  final PreferredSizeWidget bottom;
  MyAppBar({this.bottom});


  @override
  Widget build(BuildContext context) {
    return AppBar(
      iconTheme: IconThemeData(
        color: Colors.white,

      ),
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
      ),
      centerTitle: true,
      title: Text(
        'e-shop',style: TextStyle(
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
                  Icon(Icons.brightness_1,size:20,color: Colors.green,),
                  Positioned(top:3,bottom: 4, left:4.0,
                    child: Consumer<CartItemCounter>(
                        builder: (context,counter,_){
                          return Text(counter.count.toString(),style: TextStyle(color: Colors.white,
                              fontSize: 12,fontWeight: FontWeight.w500),); }
                    ),)
                ],
              ),
            )
          ],
        )
      ],
    );

  }


  Size get preferredSize => bottom==null?Size(56,AppBar().preferredSize.height):Size(56, 80+AppBar().preferredSize.height);
}
