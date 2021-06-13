
import 'package:e_shop/Address/addAddress.dart';
import 'package:e_shop/Admin/adminProfile.dart';
import 'package:e_shop/Authentication/authenication.dart';
import 'package:e_shop/Colors.dart';
import 'package:e_shop/Config/config.dart';
import 'package:e_shop/Orders/myOrders.dart';
import 'package:e_shop/Store/MyLocation.dart';
import 'package:e_shop/Store/Search.dart';
import 'package:e_shop/Store/SecurityScreen.dart';
import 'package:e_shop/Store/cart.dart';
import 'package:e_shop/Store/storehome.dart';
import 'package:e_shop/Store/userProfile.dart';
import 'package:flutter/material.dart';

import 'collapsing_list_tile_widget.dart';
import 'navigation_model.dart';

class CollapsingNavigationDrawer extends StatefulWidget {
  @override
  CollapsingNavigationDrawerState createState() {
    return new CollapsingNavigationDrawerState();
  }
}

class CollapsingNavigationDrawerState extends State<CollapsingNavigationDrawer>
    with SingleTickerProviderStateMixin {
  double maxWidth = 270;
  double minWidth = 70;
  bool isCollapsed = false;
  AnimationController _animationController;
  Animation<double> widthAnimation;
  int currentSelectedIndex = 0;
  @override
  void initState() {
    super.initState();

    _animationController = AnimationController(
        vsync: this, duration: Duration(milliseconds: 300));
    widthAnimation = Tween<double>(begin: maxWidth, end: minWidth)
        .animate(_animationController);
  }
  @override
  Widget build(BuildContext context) {
    SizedBox(height: 56,);
    return AnimatedBuilder(
      child: SizedBox(height: 80,),
      animation: _animationController,
      builder: (context, widget) => getWidget(context, widget),
    );
  }
  Widget getWidget(context, widget) {
    return Material(
      elevation: 80.0, //80
      child: Container(
        width: widthAnimation.value,
        color: AppColors.primary,
        child: Column(
          children: <Widget>[
            SizedBox( height: 25,), //25
            Row(
              children: [
                SizedBox( width: 70,),
                (widthAnimation.value >= 190) ? //70
                Material(
                  borderRadius: BorderRadius.all(Radius.circular(80.0)),
                  elevation: 1,
                  child: Container(
                    height: 120,
                    width: 120,
                    child: CircleAvatar(
                      backgroundImage: NetworkImage(EcommerceApp
                          .sharedPreferences
                          .getString(EcommerceApp.userAvatarUrl),
                      ),
                      radius: 80,
                    ),
                  ),
                ): Container()
              ],
            ),
       /* Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            SizedBox(
              height: 20,
            ),
            Row(
              children: [
                SizedBox( width: 72,), //72
                Text(
                  EcommerceApp.sharedPreferences
                      .getString(EcommerceApp.userName),
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 35,
                      fontFamily: 'signatra'),
                ),
              ],
            ),
            SizedBox(
              width: 15,
            ),]),*/

            CollapsingListTile(title: EcommerceApp.sharedPreferences
                .getString(EcommerceApp.userName), icon: Icons.person, animationController: _animationController,),
            Divider(color: Colors.pink, height: 40.0, thickness: 4, endIndent:15 ,indent: 10,),
            Expanded(
              child: ListView.separated(
                separatorBuilder: (context, counter) {
                  return Divider(height: 12.0,);
                },
                itemBuilder: (context, counter) {
                  return CollapsingListTile(
                    onTap: () {
                      setState(() {
                        currentSelectedIndex = counter;
                        if (currentSelectedIndex == 0){
                          Route route =
                          MaterialPageRoute(builder: (c) => StoreHome()); //AddAddress()
                          Navigator.pushReplacement(context, route);
                        }
                        if (currentSelectedIndex == 1){
                          Route route =
                          MaterialPageRoute(builder: (c) => UserProfileScreen()); //AddAddress()
                          Navigator.pushReplacement(context, route);
                        }
                        if (currentSelectedIndex == 2){
                          Route route =
                          MaterialPageRoute(builder: (c) => MyOrders()); //AddAddress()
                          Navigator.pushReplacement(context, route);
                        }
                        if (currentSelectedIndex == 3){
                          Route route =
                          MaterialPageRoute(builder: (c) => CartPage()); // CartPage
                          Navigator.pushReplacement(context, route);
                        }
                        if (currentSelectedIndex == 4){
                          Route route =
                          MaterialPageRoute(builder: (c) => SearchProduct()); //AddAddress()
                          Navigator.pushReplacement(context, route);
                        }
                        if (currentSelectedIndex == 5){
                          Route route =
                          MaterialPageRoute(builder: (c) => MyLocation()); //AddAddress()
                          Navigator.pushReplacement(context, route);
                        }
                        if (currentSelectedIndex == 6){
                          Route route =
                          MaterialPageRoute(builder: (c) => SecurityScreen()); //AddAddress()
                          Navigator.pushReplacement(context, route);
                        }
                        print(currentSelectedIndex);
                        print(' ab hua print');
                      });
                    },
                    isSelected: currentSelectedIndex == counter,
                    title: navigationItems[counter].title,
                    icon: navigationItems[counter].icon,
                    animationController: _animationController,
                  );
                },
                itemCount: 7 //navigationItems.length,
              ),
            ),
            InkWell(
              onTap: () {
                setState(() {
                  isCollapsed = !isCollapsed;
                  isCollapsed
                      ? _animationController.forward()
                      : _animationController.reverse();
                });
              },
              child: AnimatedIcon(
                icon: AnimatedIcons.close_menu,
                progress: _animationController,
                color:  Colors.pink,
                size: 40.0,
              ),
            ),
            SizedBox(
              height: 50.0,
            ),
          ],
        ),
      ),
    );
  }
}